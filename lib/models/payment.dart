import 'package:json_annotation/json_annotation.dart';
import 'package:minsk8/import.dart';

part 'payment.g.dart';

@JsonSerializable()
class PaymentModel {
  final String id;
  final String text;
  final int value;
  final DateTime createdAt;
  @JsonKey(nullable: true)
  final ItemModel item;

  PaymentModel({
    this.id,
    this.text,
    this.value,
    this.createdAt,
    this.item,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
