import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/color.dart';
import 'package:waven/presentation/cubit/package_detail_cubit.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/pages/home_page.dart';
import 'package:waven/presentation/widget/frostglass.dart';

class PackagePage extends StatefulWidget {
  final String idpackage;
  const PackagePage({super.key, required this.idpackage});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  @override
  void initState() {
    context.read<PackageDetailCubit>().getPackageDetail(widget.idpackage);
    context.read<PortoAllCubit>().getAllporto(idpackage: widget.idpackage);
    Logger().d("id ${widget.idpackage}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, contrains) {
          final panjang = contrains.maxWidth * 0.8;
          final tinggi = contrains.maxHeight * 0.8;
          return BlocBuilder<PackageDetailCubit, PackageDetailState>(
            builder: (context, state) {
              Logger().d("state saat ini $state");
              if (state is PackageDetailLoaded) {
                return Center(
                  child: SizedBox(
                    width: panjang,
                    height: 2000,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return FrostGlassAnimated(
                            width: panjang,
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.data.title,
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.white,
                                                fontSize: 48,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF3F3F3F),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Text(
                                                  "Rp ${state.data.price}",
                                                  style: GoogleFonts.robotoFlex(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            spacing: 20,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "What you get",
                                                style: GoogleFonts.robotoFlex(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: state.data.benefits.map((
                                                  benefit,
                                                ) {
                                                  return Row(
                                                    children: [
                                                      benefit.type == "INCLUDE"
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          benefit.description,
                                                          style:
                                                              GoogleFonts.robotoFlex(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(15),
                                      ),
                                      backgroundColor: ColorTema.accentColor,
                                      textStyle: GoogleFonts.robotoFlex(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Book Now",
                                        style: GoogleFonts.robotoFlex(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (index == 1) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: FrostGlassAnimated(
                              width: panjang,
                              height: 1200,
                              child: BlocBuilder<PortoAllCubit, PortoAllState>(
                                builder: (context, state) {
                                  if (state is PortoAllLoaded) {
                                    return GridView.builder(
                                      itemCount: state.data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 3 / 4,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                    itemBuilder: (context, index) =>
                                        CachedNetworkImage(imageUrl: state.data[index].url),
                                  );
                                  }else{
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  
                                },
                              ),
                            ),
                          );
                        } else if (index == 2) {
                          return Footer();
                        }
                      },
                    ),
                  ),
                );
              } else if (state is PackageDetailLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is PackageDetailError) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
