
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/presentation/cubit/list_invoice_cubit.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/button.dart';
import 'package:waven/presentation/widget/dialog_detail_invoice.dart';
import 'package:waven/presentation/widget/dialogtextinput.dart';
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
      itemCount: 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return HeaderLayout();
        } else if (index == 1) {
          return Center(
            child: FrostGlassAnimated(
              width: pannjanglayar > 480 ? pannjanglayar * 0.8 : pannjanglayar * 0.95,
              child: Column(
                children: [
                  HeaderProfile(pannjanglayar: pannjanglayar),
                  MainContentProfile(),
                ],
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

class HeaderLayout extends StatefulWidget {
  const HeaderLayout({super.key});

  @override
  State<HeaderLayout> createState() => _HeaderLayoutState();
}

class _HeaderLayoutState extends State<HeaderLayout> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 150,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is SessionExpired) {
                    context.read<TokenauthCubit>().onLogout();
                  }
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          state.data == null ? "memuat ..." : "Selamat datang ${state.data?.name}",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width>900? 48:14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Home / Profile",
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: MediaQuery.of(context).size.width>900?18:14,
                        ),
                      ),
                    ],
                  );
                },
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
      ),
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
  List<GlobalKey> _pageKeys = [];
  int currentindex = 0;
  int higheghtpage = 0;
  double heightpage = 1000;
  bool _measureScheduled = false;
  final limit = 2;

  @override
  void initState() {
    final cubit = context.read<ListInvoiceCubit>();
    Logger().d("init dipanggil - load page 1");
    cubit.getLoad(1, 2);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scheduleMeasure());
  }

  void _measure() {
    if (!mounted) return;
    if (_pageKeys.isEmpty) return;

    // try to measure current page key first
    final key = _pageKeys.length > currentindex ? _pageKeys[currentindex] : _pageKeys.first;
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final logicalHeight = box.size.height; // logical pixels
    Logger().d("measured logicalHeight: $logicalHeight");

    final newHeight = logicalHeight + 40; // small padding
    // only update if difference significant to avoid infinite setState loop
    if ((newHeight - heightpage).abs() > 1.0) {
      setState(() {
        heightpage = newHeight;
      });
    }
  }

  void scheduleMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      _measure();
    });
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: HeaderPage(
              onrefresh: () {
                setState(() {
                  currentindex = 0;
                  higheghtpage = 0;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: MediaQuery.of(context).size.width > 440 ? const EdgeInsets.symmetric(horizontal: 20) : const EdgeInsets.all(0),
          child: BlocConsumer<ListInvoiceCubit, ListInvoiceState>(
            listener: (context, state) {
              if (state is SessionExpired) {
                context.read<TokenauthCubit>().onLogout();
              }
            },
            builder: (context, state) {
              if (state.step == RequestState.loading && state.listdata.isEmpty) {
                return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
              }

              if (state.step == RequestState.error) {
                return Center(child: Text("terjadi kesalahan coba lagi"));
              }

              if (state.listdata.isEmpty) {
                return Center(child: Text("No data available"));
              }

              // Update higheghtpage and keys after frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final totalItems = state.data?.metadata.count ?? state.listdata.length;
                final newPageCount = (totalItems / 2).ceil();
                if (higheghtpage != newPageCount) {
                  setState(() {
                    higheghtpage = newPageCount;
                  });
                }

                if (_pageKeys.length != newPageCount) {
                  _pageKeys = List.generate(newPageCount, (_) => GlobalKey());
                }

                scheduleMeasure();
              });

              return SizedBox(
                height: heightpage,
                child: LayoutBuilder(
                  builder: (context, constrians) {
                    return PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pagecontroller,
                      onPageChanged: (value) {
                        setState(() {
                          currentindex = value;
                        });
                        // trigger load logic
                        final cubit = context.read<ListInvoiceCubit>();
                        final currentState = cubit.state;
                        if (currentState.step == RequestState.loaded && currentState.data?.metadata != null) {
                          final totalLoadedItems = currentState.listdata.length;
                          final totalAvailableItems = currentState.data!.metadata.count;
                          final itemsPerPage = 2;
                          final lastPageIndex = ((totalLoadedItems + itemsPerPage - 1) / itemsPerPage).floor() - 1;
                          if (value >= lastPageIndex && totalLoadedItems < totalAvailableItems) {
                            final nextPage = (totalLoadedItems / itemsPerPage).ceil() + 1;
                            cubit.getLoad(nextPage, itemsPerPage);
                          }
                        }
                        scheduleMeasure();
                      },
                      itemCount: higheghtpage,
                      itemBuilder: (context, indexpage) {
                        return BlocBuilder<ListInvoiceCubit, ListInvoiceState>(
                          builder: (context, state) {
                            if (state.step == RequestState.loaded) {
                              final startIndex = indexpage * 2;
                              if (startIndex >= state.listdata.length) return Container();
                              final availableItemsCount = state.listdata.length - startIndex;
                              final itemCountForThisPage = availableItemsCount > 2 ? 2 : availableItemsCount;

                              return Center(
                                child: KeyedSubtree(
                                  key: _pageKeys.length > indexpage ? _pageKeys[indexpage] : UniqueKey(),
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: itemCountForThisPage,
                                    itemBuilder: (context, idx) {
                                      final dataIndex = startIndex + idx;
                                      return Itemlistinvoicebuilderpagnation(
                                        constrains: constrians.maxHeight,
                                        data: state.listdata[dataIndex],
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else if (state.step == RequestState.loading) {
                              return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: currentindex > 0
                    ? () {
                        _pagecontroller.animateToPage(
                          currentindex - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: ColorTema.accentColor,
                  size: 28,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: currentindex < (higheghtpage - 1)
                    ? () {
                        Logger().i(
                          "Tombol kanan ditekan - currentindex: $currentindex, higheghtpage: $higheghtpage",
                        );

                        final cubit = context.read<ListInvoiceCubit>();
                        final state = cubit.state;

                        // Check apakah perlu load data baru sebelum swipe
                        if (state.step == RequestState.loaded &&
                            state.data?.metadata != null) {
                          final totalLoadedItems = state.listdata.length;
                          final totalAvailableItems =
                              state.data!.metadata.count;
                          final itemsPerPage = 2;

                          // Hitung page yang akan ditampilkan setelah swipe
                          final nextPageIndex = currentindex + 1;

                          // Hitung halaman apa saja yang sudah kita punya items-nya
                          final loadedPages = (totalLoadedItems / itemsPerPage)
                              .ceil();

                          Logger().i(
                            "Next page index: $nextPageIndex, LoadedPages: $loadedPages, Total available: $totalAvailableItems, TotalLoaded: $totalLoadedItems",
                          );

                          // Jika next page belum memiliki data yang di-load
                          if (nextPageIndex >= loadedPages &&
                              totalLoadedItems < totalAvailableItems) {
                            Logger().i("Load data baru sebelum swipe");
                            final nextPage = loadedPages + 1;
                            cubit.getLoad(nextPage, itemsPerPage);
                          }
                        }

                        _pagecontroller.animateToPage(
                          currentindex + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: ColorTema.accentColor,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class Itemlistinvoicebuilderpagnation extends StatelessWidget {
  final double constrains;
  final BookingDataEntity data;
  final GlobalKey? keys;
  const Itemlistinvoicebuilderpagnation({
    super.key,
    required this.constrains,
    required this.data,
    this.keys
  });
  Color _colorStatus(String status) {
    switch (status) {
      case "DP":
        return ColorTema.biru;

      case "LUNAS":
        return ColorTema.accentColor;

      case "PENDING":
        return Colors.amber;

      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrainss) {
        Logger().d("tinggi item adalah : ${constrainss.minHeight}");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RepaintBoundary(
            child: FrostGlassAnimated(
              keys: keys,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MediaQuery.of(context).size.width > 440
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.packageName,
                                style: GoogleFonts.robotoFlex(
                                  color: Color(0xFFE0E0E0),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _colorStatus(data.status),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    data.status,
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.packageName,
                                style: GoogleFonts.robotoFlex(
                                  color: Color(0xFFE0E0E0),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: _colorStatus(data.status),
                                ),
                                padding: EdgeInsets.all(4),
                                child: Center(
                                  child: Text(
                                    data.status,
                                    style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          DataRowItem(
                            path: ImagesPath.logouniv,
                            label: 'Universitas',
                            value: data.university,
                          ),

                          DataRowItem(
                            path: ImagesPath.logotanggal,
                            label: 'Tanggal Foto',
                            value: data.date,
                          ),

                          DataRowItem(
                            path: ImagesPath.logowaktu,
                            label: 'Waktu Foto',
                            value: "${data.startTime}:${data.endTime}",
                          ),

                          DataRowItem(
                            path: ImagesPath.logolocation,
                            label: 'Lokasi Foto',
                            value: data.location,
                          ),
                        ],
                      ),
                    ),
                    FooterContentPage(idinvoice: data.id),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FooterContentPage extends StatelessWidget {
  final String idinvoice;
  const FooterContentPage({super.key, required this.idinvoice});

  @override
  Widget build(BuildContext context) {
    final menuButtons = [
      {
        'bg': Color(0xFF27A693),
        "icon": Icons.payment,
        "label": "Cek Invoice",
        "action": () {
          showDialog(
            context: context,
            builder: (context) => InvoiceDialog(id: idinvoice),
          );
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
          showDialog(
            context: context,
            builder: (context) => Dialogtextinput(idDetailInvoice: idinvoice),
          );
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
        child: MediaQuery.of(context).size.width > 440
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 47.37),
                  backgroundColor: item['bg'] as Color,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: item['action'] as VoidCallback?,
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 47.37),
                  backgroundColor: item['bg'] as Color,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: item['action'] as VoidCallback?,
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      );
    }

    return MediaQuery.of(context).size.width > 900
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: menuButtons.map((e) => customMenuButton(e)).toList(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: menuButtons.map((e) => customMenuButton(e)).toList(),
          );
  }
}

class DataRowItem extends StatelessWidget {
  final String label;
  final String value;
  final String path;
  const DataRowItem({
    super.key,
    required this.label,
    required this.value,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat garis putus-putus vertikal (atau mirip) dengan simbol :
    const String separator = ':';

    return Row(
      // Menyeimbangkan teks vertikal
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20, height: 20, child: SvgPicture.asset(path)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: MediaQuery.of(context).size.width < 440 ? 12 : 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Kolom 2: Pemisah
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            separator,
            style: TextStyle(
              color: Color(0xFFE0E0E0), // Warna pemisah seperti di gambar
              fontSize: MediaQuery.of(context).size.width < 440 ? 12 : 16,
              letterSpacing: 0.1, // Jarak antar titik
            ),
          ),
        ),

        // Kolom 3: Value (Mengambil sisa ruang)
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: MediaQuery.of(context).size.width < 440 ? 12 : 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderPage extends StatelessWidget {
  final VoidCallback onrefresh;
  const HeaderPage({super.key, required this.onrefresh});

  @override
  Widget build(BuildContext context) {
    final panjanglayar = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Text(
            "Session Kamu",
            style: GoogleFonts.robotoFlex(
              color: ColorTema.abu,
              fontWeight: FontWeight.w600,
              fontSize: panjanglayar > 430 ? 22 : 18,
            ),
            textAlign: panjanglayar > 430 ? TextAlign.start : TextAlign.center,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  onrefresh();
                  context.read<ListInvoiceCubit>().getRefresh();
                  context.read<ListInvoiceCubit>().getLoad(1, 2);
                },
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
              LWebButton(
                label: "Tambah booking",
                onPressed: () {},
                icon: Icons.add,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderProfile extends StatefulWidget {
  final double pannjanglayar;
  const HeaderProfile({super.key, required this.pannjanglayar});

  @override
  State<HeaderProfile> createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  @override
  void initState() {
    context.read<ProfileCubit>().onGetdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.requestState == RequestState.loaded) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: ColorTema.accentColor,
                    child: Text(
                      state.data!.name[0],
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.data?.name ?? "memuat..",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit_document, color: Colors.white),
                    ),
                  ],
                ),
                MediaQuery.of(context).size.width > 420
                    ? Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.mail, color: Colors.white),
                              Text(
                                state.data?.email ?? 'email',
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 3,
                            children: [
                              Icon(Icons.phone, color: Colors.white),
                              Text(
                                state.data?.phonenumber ?? "phone",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.mail, color: Colors.white),
                              Text(
                                state.data?.email ?? 'email',
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 3,
                            children: [
                              Icon(Icons.phone, color: Colors.white),
                              Text(
                                state.data?.phonenumber ?? "phone",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                AnimatedDividerCurve(height: 1, color: Colors.white),
              ],
            ),
          );
        } else {
          return MyLottie(aset: ImagesPath.loadinglottie);
        }
      },
    );
  }
}
