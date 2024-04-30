import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'dart:math' as math;

import 'package:jollibee_commerce/components/constants.dart';

class JollyBackground extends StatelessWidget {
  final Widget child;
  const JollyBackground({
    Key? key,
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
