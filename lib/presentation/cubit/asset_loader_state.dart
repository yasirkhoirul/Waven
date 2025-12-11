part of 'asset_loader_cubit.dart';

sealed class AssetLoaderState {
  const AssetLoaderState();
}

class AssetLoaderInitial extends AssetLoaderState {
  const AssetLoaderInitial();
}

class AssetLoaderLoading extends AssetLoaderState {
  const AssetLoaderLoading();
}

class AssetLoaderLoaded extends AssetLoaderState {
  const AssetLoaderLoaded();
}

class AssetLoaderError extends AssetLoaderState {
  final String message;
  const AssetLoaderError(this.message);
}
