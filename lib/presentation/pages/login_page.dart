import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/appbars.dart';
import 'package:waven/presentation/widget/button.dart';
import 'package:waven/presentation/widget/divider.dart';
import 'package:waven/presentation/widget/fadeup.dart';
import 'package:waven/presentation/widget/footer.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';
import 'package:waven/presentation/widget/slidedirection.dart';
import 'package:web/web.dart' as web;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tinggilottie = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Builder(
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 0.5),
                ),
              ),
              child: Appbars(isloginpage: true),
            );
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            if (kIsWeb) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 70,
                      child: LayoutLogin(
                        tinggilottie: tinggilottie,
                        runtimeType: runtimeType,
                      ),
                    ),
                    Container(color: Colors.black, child: Footer()),
                  ],
                ),
              );
            }
            if (constrains.maxHeight < 800) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 800,
                  child: LayoutLogin(
                    tinggilottie: tinggilottie,
                    runtimeType: runtimeType,
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: LayoutLogin(
                  tinggilottie: tinggilottie,
                  runtimeType: runtimeType,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class LayoutLogin extends StatefulWidget {
  const LayoutLogin({
    super.key,
    required this.tinggilottie,
    required this.runtimeType,
  });

  final double tinggilottie;
  final Type runtimeType;

  @override
  State<LayoutLogin> createState() => _LayoutLoginState();
}

class _LayoutLoginState extends State<LayoutLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftBottomAnimation;
  late Animation<Offset> _rightTopAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Kiri bawah → ke kiri bawah final
    _leftBottomAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5), // dari luar kiri bawah
      end: const Offset(0, 0), // posisi final
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Kanan atas → ke kanan atas final
    _rightTopAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5), // dari luar kiri atas
      end: const Offset(0, 0), // posisi final
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Mulai animasi setelah build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.black)),
        Positioned(
          bottom: widget.tinggilottie * -0.25,
          left: 0,
          child: SlideTransition(
            position: _leftBottomAnimation,
            child: SizedBox(
              height: widget.tinggilottie,
              width: widget.tinggilottie,

              child: MyLottie(aset: ImagesPath.bgleftlottie),
            ),
          ),
        ),
        Positioned(
          top: widget.tinggilottie * -0.25,
          right: 0,
          child: SlideTransition(
            position: _rightTopAnimation,
            child: SizedBox(
              height: widget.tinggilottie,
              width: widget.tinggilottie,

              child: Hero(
                tag: 'kiri',
                child: MyLottie(aset: ImagesPath.bgrightlottie),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          top: 0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 150,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Sign In",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 48,
                              ),
                            ),
                            Text(
                              "Home/login",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                                fontSize: 18,
                              ),
                            ),
                          ],
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FrostGlassAnimated(
                      width: 800,
                      
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInUpText(
                              text: "LOGIN",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                              duration: Duration(milliseconds: 800),
                              delay: Duration(milliseconds: 300), // opsional
                              offsetY: 30, // jarak start dari bawah
                            ),
                            FadeInUpText(
                              text:
                                  "Masukkan password dan username untuk masuk",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                              ),

                              duration: Duration(milliseconds: 800),
                              delay: Duration(milliseconds: 400), // opsional
                              offsetY: 30,
                            ),
                            BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) async {
                                if (state is AuthLoaded) {
                                  context.read<TokenauthCubit>().getTokens();

                                  context.read<AuthCubit>().onInit();
                                }
                              },
                              builder: (context, state) {
                                return AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    switchInCurve: Curves.easeIn,
                                    switchOutCurve: Curves.easeOut,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child: Builder(
                                      key: ValueKey(
                                        state.runtimeType,
                                      ), // penting untuk AnimatedSwitcher
                                      builder: (_) {
                                        if (state is AuthInitial) {
                                          return FormLogin();
                                        } else if (state is AuthLoading) {
                                          return Center(
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: MyLottie(
                                                aset: ImagesPath.loadingwaven,
                                              ),
                                            ),
                                          );
                                        } else if (state is AuthError) {
                                          return Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  state.message,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context
                                                        .read<AuthCubit>()
                                                        .onInit();
                                                  },
                                                  child: const Text(
                                                    "Coba Lagi",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (state is AuthLoaded) {
                                          return Center(
                                            child: Text(
                                              state.message,
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        } else if (state
                                            is AuthRedirectGoogle) {
                                          return Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  state.message,
                                                  style: GoogleFonts.robotoFlex(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  state.data,
                                                  style: GoogleFonts.robotoFlex(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              "Terjadi kesalahan tak terduga",
                                              style: GoogleFonts.robotoFlex(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  StreamSubscription<web.MessageEvent>? _messageSubscription;
  bool showpw = true;
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  final TextEditingController ur = TextEditingController();
  final TextEditingController pw = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ur.dispose();
    _messageSubscription?.cancel();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInSlide(
      direction: SlideDirection.up,
      child: Form(
        key: _keyform,
        child: Column(
          spacing: 10,
          children: [
            TextFormField(
              controller: ur,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return "email tidak boleh kosong";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),

                label: Text(
                  "username",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                suffix: Icon(Icons.person, color: Colors.white),
              ),
            ),
            TextFormField(
              obscureText: showpw,
              controller: pw,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return "password tidak boleh kososng";
                }
                if (value.length < 8) {
                  return "password tidak boleh kurang dari 8 huruf";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(
                  "password",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                suffix: InkWell(
                  onTap: () {
                    setState(() {
                      showpw = !showpw;
                    });
                  },
                  child: Icon(
                    showpw ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            LWebButton(
              label: "Masuk",
              onPressed: () {
                if (_keyform.currentState!.validate()) {
                  context.read<AuthCubit>().onLogin(ur.text, pw.text);
                }
              },
            ),
            Text(
              "Atau lanjutkan dengan",
              style: GoogleFonts.robotoFlex(color: Color(0xFFA8A8A8)),
            ),
            LWebButton(
              widge: SvgPicture.asset(ImagesPath.google),
              label: "Masuk dengan Akun Google",
              onPressed: () {
                if (_keyform.currentState!.validate()) {
                  context.read<AuthCubit>().onLogin(ur.text, pw.text);
                }
              },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum Punya akun?",
                  style: GoogleFonts.robotoFlex(color: Color(0xFFA8A8A8)),
                ),
                InkWell(
                  onTap: () => context.go('/signup'),
                  child: Text("Daftar",style: GoogleFonts.robotoFlex(color: ColorTema.accentColor,)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
