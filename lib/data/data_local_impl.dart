import 'package:flutter_secure_storage/flutter_secure_storage.dart';
abstract class DataLocal {
  Future<void> saveTokens(String acces,String refresh);
  Future<void> deleteTokens();
  Future<String?> getAcessToken();
  Future<String?> getRefreshToken();
}

class DataLocalImpl implements DataLocal{
  final FlutterSecureStorage flutterSecureStorage;
  const DataLocalImpl(this.flutterSecureStorage);
  @override
  Future<void> deleteTokens() async{
    await flutterSecureStorage.deleteAll();
  }

  @override
  Future<String?> getAcessToken() async{
    return await flutterSecureStorage.read(key: 'acces_token');
  }

  @override
  Future<String?> getRefreshToken() async{
    return await flutterSecureStorage.read(key: 'refresh_token');
  }

  @override
  Future<void> saveTokens(String acces,String refresh) async {
    await flutterSecureStorage.write(key: "acces_token", value: acces);
    await flutterSecureStorage.write(key: "refresh_token", value: refresh);
  }
} 