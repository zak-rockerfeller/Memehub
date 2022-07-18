import 'dart:convert';
import 'package:meme_hub/models/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:clay_containers/clay_containers.dart';
import 'package:meme_hub/config/palette.dart';
import 'package:meme_hub/screens/screens.dart';
import 'package:meme_hub/responsive/widgets.dart';
import 'package:meme_hub/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInMobileScreen extends StatefulWidget {
  const SignInMobileScreen({Key? key}) : super(key: key);

  @override
  _SignInMobileScreenState createState() => _SignInMobileScreenState();
}

class _SignInMobileScreenState extends State<SignInMobileScreen> with SingleTickerProviderStateMixin{
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  void _loginUser() async{
    ApiResponse response = await login(_userEmailController.text, _userPasswordController.text);
    if(response.error == null){
      _saveThenRedirectToHome(response.data as User);
    }
    else{
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));
    }
  }

  void _saveThenRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MobileHomeBody()), (route) => false);
  }

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
                        height: 130,
                        width: 130,
                        borderRadius: 10,
                        depth: calculatedSecondDepth.toInt(),
                        curveType: CurveType.convex,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: ClayContainer(
                              height:110,
                              width: 110,
                              borderRadius: 10,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              depth: calculatedThirdDepth.toInt(),
                              curveType: CurveType.concave,
                              child: Center(
                                  child: ClayContainer(
                                    height: 100,
                                    width: 100,
                                    borderRadius: 1,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    depth: calculatedFourthDepth.toInt(),
                                    curveType: CurveType.convex,
                                    child: const Image(
                                      height: 80,
                                      width: 80,
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
                  padding: const EdgeInsets.only(top: 15, right: 25, bottom: 10, left: 25),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Palette.nestBlue),
                          controller: _userEmailController,
                          validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                          decoration: InputDecoration(
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
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(color: Palette.nestBlue),
                          controller: _userPasswordController,
                          obscureText: !_passwordVisible,
                          validator: (val) => val!.length < 5 ? 'Use at least 5 characters' : null,
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                /***
                GestureDetector(
                  //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage(),),),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 3, right: 25, bottom: 10, left: 25),
                      child: Text("Forgot password?",
                        style: TextStyle(
                          color: Palette.nestBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                        ),),
                    ),
                  ),
                ),
                    **/
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: loading ? const Center(child: CircularProgressIndicator(),) :
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Palette.nestBlue,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        }
                      },
                      child: const Text('Sign In',
                        style: TextStyle(color: Palette.scaffold),)),
                ),
                const SizedBox(height: 30),

                const Text(
                  "_______OR_______",
                  style: TextStyle(color: Palette.nestBlue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                /***
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
                    **/
                const SizedBox(height: 20),
                Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? ', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300,letterSpacing: 0.5,color: Palette.nestBlue),),
                      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterMobileScreen(),),),
                        child: const Text('Sign Up', style: TextStyle(color: Palette.nestBlue, fontSize: 20.0, fontWeight: FontWeight.w400,letterSpacing: 0.6,),),),
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
