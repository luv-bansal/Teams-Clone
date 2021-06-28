import 'package:flutter/material.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';
import 'screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teams Clone',
        theme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: Builder(
            builder: (context) => Wrapper(),
        ),
      ),
    );
  }
}
