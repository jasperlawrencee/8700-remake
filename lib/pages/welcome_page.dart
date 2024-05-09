// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';
import 'package:jollibee_commerce/pages/admin.dart';
import 'package:jollibee_commerce/pages/menu_page.dart';
import 'package:jollibee_commerce/services/firebase_auth.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: jSecondaryColor,
        backgroundColor: jPrimaryColor,
        title: Row(
          children: [
            SizedBox.square(
              dimension: 50,
              child: Image.asset(jollibeeLogo),
            ),
            Stack(
              children: [
                Text(
                  'Jollibee',
                  style: TextStyle(
                      fontFamily: 'Jellee',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = jTertiaryColor),
                ),
                const Text(
                  'Jollibee',
                  style: TextStyle(
                    fontFamily: 'Jellee',
                    color: jSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: JollyBackground(
        child: isLogin
            ? LoginForm(
                email: emailController,
                password: passwordController,
                onTap: () {
                  setState(() {
                    isLogin = false;
                  });
                },
              )
            : SignupForm(
                username: usernameController,
                email: emailController,
                password: passwordController,
                onTap: () {
                  setState(() {
                    isLogin = true;
                  });
                }),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  Function() onTap;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  SignupForm({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.onTap,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signup() async {
    User? user = await Firebase().createUserWithEmailAndPassword(
      username: widget.username.text,
      email: widget.email.text,
      password: widget.password.text,
    );

    if (user != null) {
      await db.collection('users').doc(user.uid).set({
        'username': widget.username.text,
        'email': widget.email.text,
        'role': 'customer',
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(bottomSnackbar('User Created!'));
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const MenuPage(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: jSecondaryColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jolly Signup!',
              style: TextStyle(
                fontFamily: 'Jellee',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: jTertiaryColor,
              ),
            ),
            Column(
              children: [
                textFormFieldWithIcon(
                    controller: widget.username,
                    hint: 'Username',
                    icon: const Icon(CupertinoIcons.person),
                    isPassword: false),
                const SizedBox(height: defaultPadding),
                textFormFieldWithIcon(
                  controller: widget.email,
                  hint: 'Email',
                  icon: const Icon(CupertinoIcons.mail),
                  isPassword: false,
                ),
                const SizedBox(height: defaultPadding),
                textFormFieldWithIcon(
                  controller: widget.password,
                  hint: 'Password',
                  icon: const Icon(CupertinoIcons.lock),
                  isPassword: true,
                ),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signup();
                      }
                    },
                    child: const Text('Sign Up'))
              ],
            ),
            Column(
              children: [
                const Divider(),
                AlreadyHaveAccountCheck(
                  isLogin: false,
                  onPress: widget.onTap,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Function() onTap;

  LoginForm({
    super.key,
    required this.email,
    required this.password,
    required this.onTap,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User? user = Firebase().currentUser;

  Future<void> login() async {
    try {
      User? user = await Firebase().signInWithEmailAndPassword(
          email: widget.email.text, password: widget.password.text);

      DocumentSnapshot documentSnapshot =
          await db.collection('users').doc(user!.uid).get();

      if (documentSnapshot['email'] == user.email &&
          documentSnapshot['role'] == 'customer' &&
          mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(bottomSnackbar('Logged In!'));
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const MenuPage(),
            ));
      } else if (documentSnapshot['role'] == 'admin' && mounted) {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const AdminPage(),
            ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(bottomSnackbar('Invalid Login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: jSecondaryColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jolly Login!',
              style: TextStyle(
                fontFamily: 'Jellee',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: jTertiaryColor,
              ),
            ),
            Column(
              children: [
                textFormFieldWithIcon(
                  controller: widget.email,
                  hint: 'Email',
                  icon: const Icon(CupertinoIcons.mail),
                  isPassword: false,
                ),
                const SizedBox(height: defaultPadding),
                textFormFieldWithIcon(
                  controller: widget.password,
                  hint: 'Password',
                  icon: const Icon(CupertinoIcons.lock),
                  isPassword: true,
                ),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: const Text('Sign In'))
              ],
            ),
            Column(
              children: [
                const Divider(),
                AlreadyHaveAccountCheck(
                  isLogin: true,
                  onPress: widget.onTap,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
