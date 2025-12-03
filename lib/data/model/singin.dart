import 'package:json_annotation/json_annotation.dart';

part 'singin.g.dart';

@JsonSerializable()
class Singin {
  final String email;
  final String password;
  Singin(this.email, this.password);

  Map<String, dynamic> tojson() => _$SinginToJson(this);
}

class Signinresonse {
  final String acces;
  final String refresh;
  Signinresonse(this.acces,this.refresh);
}
