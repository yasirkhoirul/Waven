import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/appbarsuser.dart';

// Custom ScrollBehavior untuk disable auto-scroll ke input field
class NoScrollBehavior extends ScrollBehavior {
  
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

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
   int botNavIndex = 0;
   
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  void gobranch(int index) {
    
    widget.statefulNavigationShell.goBranch(
      index,
      initialLocation: index == widget.statefulNavigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActiveIdex = widget.statefulNavigationShell.currentIndex>=4?3:widget.statefulNavigationShell.currentIndex;
    final isSmall = MediaQuery.of(context).size.width < 800;
    return ScrollConfiguration(
      behavior: NoScrollBehavior(),
      child: Scaffold(
        key: scaffoldkey,
        
        bottomNavigationBar:isSmall? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: isActiveIdex,
          backgroundColor: Colors.black,
          selectedItemColor: ColorTema.accentColor,
          unselectedItemColor: ColorTema.abu,
          onTap: (value) {
          
            if (value == 0) {
              gobranch(0);
            }
            else if(value == 1){
              gobranch(1);
            }
            else if(value == 2){
              gobranch(2);
            }
            else{
              gobranch(3);
            }
          },
          
          items: [
            BottomNavigationBarItem(icon: ImageBot(imagePath: ImagesPath.botnavhome, isActive: isActiveIdex == 0,),label: "Home"),
            BottomNavigationBarItem(icon: ImageBot(imagePath: ImagesPath.botnavpackage, isActive: isActiveIdex == 1,),label: "Package"),
            BottomNavigationBarItem(icon: ImageBot(imagePath: ImagesPath.botnavgalery, isActive: isActiveIdex == 2,),label: "Galeri"),
            BottomNavigationBarItem(icon: ImageBot(imagePath: ImagesPath.botnavticket, isActive: isActiveIdex == 3,),label: "Me"),
    
          ],
        ):null,
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              
              BlocConsumer<TokenauthCubit, TokenauthState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.tokens != null) {
                    return ListTile(
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
                    );
                  } else {
                    return ListTile(
                      title: Text(
                        "Login",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        context.go('/login');
                      },
                    );
                  }
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
          child: SafeArea(child: widget.statefulNavigationShell),
        ),
      ),
    );
  }
}

class ImageBot extends StatelessWidget {

  final String imagePath;
  final bool isActive;
  const ImageBot({
    super.key, required this.imagePath, required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(imagePath,colorFilter: ColorFilter.mode(isActive?ColorTema.accentColor: Colors.white, BlendMode.srcIn));
  }
}
