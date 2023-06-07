import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ariart/pages/visiteur.dart';

class AudionotPlay extends StatelessWidget {
  const AudionotPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding( padding:EdgeInsets.all(20), 
          child:Column(children: [
          const SizedBox(height: 150),

          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset("assets/images/alert.png",
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          
          const SizedBox(height: 30),

          const Text("Veuillez scanner un code Qr AriArt!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 186, 49, 49), 
              fontSize: 17,
            ),
          ),
          
          const SizedBox(height: 10),

          TextButton(
            child: const Text("Lancer le scan à nouveau",
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.push(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const Visiteur()
                )
              );
            },
          ),
          ])
        )
      )
);
  }
}