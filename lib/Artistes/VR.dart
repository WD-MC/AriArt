import 'package:flutter/material.dart';

class VisitVr extends StatelessWidget {
  const VisitVr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Visite Virtuelle"),
      ),
      body: Container(
        child: const Text("Effectuer des visites virtuelles", textAlign: TextAlign.center,),
      ),
    );
  }
}