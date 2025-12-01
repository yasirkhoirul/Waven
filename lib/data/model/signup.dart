import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/user.dart';

part 'signup.g.dart';

@JsonSerializable()
class SignUp {
  final String username;
  final String email;
  final String password;
  final String name;
  final String university;
  final String phonenumber;

  SignUp(
    this.username,
    this.email,
    this.password,
    this.name,
    this.phonenumber,
    this.university,
  );

  Map<String, dynamic> toJson() => _$SignUpToJson(this);

  factory SignUp.fromEntity(User data) {
    return SignUp(
      data.username,
      data.email,
      data.password,
      data.name,
      data.phonenumber,
      data.university,
    );
  }
}

class ResposeSIgnup {
  final String message;
  const ResposeSIgnup(this.message);
  
  factory ResposeSIgnup.fromJson(Map<String,dynamic> json){
    return ResposeSIgnup(
      json['message']
    );
  }
}
