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
                    height: 2000,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: contrains.maxWidth > 1200 ? 200 : 20,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return DetailPackageContent(
                            panjang: panjang,
                            detail: state.data,
                          );
                        } else if (index == 1) {
                          return Container();
                        } else if (index == 2) {
                          return Footer();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                );
              } else if (state is PackageDetailLoading) {
                return Center(child: MyLottie(aset: ImagesPath.loadingwaven));
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
              return Center(child: MyLottie(aset: ImagesPath.loadingwaven));
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
    return LayoutBuilder(
      builder: (context, constrains) {
        final isMobile = constrains.maxWidth < 950;

        if (isMobile) {
          return FrostGlassAnimated(
            
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildImageSection(context),
                  SizedBox(height: 20),
                  _buildDetailsSection(context,isMobile),
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: constrains.maxWidth*0.48,
            
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              spacing: 32,
              children: [
                Expanded(
                  flex: 2,
                  child: FrostGlassAnimated(
                    
                    
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildImageSection(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: FrostGlassAnimated(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildDetailsSection(context,isMobile),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return BlocBuilder<PortoAllCubit, PortoAllState>(
      builder: (context, state) {
        if (state is PortoAllLoaded && state.data.isNotEmpty) {
          return Column(
            children: [
              // Main image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: CachedNetworkImage(
                    imageUrl: state.data.first.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[800],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Thumbnail grid
              SizedBox(
                height: 100,
                child: Row(
                  children: state.data.take(4).map((porto) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: porto.url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[800]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: Icon(Icons.error, size: 16),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
        // Fallback to banner image if no portfolio
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: CachedNetworkImage(
              imageUrl: detail.bannerUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[800],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection(BuildContext context,bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          detail.title,
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),

        // Price
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xFF3F3F3F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Rp ${detail.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},-",
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 24),

        // Details header
        Text(
          "Details",
          style: GoogleFonts.robotoFlex(
            color: ColorTema.accentColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),

        // Benefits list
        ...detail.benefits.map((benefit) {
          final isInclude = benefit.type == "INCLUDE";
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isInclude ? Icons.check_circle : Icons.cancel,
                  color: isInclude ? Colors.white : Colors.grey,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    benefit.description,
                    style: GoogleFonts.robotoFlex(
                      color: isInclude ? Colors.white : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

       !isMobile?Spacer():SizedBox(height: 20,),

        // Booking button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTema.accentColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.goNamed('booking', pathParameters: {'id': detail.id});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Booking Sekarang",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DetailPackageTittle extends StatelessWidget {
  const DetailPackageTittle({super.key, required this.detail});

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
  const ListBenefitDetailPackage({super.key, required this.detail});

  final DetailPackageEntity detail;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detail.benefits.length,
      itemBuilder: (context, index) => Row(
        children: [
          detail.benefits[index].type == "INCLUDE"
              ? Icon(Icons.check_circle, color: Colors.white)
              : Icon(Icons.cancel, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail.benefits[index].description,
              style: GoogleFonts.robotoFlex(
                color: detail.benefits[index].type == "INCLUDE"
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
