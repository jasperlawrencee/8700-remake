// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollibee_commerce/components/constants.dart';

class JollyBackground extends StatelessWidget {
  final Widget child;
  const JollyBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.black12,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  height: 5,
                  width: 5,
                  'assets/icons/haha.png',
                  color: Colors.grey,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              SafeArea(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuContainer extends StatefulWidget {
  num price;
  String name;
  Function() function;
  int menuCount;

  MenuContainer({
    super.key,
    required this.price,
    required this.name,
    required this.function,
    required this.menuCount,
  });

  @override
  State<MenuContainer> createState() => _MenuContainerState();
}

class _MenuContainerState extends State<MenuContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(defaultPadding / 2),
      padding: const EdgeInsets.only(top: defaultPadding),
      decoration: const BoxDecoration(
          color: jSecondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: defaultPadding),
                  child: InkWell(
                    onTap: widget.function,
                    child: const Icon(
                      CupertinoIcons.add,
                      color: jPrimaryColor,
                    ),
                  ))
            ],
          ),
          Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                  color: jPrimaryColor,
                  borderRadius: BorderRadiusDirectional.vertical(
                      bottom: Radius.circular(4))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        color: jSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    "PHP ${widget.price.toStringAsFixed(2)}",
                    style: const TextStyle(color: jSecondaryColor),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

Widget textField(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(hintText: hint),
  );
}

class AlreadyHaveAccountCheck extends StatelessWidget {
  bool isLogin;
  final Function()? onPress;

  AlreadyHaveAccountCheck({
    Key? key,
    required this.isLogin,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLogin ? "Don't have an account?" : "Already have an account?",
          style: const TextStyle(color: jTertiaryColor),
        ),
        const SizedBox(width: defaultPadding),
        InkWell(
          onTap: onPress as void Function(),
          child: Text(
            isLogin ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: jPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
