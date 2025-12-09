import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/color.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/pages/booking_page.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah3.dart';

class Form2Content extends StatefulWidget {
  final String idpackage;
  const Form2Content({super.key, required this.idpackage});

  @override
  State<Form2Content> createState() => _Form2ContentState();
}

class _Form2ContentState extends State<Form2Content> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController nama = TextEditingController();
  final TextEditingController nowa = TextEditingController();
  final TextEditingController lokasi = TextEditingController();
  final TextEditingController instagram = TextEditingController();
  final TextEditingController catatan = TextEditingController();
  String? idpackage;
  PackageEntity? packageEntity;
  List<Addons> selectedBenefits = [];

  @override
  void initState() {
    idpackage = widget.idpackage;
    final state = context.read<PackageAllCubit>().state;
    if (state is PackageAllLoaded) {
      // Cari data yang cocok
      try {
        packageEntity = state.data.firstWhere((e) => e.id == widget.idpackage);
      } catch (e) {
        // Handle jika id tidak ditemukan
        packageEntity = null;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    nama.dispose();
    nowa.dispose();
    lokasi.dispose();
    instagram.dispose();
    catatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocConsumer<PackageAllCubit, PackageAllState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PackageAllLoaded) {
                  return RadioGroup<PackageEntity>(
                    groupValue: packageEntity,
                    onChanged: (value) => setState(() {
                      packageEntity = value;
                    }),

                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: RadioListTile(
                              activeColor: Colors.blueGrey,
                              isThreeLine: true,
                              value: state.data[index],

                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.data[index].tittle,
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    state.data[index].price.toString(),
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.data[index].description,
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () => context.goNamed(
                                          'package',
                                          pathParameters: {
                                            'id': state.data[index].id,
                                          },
                                        ),
                                        child: Text(
                                          "Details",
                                          style: GoogleFonts.robotoFlex(
                                            color: ColorTema.accentColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorTema.accentColor,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.data.length,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Center(
            child: Column(
              spacing: 10,
              children: [
                InputBox(
                  errormessage: "Silahkan masukkan nama",
                  label: "Nama Lengkap",
                  hint: 'Masukkan nama lengkap kamu',
                  controller: nama,
                ),
                InputBox(
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  errormessage: "Masukkan masukkan WA dulu",
                  label: "No Whatsapp",
                  hint: 'Masukkan Nomor Whatsapp Aktif Kamu',
                  controller: nowa,
                ),
                InputBox(
                  errormessage: "Silahkan masukkan Lokasi",
                  label: "Lokasi Foto",
                  hint: 'Mau di kampus atau cafe? Tulis detail disini yaa',
                  controller: lokasi,
                  maxline: 4,
                ),
                InputBox(
                  errormessage: "Silahkan masukkan Instagram",
                  label: "Instagram",
                  hint:
                      'Masukkan username instagram kamu, Buat backup kontak dan admin bisa tag kamu di instagram ya..',
                  controller: instagram,
                ),
                InputBox(
                  errormessage: "Silahkan masukkan nama",
                  label: "Catatan (opsional)",
                  hint: 'Tulis jika kamu ingin request tambahan',
                  controller: catatan,
                  maxline: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            flex: 2,
            child: ListPackage(
              ontap: (List<Addons> values) {
                Logger().d("terangkat di form 2 $values");
                setState(() {
                  selectedBenefits = values;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  backgroundColor: ColorTema.abu,
                ),
                onPressed: () {
                  context.read<BookingCubit>().goloaded();
                },
                child: Text(
                  "Back",
                  style: GoogleFonts.robotoFlex(color: Colors.white),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: ColorTema.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    context.read<BookingCubit>().onTahapTwo(
                      packageEntity!,
                      nama.text,
                      nowa.text,
                      lokasi.text,
                      instagram.text,
                      catatan.text,
                      selectedBenefits,
                    );
                  }
                },
                child: Text(
                  "Kirim",
                  style: GoogleFonts.robotoFlex(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final String errormessage;
  final String label;
  final String hint;
  final TextEditingController controller;
  final int? maxline;
  final List<TextInputFormatter>? textInputFormatter;
  const InputBox({
    super.key,
    required this.errormessage,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxline,
    this.textInputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: textInputFormatter,
      maxLines: maxline,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errormessage;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        labelText: label,
        labelStyle: GoogleFonts.robotoFlex(color: Colors.white),
        hintText: hint,
        hintStyle: GoogleFonts.robotoFlex(color: Colors.grey[400]),
      ),
      style: GoogleFonts.robotoFlex(color: Colors.white),
    );
  }
}
