import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget{

  final bool inSelectMode;
  final VoidCallback onPressed;

  const LeadingButton({Key key, this.inSelectMode=false, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(inSelectMode){
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: onPressed,
      );
    }else{
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: onPressed,
      );
    }
  }

}
