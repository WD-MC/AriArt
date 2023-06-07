import 'package:flutter/material.dart';

class Version extends StatelessWidget {
  const Version({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("version"),
      ),
      body: const Text("changer de version"),
    );
  }
}