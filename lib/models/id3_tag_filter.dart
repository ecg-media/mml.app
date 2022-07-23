import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id3_tag_filter.g.dart';

/// ID§ tag filters for records.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ID3TagFilter {
  /// Ids opf artist tags.
  List<String> artists = [];

  /// Ids of genre tags.
  List<String> genres = [];

  /// Ids of album tags.
  List<String> albums = [];

  /// Start date of a date interval or null if not set.
  DateTime? startDate;

  /// End date of a date interval or null if not set.
  DateTime? endDate;

  /// Initializes the model.
  ID3TagFilter({
    List<String>? artists,
    List<String>? genres,
    List<String>? albums,
    this.startDate,
    this.endDate,
  }) {
    this.artists = artists ?? [];
    this.genres = genres ?? [];
    this.albums = albums ?? [];
  }

  /// Converts a json object/map to the model.
  factory ID3TagFilter.fromJson(Map<String, dynamic> json) =>
      _$ID3TagFilterFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$ID3TagFilterToJson(this);

  /// Assigns the new filter [value] to the [ID3TagFilters] identifier.
  void operator []=(String identifier, dynamic value) {
    switch (identifier) {
      case ID3TagFilters.artists:
        artists = value as List<String>;
        break;
      case ID3TagFilters.genres:
        genres = value as List<String>;
        break;
      case ID3TagFilters.albums:
        albums = value as List<String>;
        break;
      case ID3TagFilters.date:
        var range = value as DateTimeRange;
        startDate = range.start;
        endDate = range.end;
        break;
    }
  }

  /// Returns the saved values of the [ID3TagFilters] identifier.
  dynamic operator [](String identifier) {
    switch (identifier) {
      case ID3TagFilters.artists:
        return artists;
      case ID3TagFilters.genres:
        return genres;
      case ID3TagFilters.albums:
        return albums;
      case ID3TagFilters.date:
        return startDate != null && endDate != null
            ? DateTimeRange(start: startDate!, end: endDate!)
            : null;
    }
  }

  /// Clears the filter value of the [identifier].
  void clear(String identifier) {
    switch (identifier) {
      case ID3TagFilters.artists:
        artists.clear();
        break;
      case ID3TagFilters.genres:
        genres.clear();
        break;
      case ID3TagFilters.albums:
        albums.clear();
        break;
      case ID3TagFilters.date:
        startDate = null;
        endDate = null;
        break;
    }
  }

  /// Checks if the value of the [identifier] is not empty.
  bool isNotEmpty(String identifier) {
    switch (identifier) {
      case ID3TagFilters.artists:
        return artists.isNotEmpty;
      case ID3TagFilters.genres:
        return genres.isNotEmpty;
      case ID3TagFilters.albums:
        return albums.isNotEmpty;
      case ID3TagFilters.date:
        return startDate != null;
      default:
        return true;
    }
  }
}

/// Holds the tags identifiers on which records can be fitlered.
abstract class ID3TagFilters {
  /// Artists tag identifier.
  static const String artists = "artists";

  /// Albums tag identifier.
  static const String albums = "albums";

  /// Date tag identifier.
  static const String date = "date";

  /// Genres tag identifier.
  static const String genres = "genres";
}
