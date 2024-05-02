// ignore_for_file: must_be_immutable

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
    List<bool> menuValues = List.generate(widget.menuCount, (index) => false);
    return Container(
      margin: const EdgeInsets.all(defaultPadding / 2),
      padding: const EdgeInsets.only(top: defaultPadding),
      decoration: const BoxDecoration(color: jSecondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: IconButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(jPrimaryColor),
                      iconColor: MaterialStatePropertyAll(jSecondaryColor)),
                  onPressed: widget.function,
                  icon: const Icon(Icons.add),
                ),
              )
            ],
          ),
          Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(color: jPrimaryColor),
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
