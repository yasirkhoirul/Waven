import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/widget/divider.dart';
import 'package:waven/presentation/widget/footer.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final pannjanglayar = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 1200,
              minHeight: 100,
              minWidth: 700,
              maxWidth: 800,
            ),
            child: Center(
              child: FrostGlassAnimated(
                width: pannjanglayar * 0.8,
                child: Column(
                  children: [
                    HeaderProfile(pannjanglayar: pannjanglayar),
                    Expanded(child: MainContentProfile()),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Footer();
        }
      },
    );
  }
}

class MainContentProfile extends StatefulWidget {
  const MainContentProfile({super.key});

  @override
  State<MainContentProfile> createState() => _MainContentProfileState();
}

class _MainContentProfileState extends State<MainContentProfile> {
  final _pagecontroller = PageController();
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: HeaderPage(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constrians) {
                return PageView.builder(
                  controller: _pagecontroller,
                  onPageChanged: (value) {
                    setState(() {
                      currentindex = value;
                    });
                  },
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) => SizedBox(
                        height: constrians.maxHeight / 2.05,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FrostGlassAnimated(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Judul Session",
                                        style: GoogleFonts.robotoFlex(
                                          color: Color(0xFFE0E0E0),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Container(
                                        color: ColorTema.accentColor,
                                        padding: EdgeInsets.all(10),
                                        child: Center(child: Text("Lunas",style:GoogleFonts.robotoFlex(
                                          color: Colors.white
                                        )),),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          DataRowItem(
                                            label: 'Universitas',
                                            value: 'Univeristas Gadjah Mada',
                                          ),

                                          DataRowItem(
                                            label: 'Tanggal Foto',
                                            value: '20 September 2025',
                                          ),

                                          DataRowItem(
                                            label: 'Waktu Foto',
                                            value: '13.00-14.00',
                                          ),

                                          DataRowItem(
                                            label: 'Extra',
                                            value: '30 Menit',
                                          ),

                                          DataRowItem(
                                            label: 'Lokasi Foto',
                                            value: 'GIK',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FooterContentPage(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _pagecontroller.animateToPage(
                currentindex - 1,
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
              child: Icon(Icons.arrow_back),
            ),
            InkWell(
              onTap: () => _pagecontroller.animateToPage(
                currentindex + 1,
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}

class FooterContentPage extends StatelessWidget {
  const FooterContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuButtons = [
      {
        'bg': Color(0xFF27A693),
        "icon": Icons.payment,
        "label": "Cek Invoice",
        "action": () {
          print("Booking ditekan");
        },
      },
      {
        'bg': ColorTema.accentColor,
        "icon": Icons.download,
        "label": "Foto Original",
        "action": () {
          print("Payment ditekan");
        },
      },
      {
        'bg': Color(0xFF448AFF),
        "icon": Icons.menu,
        "label": "List Foto Diedit",
        "action": () {
          print("Info ditekan");
        },
      },
      {
        'bg': Color(0xFF5900A7),
        "icon": Icons.download,
        "label": "Edited Foto",
        "action": () {
          print("Settings ditekan");
        },
      },
    ];
    Widget customMenuButton(Map item) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: item['bg'] as Color,
            padding: EdgeInsets.all(20)
          ),
          onPressed: item['action'] as VoidCallback?,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'] as IconData,color: Colors.white,),
              const SizedBox(width: 6),
              Text(item['label'] as String, style: GoogleFonts.robotoFlex(
                color: Colors.white
              ),),
            ],
          ),
        ),
      );
    }

    return MediaQuery.of(context).size.width > 660
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: menuButtons.map((e) => customMenuButton(e)).toList(),
          )
        : Column(
            children: menuButtons.map((e) => customMenuButton(e)).toList(),
          );
  }
}

class DataRowItem extends StatelessWidget {
  final String label;
  final String value;

  const DataRowItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Membuat garis putus-putus vertikal (atau mirip) dengan simbol :
    const String separator = ':';

    return Row(
      // Menyeimbangkan teks vertikal
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Kolom 1: Label
        SizedBox(
          width: 120, // Lebar tetap untuk kolom label
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Kolom 2: Pemisah
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            separator,
            style: const TextStyle(
              color: Color(0xFFE0E0E0), // Warna pemisah seperti di gambar
              fontSize: 16,
              letterSpacing: 0.1, // Jarak antar titik
            ),
          ),
        ),

        // Kolom 3: Value (Mengambil sisa ruang)
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderPage extends StatelessWidget {
  const HeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Text(
            "Session Kamu",
            style: GoogleFonts.robotoFlex(
              color: ColorTema.abu,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorTema.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                ),

                onPressed: () {
                  context.goNamed('packagelist');
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text(
                      "Booking Session",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderProfile extends StatelessWidget {
  final double pannjanglayar;
  const HeaderProfile({super.key, required this.pannjanglayar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: pannjanglayar,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: '',
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) =>
                    MyLottie(aset: ImagesPath.loadinglottie),
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "NAMA",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit_document)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [Icon(Icons.mail), Text("email")]),
                Row(children: [Icon(Icons.location_city), Text("univ")]),
                Row(children: [Icon(Icons.phone), Text("phone")]),
              ],
            ),
            AnimatedDividerCurve(height: 1, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
