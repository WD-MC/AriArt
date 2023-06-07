import 'package:flutter/material.dart';

class Boutique extends StatelessWidget {
  const Boutique({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Boutique"),
      ),
      body: Container(
        child: const Text("Acheter vos oeuvres", textAlign: TextAlign.center,),
      ),
    );
  }
}