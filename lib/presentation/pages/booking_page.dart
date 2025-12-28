import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah1.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah2.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah3.dart';
import 'package:waven/presentation/widget/button.dart';
import 'package:waven/presentation/widget/divider.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';
import 'package:waven/presentation/widget/progress_slider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

final NumberFormat _idrFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

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
              Form2Content(idpackage: widget.idpackage),
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
            child: MyLottie(aset: ImagesPath.loadingwaven),
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
        return SubmittedPage(
          key: const ValueKey('step_submitted'),
          state: state,
        );

      case BookingStep.tahap3:
        // Show upload for transfer, or confirmation for other methods
        return Column(
          key: const ValueKey('step_tahap3'),
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            state.paymentMethod == 'transfer'
                ? Header(
                    langkah: 'Terakhir',
                    sub: 'Lakukan pembayaran sesuai total harga yang tertera,',
                    subsub: 'informasi pembayaran dapat hubungi admin',
                  )
                : Header(
                    langkah: 'Terakhir',
                    sub: 'Silahkan Check Kembai Form Data',
                    subsub: 'Pastikan Tidak Ada Kesalahan',
                  ),
            // Data Confirmation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0,
              children: [
                _ConfirmationItem('Nama', state.nama ?? '-'),
                _ConfirmationItem('Universitas', state.univ ?? '-'),
                _ConfirmationItem('Tanggal Foto', state.tanggal ?? '-'),
                _ConfirmationItem(
                  'Waktu Foto',
                  '${state.starttime ?? '-'} - ${state.endtime ?? '-'}',
                ),
                if (state.packageEntity != null)
                  _ConfirmationItem(
                    state.packageEntity?.tittle ?? '',
                    _idrFormat.format(state.packageEntity?.price ?? 0),
                  ),
                if (state.datadiplih != null)
                  Column(
                    children: state.datadiplih!
                        .map(
                          (e) => _ConfirmationItem(
                            e.tittle,
                            _idrFormat.format(e.price),
                          ),
                        )
                        .toList(),
                  ),

                Divider(color: Colors.white24, height: 24),

                _ConfirmationItem(
                  'Total Dibayar',
                  _idrFormat.format(state.amount ?? 0),
                  isTotal: true,
                ),
              ],
            ),

            // Upload section for transfer only
            if (state.paymentMethod == 'transfer')
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Silahkan Transfer Ke Rekening Berikut',
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Outlined account box with copyable top text and two bold lines below
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF3F3F3F)),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Builder(
                      builder: (context) {
                        // Placeholder account data; replace with real values if available in state
                        final bankName = 'BCA';
                        final accountNumber = '1234567890';
                        final accountHolder = 'Waven Studio';
                        final topText = '$bankName  •  $accountNumber';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    topText,
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: accountNumber),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Nomor rekening disalin',
                                          style: GoogleFonts.robotoFlex(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.black87,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Divider(color: Colors.white24),
                            Text(
                              bankName,
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              accountHolder,
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Text(
                    'Upload Bukti Transfer',
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<BookingCubit>().onTapImage();
                    },
                    child: Container(
                      height: 300,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: state.dataimage != null
                              ? ColorTema.accentColor
                              : Colors.white54,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white10,
                      ),
                      child: state.dataimage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap untuk pilih bukti transfer',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : FutureBuilder<Uint8List>(
                              future: state.dataimage!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }
                                return Center(
                                  child: MyLottie(
                                    aset: ImagesPath.loadingwaven,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),

            // Submit button
            LWebButton(
              label: "Submit",
              onPressed: () {
                // Validate image for transfer
                if (state.paymentMethod == 'transfer' &&
                    state.dataimage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Silahkan upload bukti transfer terlebih dahulu',
                        style: GoogleFonts.robotoFlex(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.read<BookingCubit>().onsubmit();
              },
            ),

            // Back button
            LWebButton(
              label: "Kembali",
              onPressed: () {
                context.read<BookingCubit>().goloaded();
              },
              backgroundColor: ColorTema.abu,
            ),
          ],
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
                style: TextStyle(
                  color: ColorTema.accentColor,
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
              color: ColorTema.accentColor.withOpacity(0.2),
              border: Border.all(color: ColorTema.accentColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: ColorTema.accentColor,
                  size: 48,
                ),
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

          LWebButton(label: "Booking Lagi",onPressed: (){

            context.read<BookingCubit>().getAllDropDown();
          },),
          LWebButton(
            label: "Check",
            onPressed: () {
              if (state.invoice == null ||
                  state.invoice?.bookingDetail.bookingId == null ||
                  state.invoice?.bookingDetail.midtransId == null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Haloo"),
                    content: Row(
                      spacing: 10,
                      children: [
                        Text("Silahkan check invoice kembali di history"),
                        LWebButton(label: "OK",onPressed: (){
                          context.go("/Profile");
                        },)
                      ],
                    ),
                  ),
                );
              } else {
                context.read<BookingCubit>().checkTransaction(
                  state.invoice!.bookingDetail.bookingId,
                  state.invoice!.bookingDetail.midtransId!,
                );
              }
            },
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

class _ConfirmationItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _ConfirmationItem(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.robotoFlex(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              textAlign: TextAlign.end,
              value,
              style: GoogleFonts.robotoFlex(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
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
