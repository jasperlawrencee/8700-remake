import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/firebase_options.dart';
import 'package:jollibee_commerce/pages/menu_page.dart';
import 'package:jollibee_commerce/pages/welcome_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jollibee E-Commerce',
      theme: ThemeData(
        fontFamily: "Inter",
        primaryColor: jPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(jPrimaryColor),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: jPrimaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        )),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: jSecondaryColor,
          iconColor: jPrimaryColor,
          prefixIconColor: jPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
              // borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none),
        ),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
