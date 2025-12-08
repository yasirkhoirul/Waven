import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/presentation/cubit/package_detail_cubit.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/widget/footer.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';

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
                          return DetailPackageContent(
                            panjang: panjang,
                            detail: state.data,
                          );
                        } else if (index == 1) {
                          return PackagePortoContent(panjang: panjang);
                        } else if (index == 2) {
                          return Footer();
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ),
                );
              } else if (state is PackageDetailLoading) {
                return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
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

class PackagePortoContent extends StatelessWidget {
  const PackagePortoContent({super.key, required this.panjang});

  final double panjang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: FrostGlassAnimated(
        width: panjang,
        height: 800,
        child: BlocBuilder<PortoAllCubit, PortoAllState>(
          builder: (context, state) {
            if (state is PortoAllLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: state.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) =>
                    CachedNetworkImage(imageUrl: state.data[index].url),
              );
            } else {
              return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
            }
          },
        ),
      ),
    );
  }
}

class DetailPackageContent extends StatelessWidget {
  const DetailPackageContent({
    super.key,
    required this.panjang,
    required this.detail,
  });
  final DetailPackageEntity detail;
  final double panjang;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 400, maxHeight: 600),
      child: LayoutBuilder(
        builder: (context, constrains) {
          return FrostGlassAnimated(
            width: panjang,
            height: constrains.maxWidth > 800
                ? constrains.minHeight
                : constrains.maxHeight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  constrains.maxWidth > 800
                      ? Expanded(
                        child: Row(
                            children: [
                              Expanded(
                                child: DetailPackageTittle(detail: detail)
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 20,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "What you get",
                                      style: GoogleFonts.robotoFlex(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(child: ListBenefitDetailPackage(detail: detail))
                                  ],
                                ),
                              ),
                            ],
                          ),
                      )
                      : Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                flex: constrains.maxWidth<350?5: 3,
                                child: DetailPackageTittle(detail: detail),
                              ),
                              Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    spacing: 20,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "What you get",
                                        style: GoogleFonts.robotoFlex(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListBenefitDetailPackage(detail: detail),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                      ),
                      backgroundColor: ColorTema.accentColor,
                      textStyle: GoogleFonts.robotoFlex(color: Colors.white),
                    ),
                    onPressed: () {
                      context.goNamed('booking',
                        pathParameters: {
                          'id': detail.id
                        }
                      );
                    },
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
        },
      ),
    );
  }
}

class DetailPackageTittle extends StatelessWidget {
  const DetailPackageTittle({
    super.key,
    required this.detail,
  });

  final DetailPackageEntity detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          detail.title,
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3F3F3F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Rp ${detail.price}",
              style: GoogleFonts.robotoFlex(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListBenefitDetailPackage extends StatelessWidget {
  const ListBenefitDetailPackage({
    super.key,
    required this.detail,
  });

  final DetailPackageEntity detail;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detail.benefits.length,
      itemBuilder: (context, index) => Row(
        children: [
          detail.benefits[index].type ==
                  "INCLUDE"
              ? Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.blueGrey,
                ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail
                  .benefits[index]
                  .description,
              style: GoogleFonts.robotoFlex(
                color:
                    detail
                            .benefits[index]
                            .type ==
                        "INCLUDE"
                    ? Colors.white
                    : Colors.blueGrey,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
