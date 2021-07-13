import 'package:flutter/material.dart';
import 'package:teams_clone/screens/onboarding_screen.dart';
import 'package:teams_clone/screens/wrapper.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'package:teams_clone/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:teams_clone/utils/calendar_clients.dart';
// import 'package:teams_clone/utils/secrete.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/calendar/v3.dart' as cal;


int? isviewed;

// root of application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // On-board screen on first time
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
providers: [
  ChangeNotifierProvider(create: (_) => EventProvider()),
  ChangeNotifierProvider(create: (_) => GoogleSignInProvider())
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teams Clone',
        theme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: Builder(
            builder: (context) => isviewed !=0 ? OnBoardingScreen() : Wrapper(),
        ),
      ),
    );
  }
}
