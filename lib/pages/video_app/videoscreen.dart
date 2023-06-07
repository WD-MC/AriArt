
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VideoScreen extends StatefulWidget {
  final String audioData;

  VideoScreen({required this.audioData});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  String videoUrl = '';
  //String errorMessage = 'Vérifier votre Connexion Internet ! ';

  @override
  void initState(){
    
    _initPlayer();
    super.initState();
  }

  void _initPlayer() async{

    String videoData = widget.audioData;
    print('videoData = $videoData');
    var fileName = videoData.substring(videoData.lastIndexOf('/') + 1);
    print('filiname = $fileName');

    FirebaseFirestore.instance
        .collection('vidéo')
        .where('storagePath', isEqualTo: fileName)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        videoUrl = document.data()['downloadUrl'];
        print('vidéo = $videoUrl');
        setState(() {});
      }
    });
    

    videoPlayerController = VideoPlayerController.network(videoUrl);
    videoPlayerController.initialize();

    
  }

  @override
  void dispose(){
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    videoPlayerController = VideoPlayerController.network(videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      //autoInitialize: true,
      looping: true,
      autoPlay: true,
      aspectRatio: 16/9,
      //allowFullScreen: true,
      //allowPlaybackSpeedChanging: true,
      //allowedScreenSleep: false,
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Text(
             'Vérifier votre Connexion Internet ! ',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        //title: const Text("vidéo")
      ), 
      body: chewieController!=null
      ?Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: 
          Chewie(controller: chewieController!),
          /*Stack(
            children: [
              Chewie(controller: chewieController!),
              if (!videoPlayerController.value.isInitialized) // afficher l'indicateur de chargement si la vidéo est en cours de chargement
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          )*/
      )
      :const Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}