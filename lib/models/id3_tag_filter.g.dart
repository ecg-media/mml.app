// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id3_tag_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ID3TagFilter _$ID3TagFilterFromJson(Map<String, dynamic> json) => ID3TagFilter(
      artists:
          (json['artists'] as List<dynamic>?)?.map((e) => e as String).toList(),
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      albums:
          (json['albums'] as List<dynamic>?)?.map((e) => e as String).toList(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$ID3TagFilterToJson(ID3TagFilter instance) {
  final val = <String, dynamic>{
    'artists': instance.artists,
    'genres': instance.genres,
    'albums': instance.albums,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('startDate', instance.startDate?.toIso8601String());
  writeNotNull('endDate', instance.endDate?.toIso8601String());
  return val;
}
