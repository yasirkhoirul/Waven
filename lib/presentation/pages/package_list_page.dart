import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/widget/carausel.dart';
import 'package:waven/presentation/widget/divider.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({super.key});

  @override
  State<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  @override
  void initState() {
    context.read<PackageAllCubit>().getAllpackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tinggilottie = MediaQuery.of(context).size.height;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      child: Stack(
        children: [
          Positioned(
          bottom: tinggilottie * -0.25,
          left: 0,
          child: SizedBox(
            height: tinggilottie,
            width: tinggilottie,

            child: MyLottie(aset: ImagesPath.bgleftlottie),
          ),
        ),
        Positioned(
          top: tinggilottie * -0.25,
          right: 0,
          child: SizedBox(
            height: tinggilottie,
            width: tinggilottie,

            child: MyLottie(aset: ImagesPath.bgrightlottie),
          ),
        ),
          Positioned.fill(
            child: BlocBuilder<PackageAllCubit, PackageAllState>(
              builder: (context, state) {
                if (state is PackageAllLoading) {
                  return Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: MyLottie(aset: ImagesPath.loadinglottie),
                    ),
                  );
                } else if (state is PackageAllError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan',
                      style: GoogleFonts.robotoFlex(color: Colors.white),
                    ),
                  );
                } else if (state is PackageAllLoaded) {
                  return LayoutBuilder(
                    builder: (context, constrains) {
                      return Column(
                        children: [
                          // Header Section
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Text(
                                  'Silahkan pilih paket yang disuka',
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                AnimatedDividerCurve(
                                  color: ColorTema.accentColor,
                                  height: 3,
                                  duration: const Duration(milliseconds: 600),
                                ),
                              ],
                            ),
                          ),
                          // Content Section
                          Expanded(
                            child: _buildPackageContent(constrains, state),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageContent(BoxConstraints constrains, PackageAllLoaded state) {
    if (constrains.maxWidth < 600) {
      return ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) => SizedBox(
          height: 270,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _PackageCard(
              package: state.data[index],
              ismobile: true,
            ),
          ),
        ),
        itemCount: state.data.length,
      );
    } else {
      if (constrains.maxHeight < 600) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 700,
            child: Center(
              child: CustomCarousel(
                height: 500,
                items: state.data
                    .map(
                      (package) => _PackageCard(package: package),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      } else {
        return Center(
          child: CustomCarousel(
            height: 500,
            items: state.data
                .map((package) => _PackageCard(package: package))
                .toList(),
          ),
        );
      }
    }
  }
}

class _PackageCard extends StatelessWidget {
  final PackageEntity package;
  final bool ismobile;
  const _PackageCard({required this.package, this.ismobile = false});

  @override
  Widget build(BuildContext context) {
    
    return FrostGlassAnimated(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            // Package Banner Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: package.bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // Package Details
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    package.tittle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoFlex(
                      fontSize: ismobile?24:48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    package.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoFlex(
                      fontSize: ismobile?12:24,
                      color: Colors.grey[300],
                    ),
                  ),
    
                  Text(
                    'Rp ${package.price}',
                    style: GoogleFonts.robotoFlex(
                      fontSize: ismobile?10:20,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[400],
                    ),
                  ),
                  Expanded(child: ListView()),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTema.accentColor,
                    ),
                    onPressed: () {
                      context.goNamed('package',pathParameters: {
                        'id':package.id
                      });
                    },
                    child: Text(
                      "Detail",
                      style: GoogleFonts.robotoFlex(
                        fontSize: ismobile?8:16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
