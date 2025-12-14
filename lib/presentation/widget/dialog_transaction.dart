import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/transaction_cubit.dart';

class DialogTransaction extends StatefulWidget {
  final String idinvoice;
  final String type;
  final String transactiontype;
  final VoidCallback? onTransactionSuccess;
  const DialogTransaction({
    super.key,
    required this.idinvoice,
    required this.type,
    required this.transactiontype,
    this.onTransactionSuccess,
  });

  @override
  State<DialogTransaction> createState() => _DialogTransactionState();
}

class _DialogTransactionState extends State<DialogTransaction> {
  String pendingpaymenttype = '';

  @override
  void initState() {
    context.read<TransactionCubit>().initIdInvoice(widget.idinvoice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Card(
          color: Color(0xFF3E3E3E),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Builder(
              builder: (context) {
                if (widget.transactiontype == "DP") {
                  return Form(
                    methodtype: widget.type,
                    paymentType: 'pelunasan',
                    onTransactionSuccess: widget.onTransactionSuccess,
                  );
                } else {
                  if (pendingpaymenttype.isNotEmpty) {
                    if (pendingpaymenttype == "DP" ||
                        pendingpaymenttype == "Lunas") {
                      return Form(
                        methodtype: widget.type,
                        paymentType: pendingpaymenttype,
                        onTransactionSuccess: widget.onTransactionSuccess,
                      );
                    }
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pendingpaymenttype = "DP";
                            });
                          },
                          child: Text("DP"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pendingpaymenttype = "Lunas";
                            });
                          },
                          child: Text("Lunas"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Form extends StatelessWidget {
  final String paymentType;
  final String methodtype;
  final VoidCallback? onTransactionSuccess;
  const Form({
    super.key,
    required this.methodtype,
    required this.paymentType,
    this.onTransactionSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailInvoiceCubit, DetailInvoiceState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DetailInvoiceLoaded) {
          context.read<TransactionCubit>().inUnpaidAmount(
            state.data.unpaidAmount,
            paymentType,
          );
          return Center(
            child: methodtype == "Qris"
                ? QrisForm(
                    tipepembayaran: paymentType,
                    onTransactionSuccess: onTransactionSuccess,
                  )
                : TransferForm(
                    tipepembayaran: paymentType,
                    onTransactionSuccess: onTransactionSuccess,
                  ),
          );
        } else {
          return Center(child: Text("Terjadi kesalahan silahkan coba lagi"));
        }
      },
    );
  }
}

class TransferForm extends StatelessWidget {
  final String tipepembayaran;
  final VoidCallback? onTransactionSuccess;

  const TransferForm({
    super.key,
    required this.tipepembayaran,
    this.onTransactionSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state.step == RequestState.loaded) {
          // Trigger refresh detail invoice
          Future.delayed(Duration(seconds: 1), () {
            onTransactionSuccess?.call();
            context.read<TransactionCubit>().resetState();
            Navigator.of(context).pop();
          });
        }
        if (state.step == RequestState.error) {
          // Trigger refresh detail invoice
          Future.delayed(Duration(seconds: 1), () {
            context.read<TransactionCubit>().resetState();
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state) {
        if (state.step == RequestState.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTema.accentColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Mengirim pembayaran...',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.step == RequestState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 15),
                Text(
                  'Gagal Mengirim',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  state.errormessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.red[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.step == RequestState.loaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: ColorTema.accentColor,
                  size: 60,
                ),
                SizedBox(height: 15),
                Text(
                  'Pembayaran Berhasil',
                  style: GoogleFonts.robotoFlex(
                    color: ColorTema.accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Silakan tunggu sebentar...',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 15,
              children: [
                Text(
                  'Bukti Transfer',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      context.read<TransactionCubit>().pickimage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFF595959),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: state.image == null
                              ? ColorTema.accentColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: state.image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  color: ColorTema.accentColor,
                                  size: 40,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tambah Foto',
                                  style: GoogleFonts.robotoFlex(
                                    color: ColorTema.accentColor,
                                  ),
                                ),
                              ],
                            )
                          : Image.memory(state.image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Card(
                  color: Color(0xFF595959),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Bayar',
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Rp ${state.unpaidAmount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                              style: GoogleFonts.robotoFlex(
                                color: ColorTema.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.white24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tipe Pembayaran',
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              tipepembayaran.toUpperCase(),
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTema.accentColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: state.image == null
                      ? null
                      : () {
                          context.read<TransactionCubit>().toTransaction(
                            tipepembayaran,
                            "transfer",
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(Icons.send, color: Colors.white),
                      Text(
                        'Kirim Bukti',
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

class QrisForm extends StatefulWidget {
  final String tipepembayaran;
  final VoidCallback? onTransactionSuccess;
  const QrisForm({
    super.key,
    required this.tipepembayaran,
    this.onTransactionSuccess,
  });

  @override
  State<QrisForm> createState() => _QrisFormState();
}

class _QrisFormState extends State<QrisForm> {
  @override
  void initState() {
    context.read<TransactionCubit>().toTransaction(
      widget.tipepembayaran,
      "qris",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state.step == RequestState.error) {
          Future.delayed(Duration(seconds: 1), () {
            context.read<TransactionCubit>().resetState();
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state) {
        if (state.step == RequestState.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTema.accentColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Menggenerate QRIS...',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.step == RequestState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 15),
                Text(
                  'Gagal Generate QRIS',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  state.errormessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.red[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 15,
              children: [
                Text(
                  'Scan QRIS untuk Membayar',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: state.transactionEntityDetail?.gambarqr != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              state.transactionEntityDetail!.gambarqr!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(child: Text('No QRIS')),
                  ),
                ),
                Card(
                  color: Color(0xFF595959),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Bayar',
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Rp ${state.unpaidAmount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                              style: GoogleFonts.robotoFlex(
                                color: ColorTema.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.white24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Metode',
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'QRIS',
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF595959),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: ColorTema.accentColor, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Buka aplikasi pembayaran Anda dan scan kode QRIS ini',
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    side: BorderSide(color: ColorTema.accentColor, width: 2),
                  ),
                  onPressed: () {
                    context.read<TransactionCubit>().checkTransaction();
                  },
                  child: Text(
                    "Cek Pembayaran",
                    style: GoogleFonts.robotoFlex(
                      color: ColorTema.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    side: BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  onPressed: () {
                    context.read<TransactionCubit>().resetState();
                    context.pop();
                  },
                  child: Text(
                    "tutup",
                    style: GoogleFonts.robotoFlex(
                      color: ColorTema.accentColor,
                      fontWeight: FontWeight.bold,
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
