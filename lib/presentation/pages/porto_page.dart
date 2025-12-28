import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/domain/entity/porto.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';
import 'package:waven/common/imageconstant.dart';

class PortoPage extends StatefulWidget {
  final String packageId;
  final String packageTitle;
  

  const PortoPage({
    super.key,
    required this.packageId,
    required this.packageTitle,
  });

  @override
  State<PortoPage> createState() => _PortoPageState();
}

class _PortoPageState extends State<PortoPage> {
  late List<PortoEntity> porto;
  @override
  void initState() {
    context.read<PortoAllCubit>().getAllporto(idpackage: widget.packageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<PortoAllCubit, PortoAllState>(
        builder: (context, state) {
          if (state is PortoAllLoading) {
            return Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: MyLottie(aset: ImagesPath.loadingwaven),
              ),
            );
          } else if (state is PortoAllError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${state.message}',
                style: GoogleFonts.robotoFlex(color: Colors.white),
              ),
            );
          } else if (state is PortoAllLoaded) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                // Index 0: Header
                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Portofolio',
                          style: GoogleFonts.robotoFlex(
                            fontSize: 14,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.packageTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoFlex(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // Index 1: Horizontal ListView of Portfolios
                else {
                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.data.length,
                      itemBuilder: (context, portoIndex) {
                        final porto = state.data[portoIndex];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PortoCard(
                            porto: porto,
                            packagetitle: widget.packageTitle,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
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
      ),
    );
  }
}

class PortoCard extends StatelessWidget {
  final PortoEntity porto;
  final String packagetitle;
  const PortoCard({super.key, required this.porto, required this.packagetitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: porto.url,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: MyLottie(aset: ImagesPath.loadingwaven),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Package Details Below Image
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      packagetitle,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portfolio Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: porto.url,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
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
            // Portfolio Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      packagetitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
