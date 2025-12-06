import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:waven/data/model/detailportomodel.dart';
import 'package:waven/data/model/packagemodel.dart';
import 'package:waven/data/model/portomodel.dart';
import 'package:waven/data/model/signup.dart';
import 'package:waven/data/model/singin.dart';
import 'package:waven/domain/entity/user.dart';

abstract class DataRemote {
  Future<Signinresonse> onLogin(String email, String password);
  Future<ResposeSIgnup> signUP(User data);
  Future<Packagemodel> getPackage();
  Future<Portomodel> getPorto();
  Future<DetailPortoModel> getDetailPorto(String idpackage);
}

class DataRemoteImpl implements DataRemote {
  final baseurl = "https://6dec8615-b2a0-4cdb-b036-5913fb42266b.mock.pstmn.io/";
  @override
  Future<Signinresonse> onLogin(String email, String password) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    try {
      final response = await http.post(
        Uri.parse("${baseurl}v1/auth/login"),
        headers: {
          'Authorization': basicAuth,
          'content-type': 'application/json',
        },
      );
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
      final uri = Uri.https("6dec8615-b2a0-4cdb-b036-5913fb42266b.mock.pstmn.io",'/v1/master/portfolios',{
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
}
