
import 'package:ariart/pages/Jeux/quizscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


String _url = 'https://fr.wikipedia.org/wiki/Arielle_Kitio_Tsamo';


class LaunchScreen extends StatefulWidget {

  final String audioData;
  const LaunchScreen({super.key, required this.audioData});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    var audioData = widget.audioData;


    var titre = audioData.substring(audioData.lastIndexOf('/') + 1);

    return Scaffold(
      appBar: AppBar(
        
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),

          leading: 
            
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color:Color.fromARGB(255, 239, 233, 233),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

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
                    LaunchUrl(titre: titre),
                    const SizedBox(height: 10),

                    const Text("Amuse toi et découvre plus sur les TIC",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 9, 9),
                        fontSize: 16
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        
                        Image.asset("assets/images/right-arrow.gif", height: 50,width: 50,),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, 
                              PageRouteBuilder(pageBuilder: (_, __, ___) => const QuizScreen())
                            );
                          },
                          
                          child: const Text('Cliquez ici',
                          textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 241, 87, 11),
                              fontSize: 20
                            ),
                          ),
                        ),
                      ],
                    )
                  ]
                )
              )
            )
          )
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
        .collection("infosEntrepreneur")
        .where("storagePath", isEqualTo: widget.titre)
        .get();

    if (docRef.docs.isNotEmpty) {
      // On récupère le premier document
      var documentSnapshot = docRef.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();

      String imageUrl = data['downloadUrl'];

      return imageUrl;
    }

    return '';
  }

  

}


class LaunchUrl extends StatefulWidget {
  
  final String titre;

  const LaunchUrl({Key? key, required this.titre}) : super(key: key);

  @override
  State<LaunchUrl> createState() => _LaunchUrlState();
}

class _LaunchUrlState extends State<LaunchUrl> {


  @override
  Widget build(BuildContext context) {
    String title = widget.titre;
    String nameWithoutExtension = title.split(".")[0];
    return FutureBuilder(
      future: _getLink(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          
          return Column(
            children: [
              const Text("Pour en savoir plus sur",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 20
                ),
              ),
              Text(nameWithoutExtension,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              TextButton(
                onPressed: ()async{
                  _url = snapshot.data!;
                  
                  if (!await launchUrlString(_url)) throw 'Could not launch $_url';
                },
                
                child: const Text('Cliquez ici',
                textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 241, 87, 11),
                    fontSize: 20
                  ),
                ),
              ),

              
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _getLink() async {
    final docRef = await FirebaseFirestore.instance
        .collection("infosEntrepreneur")
        .where("storagePath", isEqualTo: widget.titre)
        .get();

    if (docRef.docs.isNotEmpty) {
      // On récupère le premier document
      var documentSnapshot = docRef.docs[0];

      // On récupère les données du document sous forme de Map<String, dynamic>
      var data = documentSnapshot.data();

      String linkUrl = data['link'];
      return linkUrl;
    }

    return '';
  }

}