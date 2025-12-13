import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/domain/entity/addons.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';

class Form3Content extends StatefulWidget {
  const Form3Content({super.key});

  @override
  State<Form3Content> createState() => _Form3ContentState();
}

class _Form3ContentState extends State<Form3Content>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;
  String? _selectedPaymentType;
  String? _selectedImageName;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _pickImage() {
    context.read<BookingCubit>().onTapImage();
  }

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _selectedPaymentMethod = value;
      if (value == 'transfer') {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _selectedImageName = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          return Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
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
                    _DetailRow('Nama', state.nama ?? '-'),
                    _DetailRow('Universitas', state.univ ?? '-'),
                    _DetailRow('Tanggal Foto', state.tanggal ?? '-'),
                    _DetailRow(
                      'Waktu Foto',
                      '${state.starttime ?? '-'} - ${state.endtime ?? '-'}',
                    ),
                    if (state.packageEntity != null)
                      _DetailRow('Paket', state.packageEntity?.tittle ?? '-'),
                    if (state.packageEntity != null)
                      _DetailRow(
                        'Harga Paket',
                        'Rp ${state.packageEntity?.price ?? 0}',
                      ),
                    if (state.datadiplih != null &&
                        state.datadiplih!.isNotEmpty)
                      _DetailRow(
                        'Add-ons',
                        state.datadiplih!
                            .map((addon) => addon.tittle)
                            .join(', '),
                      ),
                    Divider(color: Colors.white24),
                    _DetailRow(
                      'Total Dibayar',
                      'Rp ${state.amount.toStringAsFixed(0)}',
                      isBold: true,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                      style: GoogleFonts.robotoFlex(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: _onPaymentMethodChanged,
                initialValue: _selectedPaymentMethod,
              ),
              // Image Picker dengan Animasi Fade
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: _selectedPaymentMethod == 'transfer'
                      ? Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: state.dataimage != null
                                        ? Colors.green
                                        : Colors.white54,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white10,
                                ),
                                child: state.dataimage == null
                                    ? Column(
                                        spacing: 8,
                                        children: [
                                          Icon(
                                            _selectedImageName != null
                                                ? Icons.check_circle
                                                : Icons.image_outlined,
                                            color:
                                                _selectedImageName != null
                                                ? Colors.green
                                                : Colors.white54,
                                            size: 40,
                                          ),
                                          Text(
                                            _selectedImageName != null
                                                ? 'Bukti Transfer Dipilih'
                                                : 'Pilih Bukti Transfer',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.robotoFlex(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (_selectedImageName != null)
                                            Text(
                                              _selectedImageName!,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.green,
                                                fontSize: 10,
                                              ),
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                        ],
                                      )
                                    : kIsWeb? Image.network(
                                        state.dataimage!.path,
                                        fit: BoxFit.cover,
                                      ):Image.file(
                                        File(state.dataimage!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
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
                      style: GoogleFonts.robotoFlex(color: Colors.white),
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
                    // Validasi image picker jika memilih transfer
                    if (_selectedPaymentMethod == 'transfer' &&
                        state.dataimage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Silahkan pilih bukti transfer',
                            style: GoogleFonts.robotoFlex(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

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
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ColorTema.abu,
                  ),
                  onPressed: () {
                    context.read<BookingCubit>().goloaded();
                  },
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.robotoFlex(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
                    title: Text(
                      state.dataaddons?[index].tittle ?? "",
                      style: GoogleFonts.robotoFlex(color: Colors.white),
                    ),
                    trailing: Text(
                      state.dataaddons![index].price.toString(),
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isHighlight;

  const _DetailRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.isHighlight = false,
  });

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
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.robotoFlex(
              color: isHighlight ? Colors.green : Colors.white,
              fontSize: isHighlight ? 14 : 12,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
