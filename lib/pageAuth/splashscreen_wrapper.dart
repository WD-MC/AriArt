
import 'package:ariart/pages/ScanqrAuth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ariart/pageAuth/screensAuthenticate.dart';
import 'package:ariart/pages/artistes.dart';
import 'package:provider/provider.dart';
import 'package:ariart/pageAuth/models/user.dart';
import 'package:flutter/material.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const AuthenticateScreen();
    } else{
      return const Artistes();
    }
  }
}

class SplashScreenWrapperVisit extends StatelessWidget {
  const SplashScreenWrapperVisit({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const AuthenticateScreen();
    } else{
      return const ScanQrDownload();
    }
  }
}