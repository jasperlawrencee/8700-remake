import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:jollibee_commerce/components/constants.dart';
import 'package:jollibee_commerce/components/widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String jollibeeLogo = 'assets/logo/jollibee-logo.png';
  int count = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: double.infinity,
        decoration: const BoxDecoration(color: jSecondaryColor),
        padding: const EdgeInsets.all(defaultPadding),
        margin: const EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.black,
                )),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: count,
                      itemBuilder: (context, index) {
                        return Text('$index');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
