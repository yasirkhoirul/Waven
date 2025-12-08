// Example: Jika ingin menampilkan QR image dari bytes di UI
// (Optional - jika diperlukan)

import 'dart:typed_data';
import 'package:flutter/material.dart';

// Di cubit atau state management
class QrImageState {
  final Uint8List? qrImageBytes;
  final bool isLoading;
  final String? error;
  
  QrImageState({
    this.qrImageBytes,
    this.isLoading = false,
    this.error,
  });
}

// Helper untuk display QR image
class QrImageDisplay extends StatelessWidget {
  final Uint8List imageBytes;
  
  const QrImageDisplay({required this.imageBytes});
  
  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageBytes,
      fit: BoxFit.contain,
      width: 250,
      height: 250,
    );
  }
}

// Atau gunakan CachedNetworkImage dengan URL dari invoice
// seperti yang sudah ada di SubmittedPage:
// 
// CachedNetworkImage(
//   imageUrl: state.invoice!.paymentQrUrl!,
//   fit: BoxFit.cover,
//   placeholder: (context, url) => CircularProgressIndicator(),
// )
