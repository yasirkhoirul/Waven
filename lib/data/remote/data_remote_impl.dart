import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/data/model/addonsmodel.dart';
import 'package:waven/data/model/booking_request_model.dart';
import 'package:waven/data/model/detailinvoice.dart';
import 'package:waven/data/model/detailportomodel.dart';
import 'package:waven/data/model/invoicemodel.dart';
import 'package:waven/data/model/listinvoicemodeluser.dart';
import 'package:waven/data/model/packagemodel.dart';
import 'package:waven/data/model/portomodel.dart';
import 'package:waven/data/model/profilemodel.dart';
import 'package:waven/data/model/signup.dart';
import 'package:waven/data/model/singin.dart';
import 'package:waven/data/model/univ_drop_model.dart';
import 'package:waven/data/remote/dio.dart';
import 'package:waven/domain/entity/user.dart';

abstract class DataRemote {
  Future<Signinresonse> onLogin(String email, String password);
  Future<String> onLoginGoogle();
  Future<String> logout(String accestoken);
  Future<Signinresonse> signUP(User data);
  Future<Packagemodel> getPackage();
  Future<Portomodel> getPorto();
  Future<UnivDropModel> getUnivDropDown();
  Future<DetailPortoModel> getDetailPorto(String idpackage);
  Future<Addonsmodel> getAddons();
  Future<InvoiceModel> postBooking(
    BookingRequestModel bookingreq, {
    List<int>? image,
  });
  Future<bool> checkBooking(String tanggal, String start, String end);
  Future<List<int>> getQris(String transactionid);
  Future<ListInvoiceModelUser> getlistinvoice(int page, int limit);
  Future<Profilemodel> getProfile();
  Future<DetailInvoiceModel> getDetailInvoice(String id);
}

class DataRemoteImpl implements DataRemote {
  final DioClient dio;
  DataRemoteImpl(this.dio);
  final baseurl = "https://waven-development.site/";
  final baseuri = "waven-development.site";
  @override
  Future<Signinresonse> onLogin(String email, String password) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    final uri = Uri.https(baseuri, "/v1/auth/login");
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
  Future<Signinresonse> signUP(User datas) async {
    final SignUp dataready = SignUp.fromEntity(datas);
    final data = dataready.toJson();
    try {
      final response = await http.post(
        Uri.parse("${baseurl}v1/auth/register"),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return Signinresonse(
          response.headers['x-access-token']!,
          response.headers['x-refresh-token']!,
        );
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
      final uri = Uri.https(baseuri, '/v1/master/portfolios', {
        "package": idpackage,
      });
      final response = await http.get(uri);

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
  Future<UnivDropModel> getUnivDropDown() async {
    try {
      final uri = Uri.https(baseuri, '/v1/master/universities/dropdown');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return UnivDropModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.statusCode.toString();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Addonsmodel> getAddons() async {
    try {
      final uri = Uri.https(baseuri, '/v1/addons');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return Addonsmodel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<InvoiceModel> postBooking(
    BookingRequestModel payload, {
    List<int>? image,
  }) async {
    try {
      FormData formData;
      final isTransferMethod =
          payload.bookingData.paymentMethod == Constantclass.paymentMethod[1];
      final hasImage = image != null && image.isNotEmpty;

      Logger().d(
        "PostBooking - Payment Method: ${payload.bookingData.paymentMethod}, Has Image: $hasImage",
      );

      if (hasImage && isTransferMethod) {
        Logger().d("Mengirim booking WITH image (Transfer method)");
        formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(
            image,
            filename: 'bukti_transfer.jpg',
          ),
          'data': jsonEncode(payload.toJson()),
        });
      } else {
        Logger().d(
          "Mengirim booking WITHOUT image (Payment Method: ${payload.bookingData.paymentMethod})",
        );
        formData = FormData.fromMap({'data': jsonEncode(payload.toJson())});
      }

      final response = await dio.dio.post('v1/bookings', data: formData);

      Logger().d("Booking Response Status: ${response.statusCode}");
      Logger().d("Booking Response Data: ${response.data}");

      final data = InvoiceModel.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      Logger().e("DioException in postBooking: $errorMessage");
      throw Exception(errorMessage);
    } catch (e) {
      Logger().e("Exception in postBooking: $e");
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> logout(String refreshtoken) async {
    final uri = Uri.parse("${baseurl}v1/auth/logout");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refresh_token": refreshtoken}),
    );

    Logger().d(response);
    if (response.statusCode == 200) {
      return "logout sukses";
    } else {
      throw "logoutgagal";
    }
  }

  @override
  Future<bool> checkBooking(
    String tanggal,
    String starttime,
    String endtime,
  ) async {
    try {
      final response = await dio.dio.get(
        'v1/bookings/availibility',
        queryParameters: {
          'date': tanggal,
          'start_time': starttime,
          'end_time': endtime,
        },
      );
      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode != 401) {
          return false;
        } else if (e.response?.statusCode == 500) {
          throw "server sedang masalah";
        }
      }
      throw e.toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<int>> getQris(String transactionid) async {
    try {
      final response = await dio.dio.get(
        "/v1/bookings/$transactionid/qris",
        options: Options(
          responseType: ResponseType.bytes,
        ), // Expect binary data
      );

      if (response.statusCode == 200) {
        Logger().d("QR Code image received: ${response.data.length} bytes");
        return response.data; // Return raw bytes
      } else {
        throw Exception("Failed to fetch QR code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      Logger().e("DioException while fetching QR: ${e.message}");
      throw Exception("Error fetching QR code: ${e.message}");
    } catch (e) {
      Logger().e("Exception while fetching QR: $e");
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<ListInvoiceModelUser> getlistinvoice(int page, int limit) async {
    try {
      final data = await dio.dio.get(
        'v1/bookings/invoices',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (data.data.toString().contains("no bookings")) {
        return ListInvoiceModelUser(
          message: "no booking",
          metadata: Metadata(count: 0, page: 1, limit: 2),
          data: [],
        );
      }

      return ListInvoiceModelUser.fromJson(data.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Profilemodel> getProfile() async {
    try {
      final data = await dio.dio.get("v1/profiles");
      final readydata = Profilemodel.fromJson(data.data);
      return readydata;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DetailInvoiceModel> getDetailInvoice(String id) async {
    try {
      final data = await dio.dio.get('v1/bookings/invoices/$id');
      Logger().d(data);
      return DetailInvoiceModel.fromJson(data.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> onLoginGoogle() async {
    try {
      final uri = Uri.parse("${baseurl}v1/auth/google/login");

      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // final response = await http.get(
      //   uri,
      //   headers: {'Accept': 'application/json'},
      // );
      // Logger().d(response);
      // if (response.statusCode == 302 || response.statusCode == 301) {
      //   final redirectUrl = response.headers['location'];
      //   return redirectUrl!;
      // } else {
      //   throw Exception(response.statusCode);
      // }
      return "sukses";
    } catch (e) {
      throw Exception(e);
    }
  }
}
