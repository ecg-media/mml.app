import 'package:dio/dio.dart';
import 'package:mml_app/models/album.dart';
import 'package:mml_app/models/artist.dart';
import 'package:mml_app/models/genre.dart';
import 'package:mml_app/models/id3_tag_filter.dart';
import 'package:mml_app/models/model_list.dart';
import 'package:mml_app/models/record.dart';
import 'package:mml_app/services/api.dart';

/// Service that handles the records data of the server.
class RecordService {
  /// Instance of the record service.
  static final RecordService _instance = RecordService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  RecordService._();

  /// Returns the singleton instance of the [RecordService].
  static RecordService getInstance() {
    return _instance;
  }

  /// Returns a list of records with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getRecords(
      String? filter, int? offset, int? take, ID3TagFilter? tagFilter) async {
    var params = <String, String?>{};

    if (filter != null) {
      params['filter'] = filter;
    }

    if (offset != null) {
      params['skip'] = offset.toString();
    }

    if (take != null) {
      params['take'] = take.toString();
    }

    var response = await _apiService.request(
      '/media/record/list',
      queryParameters: params,
      data: tagFilter != null ? tagFilter.toJson() : {},
      options: Options(
        method: 'POST',
      ),
    );

    return ModelList(
      List<Record>.from(
        response.data['items'].map((item) => Record.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of artists with the amount of [take] starting from the [offset].
  Future<ModelList> getArtists(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/artists',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Artist>.from(
        response.data['items'].map((item) => Artist.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of albums with the amount of [take] starting from the [offset].
  Future<ModelList> getAlbums(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/albums',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Album>.from(
        response.data['items'].map((item) => Album.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Returns a list of genres with the amount of [take] starting from the [offset].
  Future<ModelList> getGenres(String? filter, int? offset, int? take) async {
    var response = await _apiService.request(
      '/media/record/genres',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
      options: Options(
        method: 'GET',
      ),
    );

    return ModelList(
      List<Genre>.from(
        response.data['items'].map((item) => Genre.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Downloads file for [recordId].
  Future download(String recordId) async {
    var response = await _apiService.request(
      '/media/record/download/$recordId',
      options: Options(
        method: 'GET',
      ),
    );

    return null;
  }
}
