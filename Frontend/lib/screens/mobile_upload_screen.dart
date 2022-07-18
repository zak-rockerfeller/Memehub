import 'dart:io';
import 'dart:ui';
import 'package:meme_hub/constants.dart';
import 'package:meme_hub/models/api_response.dart';
import 'package:meme_hub/screens/mobile_home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meme_hub/config/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_hub/services/services.dart';
import 'package:meme_hub/models/models.dart';
import 'package:meme_hub/responsive/widgets.dart';
class MobileUploadPage extends StatefulWidget {
  const MobileUploadPage({Key? key, this.post, this.title}) : super(key: key);

  final Post? post;
  final String? title;

  @override
  State<MobileUploadPage> createState() => _MobileUploadPageState();
}

class _MobileUploadPageState extends State<MobileUploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
  final _picker = ImagePicker();
  File? _imageFile;

  Future getImage() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async{
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image);

    if(response.error == null){
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _editPost(int postId) async{
    ApiResponse response = await editPost(postId, _txtControllerBody.text);

    if(response.error == null){
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if(widget.post != null){
      _txtControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
         //automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Palette.nestBlue),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: false,
          title: Text('${widget.title}', style: const TextStyle(color: Palette.nestBlue, fontSize: 18,),),
        ),
        body: _loading ? const Center(child: CircularProgressIndicator(),) :
        ListView(
          children: [
            widget.post != null ? const SizedBox(height: 40,) :
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 25,
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.2)),
                      image: _imageFile == null ? null : DecorationImage(
                          image: FileImage(_imageFile ?? File('')),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 150,),
                      IconButton(
                        icon: _imageFile != null ? const Icon(null) : const Icon(Icons.cloud_upload, size: 50, color: Palette.scaffold,),
                        onPressed: () {
                          getImage();
                        }
                        ,
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          getImage();
                        },
                        child: _imageFile != null ? const Text('') : const Text('Select image',
                          style: TextStyle(fontSize: 22, color: Palette.scaffold),),
                      ),
                    ],
                  ),
                ),
              ),

            ),
            Form(
              key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(color: Palette.scaffold),
                    controller: _txtControllerBody,
                    keyboardType: TextInputType.multiline,
                      validator: (val) => val!.isEmpty ? 'Caption is required' : null,
                      //maxLines: 9,
                      decoration: InputDecoration(
                        label: const Text('Caption', style: TextStyle(color: Palette.scaffold, fontWeight: FontWeight.w400),),
                        prefixIcon: const Icon(
                          FontAwesomeIcons.facebookMessenger,
                          color: Palette.scaffold,),
                        hintText: "  Caption",
                        hintStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
                        suffixIcon: InkWell(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                _loading = !_loading;
                              });
                              if(widget.post == null){
                                _createPost();
                              } else{
                                _editPost(widget.post!.id ?? 0);
                              }

                            }
                          },
                          child: const Icon(FontAwesomeIcons.paperPlane,
                              color: Palette.scaffold),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Palette.scaffold,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: const BorderSide(
                            color: Palette.scaffold,
                            width: 2.0,
                          ),
                        ),
                      ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
