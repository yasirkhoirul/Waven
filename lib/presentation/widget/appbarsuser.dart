import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/button.dart';

class AppbarsUser extends StatefulWidget {
  final VoidCallback? onmenupress;
  final Function(int) onpress;
  const AppbarsUser({super.key, required this.onpress, this.onmenupress});

  @override
  State<AppbarsUser> createState() => _AppbarsUserState();
}

class _AppbarsUserState extends State<AppbarsUser> {

  @override
  void initState() {
    context.read<ProfileCubit>().onGetdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => context.go("/home"),
              child: Image.asset(ImagesPath.logotekspng)),
            !isSmall
                ? Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.onpress(0);
                        },
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
                        onPressed: () {
                          widget.onpress(1);
                        },
                        child: Text(
                          "Package",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onpress(2);
                        },
                        child: Text(
                          "Gallery",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed('profile');
                        },
                        child: Text(
                          "Dashboard",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      BlocConsumer<TokenauthCubit, TokenauthState>(
                        listener: (context, state) {
                          if (state.tokens != null) {
                            context.read<ProfileCubit>().onGetdata();
                          }
                        },
                        builder: (context, state) {
                          if (state.tokens != null) {
                            return PopupMenuButton<String>(
                              color: ColorTema.warnaDialog,
                              onSelected: (value) {
                                if (value == 'profile') {
                                  context.goNamed('profile');
                                } else if (value == 'logout') {
                                  context.read<TokenauthCubit>().onLogout();
                                }
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  value: 'profile',
                                  child:
                                      BlocBuilder<ProfileCubit, ProfileState>(
                                        builder: (context, state) {
                                          if (state.requestState ==
                                              RequestState.loaded) {
                                            return ItemDropDown(
                                              name: state.data!.name,
                                              leading: CircleAvatar(
                                                radius: 18,
                                                backgroundColor:
                                                    ColorTema.accentColor,
                                                child: Text(
                                                  state.data!.name[0],
                                                  style: GoogleFonts.robotoFlex(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              "Memuat",
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                ),
                                PopupMenuItem(
                                  value: 'logout',
                                  child: ItemDropDown(
                                    name: "Logout",
                                    leading: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF00A76F),
                                radius: 18,
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                    if (state.requestState ==
                                        RequestState.loaded) {
                                      final name = state.data?.name ?? '';
                                      final initial = name.isNotEmpty
                                          ? name[0]
                                          : '';
                                      return Text(
                                        initial,
                                        style: GoogleFonts.robotoFlex(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (state.requestState ==
                                        RequestState.error) {
                                      return Icon(
                                        Icons.error,
                                        color: Colors.white,
                                        size: 16,
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return LWebButton(label: "Login",onPressed: (){
                              context.go("/login");
                            },);
                          }
                        },
                      ),
                    ],
                  )
                : BlocConsumer<TokenauthCubit, TokenauthState>(
                        listener: (context, state) {
                          if (state.tokens != null) {
                            context.read<ProfileCubit>().onGetdata();
                          }
                        },
                        builder: (context, state) {
                          if (state.tokens != null) {
                            return PopupMenuButton<String>(
                              color: ColorTema.warnaDialog,
                              onSelected: (value) {
                                if (value == 'profile') {
                                  context.goNamed('profile');
                                } else if (value == 'logout') {
                                  context.read<TokenauthCubit>().onLogout();
                                }
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  value: 'profile',
                                  child:
                                      BlocBuilder<ProfileCubit, ProfileState>(
                                        builder: (context, state) {
                                          if (state.requestState ==
                                              RequestState.loaded) {
                                            return ItemDropDown(
                                              name: state.data!.name,
                                              leading: CircleAvatar(
                                                radius: 18,
                                                backgroundColor:
                                                    ColorTema.accentColor,
                                                child: Text(
                                                  state.data!.name[0],
                                                  style: GoogleFonts.robotoFlex(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              "Memuat",
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                ),
                                PopupMenuItem(
                                  value: 'logout',
                                  child: ItemDropDown(
                                    name: "Logout",
                                    leading: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF00A76F),
                                radius: 18,
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                    if (state.requestState ==
                                        RequestState.loaded) {
                                      final name = state.data?.name ?? '';
                                      final initial = name.isNotEmpty
                                          ? name[0]
                                          : '';
                                      return Text(
                                        initial,
                                        style: GoogleFonts.robotoFlex(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (state.requestState ==
                                        RequestState.error) {
                                      return Icon(
                                        Icons.error,
                                        color: Colors.white,
                                        size: 16,
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return LWebButton(label: "Login",onPressed: (){
                              context.go("/login");
                            },);
                          }
                        },
                      ),
          ],
        ),
      ),
    );
  }
}

class ItemDropDown extends StatelessWidget {
  final String name;
  final Widget leading;
  const ItemDropDown({super.key, required this.name, required this.leading});

  @override
  Widget build(BuildContext context) {
    final displayName = name.length > 10 ? '${name.substring(0, 10)}...' : name;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        leading,
        Flexible(
          child: Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
