import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'auth_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);

            if (provider.isSigningIn) {
              return buildLoading();
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      Center(child: CircularProgressIndicator()),
    ],
  );
}
