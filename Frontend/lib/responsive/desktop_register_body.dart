import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:clay_containers/clay_containers.dart';
import '../config/palette.dart';
import 'app_outlinebutton.dart';
import 'desktop_register_body.dart';
import 'mobile_register_body.dart';



class RegisterDesktopScreen extends StatefulWidget {
  const RegisterDesktopScreen({Key? key}) : super(key: key);

  @override
  _RegisterDesktopScreenState createState() => _RegisterDesktopScreenState();
}

class _RegisterDesktopScreenState extends State<RegisterDesktopScreen> with SingleTickerProviderStateMixin{
  Color baseColor = const Color(0xFFf2f2f2);
  double firstDepth = 50;
  double secondDepth = 50;
  double thirdDepth = 50;
  double fourthDepth = 50;
  late AnimationController _animationController;

  bool _passwordVisible =false;
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final bool _validateEmail = false;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });

    _animationController.forward();
    _passwordVisible = false;

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double stagger(value, progress, delay) {
      progress = progress - (1 - delay);
      if (progress < 0) progress = 0;
      return value * (progress / delay);
    }

    double calculatedSecondDepth =
    stagger(secondDepth, _animationController.value, 0.5);
    double calculatedThirdDepth =
    stagger(thirdDepth, _animationController.value, 0.75);
    double calculatedFourthDepth =
    stagger(fourthDepth, _animationController.value, 1);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 30),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Center(
                      child: ClayContainer(
                        height: 180,
                        width: 180,
                        borderRadius: 15,
                        depth: calculatedSecondDepth.toInt(),
                        curveType: CurveType.convex,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: ClayContainer(
                              height:150,
                              width: 150,
                              borderRadius: 10,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              depth: calculatedThirdDepth.toInt(),
                              curveType: CurveType.concave,
                              child: Center(
                                  child: ClayContainer(
                                    height: 120,
                                    width: 120,
                                    borderRadius: 5,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    depth: calculatedFourthDepth.toInt(),
                                    curveType: CurveType.convex,
                                    child: const Image(
                                      height: 100,
                                      width: 100,
                                      image: AssetImage('assets/images/ponder_logo.png'),
                                      fit: BoxFit.cover,),
                                  ))),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 25,),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      style: const TextStyle(color: Palette.nestBlue),
                      controller: _userEmailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.user, size: 20, color: Palette.nestBlue,),
                        hintText: "  Full name",
                        hintStyle: const TextStyle(color: Palette.nestBlue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Palette.nestBlue,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Palette.nestBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 25,),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      style: const TextStyle(color: Palette.nestBlue),
                      controller: _userEmailController,
                      decoration: InputDecoration(
                        errorText: _validateEmail ? 'Enter a valid email address.' : null,
                        prefixIcon: const Icon(FontAwesomeIcons.envelope, size: 20, color: Palette.nestBlue,),
                        hintText: "  Email",
                        hintStyle: const TextStyle(color: Palette.nestBlue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Palette.nestBlue,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Palette.nestBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 25,),
                  child: SizedBox(
                    width: 500,
                    child: TextField(
                      controller: _userPasswordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Palette.nestBlue,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20, color: Palette.nestBlue,),
                        hintText: "  Password",
                        hintStyle: const TextStyle(color: Palette.nestBlue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  const BorderSide(
                            color: Palette.nestBlue,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Palette.nestBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Palette.nestBlue,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {

                      },
                      child: const Text('Sign Up',
                        style: TextStyle(color: Palette.scaffold),)),
                ),
                const SizedBox(height: 35),

                const Text(
                  "_______OR_______",
                  style: TextStyle(color: Palette.nestBlue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppOutlineButton(
                        asset: "assets/images/google.png",
                        onTap: () {
                          //login using google
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300,letterSpacing: 0.5,color: Palette.nestBlue),),
                      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterDesktopScreen(),),),
                        child: const Text('Sign In', style: TextStyle(color: Palette.nestBlue, fontSize: 20.0, fontWeight: FontWeight.w400,letterSpacing: 0.6,),),),
                    ],
                  ),


                ),

              ],
            ),
          )
      ),
    );
  }
}
