
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ariart/pageAuth/services/authentification.dart';
import 'package:ariart/pages/linkscreen/LinkScreen.dart';
import 'package:ariart/pages/video_app/videoscreen.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:ariart/pages/scan/screenaudio.dart';
import 'package:ariart/pages/scan/audionoplay.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';



class ScanQrDownload extends StatefulWidget {
  const ScanQrDownload({super.key});

  @override
  _ScanQrDownloadState createState() => _ScanQrDownloadState();
}

class _ScanQrDownloadState extends State<ScanQrDownload> {

  String audioData = "";

  AudioPlayer audioPlayer = AudioPlayer();

  final AuthenticationService _auth = AuthenticationService();
   

  @override
  Widget build(BuildContext context) {

    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        leading: 
          
           IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color:Color.fromARGB(255, 239, 233, 233),
            ),
            onPressed: (){
              Navigator.push(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const Visiteur(),
                )
              );
            },
          ),
      ),
      
      body: SingleChildScrollView(
        child: Center(
          child: 
          currentWidth<650
          ?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              const SizedBox(height: 90),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset("assets/inkartassets/scan2.png",
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),
              const Text("Branchez vos écouteurs!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 230, 115, 57), fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),
              const Text("Et découvrez plus de détails",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 45, 48, 85), fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),
            
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor:(const Color.fromARGB(255, 0, 0, 0)),
                  padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                ),
                child: const Text("Scan QR Code",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () async {
                  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Cancel", true, ScanMode.QR);
                  setState(() {
                    audioData = barcodeScanRes;
                    //print('audio = $audioData');
                    if (audioData.endsWith('.mp3')) {

                      getAudio(audioData);
                    }
                    if (audioData.endsWith('.mp4')) {
                      
                      getVideo(audioData);
                    }
                    if(audioData.endsWith('.PNG')){

                      getLien(audioData);
                    } 

                  });
                },
              ),
            ],
          )
          :Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              const SizedBox(height: 140),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset("assets/inkartassets/scan2.png",
                  height: 700,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),
              const Text("Branchez vos écouteurs!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 230, 115, 57), fontSize: 30,
                ),
              ),

              const SizedBox(height: 30),
              const Text("Et découvrez plus de détails",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 45, 48, 85), fontSize: 20,
                ),
              ),

              const SizedBox(height: 70),
            
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor:(const Color.fromARGB(255, 0, 0, 0)),
                  padding: const EdgeInsets.only(top: 10,bottom: 10,right: 50,left: 50)
                ),
                child: const Text("Scan QR Code",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () async {
                  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Cancel", true, ScanMode.QR);
                  setState(() {
                    audioData = barcodeScanRes;
                    //print(audioData);
                    if (audioData.endsWith('.mp3')) {

                      getAudio(audioData);
                    }
                    if (audioData.endsWith('.mp4')) {
                      
                      getVideo(audioData);
                    }
                    if(audioData.endsWith('.PNG')){

                      getLien(audioData);
                    }
                  });
                },
              ),

            ],
          ),
        )
      ),
    );
  }

  void getAudio(String audioData)async{
    var fileName = audioData.substring(audioData.lastIndexOf('/') + 1);

    final docRef = await FirebaseFirestore.instance
        .collection("audio")
        .where("storagePath", isEqualTo: fileName)
        .get();
    if (docRef.docs.isNotEmpty) {
      
      playAudio();

    }
    else{
      NoPlay();
    }
  }

  void getVideo(String audioData)async{
    var fileName = audioData.substring(audioData.lastIndexOf('/') + 1);

    final docRef = await FirebaseFirestore.instance
        .collection("vidéo")
        .where("storagePath", isEqualTo: fileName)
        .get();
    if (docRef.docs.isNotEmpty) {
      
      playVideo();

    }
    else{
      NoPlay();
    }
  }

  void getLien (String audioData) async{
    var fileName = audioData.substring(audioData.lastIndexOf('/')+1);

    final docref = await FirebaseFirestore.instance.collection("infosEntrepreneur")
    .where("storagePath", isEqualTo: fileName)
    .get();

    if (docref.docs.isNotEmpty) {

      launchLien();
      
    }
    else{
      NoPlay();
    }
  }

  void playAudio(){
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AudioListen(audioData: audioData)
      )
    ); 
  }

  void playVideo(){
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => VideoScreen(audioData: audioData)
      )
    ); 
  }

  void NoPlay(){
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AudionotPlay()
      )
    );
  }

  void launchLien(){
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LaunchScreen(audioData: audioData)
      )
    );
  }

  
}


