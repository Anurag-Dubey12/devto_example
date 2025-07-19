  import 'package:json_annotation/json_annotation.dart';
part 'times_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TimesModel {
  @JsonKey(name: 'isOpen', defaultValue: false)
  bool isOpen;

  @JsonKey(name: 'openTime')
  String? openTime;

  @JsonKey(name: 'closeTime')
  String? closeTime;

  TimesModel({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory TimesModel.fromJson(Map<String, dynamic> json) =>
      _$TimesModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesModelToJson(this);
}
