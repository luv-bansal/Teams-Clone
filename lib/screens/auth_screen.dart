import 'package:flutter/material.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: loginButton()),
    );
  }


  Widget loginButton() {
    return FlatButton(
      padding: EdgeInsets.all(35),
      child: Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.white,
        period: Duration(seconds: 3),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
      ),
      onPressed: () {
        final provider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.login();
      },
    );
  }

}
