import 'dart:async';

import 'package:flutter/material.dart';

class DisappearingText extends StatefulWidget {
  final String text;

  DisappearingText({required this.text});

  @override
  _DisappearingTextState createState() => _DisappearingTextState();
}

class _DisappearingTextState extends State<DisappearingText> {
  bool _showText = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _showText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showText 
    ?Text(widget.text,
      style: const TextStyle(
        color: Colors.green,
        fontSize: 32
      ),
    ) 
    : Container();
  }
  
}