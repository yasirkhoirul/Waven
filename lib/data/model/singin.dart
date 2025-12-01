
import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/user.dart';

part 'singin.g.dart';

@JsonSerializable()
class Singin {
  final String email;
  final String password;
  Singin(this.email, this.password);

  Map<String,dynamic> tojson() => _$SinginToJson(this);

}