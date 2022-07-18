import 'dart:io';
import 'package:meme_hub/constants.dart';
import 'package:meme_hub/services/services.dart';
import 'package:flutter/material.dart';
import 'package:meme_hub/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_hub/responsive/widgets.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:meme_hub/config/palette.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MobileProfilePage extends StatefulWidget {
  const MobileProfilePage({Key? key}) : super(key: key);

  @override
  State<MobileProfilePage> createState() => _MobileProfilePageState();
}

class _MobileProfilePageState extends State<MobileProfilePage> with SingleTickerProviderStateMixin{
  User? user;
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();
  final TextEditingController _txtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color baseColor = const Color(0xff949494);
  double firstDepth = 50;
  double secondDepth = 50;
  double thirdDepth = 50;
  double fourthDepth = 50;
  late AnimationController _animationController;


  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //Get user details
  Future<void> getUser() async{
    ApiResponse response = await getUserDetail();

    if(response.error == null){
      setState(() {
        user = response.data as User;
        loading = false;
        _txtController.text = user!.name ?? '';

      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));

    }
  }

  //Update Profile
  void updateProfile() async{
    ApiResponse response = await updateUser(_txtController.text, getStringImage(_imageFile));

    setState(() {
      loading = false;
    });

    if(response.error == null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.data}'),));
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));
    }
  }


  @override
  void initState() {
    getUser();
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    _animationController.forward();
    super.initState();


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

    return loading ? const Center(child: CircularProgressIndicator(),) :
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(padding: const EdgeInsets.fromLTRB(40, 40, 40, 0 ),
            child: ListView(
              children: [
                Center(
                  child: ClayContainer(
                    height: 150,
                    width: 150,
                    borderRadius: 75,
                    depth: calculatedSecondDepth.toInt(),
                    curveType: CurveType.concave,
                    color: Colors.white70,
                    child: Center(
                      child: ClayContainer(
                          height:110,
                          width: 110,
                          borderRadius: 55,
                          color: Colors.white70,
                          depth: calculatedThirdDepth.toInt(),
                          curveType: CurveType.convex,
                          child: Center(
                              child: ClayContainer(
                                height: 90,
                                width: 90,
                                borderRadius: 45 ,
                                color: Colors.white70,
                                depth: calculatedFourthDepth.toInt(),
                                curveType: CurveType.concave,
                                child: GestureDetector(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(45),
                                        image: _imageFile == null ? user!.image != null ?
                                        DecorationImage(image: NetworkImage('${user!.image}'), fit: BoxFit.cover) : null :
                                        DecorationImage(image: FileImage(_imageFile ?? File('')),fit: BoxFit.cover)
                                    ),
                                       child: _imageFile == null ? user!.image != null ? null :
                                    const Icon(FontAwesomeIcons.userAlt, size: 30, color: Palette.scaffold,) : null

                                  ),
                                  onTap: (){
                                    getImage();
                                  },
                                ),
                              ))),
                    ),
                  ),
                ),
                const SizedBox(height: 50,),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Palette.scaffold),
                        controller: _txtController,
                        validator: (val) => val!.isEmpty ? 'Invalid name' : null,
                        decoration: InputDecoration(
                          label: const Text('Name', style: TextStyle(color: Palette.scaffold, fontWeight: FontWeight.w400),),
                          prefixIcon: const Icon(FontAwesomeIcons.userAlt, size: 20, color: Palette.scaffold,),
                          hintText: "  Name",
                          hintStyle: const TextStyle(color: Palette.scaffold),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Palette.scaffold,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Palette.scaffold,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Palette.nestBlue,
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                loading = true;
                              });
                              updateProfile();
                            }
                          },
                          child: const Text('Update Profile',
                            style: TextStyle(color: Palette.scaffold, fontSize: 18),)),
                    ],
                  ),
                ),
              ],
            ),),
        );
  }
}
