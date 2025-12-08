import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<BookingCubit, BookingState>(
                  listener: (context, state) {
                    if (state is BookingSessionExpired) {
                      context.read<TokenauthCubit>().onLogout();
                    }
                  },
                  builder: (context, state) {
                    if (state.step == BookingStep.loaded) {
                      return SizedBox(
                        height: 1000,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Header(langkah: '1', sub: 'Pilih tanggal dan waktu'),
                            Expanded(child: FormContent()),
                          ],
                        ),
                      );
                    } else if (state.step == BookingStep.tahap1) {
                      return SizedBox(
                        height: 1200,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Header(langkah: '2', sub: 'Pilih Paket dan Isi form'),
                            Expanded(
                              child: Form2Content(idpackage: widget.idpackage),
                            ),
                          ],
                        ),
                      );
                    } else if (state.step == BookingStep.tahap2) {
                      return SizedBox(
                        height: 500,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Header(
                              langkah: '3',
                              sub: 'Bayar dan Upload Bukti Bayar',
                            ),
                            Expanded(child: Form3Content()),
                          ],
                        ),
                      );
                    } else if (state.step == BookingStep.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state.step == BookingStep.error) {
                      return Center(
                        child: Text(
                          "Terjadi Kesalahan ${state.errorMessage}",
                          style: GoogleFonts.robotoFlex(color: Colors.white),
                        ),
                      );
                    } else if (state.step == BookingStep.submitted) {
                      Logger().d("invoice di state = ${state.invoice}");
                      return SubmittedPage(state: state);
                    } else if (state.step == BookingStep.tahap3) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<BookingCubit>().onsubmit();
                          },
                          child: const Text("Submit"),
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
            items: Constantclass.paymentMethod.map((method) {
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
            initialValue: _selectedPaymentMethod,
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
            items: Constantclass.paymentType.map((type) {
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
            initialValue: _selectedPaymentType,
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
    Logger().d("adddons yang dipilih $selected");
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state.step == BookingStep.tahap1) {
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
                              value: state.data[index],
                              title: Text(state.data[index].tittle),
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
          Center(
            child: OutlinedButton(
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
        return null;
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
    "05:30-06:30",
    "06:30-07:30",
    "07:30-08:30",
    "08:30-09:30",
    "09:30-10:30",
    "10:30-11:30",
    "11:30-12:30",
    "12:30-13:30",
    "13:00-14:00",
    "14:00-15:00",
    "15:00-16:00",
    "16:00-17:00",
    "17:00-18:00",
  ];
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? _selectedUniversitas;
  String? timeSlotsdata;
  int? _selectedWaktuIndex;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Tidak bisa pilih tanggal kemarin
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.step == BookingStep.loaded && state.data!.isNotEmpty) {
            setState(() {
              _selectedUniversitas =
                  state.data!.first!.name; // Jadikan default
            });
          }
        },
        builder: (context, state) {
          if (state.step == BookingStep.loaded) {
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
                  initialValue: _selectedUniversitas,
                  items: state.data?.map((e) {
                    return DropdownMenuItem<String>(
                      value: e!.id,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversitas = value;
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
                        bool isSelected = index == _selectedWaktuIndex;
    
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedWaktuIndex = index;
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
                        Logger().d("selectedindex = $_selectedWaktuIndex");
                        if (_selectedWaktuIndex != null) {
                          String slot = timeSlots[_selectedWaktuIndex!];
                          List<String> parts = slot.split('-');
    
                          String startTime = parts[0];
                          String endTime = parts[1];
                          context.read<BookingCubit>().onTahapOne(
                            _selectedUniversitas!,
                            startTime,
                            endTime,
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
          } else if (state.step == BookingStep.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.step == BookingStep.error) {
            return Center(child: Text(state.errorMessage.toString()));
          } else {
            return Container();
          }
        },
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
                    child: CachedNetworkImage(
                      imageUrl: state.invoice!.paymentQrUrl!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey[800],
                        child: Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
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
                  _DetailRow('Booking ID', state.invoice!.bookingDetail.bookingId),
                  _DetailRow('Total Amount', 'Rp ${state.invoice!.bookingDetail.totalAmount}'),
                  _DetailRow('Paid Amount', 'Rp ${state.invoice!.bookingDetail.paidAmount}'),
                  _DetailRow('Currency', state.invoice!.bookingDetail.currency ?? '-'),
                  _DetailRow('Payment Type', state.invoice!.bookingDetail.paymentType),
                  _DetailRow('Payment Method', state.invoice!.bookingDetail.paymentMethod.toUpperCase()),
                  _DetailRow('Status', state.invoice!.bookingDetail.paymentStatus),
                  _DetailRow('Transaction Time', state.invoice!.bookingDetail.transactionTime),
                  if (state.invoice!.bookingDetail.acquirer != null)
                    _DetailRow('Acquirer', state.invoice!.bookingDetail.acquirer!),
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
          style: GoogleFonts.robotoFlex(
            color: Colors.grey[400],
            fontSize: 12,
          ),
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
