import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 100),
        child: Column(
          children: <Widget>[
            Image.asset("assets/inkartassets/4.png"),
            //SvgPicture.asset("assets/images/INKART.svg"),

            const SizedBox(height: 40),
            const SpinKitChasingDots(
              color: Color.fromARGB(255, 29, 49, 66),
              size: 40,
            ),
          ],
        )
      ),
    );
  }
}