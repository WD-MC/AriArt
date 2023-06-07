import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  String email='';
  

  //Stocke les données de  l'utilisateur couramment connecté
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> Data() async {
    
    final docRef = await FirebaseFirestore.instance.collection("utilisateurs").where("uid", isEqualTo: user.uid).get();
    
    if (docRef.docs.isNotEmpty ) {
      // On récupère le premier document
      var documentSnapshot = docRef.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();
      
      email = data['email'];
      return email;
      
    }

    return '';
    
  }

  Future<void> _getData() async {
    email = await Data();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {

    // Récupérer l'utilisateur courant
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String email = user.email ?? 'Email inconnu';
      // Afficher l'email de l'utilisateur
      return Container(
        child: Column(
          children: [
            const SizedBox(height: 50),

            const Icon(Icons.account_circle,size:90),

            const SizedBox(height: 20),

            
            Text(email),
            //Text('Email de l\'utilisateur : $email')

          ],
        ),
      );
    } else {
      // Aucun utilisateur connecté
      return const Text('Aucun utilisateur connecté');
    }
    
  }
}

