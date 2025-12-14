import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';

class Dialogtextinput extends StatefulWidget {
  final String idDetailInvoice;
  const Dialogtextinput({required this.idDetailInvoice, super.key});

  @override
  State<Dialogtextinput> createState() => _DialogtextinputState();
}

class _DialogtextinputState extends State<Dialogtextinput> {
  final TextEditingController editedphototeks = TextEditingController();
  final GlobalKey<FormState> _fomkey = GlobalKey<FormState>();

  @override
  void dispose() {
    editedphototeks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: Card(
          color: Color(0xFF3E3E3E),
          child: Form(
            key: _fomkey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: BlocConsumer<DetailInvoiceCubit, DetailInvoiceState>(
                  listener: (context, state) {
                    if (state is SessionExpired) {
                      context.read<TokenauthCubit>().onLogout();
                    }
                  },
                  builder: (context, state) {

                    if (state is DetailInvoiceLoading) {
                      return Center(child: CircularProgressIndicator(),);
                    }

                    if (state is DetailInvoiceerror) {
                      return Center(
                        child: Column(
                          children: [
                            Text("Terjadi Kesalahan"),
                            ElevatedButton(onPressed: (){
                              context.pop();
                            }, child: Text('tutup'))
                          ],
                        ),
                      );
                    }

                    if (state is DetailSubmitEdited) {
                      return Center(
                        child: Column(
                          children: [
                            Text(state.message),
                            ElevatedButton(onPressed: (){
                              context.read<DetailInvoiceCubit>().goinit();
                              context.pop();
                            }, child: Text('tutup'))
                          ],
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 20,
                      children: [
                        Text(
                          "Silahkan isikan nama file yang ingin di edit pisahkan dengan (,)",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Ex : gambar_1, gambar_2, gambar_3",
                          style: GoogleFonts.robotoFlex(
                            color: ColorTema.accentColor,
                            fontSize: 14,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "tidak boleh kosong ya";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          controller: editedphototeks,
                          style: GoogleFonts.robotoFlex(color: Colors.white),
                          maxLines: 4,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            side: BorderSide(
                              color: ColorTema.accentColor,
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            if (_fomkey.currentState!.validate()) {
                              context
                                  .read<DetailInvoiceCubit>()
                                  .onSubmitEditedPhoto(
                                    widget.idDetailInvoice,
                                    editedphototeks.text,
                                  );
                            }
                          },
                          child: Text(
                            "Kirim",
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
                            side: BorderSide(color: Colors.red, width: 2),
                          ),
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            "Batal",
                            style: GoogleFonts.robotoFlex(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
