import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset('assets/teams.jpg'),
          ),
          Text(
            '      Teams\n Authentication',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: (){
        final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.login();
            },
            child: Center(
              child: Container(
                height: 50,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey[600],
                ),
                width: MediaQuery.of(context).size.width*0.7,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Icon(
                    
                  FontAwesomeIcons.google,
                  
                  ),
                  Text('Google SignIn', style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
