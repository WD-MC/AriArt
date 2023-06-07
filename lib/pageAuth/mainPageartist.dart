import 'package:flutter/material.dart';
import 'package:ariart/pageAuth/services/authentification.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ariart/pageAuth/liaisonAuth.dart';
import 'package:ariart/pageAuth/models/user.dart';
import 'package:ariart/pageAuth/screensAuthenticate.dart';
import 'package:ariart/pages/artistes.dart';
import 'package:provider/provider.dart';
import 'package:ariart/pageAuth/splashscreen_wrapper.dart';

// class pour l'affiche de la page artiste s'il est connecté 

class MainPageArtist extends StatelessWidget {
  const MainPageArtist({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user, 
      initialData: null,
      child: const MaterialApp(home:  SplashScreenWrapper(),)
    );
  }
}

class MainPageVisiteur extends StatelessWidget {
  const MainPageVisiteur({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user, 
      initialData: null,
      child: const MaterialApp(home:  SplashScreenWrapperVisit(),)
    );
  }
}
