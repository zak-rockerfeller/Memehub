import 'package:flutter/material.dart';
import 'package:meme_hub/responsive/widgets.dart';

class ResponsiveLoginPage extends StatefulWidget {
  const ResponsiveLoginPage({Key? key}) : super(key: key);

  @override
  State<ResponsiveLoginPage> createState() => _ResponsiveLoginPageState();
}

class _ResponsiveLoginPageState extends State<ResponsiveLoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ResponsiveLayout(mobileBody: SignInMobileScreen(), desktopBody: SignInDesktopScreen())
    );
  }
}