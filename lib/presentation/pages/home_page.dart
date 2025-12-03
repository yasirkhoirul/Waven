import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/fadeup.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Warna Utama
    // Hijau tombol
    const backgroundColor = Color(0xFF0D0D0D); // Hitam pekat
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
            },
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 540,
      child: Padding(
        padding: const EdgeInsets.only(right: 100, left: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Let’s Have a Moment \nwith waven moment",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF18181B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(115),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Book Now",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Divider(height: 2, color: Colors.white),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "About \nRareblocks",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam dictum aliquet accumsan porta lectus ridiculus in mattis. Netus sodales in volutpat ullamcorper amet adipiscing fermentum.",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "  Waven",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Home",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "package",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "About",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1080,
      child: Stack(
        children: [
          Positioned.fill(
            left: 0,
            child: Image.asset(ImagesPath.bgwavenmoment, fit: BoxFit.fitHeight),
          ),
          Positioned(
            right: 100,
            bottom: 0,
            top: 0,
            child: SizedBox(
              width: 700,
              height: 400,
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
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                          ),
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
    return SizedBox(
      height: 1080,
      child: Column(
        children: [
          FadeInUpText(
            delay: Duration(seconds: 1),
            text: "A Glimpse of joy, moment, elegance, a story of happiness",
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Hitung lebar dan tinggi item agar pas di layar
                  // Kita ingin 3 kolom dan 2 baris (itemCount: 6)

                  int crossAxisCount = 3; // Jumlah Kolom
                  int rowCount = 2; // Jumlah Baris (karena item ada 6)

                  double spacing = 20; // Spacing yang kamu tentukan

                  // Hitung lebar total tersedia dikurangi spacing antar kolom
                  double totalWidth =
                      constraints.maxWidth - ((crossAxisCount - 1) * spacing);
                  double itemWidth = totalWidth / crossAxisCount;

                  // Hitung tinggi total tersedia dikurangi spacing antar baris
                  double totalHeight =
                      constraints.maxHeight - ((rowCount - 1) * spacing);
                  double itemHeight = totalHeight / rowCount;

                  // Hitung aspect ratio yang diperlukan
                  double ratio = itemWidth / itemHeight;

                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    // Hapus shrinkWrap: true agar dia memenuhi Expanded
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                      childAspectRatio: ratio, // Gunakan rasio dinamis ini
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Image.asset(
                        ImagesPath.buttonimage1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: SizedBox(
        height: 1080,
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "Package",
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    "A memorable graduation moment start here",
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Choose what your suitable needs",
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage1,
                    nama: "Person Session",
                    height: 300,
                    width: 300,
                  ),
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage2,
                    nama: "Couple Session",
                    height: 300,
                    width: 300,
                  ),
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage3,
                    nama: "Group Session",
                    height: 300,
                    width: 300,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage1,
                    nama: "Personal 2 + Video",
                    height: 300,
                    width: 300,
                  ),
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage2,
                    nama: "Couple 2 + Video",
                    height: 300,
                    width: 300,
                  ),
                  HoverLiftButton(
                    onClik: () {},
                    imagepath: ImagesPath.buttonimage3,
                    nama: "Group 2 + Video",
                    height: 300,
                    width: 300,
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

class AppSliver extends StatelessWidget {
  const AppSliver({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(ImagesPath.background, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        FadeInUpText(
                          
                          text: "Capture Your Precious \nMoment with",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 30,
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
                    ),
                    FadeInUpText(
                      delay: Duration(milliseconds: 500),
                      text: "We transform your precious memories into timeless, visually \ncaptivating art. Reserve your spot today!",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    FadeInSlide(
                      direction: SlideDirection.up,
                      delay: Duration(milliseconds: 500),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                          backgroundColor: accentColor,
                        ),
                      
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Book Now",
                            style: GoogleFonts.robotoFlex(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
