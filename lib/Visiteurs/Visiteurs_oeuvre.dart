import 'dart:io';

// import 'package:ariart/pages/visiteur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ariart/Visiteurs/plusdedetail.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:ariart/Visiteurs/api/pdf_api.dart';

class Movie {
  // final String name;
  final String id;
  final String image;
  final String titre;
  final String categorie;
  final String auteur;
  final String type;

  // Movie({required this.name, required this.image});
  Movie({
    required this.id, required this.titre, required this.image, required this.categorie,
    required this.auteur, required this.type
  });
}

// class qui permet de recupérer les données pour visiteurs et les afficher

class VisiteurOeuvre extends StatefulWidget {
  const VisiteurOeuvre({super.key});

  @override
  State<VisiteurOeuvre> createState() => _VisiteurOeuvreState();
}

class _VisiteurOeuvreState extends State<VisiteurOeuvre> {

  // creer le constructeur de la classe
  _VisiteurOeuvre(){
    _selectedVal = _productSizesList[0];
  }

  // variables
  final _productSizesList= [
    "Toutes les catégories",
    "Peinture", 
    "Illustrations", 
    "Dessin murale", 
    "Peinture abstraite", 
    "Décoration d'intérieur", 
    "Fashion et design de mode", 
    "Design d'objets et mobiliers", 
    "Design fer forge"
  ];
  
  String? _selectedVal = "Toutes les catégories";

  Future<List<Movie>> getMovies(String category) async {

    final movies = <Movie>[];
    if (category == "Toutes les catégories") {

      final moviesSnapshot = await FirebaseFirestore.instance
      .collection('Publications')
      .where('categorie', isEqualTo: "oeuvre")
      .get();

      for (var doc in moviesSnapshot.docs) {
        final movieData = doc.data();
        final movieImage = movieData['poster'];
        final movieTitre = movieData['name'];
        final movieCategorie = movieData['categorie'];
        final movieType = movieData['type'];
        final movieAuteur = movieData['auteur'];
        final movieId = doc.id;
        final movie = Movie(id: movieId, titre:movieTitre, image: movieImage,categorie:movieCategorie,
        auteur: movieAuteur, type:movieType);
        movies.add(movie);
      }

    } else 
    {
      
      final moviesSnapshot = await FirebaseFirestore.instance
      .collection('Publications')
      .where('categorie', isEqualTo: "oeuvre")
      .where('type', isEqualTo: category)
      .get();

      for (var doc in moviesSnapshot.docs) {
        final movieData = doc.data();
        final movieImage = movieData['poster'];
        final movieTitre = movieData['name'];
        final movieAuteur = movieData['auteur'];
        final movieCategorie = movieData['categorie'];
        final movieType = movieData['type'];
        final movieId = doc.id;
        final movie = Movie(id: movieId, titre:movieTitre, image: movieImage,categorie:movieCategorie,
        auteur: movieAuteur, type: movieType);
        movies.add(movie);
      }
    }
    return movies;
  }

  bool chargement = false;

  //methode qui permet d'ajouter un like
  void addLike(String docID, int like){
    var newLikes = like +1;
    try {
      FirebaseFirestore.instance.collection('Publications').doc(docID).update({
        'like':newLikes,
      }).then((value) => print('données à jour'));
    } catch (e) {
      print(e.toString());
    }
  }

  void addcomment(String docID, int commentaire){
    var newcomment = commentaire +1;
    commentaire =newcomment;
    try {
      FirebaseFirestore.instance.collection('Publications').doc(docID).update({
        'commentaire':newcomment,
      }).then((value) => print('données à jour'));
    } catch (e) {
      print(e.toString());
    }
  }

  void SendComment(String docID, comment,) async{
   
    // ajouter une sous collection
      FirebaseFirestore.instance.collection("Publications").doc(docID).collection("Commentaires").add({
      'comment': comment,
    });

  }


  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // dropdown button pour les catégories
        DropdownButtonFormField(
          value: _selectedVal,
          items: _productSizesList.map(
            (e) => DropdownMenuItem(child:Text(e), value: e,)
          ).toList(), 
          onChanged: (val){
            setState(() {
              _selectedVal = val as String; 
            });
          },

          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color:Color.fromARGB(184, 248, 79, 6),
          ),

          dropdownColor: Colors.deepPurple.shade50,

          decoration: const InputDecoration(
            labelText: "catégories",
            prefixIcon: Icon(
              Icons.category,
              color:Color.fromARGB(184, 248, 79, 6),
            ),
            border: OutlineInputBorder()
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: getMovies(_selectedVal!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final movies = snapshot.data;
              if (movies != null && movies.isNotEmpty) {
                return Column(
                  children: [
                    for (final movie in movies)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child:Column(
                              children: [
                                
                                currentWidth<650 
                                ?ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child:FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/load-35_128.gif',
                                    image: movie.image,
                                    height: 600,
                                    width: 400,
                                    fit: BoxFit.cover,
                                    placeholderFit: BoxFit.none,
                                  ) 
                                )
                                :ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/load-35_128.gif',
                                    image: movie.image,
                                    height: 1100,
                                    width: 630,
                                    fit: BoxFit.cover,
                                    placeholderFit: BoxFit.none,
                                  ) 
                                ),

                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(movie.titre,
                                      textAlign: TextAlign.start,
                                        style: GoogleFonts.aBeeZee(
                                          color: const Color.fromARGB(255, 217, 96, 21),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.copyright, size:20, color: Colors.black),
                                    Text(movie.auteur,
                                      textAlign: TextAlign.start,
                                        style: GoogleFonts.aBeeZee(
                                          color: const Color.fromARGB(255, 74, 74, 73),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                        ),
                                    ),

                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // minimumSize: const Size.fromHeight(50),
                                        backgroundColor:(const Color.fromARGB(255, 217, 96, 21)),
                                      ),
                                      onPressed: (){
                                      }, 
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.call, size: 20),
                                          SizedBox(width: 5),
                                          Text(
                                            "Contactez l'auteur",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // minimumSize: const Size.fromHeight(50),
                                        backgroundColor:(const Color.fromARGB(255, 31, 31, 31)),
                                      ),
                                      onPressed: (){
                                      }, 
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.camera_outdoor, size: 20),
                                          SizedBox(width: 5),
                                          Text(
                                            "Projectez l'oeuvre",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(color:Color.fromARGB(179, 114, 109, 109)),
                                
                              ],
                            ),
                          ),
                        ],
                      )
                      
                      // Display movie images using Image.network
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      height: 410,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/nodata.png"),
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                    
                    // const Text('Aucune donnée trouvée')
                  ],
                );
              }
            }
          },
        ),
      ],
    );
    
  }
}






