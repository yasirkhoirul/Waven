import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';



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
        final month = picked.month.toString().padLeft(2, '0');
        final day = picked.day.toString().padLeft(2, '0');

        _dateController.text = "${picked.year}-$month-$day";
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
              _selectedUniversitas = state.data!.first!.name; // Jadikan default
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:  MediaQuery.of(context).size.width>650?5: 3, // 3 kolom seperti contoh
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorTema.accentColor
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: ColorTema.accentColor.withAlpha(144),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
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
            return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
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
