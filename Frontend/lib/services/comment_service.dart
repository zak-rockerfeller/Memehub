import 'dart:convert';
import 'package:meme_hub/models/models.dart';
import 'package:meme_hub/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:meme_hub/constants.dart';

Future<ApiResponse> getComments(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(Uri.parse('$postsUrl/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'});

    switch(response.statusCode){
      case 200:
        //Map each comments to comment model
        apiResponse.data = jsonDecode(response.body)['comments'].map((k) => Comment.fromJson(k)).toList();
        apiResponse.data as List<dynamic>;
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

Future<ApiResponse> createComments(int postId, String? comment) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsUrl/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'},

        body:{
          'comment': comment
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
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

Future<ApiResponse> deleteComment(int commentId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.delete(Uri.parse('$commentsUrl/$commentId'),
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

Future<ApiResponse> editComment(int commentId, String comment) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.put(Uri.parse('$commentsUrl/$commentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'},
        body: {
          'comment': comment
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












