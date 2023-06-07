import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Services"),
      ),
      body: Container(
        child: const Text("obtener des prestations de services", textAlign: TextAlign.center,),
      ),
    );
  }
}