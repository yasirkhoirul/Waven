import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waven/presentation/pages/home_page.dart';
import 'package:waven/presentation/widget/appbarsuser.dart';

class MainScaffoldUserPage extends StatelessWidget {
  final StatefulNavigationShell statefulNavigationShell;
  const MainScaffoldUserPage({
    super.key,
    required this.statefulNavigationShell,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.black.withAlpha(56)),
          child: AppbarsUser(alreadylogin: true),
        ),
       
      ),
      body: statefulNavigationShell,
    );
  }
}
