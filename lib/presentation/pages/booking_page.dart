import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah1.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah2.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah3.dart';
import 'package:waven/presentation/widget/divider.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';
import 'package:waven/presentation/widget/progress_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatefulWidget {
  final String idpackage;
  const BookingPage({super.key, required this.idpackage});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    context.read<BookingCubit>().getAllDropDown();
    super.initState();
  }

  Widget _buildContentByStep(BookingState state) {
    switch (state.step) {
      case BookingStep.loaded:
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(
              langkah: '1',
              sub: 'Pilih tanggal dan waktu',
              subsub:
                  "Pilih universitas asalmu, pilih tanggal, pilih jam yang tersedia",
            ),
            FormContent(),
          ],
        );

      case BookingStep.tahap1:
        return SizedBox(
          height: 1200,
          key: const ValueKey('step_tahap1'),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header(
                langkah: '2',
                sub: 'Pilih Paket dan Isi form',
                subsub: 'Isi form lengkap untuk keep the slot!',
              ),
              Expanded(child: Form2Content(idpackage: widget.idpackage)),
            ],
          ),
        );

      case BookingStep.tahap2:
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderWa(langkah: '3', sub: 'Bayar dan Upload Bukti Bayar'),
            Form3Content(),
          ],
        );

      case BookingStep.loading:
        return Center(
          key: const ValueKey('step_loading'),
          child: SizedBox(
            height: 300,
            width: 300,
            child: MyLottie(aset: ImagesPath.loadinglottie),
          ),
        );

      case BookingStep.error:
        return Center(
          key: const ValueKey('step_error'),
          child: Text(
            "Terjadi Kesalahan ${state.errorMessage}",
            style: GoogleFonts.robotoFlex(color: Colors.white),
          ),
        );

      case BookingStep.submitted:
        Logger().d("invoice di state = ${state.invoice}");
        return SubmittedPage(
          key: const ValueKey('step_submitted'),
          state: state,
        );

      case BookingStep.tahap3:
        return Center(
          key: const ValueKey('step_tahap3'),
          child: ElevatedButton(
            onPressed: () {
              context.read<BookingCubit>().onsubmit();
            },
            child: const Text("Submit"),
          ),
        );

      default:
        return Container(key: const ValueKey('step_default'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                LayourHeaders(
                  headername: 'Booking',
                  subheader: 'Home / Data List',
                ),
                // Progress Slider di atas FrostGlass
                BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    int currentStep = 0;
                    if (state.step == BookingStep.tahap1) {
                      currentStep = 1;
                    } else if (state.step == BookingStep.tahap2) {
                      currentStep = 2;
                    } else if (state.step == BookingStep.tahap3 ||
                        state.step == BookingStep.submitted) {
                      return Container();
                    }
                    return ProgressSlider(currentStep: currentStep);
                  },
                ),
                // FrostGlass dengan content
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 400, maxWidth: 700),
                  child: FrostGlassAnimated(
                    width: constraints.maxWidth * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocConsumer<BookingCubit, BookingState>(
                        listener: (context, state) {
                          if (state is BookingSessionExpired) {
                            context.read<TokenauthCubit>().onLogout();
                          } else if (state.step == BookingStep.error) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Gagal"),
                                content: Text("${state.errorMessage}"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<BookingCubit>().goloaded();
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.95, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildContentByStep(state),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LayourHeaders extends StatelessWidget {
  final String headername;
  final String subheader;
  const LayourHeaders({
    super.key,
    required this.headername,
    required this.subheader,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return constrains.maxWidth < 300
                      ? Column(
                          children: [
                            Expanded(
                              child: Text(
                                headername,
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                subheader,
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                headername,
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 48,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                subheader,
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
            AnimatedDividerCurve(
              color: Colors.white,
              height: 1,
              duration: Duration(seconds: 1),
              curve: Curves.easeOutBack,
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String langkah;
  final String sub;
  final String subsub;
  const Header({
    super.key,
    required this.langkah,
    required this.sub,
    required this.subsub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Langkah $langkah:\n$sub",
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        Text(
          subsub,
          style: GoogleFonts.robotoFlex(
            color: ColorTema.abu,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class HeaderWa extends StatelessWidget {
  final String langkah;
  final String sub;
  const HeaderWa({super.key, required this.langkah, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Langkah $langkah:\n$sub",
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 14, color: ColorTema.abu),
            children: [
              const TextSpan(
                text:
                    "Lakukan Pembayaran Sesuai Total, Kirim bukti bayar dengan klik upload bukti, atau dapat chat via admin ke ",
              ),
              TextSpan(
                text: "wa.me/6285331973131",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    // Aksi ketika link di klik, misal launch URL
                    final Uri url = Uri.parse("https://wa.me/6285331973131");

                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: '_blank', // Untuk Web: buka tab baru
                    )) {
                      throw Exception('Gagal buka WA');
                    }
                  },
              ),
              const TextSpan(
                text:
                    ". Pastikan menerima tanda booking berhasil dari admin setelah konfirmasi bukti bayar",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SubmittedPage extends StatelessWidget {
  final BookingState state;
  const SubmittedPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 12),
                Text(
                  'Booking Berhasil!',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Silahkan lakukan pembayaran sesuai metode yang dipilih',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // QR Code Section (if available)
          if (state.invoice?.paymentQrUrl != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Scan untuk Pembayaran',
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: QrImageDisplay(
                      imageBytes:
                          state.invoice?.gambarqr ?? Uint8List.fromList([]),
                    ),
                  ),
                ],
              ),
            ),

          // Booking Details
          if (state.invoice?.bookingDetail != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    'Detail Booking',
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(color: Colors.white24),
                  _DetailRow(
                    'Booking ID',
                    state.invoice!.bookingDetail.bookingId,
                  ),
                  if (state.invoice!.bookingDetail.midtransId != null)
                    _DetailRow(
                      'Midtrans ID',
                      state.invoice!.bookingDetail.midtransId!,
                    ),
                  _DetailRow(
                    'Total Amount',
                    'Rp ${state.invoice!.bookingDetail.totalAmount}',
                  ),
                  _DetailRow(
                    'Paid Amount',
                    'Rp ${state.invoice!.bookingDetail.paidAmount}',
                  ),
                  _DetailRow(
                    'Currency',
                    state.invoice!.bookingDetail.currency ?? '-',
                  ),

                  _DetailRow(
                    'Payment Method',
                    state.invoice!.bookingDetail.paymentMethod.toUpperCase(),
                  ),
                  _DetailRow(
                    'Status',
                    state.invoice!.bookingDetail.paymentStatus,
                  ),
                  _DetailRow(
                    'Transaction Time',
                    state.invoice!.bookingDetail.transactionTime,
                  ),
                  if (state.invoice!.bookingDetail.acquirer != null)
                    _DetailRow(
                      'Acquirer',
                      state.invoice!.bookingDetail.acquirer!,
                    ),
                ],
              ),
            ),

          // Action Buttons
          SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: ColorTema.accentColor,
              ),
              onPressed: () {
                // Navigate back or perform action
                context.read<BookingCubit>().getAllDropDown();
              },
              child: Text(
                'Selesai',
                style: GoogleFonts.robotoFlex(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoFlex(color: Colors.grey[400], fontSize: 12),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class QrImageDisplay extends StatelessWidget {
  final Uint8List imageBytes;

  const QrImageDisplay({required this.imageBytes, super.key});

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
