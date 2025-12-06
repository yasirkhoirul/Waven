import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:waven/data/model/addonsmodel.dart';
import 'package:waven/data/model/detailportomodel.dart';
import 'package:waven/data/model/packagemodel.dart';
import 'package:waven/data/model/portomodel.dart';
import 'package:waven/data/model/signup.dart';
import 'package:waven/data/model/singin.dart';
import 'package:waven/data/model/univ_drop_model.dart';
import 'package:waven/domain/entity/user.dart';

abstract class DataRemote {
  Future<Signinresonse> onLogin(String email, String password);
  Future<ResposeSIgnup> signUP(User data);
  Future<Packagemodel> getPackage();
  Future<Portomodel> getPorto();
  Future<UnivDropModel> getUnivDropDown();
  Future<DetailPortoModel> getDetailPorto(String idpackage);
  Future<Addonsmodel> getAddons();
}

class DataRemoteImpl implements DataRemote {
  final baseurl = "http://157.10.252.202:3000/";
  final baseuri= "157.10.252.202:3000";
  @override
  Future<Signinresonse> onLogin(String email, String password) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    final uri = Uri.http(baseuri,"/v1/auth/login");
    try {
      final response = await http.post(
        uri,
        
        headers: {
          'Authorization': basicAuth,
          'content-type': 'application/json',
        },
      );
      Logger().d(response.body);
      if (response.statusCode == 200) {
        return Signinresonse(
          response.headers['x-access-token']!,
          response.headers['x-refresh-token']!,
        );
      } else {
        throw Exception("gagal status ${jsonDecode(response.body)}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ResposeSIgnup> signUP(User datas) async {
    final SignUp dataready = SignUp.fromEntity(datas);
    final data = dataready.toJson();
    try {
      final response = await http.post(
        Uri.parse("${baseurl}v1/auth/register"),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return ResposeSIgnup.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Packagemodel> getPackage() async {
    try {
      Logger().d("ini get package");
      final response = await http.get(Uri.parse("${baseurl}v1/packages"));
      Logger().d("respon = ${response.body}");
      if (response.statusCode == 200) {
        return Packagemodel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Portomodel> getPorto({String? idpackage}) async {
    try {
      final uri = Uri.http(baseuri,'/v1/master/portfolios',{
        "package":idpackage
      });
      final response = await http.get(
        uri
      );

      if (response.statusCode == 200) {
        return Portomodel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "error ${Portomodel.fromJson(jsonDecode(response.body)).message}",
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DetailPortoModel> getDetailPorto(String idpackage) async {
    try {
      final uri = Uri.parse("${baseurl}v1/packages/$idpackage");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return DetailPortoModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          DetailPortoModel.fromJson(jsonDecode(response.body)).message,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<UnivDropModel> getUnivDropDown() async{
    try {
      final uri = Uri.http(baseuri,'/v1/master/universities/dropdown');
      final response = await http.get(uri);
      
      if (response.statusCode  == 200) {
        return UnivDropModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.statusCode.toString();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  
  @override
  Future<Addonsmodel> getAddons()async {
    try {
      final uri = Uri.http(baseuri,'/v1/addons');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return Addonsmodel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
