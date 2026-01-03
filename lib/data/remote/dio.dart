import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waven/data/remote/data_local_impl.dart'; // Ganti sesuai package local storage bapak

class DioClient {
  late Dio _dio;
  final DataLocal dataLocal;
  final Function()? onAuthorized;

  // 1. Masukkan URL API Bapak disini
  final String baseUrl = "https://waven-development.site/";

  // Variable untuk mencegah refresh token berkali-kali bersamaan
  bool _isRefreshing = false;

  DioClient(this.dataLocal,{this.onAuthorized}) {
    // Setup dasar Dio
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20), // Waktu tunggu maksimal
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
      ),
    );

    // --- DISINI KITA PASANG SATPAM (INTERCEPTOR) ---
    _dio.interceptors.add(
      InterceptorsWrapper(
        // A. TUGAS SAAT MAU KIRIM DATA (REQUEST)
        onRequest: (options, handler) async {
          // Ambil token dari Local Storage bapak
          // GANTI BARIS INI sesuai kodingan bapak untuk ambil token
          String? token = await dataLocal.getAcessToken();

          if (token != null) {
            // Tempel token otomatis di Header
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options); // Lanjut jalan
        },

        // B. TUGAS SAAT ADA ERROR (RESPONSE)
        onError: (DioException error, handler) async {
          // Cek: Apakah errornya 401 (Token Mati)?
          if (error.response?.statusCode == 401) {
            // Cek: Jangan refresh kalau yang error adalah url refresh token itu sendiri
            if (error.requestOptions.path.contains('refresh-token')) {
              return handler.next(error);
            }

            print("⚠️ Token Mati! Satpam sedang mengurus Refresh Token...");

            // KUNCI: Lakukan Refresh Token
            if (!_isRefreshing) {
              _isRefreshing = true;

              // Panggil fungsi refresh (ada di bawah)
              final newToken = await _refreshTokenApi();

              _isRefreshing = false;

              if (newToken != null) {
                print("✅ Refresh Sukses! Mengirim ulang paket...");

                
                // 2. Update token di request yang tadi gagal
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';

                // 3. Clone dan Ulangi Request (Retry)
                try {
                  final clonedRequest = await _dio.fetch(error.requestOptions);
                  return handler.resolve(
                    clonedRequest,
                  ); // Berhasil diselamatkan!
                } catch (e) {
                  return handler.next(error);
                }
              } else {
                onAuthorized?.call();
                return handler.next(error);
              }
            }
          }
          // Kalau error bukan 401, biarkan saja
          return handler.next(error);
        },
      ),
    );
  }

  // Agar bisa dipakai di luar
  Dio get dio => _dio;

  // --- FUNGSI RAHASIA UNTUK HIT API REFRESH ---
  Future<String?> _refreshTokenApi() async {
    try {
      // Ambil refresh token lama
      String? refreshToken = await const FlutterSecureStorage().read(
        key: 'refresh_token',
      );

      // Pakai Dio baru (polos) agar tidak kena interceptor loop
      final dioRefresh = Dio(BaseOptions(baseUrl: baseUrl));

      final response = await dioRefresh.post(
        'v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      if (response.statusCode == 200) {
        final newAccessToken = response.headers.value('X-Access-Token');

        // Ambil Refresh Token Baru (Biasanya ikut dirotasi juga)
        final newRefreshToken = response.headers.value('X-Refresh-Token');
        if (newAccessToken != null) {
          // Simpan token baru.
          // Jika newRefreshToken ada, simpan juga. Jika null, pakai yang lama.
          await dataLocal.saveTokens(
            newAccessToken,
            newRefreshToken ??
                refreshToken!, // Fallback ke lama jika header kosong
          );
        }
        // Ambil token baru dari JSON (Sesuaikan dengan respon API bapak)
        return newAccessToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
