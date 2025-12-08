import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/pages/porto_page.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';
import 'package:waven/common/imageconstant.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    context.read<PackageAllCubit>().getAllpackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageAllCubit, PackageAllState>(
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
              'Terjadi kesalahan: ${state.message}',
              style: GoogleFonts.robotoFlex(color: Colors.white),
            ),
          );
        } else if (state is PackageAllLoaded) {
          return CustomScrollView(
            slivers: [
              // Header with Package Count
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Galeri Paket',
                          style: GoogleFonts.robotoFlex(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Total ${state.data.length} paket tersedia',
                          style: GoogleFonts.robotoFlex(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          height: 3,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Spacing
              SliverList.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 400,
                  child: PortoPage(
                    packageId: state.data[index].id,
                    packageTitle: state.data[index].tittle,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
              'Tidak ada data',
              style: GoogleFonts.robotoFlex(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
