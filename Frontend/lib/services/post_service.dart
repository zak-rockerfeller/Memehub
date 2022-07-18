import 'dart:convert';
import 'package:meme_hub/models/models.dart';
import 'package:meme_hub/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:meme_hub/constants.dart';


Future<ApiResponse> getPosts () async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse(postsUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((k) => Post.fromJson(k)).toList();
        apiResponse.data as List<dynamic>;
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

Future<ApiResponse> createPost (String body, String? image) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(Uri.parse(postsUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'},

        body: image != null ? {
          'body': body,
          'image': image } : {
          'body': body
        });

     //here if the image is null we just send the body, if not null we send the image too
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

Future<ApiResponse> editPost(int postId, String body) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.put(Uri.parse('$postsUrl/$postId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'},
    body: {
      'body': body
    });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;

      case 403:
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

Future<ApiResponse> deletePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.delete(Uri.parse('$postsUrl/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'});

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;

      case 403:
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

Future<ApiResponse> likeUnlikePost (int postId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsUrl/$postId/likes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

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