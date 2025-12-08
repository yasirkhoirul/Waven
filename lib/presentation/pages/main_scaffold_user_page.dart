import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/appbarsuser.dart';

class MainScaffoldUserPage extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;
  const MainScaffoldUserPage({
    super.key,
    required this.statefulNavigationShell,
  });

  @override
  State<MainScaffoldUserPage> createState() => _MainScaffoldUserPageState();
}

class _MainScaffoldUserPageState extends State<MainScaffoldUserPage> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  void gobranch(int index) {
    widget.statefulNavigationShell.goBranch(
      index,
      initialLocation: index == widget.statefulNavigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text(
                "Home",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                context.pop();
                gobranch(0);
              },
            ),
            ListTile(
              title: Text(
                "Package",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                context.pop();
                gobranch(1);
              },
            ),
            ListTile(
              title: Text(
                "Gallery",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                context.pop();
                gobranch(2);
              },
            ),
            ListTile(
              title: Text(
                "Logout",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                context.pop();
                context.read<TokenauthCubit>().onLogout();
              },
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.black.withAlpha(56)),
          child: AppbarsUser(
            onpress: (int p1) {
              gobranch(p1);
            },
            onmenupress: () {
              scaffoldkey.currentState?.openDrawer();
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(child: widget.statefulNavigationShell)),
    );
  }
}
