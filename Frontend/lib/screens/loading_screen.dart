import 'package:meme_hub/constants.dart';
import 'package:meme_hub/models/api_response.dart';
import 'package:meme_hub/services/services.dart';
import 'package:flutter/material.dart';
import 'package:meme_hub/screens/screens.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  
  void _loadUserInfo() async{
    String token = await getToken();
    if(token == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
    }
    else{
      ApiResponse response = await getUserDetail();
      if(response.error == null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const ResponsiveLoginPage()), (route) => false);
      }
      else if(response.error == unauthorized){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}'),));
      }
    }

  }
  @override
  void initState(){
    _loadUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
