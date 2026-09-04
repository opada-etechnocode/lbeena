import 'package:syrians_in_uae/ui/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class SnackBarHelper{

  static mySnackBarError(title,BuildContext context,{behavior,duration}){
    return ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content:
        Text(title,style: TextStyle(color: Colors.white),) ,
          backgroundColor: Colors.red,behavior: behavior,duration: duration??Duration(milliseconds: 1500),
        ),
    );
  }

  static mySnackBarSuccess(title,BuildContext context,{behavior,duration}){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text(title,style: TextStyle(color: Colors.white),) ,
          backgroundColor: Colors.green,behavior: behavior,duration: duration??Duration(milliseconds: 1500),
        ),
    );
  }

  static mySnackBarPending(title,BuildContext context,{behavior,duration}){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text(title,style: TextStyle(color: Colors.black),) ,
          backgroundColor: Colors.yellow,duration: duration??Duration(milliseconds: 1500),
        ));
  }


  // /// flusher error
  // static myFlusherError(title,BuildContext context){
  //   return  Flushbar(
  //     message:  title,
  //     backgroundColor: Colors.red,
  //
  //     duration:  Duration(seconds: 1),
  //   )..show(context);;
  // }
  //
  // /// flusher success
  // static myFlusherSuccess(title,BuildContext context){
  //   return  Flushbar(
  //     message:  title,
  //     backgroundColor: Colors.green,
  //
  //     duration:  Duration(seconds: 1),
  //   )..show(context);;
  // }
}