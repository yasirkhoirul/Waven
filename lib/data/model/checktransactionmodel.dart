import 'package:json_annotation/json_annotation.dart';

part 'checktransactionmodel.g.dart';


@JsonSerializable()
class Checktransactionmodel {
  final String message;
  final DataCheckTransaction data;
  Checktransactionmodel(this.message,this.data);
  factory Checktransactionmodel.fromJson(Map<String,dynamic> json) => _$ChecktransactionmodelFromJson(json);
}

@JsonSerializable()
class DataCheckTransaction {
  @JsonKey(name: "is_paid")
  final bool ispaid;
  final String description;
  DataCheckTransaction(this.ispaid,this.description);
  factory DataCheckTransaction.fromJson(Map<String,dynamic> json) => _$DataCheckTransactionFromJson(json);
}