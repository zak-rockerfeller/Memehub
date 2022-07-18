import 'package:meme_hub/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:meme_hub/services/services.dart';
import 'package:meme_hub/screens/screens.dart';
import 'package:meme_hub/responsive/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
