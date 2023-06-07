import 'package:flutter/material.dart';
import 'package:ariart/pageAuth/connexion.dart';
import 'package:ariart/pageAuth/inscription.dart';

class LiaisonPageAuth extends StatefulWidget {
  const LiaisonPageAuth({super.key});



  @override
  State<LiaisonPageAuth> createState() => _LiaisonPageAuthState();
}

class _LiaisonPageAuthState extends State<LiaisonPageAuth> {

  bool affichePageConnexion = true;

  void basculation(){
    setState(() => affichePageConnexion = !affichePageConnexion);
  }
  @override
  Widget build(BuildContext context) {
    if (affichePageConnexion) {
      return Login(basculation: basculation);
    }else{
      return Register(basculation: basculation);
    }
  }
}