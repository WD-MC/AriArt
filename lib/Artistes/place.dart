import 'package:flutter/material.dart';

class Place extends StatelessWidget {
  const Place({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Lieux de Ventes"),
      ),
      body: Container(
        child: const Text("Trouver les lieux de ventes des oeuvres", textAlign: TextAlign.center,),
      ),
    );
  }
}