import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'asset_loader_state.dart';

class AssetLoaderCubit extends Cubit<AssetLoaderState> {
  AssetLoaderCubit() : super(const AssetLoaderInitial());

  Future<void> preloadAssets(BuildContext context) async {
    try {
      emit(const AssetLoaderLoading());

      // Preload hanya images yang bukan SVG (PNG, JPG, dll)
      // SVG tidak bisa di-precache menggunakan precacheImage()
      await Future.wait([
        precacheImage(AssetImage('assets/logo/wavenmoment.png'), context),
        precacheImage(AssetImage('assets/logo/DFA00159.JPG'), context),
        precacheImage(AssetImage('assets/logo/buttonimage1.png'), context),
        precacheImage(AssetImage('assets/logo/buttonimage2.png'), context),
        precacheImage(AssetImage('assets/logo/buttonimage3.png'), context),
        precacheImage(AssetImage('assets/logo/backgroundwavenmoment.png'), context),
      ]);

      // Add delay for better UX
      await Future.delayed(Duration(milliseconds: 500));

      emit(const AssetLoaderLoaded());
    } catch (e) {
      emit(AssetLoaderError('Failed to load assets: ${e.toString()}'));
    }
  }
}
