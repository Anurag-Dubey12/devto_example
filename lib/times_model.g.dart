// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'times_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesModel _$TimesModelFromJson(Map<String, dynamic> json) => TimesModel(
  isOpen: json['isOpen'] as bool? ?? false,
  openTime: json['openTime'] as String?,
  closeTime: json['closeTime'] as String?,
);

Map<String, dynamic> _$TimesModelToJson(TimesModel instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };
