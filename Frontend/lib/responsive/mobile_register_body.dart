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


class RegisterMobileScreen extends StatefulWidget {
  const RegisterMobileScreen({Key? key}) : super(key: key);
  @override
  _RegisterMobileScreenState createState() => _RegisterMobileScreenState();
}

class _RegisterMobileScreenState extends State<RegisterMobileScreen> {
  final bool value = false;
  bool _passwordVisible =false;
  bool _confirmPasswordVisible =false;
  final bool _validateEmail = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  void _registerUser() async{
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
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
    _passwordVisible = false;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            //iconSize: 30.0,
            color: Palette.nestBlue,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 3,


        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Text("Sign Up to continue",
                  style: TextStyle(
                    color: Palette.nestBlue,
                    fontSize: 18,
                    fontFamily: 'CM Sans Serif',
                    height: 1.2,
                    letterSpacing: 0.5,),
                  textAlign: TextAlign.start,
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 25, bottom: 10, left: 25),
                      child: TextFormField(
                        style: const TextStyle(color: Palette.nestBlue),
                        controller: nameController ,
                        decoration: InputDecoration(
                          label: const Text('Full name', style: TextStyle(fontSize: 15, color: Palette.nestBlue),),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 25, bottom: 10, left: 25),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          style: const TextStyle(color: Palette.nestBlue),
                          controller: emailController,
                          decoration: InputDecoration(
                            label: const Text('Email', style: TextStyle(fontSize: 15, color: Palette.nestBlue),),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 25, bottom: 5, left: 25),
                      child: TextFormField(
                        style: const TextStyle(color: Palette.nestBlue),
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                        validator: (val) => val!.length < 5 ? 'Use at least 5 characters' : null,
                        decoration: InputDecoration(
                          label: const Text('Password', style: TextStyle(fontSize: 15, color: Palette.nestBlue),),

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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 25, bottom: 5, left: 25),
                      child: TextFormField(
                        style: const TextStyle(color: Palette.nestBlue),
                        controller: confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        validator: (val) => val != passwordController.text ? 'Password does not match' : null,
                        decoration: InputDecoration(
                          label: const Text('Confirm password', style: TextStyle(fontSize: 15, color: Palette.nestBlue),),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Palette.nestBlue,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              });
                            },
                          ),
                          prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20, color: Palette.nestBlue,),
                          hintText: "  Confirm password",
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
                  ],
                ),

              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
                child: loading ? const Center(child: CircularProgressIndicator(),):
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Palette.nestBlue,
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed:() {
                      if(formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                          _registerUser();
                        });
                      }
                    },
                    child: const Text('Sign Up')),

              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: (){

                },
                child: const Center(
                  child: Text('By continuing you agree to terms and conditions.',
                    style: TextStyle(fontSize: 10, color: Palette.nestBlue,
                        decoration: TextDecoration.none,  fontWeight: FontWeight.w400),),
                ),
              ),
/**
              const SizedBox(height: 14),
              const Text(
                "_______OR_______",
                style: TextStyle(color: Palette.nestBlue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppOutlineButton(
                      asset: "assets/images/google.png",
                      onTap: () {
                      //sign up with google
                      },
                    ),
                  ],
                ),
              ),
    **/
              const SizedBox(height: 24),
              Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300,letterSpacing: 0.5, color: Palette.nestBlue),),
                      GestureDetector(onTap: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInMobileScreen()),),
                        child: const Text('Sign In', style: TextStyle(color: Palette.nestBlue, fontSize: 16.0, fontWeight: FontWeight.w400,letterSpacing: 0.6,),),),
                    ],
                  )
              ),


            ],
          ),
        ),
      ),
    );
  }
}