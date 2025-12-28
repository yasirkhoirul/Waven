import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/button.dart';
import 'package:waven/presentation/widget/fadeup.dart';
import 'package:waven/presentation/widget/footer.dart';
import 'package:waven/presentation/widget/image_button.dart';
import 'package:waven/presentation/widget/slidedirection.dart';

class WavenHomePage extends StatefulWidget {
  const WavenHomePage({super.key});

  @override
  State<WavenHomePage> createState() => _WavenHomePageState();
}

class _WavenHomePageState extends State<WavenHomePage> {
  @override
  void initState() {
    context.read<TokenauthCubit>().getTokens();
    context.read<PackageAllCubit>().getAllpackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Hitam pekat
    const accentColor = Color(0xFF00C853);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, // Agar gambar hero bisa sampai atas
      body: CustomScrollView(
        slivers: [
          AppSliver(accentColor: accentColor),
          
          SliverList.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index == 0) {
                return FadeInSlide(
                  delay: Duration(milliseconds: 500),
                  direction: SlideDirection.up,
                  child: WidgetChoose(),
                );
              }
              if (index == 1) {
                return FadeInSlide(
                  delay: Duration(milliseconds: 500),
                  direction: SlideDirection.left,
                  child: WidgetPortofolio(),
                );
              }
              if (index == 2) {
                return FadeInSlide(
                  delay: Duration(milliseconds: 500),
                  direction: SlideDirection.right,
                  child: AboutUs(accentColor: accentColor),
                );
              }
              if (index == 3) {
                return FadeInSlide(
                  delay: Duration(milliseconds: 500),
                  direction: SlideDirection.down,
                  child: Footer(),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return SizedBox(
      height: isSmall ? 700 : 1080,
      child: Stack(
        children: [
          Positioned.fill(
            left: 0,
            child: Image.asset(ImagesPath.bgwavenmoment, fit: BoxFit.fitHeight),
          ),
          Positioned(
            left: isSmall ? 0 : null,
            right: isSmall ? 0 : 100,
            bottom: 0,
            top: 0,
            child: SizedBox(
              width: isSmall ? MediaQuery.of(context).size.width : 700,
              height: isSmall ? 200 : 400,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 100,
                        offset: Offset(-15, 0),
                        color: Colors.white.withAlpha(40),
                        spreadRadius: 20,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            ImagesPath.buttonimage1,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Waven Moment",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Since 2020, we’ve been capturing the smiles, hugs, and happy tears of graduation day all around Yogyakarta. For us, every click of the camera is more than just a photo — it’s a story of hard work, pride, and love worth remembering. Whether it’s under the campus trees or in the studio lights, we’ll make sure your moment feels real and beautiful. Let’s celebrate your big day the way it deserves — book your session now and let us capture the magic of your graduation!",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: LWebButton(label: "Book Now",onPressed: () => context.goNamed('packagelist'),)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetPortofolio extends StatelessWidget {
  const WidgetPortofolio({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;

    // Tips: Tidak perlu bungkus SizedBox jika tidak ada height/width khusus
    // Langsung return Column atau Padding saja
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInUpText(
            delay: Duration(seconds: 1),
            text: "A Glimpse of joy, moment, elegance, a story of happiness",
            alig: TextAlign.center,
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: isSmall ? 16 : 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                double spacing = 5;

                // Hitung lebar item
                double totalWidth =
                    constraints.maxWidth - ((crossAxisCount - 1) * spacing);
                double itemWidth = totalWidth / crossAxisCount;

                // Hitung tinggi item (Logic Anda: Tinggi = Lebar * 1.3) -> Portrait
                double itemHeight = itemWidth * 1.3;

                // Hitung Aspect Ratio
                double ratio = itemWidth / itemHeight;

                return BlocBuilder<PortoAllCubit, PortoAllState>(
                  builder: (context, state) {
                    if (state is PortoAllLoaded) {
                      final displayData = state.data.take(6).toList();

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),

                        // --- PERBAIKAN DI SINI ---
                        // WAJIB TRUE karena Expanded sudah dihapus
                        // Agar tinggi GridView mengikuti isinya (children)
                        shrinkWrap: true,

                        // -------------------------
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: ratio, // Ratio dinamis sudah benar
                        ),
                        itemCount: displayData.length,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Opsional: Biar manis
                          child: FadeInSlide(
                            direction: SlideDirection.up,
                            delay: Duration(milliseconds: (index * 300)),
                            child: CachedNetworkImage(
                              imageUrl: state.data[index].url,
                              // Tips: Gunakan cover agar gambar tidak gepeng mengikuti rasio
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Icons.error)),
                            ),
                          ),
                        ),
                      );
                    } else if (state is PortoAllLoading) {
                      return SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is PortoAllError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.robotoFlex(color: Colors.white),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetChoose extends StatelessWidget {
  const WidgetChoose({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: SizedBox(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  "Package",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: isSmall ? 9 : 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  "A memorable graduation moment start here",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: isSmall ? 16 : 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Choose what your suitable needs",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: isSmall ? 9 : 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
            BlocBuilder<PackageAllCubit, PackageAllState>(
              builder: (context, state) {
                if (state is PackageAllLoaded) {
                  return SizedBox(
                    width: 900,
                    child: GridView.builder(
                      physics: isSmall? NeverScrollableScrollPhysics():null,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          height: 500,
                          width: 500,
                          child: Center(
                            child: HoverLiftButton(
                              height: 300,
                              width: 300,
                              imagepath: state.data[index].bannerUrl,
                              nama: state.data[index].tittle,
                              onClik: () {
                                context.goNamed(
                                  'package',
                                  pathParameters: {'id': state.data[index].id},
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is PackageAllError) {
                  return Center(
                    child: Text("Terjadi kesalahan ${state.message}"),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppSliver extends StatefulWidget {
  const AppSliver({super.key, required this.accentColor});
  
  final Color accentColor;

  @override
  State<AppSliver> createState() => _AppSliverState();
}

class _AppSliverState extends State<AppSliver> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<String> _sliderImages = [
    ImagesPath.slider1,
    ImagesPath.slider2,
    ImagesPath.slider3,
  ];

  @override
  void initState() {
    super.initState();
    // Auto slide every 5 seconds
    Future.delayed(Duration(milliseconds: 500), () {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && _pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _sliderImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lebarlayar = MediaQuery.of(context).size.width > 585;
    final iskecil = MediaQuery.of(context).size.width > 350;
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _sliderImages.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    _sliderImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iskecil
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FadeInUpText(
                                text: "Capture Your Precious \nMoment with",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontSize: lebarlayar ? 48 : 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Positioned(
                                bottom: lebarlayar ? 10 : 0,
                                right: lebarlayar ? 30 : -60,
                                child: FadeInSlide(
                                  delay: Duration(milliseconds: 500),
                                  direction: SlideDirection.up,
                                  child: Image.asset(
                                    ImagesPath.logotekspng,
                                    height: 29,
                                    width: 198,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              FadeInUpText(
                                text: "Capture Your Precious \nMoment with",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontSize: lebarlayar ? 48 : 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              FadeInSlide(
                                delay: Duration(milliseconds: 500),
                                direction: SlideDirection.up,
                                child: Image.asset(
                                  ImagesPath.logotekspng,
                                  height: 29,
                                  width: 198,
                                ),
                              ),
                            ],
                          ),
                    FadeInUpText(
                      delay: Duration(milliseconds: 500),
                      text:
                          "We transform your precious memories into timeless, visually \ncaptivating art. Reserve your spot today!",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontSize: lebarlayar ? 22 : 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    FadeInSlide(
                      direction: SlideDirection.up,
                      delay: Duration(milliseconds: 500),
                      child: LWebButton(label: "Book Now",onPressed: () => context.goNamed('packagelist'),)
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
