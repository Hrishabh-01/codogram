import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils {

  static double averageRating(List<int> rating){
    if (rating.isEmpty) return 0.0; // Avoid division by zero
    double avgRating = rating.reduce((a, b) => a + b) / rating.length;
    return double.parse(avgRating.toStringAsFixed(1));
  }
  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        // backgroundColor: Colors.redAccent
        fontSize: 30);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          padding: const EdgeInsets.all(8),
          messageText: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis, // Avoid overflow
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          title: "Error",
          backgroundColor: Colors.redAccent,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 10,
          icon: const Icon(Icons.error,size: 24,color: Colors.white,),
        )..show(context));
  }

  static snackBar(String message,BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content:Text(message))
    );
  }

  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
