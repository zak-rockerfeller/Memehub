import 'dart:convert';
import 'dart:io';
import 'package:meme_hub/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meme_hub/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

  //Sign In
  Future<ApiResponse> login (String email, String password) async{
    ApiResponse apiResponse = ApiResponse();
    try{
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password}
      );


      switch(response.statusCode){
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          break;

        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;

        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  //Sign Out
  Future<ApiResponse> register (String name, String email, String password) async{
    ApiResponse apiResponse = ApiResponse();
    try{
      final response = await http.post(
          Uri.parse(registerUrl),
          headers: {'Accept': 'application/json'},
          body: {
            'name': name,
            'email': email,
            'password': password,
            'password_confirmation': password,

          }
      );


      switch(response.statusCode){
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          break;

        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;

        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  //Get User Details
  Future<ApiResponse> getUserDetail () async{
    ApiResponse apiResponse = ApiResponse();
    try{
        String token = await getToken();
        final response = await http.get(
          Uri.parse(userUrl),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      switch(response.statusCode){
        case 200:
          apiResponse.data = User.fromJson(jsonDecode(response.body));
          break;

        case 401:
          apiResponse.error = unauthorized;
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  //Update User
  Future<ApiResponse> updateUser (String name, String? image) async{
    ApiResponse apiResponse = ApiResponse();
    try{
      String token = await getToken();
      final response = await http.put(Uri.parse(userUrl),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'},
          //if response doesn't contain an image,
          body: image == null ? {'name': name,} : //else
          {'name': name, 'image': image});

      //User can update his/her name and image
      switch(response.statusCode){
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;

        case 401:
          apiResponse.error = unauthorized;
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    }
    catch(e){
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  //Get user token details
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  //Get user id
  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('userId') ?? 0;
  }


  //Logout
  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.remove('token');
  }

  //Get base64 encoded image
  String? getStringImage(File? file){
    if(file == null) return null ;
    return base64Encode(file.readAsBytesSync());
  }