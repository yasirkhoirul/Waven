import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/package_detail_cubit.dart';
import 'package:waven/presentation/widget/frostglass.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FrostGlassAnimated(
              width: constraints.maxWidth * 0.8,
              height: 1200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<BookingCubit, BookingState>(
                  listener: (context, state) {
                     Logger().i("""
nama : ${state.nama}
lokasi : ${state.lokasi}
catatan : ${state.catatan}
method : ${state.paymentMethod}
type: ${state.paymentType}
catatan : ${state.catatan}
nama : ${state.ig}
addons : ${state.datadiplih}
tanggal : ${state.tanggal}
start : ${state.starttime}
end : ${state.endtime}
""");
                    if (state is Bookingtahap3) {
                     
                    }
                  },
                  builder: (context, state) {
                    if (state is BookingReady) {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Header(langkah: '1', sub: 'Pilih tanggal dan waktu'),
                          Expanded(child: FormContent()),
                        ],
                      );
                    } else if (state is Bookingtahap1) {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Header(langkah: '2', sub: 'Pilih Paket dan Isi form'),
                          Expanded(
                            child: Form2Content(idpackage: widget.idpackage),
                          ),
                        ],
                      );
                    } else if (state is Bookingtahap2) {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Header(
                            langkah: '3',
                            sub: 'Bayar dan Upload Bukti Bayar',
                          ),
                          Expanded(child: Form3Content()),
                        ],
                      );
                    } else if (state is BookingLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is BookingError) {
                      return Center(
                        child: Text(
                          "Terjadi Kesalahan",
                          style: GoogleFonts.robotoFlex(color: Colors.white),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Form3Content extends StatefulWidget {
  const Form3Content({super.key});

  @override
  State<Form3Content> createState() => _Form3ContentState();
}

class _Form3ContentState extends State<Form3Content> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;
  String? _selectedPaymentType;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Silahkan pilih metode pembayaran";
              }
              return null;
            },
            decoration: InputDecoration(
              labelStyle: GoogleFonts.robotoFlex(color: Colors.white),
              labelText: "Metode Pembayaran",
              hintText: "Pilih metode pembayaran",
              hintStyle: GoogleFonts.robotoFlex(color: Colors.grey),
              iconColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: constantclass.paymentMethod.map((method) {
              return DropdownMenuItem<String>(
                value: method,
                child: Text(
                  method.toUpperCase(),
                  style: GoogleFonts.robotoFlex(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value;
              });
            },
            value: _selectedPaymentMethod,
          ),
          DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Silahkan pilih tipe pembayaran";
              }
              return null;
            },
            decoration: InputDecoration(
              labelStyle: GoogleFonts.robotoFlex(color: Colors.white),
              labelText: "Tipe Pembayaran",
              hintText: "Pilih tipe pembayaran",
              hintStyle: GoogleFonts.robotoFlex(color: Colors.grey),
              iconColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: constantclass.paymentType.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: GoogleFonts.robotoFlex(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPaymentType = value;
              });
            },
            value: _selectedPaymentType,
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: ColorTema.accentColor,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<BookingCubit>().onTahapThree(
                    _selectedPaymentType!,
                    _selectedPaymentMethod!,
                  );
                }
              },
              child: Text(
                "Lanjutkan",
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

class ListPackage extends StatefulWidget {
  const ListPackage({super.key, required this.ontap});
  final Function(List<Addons>) ontap;

  @override
  State<ListPackage> createState() => _ListPackageState();
}

class _ListPackageState extends State<ListPackage> {
  List<Addons> selected = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingReady) {
          return ListView.builder(
            itemCount: state.dataaddons?.length,
            itemBuilder: (context, index) {
              final isSelected = selected.contains(state.dataaddons![index]);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selected.remove(state.dataaddons?[index]);
                          } else {
                            selected.add(state.dataaddons![index]);
                          }
                        });

                        widget.ontap(selected);
                      },
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.add_circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(state.dataaddons?[index].tittle ?? ""),
                    trailing: Text(state.dataaddons![index].price.toString()),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

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
        children: [
          Expanded(
            child: RadioGroup<String>(
              groupValue: idpackage,
              onChanged: (value) => setState(() {
                idpackage = value;
              }),
              child: BlocBuilder<PackageAllCubit, PackageAllState>(
                builder: (context, state) {
                  if (state is PackageAllLoaded) {
                    return ListView.builder(
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
                              value: state.data[index].id,
                              title: Text(state.data[index].tittle),
                            ),
                          ),
                        );
                      },
                      itemCount: state.data.length,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
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
                setState(() {
                  selectedBenefits = values;
                });
              },
            ),
          ),
          Center(
            child: OutlinedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  context.read<BookingCubit>().onTahapTwo(
                    idpackage!,
                    nama.text,
                    nowa.text,
                    lokasi.text,
                    instagram.text,
                    catatan.text,
                    selectedBenefits,
                  );
                }
              },
              child: Text("Kirim"),
            ),
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
  const InputBox({
    super.key,
    required this.errormessage,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxline,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxline,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errormessage;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        hint: Text(hint),
      ),
      style: GoogleFonts.robotoFlex(color: Colors.white),
    );
  }
}

class FormContent extends StatefulWidget {
  const FormContent({super.key});

  @override
  State<FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<FormContent> {
  final List<String> timeSlots = [
    "05.30-06.30",
    "06.30-07.30",
    "07.30-08.30",
    "08.30-09.30",
    "09.30-10.30",
    "10.30-11.30",
    "11.30-12.30",
    "12.30-13.30",
    "13.00-14.00",
    "14.00-15.00",
    "15.00-16.00",
    "16.00-17.00",
    "17.00-18.00",
  ];
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? _selectedItem;
  String? timeSlotsdata;
  int? _selectIndex;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Tidak bisa pilih tanggal kemarin
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formkey,
        child: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            
            if (state is BookingReady && state.data!.isNotEmpty) {
              setState(() {
                _selectedItem = state.data!.first!.name; // Jadikan default
              });
            }
          },
          builder: (context, state) {
            if (state is BookingReady) {
              return Column(
                spacing: 10,
                children: [
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "silahkan  masukkan tempat";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.robotoFlex(color: Colors.white),
                      labelText: "Universitas",
                      iconColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedItem,
                    items: state.data?.map((e) {
                      return DropdownMenuItem<String>(
                        value: e!.name,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _dateController,

                    decoration: InputDecoration(
                      iconColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelStyle: GoogleFonts.robotoFlex(color: Colors.white),
                      labelText: "Pilih Tanggal",
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    readOnly: true, // Tidak bisa ketik manual
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tanggal tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 300, // agar bisa scroll
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 kolom seperti contoh
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2.3, // atur bentuk tombol
                            ),
                        itemCount: timeSlots.length,
                        itemBuilder: (context, index) {
                          bool isSelected = index == _selectIndex;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                Logger().d(
                                  "seleccted index daristate $_selectIndex",
                                );
                                _selectIndex = index;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                timeSlots[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ColorTema.accentColor,
                      ),

                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          Logger().d("selectedindex = $_selectIndex");
                          if (_selectIndex != null) {
                            context.read<BookingCubit>().onTahapOne(
                              _selectedItem!,
                              timeSlots[_selectIndex!],
                              timeSlots[_selectIndex!],
                              _dateController.text,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.black,
                                icon: Icon(Icons.error, color: Colors.red),
                                content: Text(
                                  "Silahkan pilih waktu !",
                                  style: GoogleFonts.robotoFlex(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Kirim",
                        style: GoogleFonts.robotoFlex(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is BookingLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookingError) {
              return Center(child: Text(state.message));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String langkah;
  final String sub;
  const Header({super.key, required this.langkah, required this.sub});

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
          "Pilih universitas asalmu, pilih tanggal, pilih jam yang tersedia",
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
