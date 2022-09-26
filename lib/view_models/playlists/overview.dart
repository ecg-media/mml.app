import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/mml_app_localizations.dart';
import 'package:mml_app/components/progress_indicator.dart';
import 'package:mml_app/models/id3_tag_filter.dart';
import 'package:mml_app/models/local_record.dart';
import 'package:mml_app/models/model_base.dart';
import 'package:mml_app/models/model_list.dart';
import 'package:mml_app/services/db.dart';
import 'package:mml_app/services/file.dart';
import 'package:mml_app/services/player/player.dart';
import 'package:mml_app/services/router.dart';

/// View model of the playlist view.
class PlaylistViewModel extends ChangeNotifier {
  /// Route of the plalist screen.
  static String route = '/playlist';

  /// [RecordService] used to load data for the records uplaod dialog.
  final DBService _service = DBService.getInstance();

  /// App locales.
  late AppLocalizations locales;

  /// Initializes the view model.
  Future<bool> init(BuildContext context) {
    return Future.microtask(() {
      locales = AppLocalizations.of(context)!;

      return true;
    });
  }

  /// Loads the records with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    dynamic subfilter,
  }) async {
    return _service.load(filter, offset, take);
  }

  /// Removes the [offlineRecords] from local database and deletes cached file, if record is not available anymore.
  Future deleteRecords(List<ModelBase?> offlineRecords) async {
    showProgressIndicator();
    for (var record in offlineRecords) {
      await _removeRecord(record as LocalRecord);
    }
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }

  /// Deletes playlist with [playlistId].
  Future deletePlaylist(int playlistId) async {
    showProgressIndicator();
    var records = await _service.getRecords(playlistId);
    for (var record in records) {
      await _removeRecord(record);
    }
    await _service.removePlaylist(playlistId);
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }

  /// Removes one record from playlist.
  Future _removeRecord(LocalRecord record) async {
    await _service.removeFromPlaylist(
      record.recordId!,
      record.playlist.id!,
    );

    if (!(await _service.isInPlaylist(record.recordId!))) {
      await _service.removeRecord(record.recordId!);
      await FileService.getInstance().remove(record.checksum!);
    }
  }

  /// Plays one record.
  void playRecord(
    BuildContext context,
    ModelBase record,
    String? filter,
    ID3TagFilter? subfilter,
  ) {
    PlayerService.getInstance().play(
      context,
      record as LocalRecord,
      filter,
      subfilter,
    );
  }
}