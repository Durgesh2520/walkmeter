import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walkmeter_app/screens/home_screen.dart';
import 'package:walkmeter_app/screens/login_screen.dart';
import 'package:walkmeter_app/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(

  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/homeScreen': (context) => HomeScreen(),

      },
      home: LoginScreen(
      ),
    );
  }
}

