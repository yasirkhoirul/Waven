import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/list_invoice_user.dart';
import 'package:waven/presentation/cubit/list_invoice_cubit.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/widget/dialog.dart';
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
              width: pannjanglayar * 0.8,
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
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          state.data == null?  "memuat ...": "Selamat datang ${state.data?.name}",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 48,
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
                          fontSize: 18,
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
  int currentindex = 0;
  int higheghtpage = 0;
  final limit = 2;

  @override
  void initState() {
    final cubit = context.read<ListInvoiceCubit>();
    Logger().d("init dipanggil - load page 1");
    cubit.getLoad(1, 2);
    super.initState();
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
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<ListInvoiceCubit, ListInvoiceState>(
            builder: (context, state) {
              if (state.step == RequestState.loading &&
                  state.listdata.isEmpty) {
                return Center(child: MyLottie(aset: ImagesPath.loadinglottie));
              }

              if (state.step == RequestState.error) {
                return Center(child: Text("Error loading data"));
              }

              if (state.listdata.isEmpty) {
                return Center(child: Text("No data available"));
              }

              // Update higheghtpage based on total count from metadata
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final totalItems =
                    state.data?.metadata.count ?? state.listdata.length;
                final newPageCount = (totalItems / 2).ceil();
                Logger().i(
                  "Calculate pages - totalItems: $totalItems, newPageCount: $newPageCount",
                );
                if (higheghtpage != newPageCount) {
                  setState(() {
                    higheghtpage = newPageCount;
                  });
                }
              });

              return SizedBox(
                height: MediaQuery.of(context).size.width < 920 ? 1000 : 600,
                child: LayoutBuilder(
                  builder: (context, constrians) {
                    return PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pagecontroller,
                      onPageChanged: (value) {
                        setState(() {
                          currentindex = value;
                        });

                        final cubit = context.read<ListInvoiceCubit>();
                        final currentState = cubit.state;

                        if (currentState.step != RequestState.loaded) {
                          return;
                        }
                        if (currentState.data?.metadata == null) {
                          return;
                        }

                        final totalLoadedItems = currentState.listdata.length;
                        final totalAvailableItems =
                            currentState.data!.metadata.count;
                        final itemsPerPage = 2;

                        // Hitung page index terakhir yang bisa ditampilkan
                        final lastPageIndex =
                            ((totalLoadedItems + itemsPerPage - 1) /
                                    itemsPerPage)
                                .floor() -
                            1;
                        // Trigger load data baru saat user di halaman terakhir
                        if (value >= lastPageIndex &&
                            totalLoadedItems < totalAvailableItems) {
                          // Hitung nomor page selanjutnya
                          final nextPage =
                              (totalLoadedItems / itemsPerPage).ceil() + 1;
                          cubit.getLoad(nextPage, itemsPerPage);
                        }
                      },
                      itemCount: higheghtpage,
                      itemBuilder: (context, indexpage) {
                        return BlocConsumer<ListInvoiceCubit, ListInvoiceState>(
                          listener: (context, state) {
                            if (state.step == RequestState.loaded) {
                              setState(() {
                                // Hitung jumlah halaman (2 items per halaman)
                                higheghtpage = (state.listdata.length / 2)
                                    .ceil();
                              });
                              Logger().i(
                                "higheghtpage updated to: $higheghtpage, total items: ${state.listdata.length}",
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state.step == RequestState.loaded) {
                              Logger().i(
                                "Building page $indexpage, listdata length: ${state.listdata.length}",
                              );

                              // Validasi index untuk menghindari RangeError
                              final startIndex = indexpage * 2;
                              final endIndex = startIndex + 2;

                              Logger().i(
                                "StartIndex: $startIndex, EndIndex: $endIndex",
                              );

                              // Pastikan index tidak melebihi jumlah data
                              if (startIndex >= state.listdata.length) {
                                Logger().w(
                                  "StartIndex melebihi listdata length",
                                );
                                return Container();
                              }

                              // Hitung berapa item yang tersedia untuk halaman ini
                              final availableItemsCount =
                                  state.listdata.length - startIndex;
                              final itemCountForThisPage =
                                  availableItemsCount > 2
                                  ? 2
                                  : availableItemsCount;

                              Logger().i(
                                "Available items: $availableItemsCount, akan ditampilkan: $itemCountForThisPage",
                              );

                              return Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: itemCountForThisPage,
                                  itemBuilder: (context, index) {
                                    final dataIndex = startIndex + index;
                                    Logger().i(
                                      "Rendering item at index: $dataIndex",
                                    );
                                    return LayoutBuilder(
                                      builder: (context, constraints) {
                                        Logger().i(constraints.maxHeight);
                                        return Itemlistinvoicebuilderpagnation(
                                          constrains: constrians.maxHeight,
                                          data: state.listdata[dataIndex],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            } else if (state.step == RequestState.loading) {
                              return Center(
                                child: MyLottie(aset: ImagesPath.loadinglottie),
                              );
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
          spacing: 20,
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
  const Itemlistinvoicebuilderpagnation({
    super.key,
    required this.constrains,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FrostGlassAnimated(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaQuery.of(context).size.width>440? Row(
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: data.status == 'PENDING'
                          ? Colors.amber
                          : ColorTema.accentColor,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        data.status,
                        style: GoogleFonts.robotoFlex(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ):Column(
                children: [
                  Text(
                    data.packageName,
                    style: GoogleFonts.robotoFlex(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: data.status == 'PENDING'
                          ? Colors.amber
                          : ColorTema.accentColor,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Center(
                      child: Text(
                        data.status,
                        style: GoogleFonts.robotoFlex(color: Colors.white),
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
        child: MediaQuery.of(context).size.width>440? ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: item['bg'] as Color,
            padding: EdgeInsets.all(20),
          ),
          onPressed: item['action'] as VoidCallback?,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'] as IconData, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                item['label'] as String,
                style: GoogleFonts.robotoFlex(color: Colors.white),
              ),
            ],
          ),
        ):ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: item['bg'] as Color,
            padding: EdgeInsets.all(10),
          ),
          onPressed: item['action'] as VoidCallback?,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'] as IconData, color: Colors.white,size: 10,),
              const SizedBox(width: 3),
              Text(
                item['label'] as String,
                style: GoogleFonts.robotoFlex(color: Colors.white,fontSize: 10),
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
        Expanded(child: SizedBox(width: 20, height: 20, child: SvgPicture.asset(path))),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: MediaQuery.of(context).size.width<440? 8:16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Kolom 2: Pemisah
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            separator,
            style:  TextStyle(
              color: Color(0xFFE0E0E0), // Warna pemisah seperti di gambar
              fontSize: MediaQuery.of(context).size.width<440? 8:16,
              letterSpacing: 0.1, // Jarak antar titik
            ),
          ),
        ),

        // Kolom 3: Value (Mengambil sisa ruang)
        Expanded(
          child: Text(
            value,
            style:  TextStyle(
              color: Color(0xFFE0E0E0), // Teks putih
              fontSize: MediaQuery.of(context).size.width<440? 8:16,
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
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CachedNetworkImage(
                    imageUrl: '',
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: Colors.white),
                    placeholder: (context, url) =>
                        MyLottie(aset: ImagesPath.loadinglottie),
                    fit: BoxFit.cover,
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
                MediaQuery.of(context).size.width>420?Row(
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
                ):Column(
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
