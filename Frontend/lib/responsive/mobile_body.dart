import 'package:flutter/material.dart';
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

class MobileHomeBody extends StatefulWidget {
  const MobileHomeBody({Key? key}) : super(key: key);

  @override
  State<MobileHomeBody> createState() => _MobileHomeBodyState();
}

class _MobileHomeBodyState extends State<MobileHomeBody> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Palette.nestBlue),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
          },
          icon: Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
                color: Palette.scaffold,
                shape: BoxShape.circle,
                image:  DecorationImage(
                    image: AssetImage("assets/images/ponder_logo.png"),
                    fit: BoxFit.fitHeight)

            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Memehub', style: TextStyle(color: Palette.nestBlue, fontSize: 18,),),
        actions: [
          IconButton(
            color: Palette.nestBlue,
            icon: const Icon(FontAwesomeIcons.signOutAlt, size: 25,),
            onPressed: () {
              logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.nestBlue,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MobileUploadPage(
            title: 'Upload',
          ),),);
        },
        child: const Icon(Icons.add, color: Palette.scaffold,),
      ),
      body: currentIndex == 0 ? const MobileHomePage() : const MobileProfilePage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home, color: Palette.nestBlue,),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.user, color: Palette.nestBlue),
                  label: ''),
            ],
            currentIndex: currentIndex,
            onTap: (val){
              setState((){
                currentIndex = val;
              });
            }
        ),
      ),
    );
  }
}
