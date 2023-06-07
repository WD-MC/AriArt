import 'package:ariart/Visiteurs/Visiteurs_oeuvre.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ariart/pages/generate/qrgenerator.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ariart/constant/delaiyed_animation.dart';

//class qui permet d'afficher les données pour la galerie des lieux d'expositions

class Movie {
  // final String name;
  final String id;
  final String image;
  final String titre;
  final String categorie;

  // Movie({required this.name, required this.image});
  Movie({required this.id, required this.titre, required this.image, required this.categorie});
}


class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  String uid='';
  String uid1 = '';


  //Stocke les données de  l'utilisateur couramment connecté
  final user = FirebaseAuth.instance.currentUser!;

  void supprimer(String docID){
    FirebaseFirestore.instance.collection("Movies").doc(docID).delete().then(
      (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }
  
  // Methode pour publier une oeuvre
  void publier(String docID){
    final docRef = FirebaseFirestore.instance.collection("Movies").doc(docID);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        //Stocke les données de  l'utilisateur couramment connecté
        final user = FirebaseAuth.instance.currentUser!;

        FirebaseFirestore.instance.collection("Publications").add({       
          // recupere les valeurs des champs
          'uid': user.uid,
          'name': data['name'],
          'auteur':data['auteur'],
          'categorie':data['catégorie'],
          'lieu':data['lieu'],
          'date':data['date'],
          'poster': data['poster'],
          'description':data['description'],
          'type':data['type'],
          'like':0,
          'timestamp': DateTime.now()
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );

  }

  Future<String> Data() async {
      uid1 = user.uid;
      return uid1;
  }

  void _getData() async {
    //Appel de la méthode Data()
    uid1 = await Data();
    // Utilisation de l'UID récupéré
    // print('UID récupéré : $uid1');
  } 

  @override
  void initState(){
    super.initState();
    _getData();
  }

  Future<List<Movie>> getMovies(String category) async {

    final movies = <Movie>[];
    if (category == "d'art") {
      final moviesSnapshot = await FirebaseFirestore.instance
      .collection('Movies')
      .where('uid', isEqualTo: uid1)
      .get();

      for (var doc in moviesSnapshot.docs) {
        final movieData = doc.data();
        // final movieName = movieData['name'];
        final movieImage = movieData['poster'];
        final movieTitre = movieData['name'];
        final movieCategorie = movieData['catégorie'];
        // final movie = Movie(name: movieName, image: movieImage);
        final movieId = doc.id;
        final movie = Movie(id: movieId, titre:movieTitre, image: movieImage,categorie:movieCategorie);
        movies.add(movie);
      }

    } else if (category == "d'oeuvre" || category == "d'exposition"){
      
      List<String> parts = category.split("'");
      category = parts[1];
      final moviesSnapshot = await FirebaseFirestore.instance
      .collection('Movies')
      .where('uid', isEqualTo: uid1)
      .where('catégorie', isEqualTo: category)
      .get();

      for (var doc in moviesSnapshot.docs) {
        final movieData = doc.data();
        // final movieName = movieData['name'];
        final movieImage = movieData['poster'];
        final movieTitre = movieData['name'];
        final movieCategorie = movieData['catégorie'];
        // final movie = Movie(name: movieName, image: movieImage);
        final movieId = doc.id;
        final movie = Movie(id: movieId, titre:movieTitre, image: movieImage,categorie:movieCategorie);
        movies.add(movie);
      }
    }

    return movies;
  }

  String? _selectedVal = "d'art";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const  SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Ma Galerie",
                textAlign: TextAlign.center,
                style: GoogleFonts.gabriela(
                  color:const Color.fromARGB(240, 19, 19, 19),
                  fontSize: 18, 
                )
              ),
              DropdownButton<String>(
                value: _selectedVal,
                items: const [
                  DropdownMenuItem(
                    value: "d'art",
                    child: Text("d'art"),
                  ),
                  DropdownMenuItem(
                    value: "d'exposition",
                    child: Text("d'exposition"),
                  ),
                  DropdownMenuItem(
                    value: "d'oeuvre",
                    child: Text("d'oeuvre"),
                  ),
                  // Autres éléments
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedVal = value as String; 
                  });
                },
              )
            ],
          ),

          const SizedBox(height: 20),
    
          SvgPicture.asset("assets/inkartassets/divide1.svg"),
          const SizedBox(height: 50),

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
                            padding: const EdgeInsets.all(10),
                            child:Column(
                              children: [
                                
                                SizedBox(
                                  child:ClipRRect(

                                    borderRadius: BorderRadius.circular(10), // Définissez le rayon du border radius souhaité
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/icons8-loading-infinity.gif',
                                      image: movie.image,
                                      height: 470,
                                      width: 400,
                                      fit: BoxFit.cover,
                                      placeholderFit: BoxFit.none,
                                    ), 
                                  ),
                                  
                                ),
                                const SizedBox(height: 10),
                                if(movie.categorie == "exposition")
                                  Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: const Color.fromARGB(255, 39, 204, 33),
                                        ),
                                        child:  
                                          const Icon(Icons.download,size: 15,color: Color.fromARGB(255, 255, 255, 255),
                                          ),
                                      ),
                                      Text(" 0 Téchargements",
                                        style: GoogleFonts.aBeeZee(
                                          color: const Color.fromARGB(255, 44, 50, 80),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ],
                                  )
                                

                                
                              ],
                            ),
                          ),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0,3), // Décalez l'ombre horizontalement et verticalement
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        // supprimer(movie.id);
                                        succes(context,movie.id,movie.categorie,"Supprimer");
                                      }, 
                                      icon: const Icon(Icons.delete),
                                      
                                    ),
                                    Text("Supprimez",
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: (){}, 
                                      icon: const Icon(Icons.create),
                                    ),
                                    Text("Modifiez",
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: ()async{
                                        //Effectuez une requête pour récupérer les informations des expositions
                                        final collectionRef = FirebaseFirestore.instance.collection('Publications');
                                        final querySnapshot = await collectionRef.get();
                                        if (querySnapshot.docs.isNotEmpty) {

                                          if (querySnapshot.docs.any((doc) => doc['name'] == movie.titre)) {
                                            errorExpo(context); 
                                          }
                                          else{
                                            succes(context,movie.id,movie.categorie,"Publier");
                                          }
                                          
                                        }
                                      }, 
                                      icon: const Icon(Icons.publish),
                                    ),
                                    Text("Publiez",
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ) ,
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
          // const MoviesInformation(),
        ],
      ),
    ); 
  }

  void succes(BuildContext context, String id, String categorie, String action)async{
    showDialog(context: context, builder: (BuildContext context){
      return DelayedAnimation1(
        delay: 1500, 
        child:SimpleDialog(
          contentPadding: EdgeInsets.zero,
          
          children: [
            Container(
              height: 185,
              width: 350,
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.center,

              child: Column(children: [
                
                Image.asset("assets/images/interro.png", height: 75,),
                const SizedBox(height: 10),
                if(categorie == "exposition")
                  Text('Voulez-vous $action cette exposition!',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 17, 17, 17),
                      fontSize: 15
                    ),
                  ),
                if(categorie != "exposition")
                  Text("Voulez-vous $action cette oeuvre!",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 17, 17, 17),
                      fontSize: 15
                    ),
                  ),
                const SizedBox(height: 10),
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
                        if (action == "Publier") {
                          if(categorie == "exposition"){
                            print("expo");
                            // publier(id);
                            // Navigator.push(
                            //   context, 
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => const Visiteur()
                            //   )
                            // );
                          }
                          if(categorie != "exposition"){
                            print("oeuvre");
                            publier(id);
                            Navigator.push(
                              context, 
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const Visiteur()
                              )
                            );
                          }
                          
                        }
                        if (action == "Supprimer") {
                          supprimer(id);
                          Navigator.pop(context);
                        }
                      }, 
                      child: Text(action,
                          style: const TextStyle(fontSize: 15),
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

  void errorExpo(BuildContext context)async{
    showDialog(context: context, builder: (BuildContext context){
      return DelayedAnimation1(
        delay: 1500, 
        child:SimpleDialog(
          contentPadding: EdgeInsets.zero,
          
          children: [
            Container(
              height: 185,
              width: 350,
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.center,

              child: Column(children: [
                
                Image.asset("assets/images/alert.png", height: 75,),
                const SizedBox(height: 10),
                const Text("Error",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 20
                  ),
                ),
                const Text("Oeuvre déjà existante!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:(const Color.fromARGB(255, 244, 76, 75)),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text("OK",
                      style: TextStyle(fontSize: 15),
                    )
                ), 
              ],)
              
              
            ),
          ],
        )
      );
    });
  }
}