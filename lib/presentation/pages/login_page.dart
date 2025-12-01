import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/widget/appbars.dart';
import 'package:waven/presentation/widget/frostglass.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Appbars(isloginpage: true,),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)),

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Center(
                child: FrostGlass(
                  width: 800,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGIN",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          "Masukkan password dan username untuk masuk",
                          style: GoogleFonts.robotoFlex(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthInitial) {
                              return FormLogin();
                            }else if(state is AuthLoading){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if(state is AuthError){
                              return Center(
                                child: Column(
                                  children: [Text(
                                    state.message
                                  ),
                                  ElevatedButton(onPressed: (){
                                    context.read<AuthCubit>().onInit();
                                  }, child: Text("Coba Lagi"))
                                  ],
                                ),
                              );
                            }else if(state is AuthLoaded){
                              return Center(
                                child: Text("Sukses",style: GoogleFonts.robotoFlex(
                                  color: Colors.white
                                )),
                              );
                            }else{
                              return Center(
                                child: Text("terjadi kesalahan tak terduga",style: GoogleFonts.robotoFlex(
                                  color: Colors.white
                                ),),
                              );
                            }
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
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
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
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  showpw = !showpw;
                }
                ,child: Icon(Icons.visibility, color: Colors.white)),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Color(0xFF00A76F)),
            onPressed: () {
              if (_keyform.currentState!.validate()) {
                context.read<AuthCubit>().onLogin(ur.text, pw.text);
              }
            },
            child: Text(
              "Login",
              style: GoogleFonts.robotoFlex(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
