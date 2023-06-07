import 'package:flutter/material.dart';



class ArProject extends StatelessWidget {
  const ArProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("AR Projection"),
      ),
      body: const Text("Projeter les oeuvres dans votre maison", textAlign: TextAlign.center,),
    );
  }
}