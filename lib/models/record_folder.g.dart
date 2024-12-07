// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordFolder _$RecordFolderFromJson(Map<String, dynamic> json) => RecordFolder(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      isDeletable: json['isDeletable'] as bool? ?? false,
      isSelectable: json['isSelectable'] as bool? ?? false,
    );

Map<String, dynamic> _$RecordFolderToJson(RecordFolder instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isDeletable', instance.isDeletable);
  writeNotNull('isSelectable', instance.isSelectable);
  val['year'] = instance.year;
  writeNotNull('month', instance.month);
  writeNotNull('day', instance.day);
  return val;
}
