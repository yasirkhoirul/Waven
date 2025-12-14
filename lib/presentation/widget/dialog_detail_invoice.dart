import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/dialog_transaction.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';

class InvoiceDialog extends StatefulWidget {
  final String id;
  const InvoiceDialog({super.key, required this.id});

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  @override
  void initState() {
    context.read<DetailInvoiceCubit>().ongetDetail(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 600, maxWidth: 800),
        child: Card(
          color: Color(0xFF3E3E3E),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<DetailInvoiceCubit, DetailInvoiceState>(
              listener: (context, state) {
                if (state is SessionExpired) {
                  context.read<TokenauthCubit>().onLogout();
                }
              },
              builder: (context, state) {
                if (state is DetailInvoiceLoading) {
                  return Center(
                    child: SizedBox(
                      height: 100,
                      child: MyLottie(aset: ImagesPath.loadinglottie),
                    ),
                  );
                }

                if (state is DetailInvoiceerror) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 40),
                        SizedBox(height: 10),
                        Text(
                          state.message,
                          style: GoogleFonts.robotoFlex(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }

                if (state is! DetailInvoiceLoaded) {
                  return Center(
                    child: Text(
                      'No data',
                      style: GoogleFonts.robotoFlex(color: Colors.white),
                    ),
                  );
                }

                final data = state.data;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "Detail Pembayaran",
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 25),
                      Card(
                        color: Color(0xFF595959),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ItemText(
                                      jenis: 'Nama Client',
                                      isi: data.clientName,
                                    ),
                                    ItemText(
                                      jenis: 'Universitas',
                                      isi: data.university,
                                    ),
                                    ItemText(
                                      jenis: 'Status Bayar',
                                      isi: data.status,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ItemText(
                                      jenis: 'Package',
                                      isi: data.packageName,
                                    ),
                                    ItemText(
                                      jenis: 'Extra',
                                      isi: data.extra.isNotEmpty
                                          ? data.extra
                                                .map((e) => e.name)
                                                .join(', ')
                                          : 'Tidak ada',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(height: 1),
                      SizedBox(height: 5),
                      Column(
                        spacing: 10,
                        children: [
                          RowItem(
                            jenis: 'Total Bayar',
                            isi: 'Rp ${data.totalAmount.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(height: 1),
                      SizedBox(height: 5),
                      Column(
                        spacing: 10,
                        children: [
                          RowItem(
                            jenis: 'Sudah Bayar',
                            isi: 'Rp ${data.paidAmount.toStringAsFixed(0)}',
                          ),
                          RowItem(
                            jenis: 'Kurang Bayar',
                            isi: 'Rp ${data.unpaidAmount.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(height: 1),
                      SizedBox(height: 15),
                      Text(
                        "Riwayat Transaksi",
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF595959),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: data.transactions.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada transaksi',
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount: data.transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = data.transactions[index];
                                  return TransactionHistoryItem(
                                    transaction: transaction,
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 15),
                      Divider(height: 1),
                      SizedBox(height: 15),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OulinedGreen(),
                          data.status == "LUNAS" || data.status == "CANCELLED"
                              ? Container()
                              : PopupMenuButton(
                                  onSelected: (value) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => DialogTransaction(
                                        idinvoice: widget.id,
                                        type: value,
                                        transactiontype: data.status,
                                        onTransactionSuccess: () {
                                          context
                                              .read<DetailInvoiceCubit>()
                                              .refreshDetail();
                                        },
                                      ),
                                    );
                                  },
                                  itemBuilder: (context) => ['Transfer', 'Qris']
                                      .map(
                                        (e) => PopupMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bayar",
                                        style: GoogleFonts.robotoFlex(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OulinedGreen extends StatelessWidget {
  const OulinedGreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        side: BorderSide(color: ColorTema.accentColor, width: 2),
      ),
      onPressed: () {
        context.pop();
      },
      child: Text(
        "Batal",
        style: GoogleFonts.robotoFlex(
          color: ColorTema.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String jenis;
  final String isi;
  const RowItem({super.key, required this.jenis, required this.isi});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          jenis,
          style: GoogleFonts.robotoFlex(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          isi,
          style: GoogleFonts.robotoFlex(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w100,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ItemText extends StatelessWidget {
  final String jenis;
  final String isi;
  const ItemText({super.key, required this.jenis, required this.isi});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          jenis,
          style: GoogleFonts.robotoFlex(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          isi,
          style: GoogleFonts.robotoFlex(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w100,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class TransactionHistoryItem extends StatelessWidget {
  final dynamic transaction;

  const TransactionHistoryItem({super.key, required this.transaction});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
      case 'BERHASIL':
        return ColorTema.accentColor;
      case 'FAILED':
      case 'GAGAL':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF474747),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(transaction.amount),
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.status,
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${transaction.type} - ${transaction.method}',
                  style: GoogleFonts.robotoFlex(
                    color: Color(0xFFB0B0B0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              transaction.transactionTime,
              style: GoogleFonts.robotoFlex(
                color: Color(0xFF888888),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
