import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:waven/data/model/signup.dart';
import 'package:waven/domain/entity/user.dart';

abstract class DataRemote {
  Future<String> onLogin(String email,String password);
  Future<ResposeSIgnup> signUP(User data);
}

class DataRemoteImpl implements DataRemote{
  final baseurl = "https://ffcbd8f0-1f55-429c-9ecf-21c8ff4d24ab.mock.pstmn.io/";
  final endpoint = "https://fakestoreapi.com/auth/login";
  @override
  Future<String> onLogin(String email, String password) async{
     String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization':basicAuth,
          'content-type':'application/json'
        },
      );
      if (response.statusCode == 200) {
        return "sukses";
      }else{
        return "gagal status ${response.statusCode}";
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<ResposeSIgnup> signUP(User datas) async{
    final SignUp dataready = SignUp.fromEntity(datas);
    final data = dataready.toJson();
    try {
      final response = await http.post(
        Uri.parse("${baseurl}/v1/auth/register"),
        headers: {
          'content-type':'application/json'
        },
        body: jsonEncode(
          data
        )
      );
      Logger().d(response.body);
      if (response.statusCode == 201) {
        return ResposeSIgnup.fromJson(jsonDecode(response.body));
      }else{
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}