import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/profile.dart';

part 'profilemodel.g.dart';

@JsonSerializable()
class Profilemodel {
  final String message;
  final DataProfile data;

  const Profilemodel(this.message,this.data);

  factory Profilemodel.fromJson(Map<String,dynamic> json)=> _$ProfilemodelFromJson(json);
}


@JsonSerializable()
class DataProfile {
  final String id;
  final String username;
  final String email;
  final String name;

  @JsonKey(name: "phone_number")
  final String phonenumber;

  @JsonKey(name: "created_at")
  final String createdat;
  const DataProfile(this.id, this.username, this.email, this.name, this.phonenumber, this.createdat);

  Profile toEntity(){
    return Profile(id, username, email, name, phonenumber);
  }

  factory DataProfile.fromJson(Map<String,dynamic> json)=> _$DataProfileFromJson(json);
}