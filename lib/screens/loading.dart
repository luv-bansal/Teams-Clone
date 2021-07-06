import 'package:flutter/material.dart';
import 'package:teams_clone/utils/utilities.dart';

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        CircularProgressIndicator(color: color,),
      ],
    );
  }
}