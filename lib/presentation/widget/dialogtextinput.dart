import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/domain/entity/list_gdrive.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/google_drive_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/button.dart';

class Dialogtextinput extends StatefulWidget {
  final String idDetailInvoice;
  const Dialogtextinput({required this.idDetailInvoice, super.key});

  @override
  State<Dialogtextinput> createState() => _DialogtextinputState();
}

class _DialogtextinputState extends State<Dialogtextinput> {
  final TextEditingController editedphototeks = TextEditingController();
  final GlobalKey<FormState> _fomkey = GlobalKey<FormState>();
  final List<GoogleDriveFileEntity> selectedFiles = [];

  @override
  void initState() {
    
    super.initState();
  }

  void _addSelectedFile(GoogleDriveFileEntity file) {
    if (!selectedFiles.any((f) => f.id == file.id)) {
      setState(() {
        selectedFiles.add(file);
      });
    }
  }

  void _removeSelectedFile(GoogleDriveFileEntity file) {
    setState(() {
      selectedFiles.removeWhere((f) => f.id == file.id);
    });
  }

  String _getSelectedFilesAsString() {
    return selectedFiles
        .map((file) {
          // Hapus extension (bagian di belakang titik)
          final nameWithoutExt = file.name.contains('.')
              ? file.name.substring(0, file.name.lastIndexOf('.'))
              : file.name;
          return nameWithoutExt;
        })
        .join(',');
  }

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
                        Text(
                          "Silahkan pilih gambar lewat berikut:",
                          style: GoogleFonts.robotoFlex(
                            color: ColorTema.accentColor,
                            fontSize: 14,
                          ),
                        ),
                        DropdownSearch<GoogleDriveFileEntity>(
                          compareFn: (item1, item2) => item1.id == item2.id,
                          itemAsString: (item) => item.name,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            disableFilter: true,
                            infiniteScrollProps: InfiniteScrollProps(
                              loadProps: LoadProps(skip: 0,take: 10)
                            )
                          ),
                          items: (filter, loadProps) async{
                            final page = (loadProps!.skip ~/ loadProps.take) + 1;
                            return context.read<GoogleDriveCubit>().getDataReturn(widget.idDetailInvoice, page, loadProps.take,search: filter);
                          },
                          onChanged: (GoogleDriveFileEntity? item) {
                            if (item != null) {
                              _addSelectedFile(item);
                            }
                          },
                        ),
                     
                        if (selectedFiles.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: selectedFiles
                                  .map(
                                    (file) => Container(
                                      decoration: BoxDecoration(
                                        color: ColorTema.accentColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            file.name,
                                            style: GoogleFonts.robotoFlex(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _removeSelectedFile(file),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        if (selectedFiles.isEmpty)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Tidak ada file yang dipilih",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      
                        LWebButton(label: "Kirim",onPressed: (){
                          if (selectedFiles.isNotEmpty) {
                              context
                                  .read<DetailInvoiceCubit>()
                                  .onSubmitEditedPhoto(
                                    widget.idDetailInvoice,
                                    _getSelectedFilesAsString().trim(),
                                  );
                            }
                        },),
                        LWebButton(label: "Batal",onPressed: (){
                          context.pop();
                        },
                        backgroundColor: Colors.redAccent,
                        )
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
