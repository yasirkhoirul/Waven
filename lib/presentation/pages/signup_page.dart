import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/constant.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/domain/entity/univ_dropdown.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/widget/appbars.dart';
import 'package:waven/presentation/widget/button.dart';
import 'package:waven/presentation/widget/frostglass.dart';
import 'package:waven/presentation/widget/lottieanimation.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final limit = 10;
  int page = 1;
  @override
  void initState() {
    super.initState();
  }

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
              child: Appbars(isloginpage: false),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.black)),
            Positioned(
              bottom: tinggilottie * -0.40,
              left: 0,
              child: SizedBox(
                height: tinggilottie,
                width: tinggilottie,

                child: MyLottie(aset: ImagesPath.bgleftlottie),
              ),
            ),
            Positioned(
              top: tinggilottie * -0.40,
              right: 0,
              child: SizedBox(
                height: tinggilottie,
                width: tinggilottie,

                child: MyLottie(aset: ImagesPath.bgrightlottie),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Center(
                child: FrostGlassAnimated(
                  width: 800,
                  height: 800,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 800,
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SignUp",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                            Text(
                              "Masukkan Data diri untuk melakukan SignUp",
                              style: GoogleFonts.robotoFlex(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            Expanded(
                              child: BlocConsumer<SignupCubit, SignupState>(
                                listener: (context, state) {
                                  if (state is SignupLoaded) {
                                    context.read<TokenauthCubit>().getTokens();
                                  }
                                },
                                builder: (context, state) {
                                  if (state is SignupLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is SignupError) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        Text(
                                          state.message,
                                          style: GoogleFonts.robotoFlex(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<SignupCubit>().init();
                                          },
                                          child: Text("Coba Lagi"),
                                        ),
                                      ],
                                    );
                                  } else if (state is SignupLoaded) {
                                    return Center(child: Text("Sukses"));
                                  } else if (state is SignupInitial) {
                                    return FormSignUp(
                                      reqstate: state.constantclass,
                                      univ: state.datauniv,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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

class FormSignUp extends StatefulWidget {
  const FormSignUp({super.key, required this.reqstate, required this.univ});
  final List<UnivDropdown> univ;
  final RequestState reqstate;
  @override
  State<FormSignUp> createState() => _FormSignUpState();
}

class _FormSignUpState extends State<FormSignUp> {
  bool showpw = true;
  bool showrepw = true;
  String? selectedUniversity;
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  final TextEditingController ur = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pw = TextEditingController();
  final TextEditingController repw = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ur.dispose();
    email.dispose();
    name.dispose();
    phone.dispose();
    pw.dispose();
    repw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyform,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          TextFormField(
            controller: ur,
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "username tidak boleh kosong";
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
            controller: email,
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
                "email",
                style: GoogleFonts.robotoFlex(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffix: Icon(Icons.mail, color: Colors.white),
            ),
          ),
          TextFormField(
            controller: name,
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "name tidak boleh kosong";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),

              label: Text(
                "name",
                style: GoogleFonts.robotoFlex(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffix: Icon(Icons.person, color: Colors.white),
            ),
          ),
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              if (state is SignupInitial) {
                return DropDownSearchUniv(
                  onChange: (UnivDropdown? p1) {
                    setState(() {
                      selectedUniversity = p1?.name;
                    });
                  },
                );
              } else {
                return Text("Memuat Univ...");
              }
            },
          ),
          TextFormField(
            controller: phone,
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "phone number tidak boleh kosong";
              }
              final v = value.trim();
              // allow numbers starting with 62 or 0, otherwise invalid
              if (!RegExp(r'^(62|0)\d+ *').hasMatch(v)) {
                return "Nomor telepon harus dimulai dengan 62 atau 0";
              }
              if (v.replaceAll(RegExp(r'\D'), '').length < 9) {
                return "phone number terlalu pendek";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),

              label: Text(
                "Phone Number",
                style: GoogleFonts.robotoFlex(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffix: Icon(Icons.numbers, color: Colors.white),
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
              if (value != pw.text) {
                return "password harus sama";
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
          TextFormField(
            obscureText: showrepw,
            controller: repw,
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "re password tidak boleh kososng";
              }
              if (value.length < 8) {
                return "re password tidak boleh kurang dari 8 huruf";
              }
              if (value != pw.text) {
                return "password harus sama";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),

              label: Text(
                "re-password",
                style: GoogleFonts.robotoFlex(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              suffix: InkWell(
                onTap: () {
                  setState(() {
                    showrepw = !showrepw;
                  });
                },
                child: Icon(
                  showrepw ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          LWebButton(
            label: "Daftar",
            onPressed: () {
              if (_keyform.currentState!.validate()) {
                if (selectedUniversity == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: Icon(Icons.error),
                      content: Text("silahkan pilih univ"),
                    ),
                  );
                  return;
                }
                // normalize phone to start with 62
                String normalizedPhone = phone.text.trim();
                if (normalizedPhone.startsWith('0')) {
                  normalizedPhone = '62' + normalizedPhone.substring(1);
                } else if (!normalizedPhone.startsWith('62')) {
                  normalizedPhone = '62' + normalizedPhone;
                }

                final User data = User(
                  email: email.text,
                  username: ur.text,
                  password: pw.text,
                  name: name.text,
                  university: selectedUniversity!,
                  phonenumber: normalizedPhone,
                );
                context.read<SignupCubit>().onSignup(data);
              }
            },
          ),
        ],
      ),
    );
  }
}

class DropDownSearchUniv extends StatelessWidget {
  final Function(UnivDropdown?) onChange;
  final double? fontSize;
  final UnivDropdown? initialValue;

  final String? Function(UnivDropdown?)? validator;
  const DropDownSearchUniv({super.key, required this.onChange, this.fontSize, this.initialValue, this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<UnivDropdown>(
      validator: validator,
      dropdownBuilder: (context, selectedItem) {
        final text = selectedItem?.name ?? "";
        return DefaultTextStyle(
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: fontSize ?? 11,
            fontWeight: FontWeight.w600,
          ),
          child: Text(text),
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(),

          hintStyle: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: fontSize ?? 11,
            fontWeight: FontWeight.bold,
          ),
          hintText: "Pilih Universitas",
        ),
      ),
      compareFn: (item1, item2) => item1.id == item2.id,

      items: (filter, loadProps) async {
        final page = (loadProps!.skip ~/ loadProps.take) + 1;
        final data = await context.read<SignupCubit>().getUnivdrop(
          page,
          loadProps.take,
          filter,
        );
        return data;
      },
      selectedItem: initialValue,
      itemAsString: (item) => item.name,
      onChanged: onChange,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        disableFilter: true,
        infiniteScrollProps: InfiniteScrollProps(
          loadProps: LoadProps(skip: 0, take: 2),
        ),
      ),
    );
  }
}
