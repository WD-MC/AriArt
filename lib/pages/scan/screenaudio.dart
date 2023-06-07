

import 'dart:ffi';


import 'package:ariart/constant/delaiyed_animation.dart';
import 'package:ariart/pageAuth/mainPageartist.dart';
import 'package:ariart/pageAuth/services/authentification.dart';
import 'package:ariart/pages/Jeux/quizscreen.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ariart/pages/scan/quizscreen.dart';
// import 'package:ariart/pages/scan/quizz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:convert';
import 'dart:io';
// import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:ariart/pages/Scanqr.dart';
import 'package:ariart/pages/scan/audionoplay.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

String _url = 'https://fr.wikipedia.org/wiki/Arielle_Kitio_Tsamo';


class AudioListen extends StatefulWidget {
  
  final String audioData;

  const AudioListen({Key? key, required this.audioData}) : super(key: key);

  @override
  State<AudioListen> createState() => _AudioListenState();
}

class _AudioListenState extends State<AudioListen> {

 
  AudioPlayer audioPlayer = AudioPlayer();

  final AuthenticationService _auth = AuthenticationService();

  late PlayerState audioPlayerState;
  PlayerState state = PlayerState.STOPPED;

  Duration duration = const Duration();
  Duration position = const Duration();
  

  bool play = true;
  bool pause = false;
  bool stop = false;

  //afficher le message de chargement
  bool audioLoading = false;
  // vérifier si l'audio est lancé
  bool isPlaying = false;
  //vérifier l'etat de la connexion
  bool isConnected = true;

  static const iconSize = 35.0;
  // vérifie l'état du téléchargement
  bool isDownloading = false;

  //vérifi si l'utilisateur est connecté
  bool connect = false;
  //pour gérer les versions
  bool limite = false;

  final user = FirebaseAuth.instance.currentUser;

  


  @override
  void initState(){
    super.initState();

    // Appeler la méthode pour vérifier l'état de la connexion Internet
    checkConnectivity(); 
    audioPlayer.onAudioPositionChanged.listen((Duration newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    isPlaying = false;
    if (user == null ) {
      connect = false;
    }else{
      connect = true;
    }
    limite = false;

  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }



  void downloadFile(Reference ref, urlAudio) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        
        // User is not authenticated, show appropriate message or redirect to login page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez vous connectez pour télécharger le fichier audio'),
          ),
        );
        return;
      }

      // Vérifier si l'application a accès au répertoire de téléchargement
      var status = await Permission.storage.status;

      if (!status.isGranted) {
        await Permission.storage.request();
        status = await Permission.storage.status;
      }
      
      
      if (status.isGranted) {
        final userDoc = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(user.uid)
          .get();

        if (userDoc.exists) {
          final downloadCount = userDoc.get('nombreTelechargement');
          final download = userDoc.get('telechargement');
          
          if (downloadCount == 0) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('passer à la version pro'),
            //   ),
            // );
            setState(() {
              limite = true;
            });
            ResetDownload(user.uid);
            versionProInfo(context, limite);
          }
          if(downloadCount != 0){
            setState(() {
              limite = false;
            });
            versionProInfo(context, limite);
            // Obtenir le nom du fichier à partir de l'URL
            final fileName = ref.name;
            print (fileName);
            setState(() {
              isDownloading = true;
            });

            // Téléchargement du fichier
            final directory = Directory("/storage/emulated/0/Download/AriArt");
            await directory.create(recursive: true);

            // Téléchargement du fichier
            // final externalDir = await getExternalStorageDirectory();
            // final saveDir = externalDir!.path + "/Download/$fileName";
            final saveDir = "/storage/emulated/0/Download/AriArt/$fileName";

            final dio = Dio();
            await dio.download(urlAudio, saveDir).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Téléchargement terminé'),
                ),
              );
              
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors du téléchargement'),
                ),
              );
            }).whenComplete(() {
              setState(() {
                isDownloading = false;
              });
              addDownload(user.uid, download, downloadCount);
            });
            
            print("Fichier téléchargé : $saveDir");
          }
        } else {
          print('User document does not exist');
        }
        
      } else {
        // Afficher un message d'erreur si l'accès au répertoire de téléchargement est refusé
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'accès au répertoire de téléchargement est refusé'),
          ),
        );
      }
    } 
    catch (e) {
      // Afficher un message d'erreur en cas d'erreur lors du téléchargement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur s\'est produite lors du téléchargement'),
        ),
      );
    }
  }

  //methode qui permet de gérer les téléchargements
  void addDownload(String docID, int Ndownload, int Odownload){
    final newDownload = Ndownload +1;
    final oldDownload = Odownload -1;
    try {
      FirebaseFirestore.instance.collection('utilisateurs').doc(docID).update({
        'telechargement':newDownload,
        'nombreTelechargement':oldDownload,
      }).then((value) => print('données à jour'));
    } catch (e) {
      print(e.toString());
    }
  }

  //methode qui permet de reset téléchargement
  void ResetDownload(String docID){
    int newDownload = 0;
    try {
      FirebaseFirestore.instance.collection('utilisateurs').doc(docID).update({
        'telechargement':newDownload,
      }).then((value) => print('données à jour'));
    } catch (e) {
      print(e.toString());
    }
  }

  // showDialog de la version
  void versionProInfo(BuildContext context, bool limite)async{
    showDialog(context: context, builder: (BuildContext context){
      return DelayedAnimation1(
        delay: 1500, 
        child:SimpleDialog(
          contentPadding: EdgeInsets.zero,
          
          children: [
            Container(
              height: 185,
              width: 370,
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.center,

              child: Column(children: [
                
                // Image.asset("assets/images/Check.png", height: 75,),
                Text("Passer à la version PRO",
                textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    color: const Color.fromARGB(255, 44, 50, 80),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                !limite
                ?const Text("Vous avez un nombre limite de 5 téléchargement dans la version gratuite de l'application",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 15
                  ),
                )
                :const Text("Vous avez dépassez votre nombre limite de 5 téléchargements dans la version gratuite de l'application",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Passer à la version PRO pour retirer les limites",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size.fromHeight(50),
                        backgroundColor:(const Color.fromARGB(255, 177, 23, 23)),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text("Annuler",
                          style: TextStyle(fontSize: 15),
                        )
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // minimumSize: const Size.fromHeight(50),
                        backgroundColor:(const Color.fromARGB(255, 217, 96, 21)),
                      ),
                      onPressed: (){
                        
                      }, 
                      child: const Text("PASSER EN PRO",
                          style: TextStyle(fontSize: 15),
                        )
                    ),
                  ],
                ),
              ],)
              
              
            ),
          ],
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var audioData = widget.audioData;

    var titre = audioData.substring(audioData.lastIndexOf('/') + 1);
    List<String>  parts = titre.split(".");
    String nom = parts[0];

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('audio/$titre');
    

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
    
      child: Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),

        leading: 
          
           IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color:Color.fromARGB(255, 239, 233, 233),
            ),
            onPressed: (){
              audioPlayer.stop();
              Navigator.push(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const Visiteur(),
                )
              );
            },
          ),

        actions: [
          !connect
          ?TextButton(
            onPressed: (){
                
                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const MainPageVisiteur(),
                  )
                );
              
            }, 
            child:const 
              Text("Connexion",
                style: TextStyle(
               
                color:  Color.fromARGB(255, 255, 255, 255),
              ),
            )
          )
          :TextButton(
            
            onPressed: ()async{
              await _auth.signOut();
              setState(() {
                connect = false;
              });           
            }, 
            child:const 
              Text("Déconnexion",
                style: TextStyle(
               
                color:  Color.fromARGB(255, 255, 255, 255),
              ),
            )
          ),
        ],

      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
            child:SingleChildScrollView(
              child: Card(
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    LoadImage(titre: titre),
                    
                    const SizedBox(height: 10),
                    Text(nom,
                      style: GoogleFonts.aBeeZee(
                        color: const Color.fromARGB(255, 44, 50, 80),
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                    
                    // LaunchUrl(titre: titre),
                     
                    Visibility(
                      visible: audioLoading, // Afficher le widget seulement lorsque audioLoading est vrai
                      child: const Text('Chargement de l\'audio...'),
                    ),
                    Visibility(
                      visible: !isConnected, // Afficher le widget seulement lorsque isConnected est faux (mauvaise connexion)
                      child: const Text(
                        'Veuillez vérifier votre connexion Internet',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Visibility(
                      visible: isPlaying, // Afficher le widget seulement lorsque isPlaying est vrai
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}', // Formatage du temps de lecture (minutes:secondes)
                          ),
                          const Text(' / '),
                          Text(
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}', // Formatage du temps total de l'audio (minutes:secondes)
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          seekToSecond(value.toInt());
                          value = value;
                        });
                      }
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        !play
                        ?const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.grey,
                            size: iconSize,
                          ),
                        )
                        :IconButton(
                          icon: const Icon(Icons.play_arrow,
                            size: iconSize,
                            color:Colors.green,
                          ),
                          onPressed: () async {

                            setState(() {
                              audioLoading = true; // Mettre à jour l'état du chargement de l'audio
                            });

                            await _playAudio(audioData);

                            // setState(() {
                            //   audioLoading = false; // Mettre à jour l'état du chargement de l'audio lorsque l'audio commence à jouer
                            // });

                            play = false;
                            pause = true;
                            stop = true;


                          },
                        ),

                        !pause
                        ?const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.pause,
                            color: Colors.grey,
                            size: iconSize,
                          ),
                        )
                        :IconButton(
                          icon: const Icon(Icons.pause,
                            size: iconSize,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            audioPlayer.pause();
                            pause = false;
                            play = true;
                            stop = true;
                          },
                        ),

                        !stop
                        ?const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.stop,
                            color: Colors.grey,
                            size: iconSize,
                          ),
                        )
                        :IconButton(
                          icon: const Icon(Icons.stop,
                            size: iconSize,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            audioPlayer.stop();
                            setState(() {
                              position = const Duration();
                            });
                            stop = false;
                            play = true;
                            pause = false;
                          },
                        ),

                        
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (isDownloading)
                      Column(
                        children: const [
                          LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          Text("Téchargement en cours..."),
                        ],
                      ),
                      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton( 
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size.fromHeight(50),
                            backgroundColor:(const Color.fromARGB(255, 241, 87, 11)),
                          ),
                          onPressed: ()async{
                            final urlAudio = await reference.getDownloadURL();
                            downloadFile(reference, urlAudio);
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/download.gif", height: 18,width: 18,),
                              const SizedBox(width: 5),
                              const Text(
                                "Télécharger",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // minimumSize: const Size.fromHeight(50),
                            backgroundColor:(const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          onPressed: (){
                            Navigator.push(context, 
                              PageRouteBuilder(pageBuilder: (_, __, ___) => const QuizScreen() )
                            );
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.explore, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "Aller à la découverte",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            )
          ),
        )
        
      )
    );

    
  }

  Future<void> _playAudio(audioData) async {

    var fichierAudio = audioData.substring(audioData.lastIndexOf('/') + 1);
    
    final docRef = await FirebaseFirestore.instance.collection("audio").where("storagePath", isEqualTo: 'audio/$fichierAudio').get();
    
    final docRef1 = await FirebaseFirestore.instance.collection("audio").where("storagePath", isEqualTo: fichierAudio).get();
    
    if (docRef.docs.isNotEmpty ) {
      // On récupère le premier document
      var documentSnapshot = docRef.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();
      
      String audioURL = data['downloadUrl'];

      await audioPlayer.play(audioURL);
      
    }else if(docRef1.docs.isNotEmpty){

      var documentSnapshot = docRef1.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();
      
      String audioURL = data['downloadUrl'];
      await audioPlayer.play(audioURL);
      setState(() {
        audioLoading = false;
        isPlaying = true;
      });

    }else {
      
      NoPlay();
    }
    
  }

  void NoPlay(){
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AudionotPlay()
      )
    );
  }
  
}




class LoadImage extends StatefulWidget {
  
  final String titre;

  const LoadImage({Key? key, required this.titre}) : super(key: key);

  @override
  State<LoadImage> createState() => _LoadImageState();
}

class _LoadImageState extends State<LoadImage> {
  


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            
            child:
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/icons8-dots-loading.gif',
              image: snapshot.data!,
              height: 600,
              width: 400,
              fit: BoxFit.cover,
              placeholderFit: BoxFit.none,
            ) 
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _getImageUrl() async {
    final docRef = await FirebaseFirestore.instance
        .collection("audio")
        .where("storagePath", isEqualTo: widget.titre)
        .get();

    if (docRef.docs.isNotEmpty) {
      // On récupère le premier document
      var documentSnapshot = docRef.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();

      String imageUrl = data['imageUrl'];

      return imageUrl;
    }

    return '';
  }

  

}


// class LaunchUrl extends StatefulWidget {
  
//   final String titre;

//   const LaunchUrl({Key? key, required this.titre}) : super(key: key);

//   @override
//   State<LaunchUrl> createState() => _LaunchUrlState();
// }

// class _LaunchUrlState extends State<LaunchUrl> {


//   @override
//   Widget build(BuildContext context) {
//     String title = widget.titre;
//     String nameWithoutExtension = title.split(".")[0];
//     return FutureBuilder(
//       future: _getLink(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
          
//           return Column(
//             children: [
//               const Text("Pour en savoir plus sur",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                   fontSize: 20
//                 ),
//               ),
//               Text(nameWithoutExtension,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
              
//               TextButton(
//                 onPressed: ()async{
//                   _url = snapshot.data!;
                  
//                   if (!await launchUrlString(_url)) throw 'Could not launch $_url';
//                 },
                
//                 child: const Text('Cliquez ici',
//                 textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 241, 87, 11),
//                     fontSize: 20
//                   ),
//                 ),
//               ),

              
//             ],
//           );
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }

//   Future<String> _getLink() async {
//     final docRef = await FirebaseFirestore.instance
//         .collection("audio")
//         .where("storagePath", isEqualTo: widget.titre)
//         .get();

//     if (docRef.docs.isNotEmpty) {
//       // On récupère le premier document
//       var documentSnapshot = docRef.docs[0];

//       // On récupère les données du document sous forme de Map<String, dynamic>
//       var data = documentSnapshot.data();

//       String linkUrl = data['link'];
//       return linkUrl;
//     }

//     return '';
//   }

  

// }







