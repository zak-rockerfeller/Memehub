import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const baseUrl = 'https://www.nest-keja.com/MH/Memehub/public/api';
const loginUrl = baseUrl + '/login';
const registerUrl = baseUrl + '/register';
const logoutUrl = baseUrl + '/logout';
const userUrl = baseUrl + '/user';
const postsUrl = baseUrl + '/posts';
const commentsUrl = baseUrl + '/comments';

///---------Errors---------////
const serverError = "Server error";
const unauthorized = "Unauthorized";
const somethingWentWrong = "Something went wrong, try again";


//Lick and comment button
//Lick the like button lol ;)
Expanded likeAndComment(int value, IconData icon, Color color, Function onTap){
  return Expanded(
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        color: Colors.grey[300],
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16,),
                const SizedBox(width: 4,),
                Text('$value'),
              ],
            ),
          ),
        ),
      ));
}

