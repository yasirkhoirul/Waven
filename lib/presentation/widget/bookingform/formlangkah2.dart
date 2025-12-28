import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/color.dart';
import 'package:intl/intl.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/widget/bookingform/formlangkah3.dart';
import 'package:waven/presentation/widget/button.dart';

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
    // request profile data and initialize controllers if available
    try {
      context.read<ProfileCubit>().onGetdata();
      final pstate = context.read<ProfileCubit>().state;
      if (pstate.requestState == RequestState.loaded && pstate.data != null) {
        final profile = pstate.data!;
        if (nama.text.isEmpty) nama.text = profile.name;
        if (nowa.text.isEmpty) nowa.text = profile.phonenumber;
      }
    } catch (_) {}
  }

  // Indonesian currency formatter
  static final NumberFormat _idrFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, pstate) {
        if (pstate.requestState == RequestState.loaded && pstate.data != null) {
          final profile = pstate.data!;
          if (nama.text.isEmpty) nama.text = profile.name;
          if (nowa.text.isEmpty) nowa.text = profile.phonenumber;
        }
      },
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocConsumer<PackageAllCubit, PackageAllState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PackageAllLoaded) {
                  return RadioGroup<PackageEntity>(
                    groupValue: packageEntity,
                    onChanged: (value) => setState(() {
                      packageEntity = value;
                    }),

                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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

                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.data[index].tittle,
                                      style: GoogleFonts.robotoFlex(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _idrFormat.format(
                                        state.data[index].price,
                                      ),
                                      style: GoogleFonts.robotoFlex(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
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
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                    isiMportant: false,
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
            ListPackage(
              ontap: (List<Addons> values) {
                Logger().d("terangkat di form 2 $values");
                setState(() {
                  selectedBenefits = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                LWebButton(label: "Kembali",onPressed: () {
                  context.read<BookingCubit>().goloaded();
                },backgroundColor: ColorTema.abu,),
                LWebButton(
                  label: "Lanjut",
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      // validate WA number: must start with 62 or 0 and contain only digits
                      String phoneRaw = nowa.text.trim();
                      if (!RegExp(r'^(0|62)\d{9,13}$').hasMatch(phoneRaw)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            icon: Icon(Icons.error),
                            content: Text(
                              'Nomor WA harus dimulai dengan 0 atau 62 dan hanya berisi angka',
                            ),
                          ),
                        );
                        return;
                      }

                      // normalize to start with 62
                      if (phoneRaw.startsWith('0')) {
                        phoneRaw = '62' + phoneRaw.substring(1);
                      } else if (!phoneRaw.startsWith('62')) {
                        phoneRaw = '62' + phoneRaw;
                      }

                      context.read<BookingCubit>().onTahapTwo(
                        packageEntity!,
                        nama.text,
                        phoneRaw,
                        lokasi.text,
                        instagram.text,
                        catatan.text,
                        selectedBenefits,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
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
  final bool? isiMportant;
  final List<TextInputFormatter>? textInputFormatter;
  const InputBox({
    super.key,
    required this.errormessage,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxline,
    this.textInputFormatter,
    this.isiMportant,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: textInputFormatter,
      maxLines: maxline,
      controller: controller,
      validator: isiMportant != null
          ? null
          : (value) {
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
