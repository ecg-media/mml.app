import 'package:flutter/material.dart';
import 'package:mml_app/components/async_select_list_dialog.dart';
import 'package:mml_app/models/model_base.dart';
import 'package:mml_app/models/playlist.dart';
import 'package:mml_app/services/db.dart';
import 'package:mml_app/views/records/download.dart';

/// Service that handles the playlist data.
class PlaylistService {
  /// Instance of the record service.
  static final PlaylistService _instance = PlaylistService._();

  /// Private constructor of the service.
  PlaylistService._();

  /// Returns the singleton instance of the [PlaylistService].
  static PlaylistService getInstance() {
    return _instance;
  }

  /// Handles the download of [records] and adding them to playlists or to one predefined [playlist].
  Future<bool> downloadRecords(
    List<ModelBase?> records,
    BuildContext context, {
    Playlist? playlist,
  }) async {
    List<dynamic>? selectedPlaylists = playlist != null
        ? [playlist.id]
        : await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AsyncSelectListDialog(
                loadData: ({filter, offset, take}) {
                  return DBService.getInstance().getPlaylists(
                    filter,
                    offset,
                    take,
                  );
                },
                initialSelected: const [],
              );
            },
          );

    if (selectedPlaylists == null || selectedPlaylists.isEmpty) {
      return false;
    }

    if (!context.mounted) {
      return false;
    }

    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RecordDownloadDialog(
          records: records,
          playlists: selectedPlaylists,
        );
      },
    );
  }

  /// Returns if [recordId] is in one playlist already.
  Future<bool> isFavorite(String? recordId) async {
    return recordId?.isNotEmpty == true
        ? await DBService.getInstance().isInPlaylist(recordId!)
        : false;
  }
}
