import 'package:flutter/material.dart';
import 'package:mml_app/models/playlist.dart';
import 'package:mml_app/models/record.dart';

class LocalRecord extends Record {
  /// The playlist the record belongs to.
  Playlist playlist;

  LocalRecord({
    required super.recordId,
    required super.checksum,
    required this.playlist,
    super.title,
    super.date,
    super.duration = 0,
    super.album,
    super.artist,
    super.genre,
  });

  @override
  dynamic getIdentifier() {
    return recordId == null ? null : '$recordId${playlist.id}';
  }

  @override
  String? getGroup(BuildContext context) {
    return playlist.name;
  }
}
