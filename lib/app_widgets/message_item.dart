import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class MessageWidget{

  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message , Color color , BuildContext context){
    final snackBar = SnackBar(
      content: Text(message , style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 13),),
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      action: SnackBarAction(
        textColor: Colors.white,
        label: S.of(context)!.ok,
        onPressed: () {},
      ),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}