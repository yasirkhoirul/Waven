import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/package.dart';
import 'package:waven/domain/entity/detail_package.dart';
import 'package:waven/domain/usecase/get_detail_package.dart';
import 'package:waven/injection.dart' as di;
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/widget/button.dart';
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
         
          Positioned.fill(
            child: BlocBuilder<PackageAllCubit, PackageAllState>(
              builder: (context, state) {
                if (state is PackageAllLoading) {
                  return Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: MyLottie(aset: ImagesPath.loadingwaven),
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
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // Header Section
                            HeaderItem(),
                            // Content Section
                            _buildPackageContent(constrains, state),
                          ],
                        ),
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

  Widget _buildPackageContent(
    BoxConstraints constrains,
    PackageAllLoaded state,
  ) {
    if (constrains.maxWidth < 870) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) {
          
          return SizedBox(
          height: 270,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _PackageCard(package: state.data[index], ismobile: true),
          ),
        );},
      itemCount: state.data.length,
      );
    } else {
      return GridPackage(data: state.data);
    }
  }
}

class HeaderItem extends StatelessWidget {
  const HeaderItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Package",
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(
                                context,
                              ).size.width >
                              900
                          ? 48
                          : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "Home / Package",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize:
                        MediaQuery.of(context).size.width >
                            900
                        ? 18
                        : 14,
                  ),
                ),
              ],
            ),
            AnimatedDividerCurve(
              color: Colors.white,
              height: 1,
              duration: Duration(seconds: 1),
              curve: Curves.easeOutBack,
            ),
          ],
        ),
      ),
    );
  }
}

class GridPackage extends StatelessWidget {
  final List<PackageEntity> data;
  const GridPackage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lebarlayar = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 200, vertical: 75),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: lebarlayar < 1200 ? 2 : 3,
        mainAxisExtent: 580,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _PackageCardGrid(package: data[index]);
      },
    );
  }
}

class _PackageCardGrid extends StatelessWidget {
  final PackageEntity package;
  const _PackageCardGrid({required this.package});

  @override
  Widget build(BuildContext context) {
    final getDetailPackage = di.locator<GetDetailPackage>();

    return FutureBuilder<DetailPackageEntity>(
      future: getDetailPackage.execute(package.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FrostGlassAnimated(
            width: double.infinity,
            child: Center(
              child: MyLottie(aset: ImagesPath.loadingwaven),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return FrostGlassAnimated(
            width: double.infinity,
            child: Center(child: Icon(Icons.error, color: Colors.red)),
          );
        }

        final detail = snapshot.data!;

        return FrostGlassAnimated(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: CachedNetworkImage(
                      imageUrl: detail.bannerUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: Center(child: MyLottie(aset: ImagesPath.loadingwaven)),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        detail.title,
                        style: GoogleFonts.robotoFlex(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),

                      // Price
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rp ${detail.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},-',
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Benefits
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: detail.benefits.take(2).map((benefit) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: ColorTema.accentColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        benefit.description,
                                        style: GoogleFonts.robotoFlex(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // "Lihat selengkapnya"
                      if (detail.benefits.length > 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => context.goNamed(
                              'package',
                              pathParameters: {'id': package.id},
                            ),
                            child: Text(
                              'Lihat selengkapnya...',
                              style: GoogleFonts.robotoFlex(
                                fontSize: 14,
                                color: ColorTema.accentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 16),

                      // Booking Button
                      SizedBox(
                        width: double.infinity,
                        child: LWebButton(
                          label: "Booking Sekarang",
                          onPressed: () => context.goNamed(
                            'package',
                            pathParameters: {'id': package.id},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PackageEntity package;
  final bool ismobile;
  const _PackageCard({required this.package, this.ismobile = false});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FrostGlassAnimated(
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
                      child: Center(child: MyLottie(aset: ImagesPath.loadingwaven)),
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
                        fontSize: ismobile ? 24 : 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      package.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoFlex(
                        fontSize: ismobile ? 12 : 24,
                        color: Colors.grey[300],
                      ),
                    ),

                    Text(
                      'Rp ${package.price}',
                      style: GoogleFonts.robotoFlex(
                        fontSize: ismobile ? 10 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[400],
                      ),
                    ),
                    Spacer(),
                    LWebButton(
                      label: "Detail",
                      onPressed: () => context.goNamed(
                        'package',
                        pathParameters: {'id': package.id},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
