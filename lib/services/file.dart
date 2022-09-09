import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mml_app/models/record.dart';
import 'package:mml_app/services/api.dart';
import 'package:mml_app/services/secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fast_rsa/fast_rsa.dart';

/// Service which handles operations on files on disk.
class FileService {
  /// Instance of the service.
  static final FileService _instance = FileService._();

  /// Returns the singleton instance of the [FileService].
  static FileService getInstance() {
    return _instance;
  }

  Future<String> get _folder async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/records';
  }

  /// Private constructor of the service.
  FileService._();

  /// Creates folder where to store downloaded records.
  Future<void> createFolder() async {
    await Directory(await _folder).create(recursive: true);
  }

  /// Removes all saved files from records folder.
  Future<void> clear() async {
    final files = Directory(await _folder).listSync();
    for (FileSystemEntity entity in files) {
      if (entity is File) {
        await entity.delete();
      }
    }
  }

  /// Removes saved file with [fileName] from disk.
  Future<void> remove(String fileName) async {
    final file = File('${await _folder}/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Downloads the [record] from server if not already available on disk.
  ///
  /// [onProgress] shows the progress of downloading.
  Future<void> download(Record record, {ProgressCallback? onProgress}) async {
    var savePath = '${await _folder}/${record.checksum}';
    final cryptFile = File(savePath);
    final publicKey = await SecureStorageService.getInstance().get(
      SecureStorageService.rsaPublicStorageKey,
    );

    if (await cryptFile.exists()) {
      return;
    }

    Response<ResponseBody> response =
        await ApiService.getInstance().request<ResponseBody>(
      '/media/stream/${record.recordId}',
      options: Options(
        responseType: ResponseType.stream,
        receiveTimeout: 0,
      ),
    );

    var size =
        int.tryParse(response.headers["content-length"]?.first ?? "") ?? 0;
    var downloadedAndEncryptedSize = 0;

    await (response.data?.stream as Stream<Uint8List>)
        .asyncMap((Uint8List chunk) async {
          final encryptChunk = await RSA.encryptPKCS1v15Bytes(
            Uint8List.fromList(chunk),
            publicKey!,
          );

          await cryptFile.writeAsBytes(encryptChunk, mode: FileMode.append);

          if (onProgress != null) {
            downloadedAndEncryptedSize += chunk.length;
            onProgress(downloadedAndEncryptedSize, size);
          }

          return encryptChunk;
        })
        .listen((event) {})
        .asFuture();
  }

  /// Loads file with [fileName] as decrypted byte chunked stream.
  Future<File> getFile(String fileName) async {
    return File('${await _folder}/$fileName');
    // final privateKey = await SecureStorageService.getInstance().get(
    //   SecureStorageService.rsaPrivateStorageKey,
    // );

    // return cryptFile.openRead();
    // .asyncMap((List<int> input) {
    //   // return RSA.decryptPKCS1v15Bytes(Uint8List.fromList(input), privateKey!);
    //   return input;
    // }).asBroadcastStream();
  }
}

class MMLAudioSource extends StreamAudioSource {
  final File file;
  final String privateKey;

  MMLAudioSource(this.file, this.privateKey) : super(tag: "MMLAudioSource");

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= await file.length();
    return StreamAudioResponse(
      sourceLength: await file.length(),
      contentLength: end - start,
      offset: start,
      stream: file.openRead(start, end).asyncMap((List<int> input) {
        return RSA.decryptPKCS1v15Bytes(Uint8List.fromList(input), privateKey);
      }).asBroadcastStream(),
      contentType: 'audio/mpeg',
    );
  }
}
