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
  final String date;
  final String lieu;
  final int like;
  final int commentaire;

  // Movie({required this.name, required this.image});
  Movie({
    required this.id, required this.titre, required this.image, required this.categorie,
    required this.auteur, required this.date, required this.lieu, required this.like, required this.commentaire
  });
}

// class qui permet de recupérer les données pour visiteurs et les afficher

class PageVisiteur extends StatefulWidget {
  const PageVisiteur({super.key});

  @override
  State<PageVisiteur> createState() => _PageVisiteurState();
}

class _PageVisiteurState extends State<PageVisiteur> {

  //déclarer un flux de donnée et recupérer un flux de données
  // final Stream<QuerySnapshot> _movieStream = FirebaseFirestore.instance.collection("Publications").snapshots();
  Future<List<Movie>> getMovies(String category) async {

    final movies = <Movie>[];

    final moviesSnapshot = await FirebaseFirestore.instance
    .collection('Publications')
    .where('catégorie', isEqualTo: category)
    .get();

    for (var doc in moviesSnapshot.docs) {
      final movieData = doc.data();
      // final movieName = movieData['name'];
      final movieImage = movieData['poster'];
      final movieTitre = movieData['name'];
      final movieAuteur = movieData['auteur'];
      final movieDate= movieData['date'];
      final movieLieu = movieData['lieu'];
      final movieLike = movieData['like'];
      final movieCommentaire= movieData['commentaire'];
      final movieCategorie = movieData['catégorie'];
      // final movie = Movie(name: movieName, image: movieImage);
      final movieId = doc.id;
      final movie = Movie(
        id: movieId, titre:movieTitre, image: movieImage,categorie:movieCategorie,
        auteur: movieAuteur, date:movieDate, lieu: movieLieu, like:movieLike, commentaire:movieCommentaire
      );
      movies.add(movie);
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

    return FutureBuilder<List<Movie>>(
      future: getMovies("exposition"),
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

                            const SizedBox(height: 10),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.place, size:20, color: Colors.black),
                                Text(movie.lieu,
                                  textAlign: TextAlign.start,
                                    style: GoogleFonts.aBeeZee(
                                      color: const Color.fromARGB(255, 72, 71, 71),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 10),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.calendar_month, size:20, color: Colors.black),
                                Text(movie.date,
                                  textAlign: TextAlign.start,
                                    style: GoogleFonts.aBeeZee(
                                      color: const Color.fromARGB(255, 72, 71, 71),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(color:Color.fromARGB(179, 114, 109, 109)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        addLike(movie.id, movie.like);
                                      }, 
                                      icon: const Icon(Icons.thumb_up_alt_outlined),
                                    ),
                                    Text(movie.like.toString(),
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text('likes',
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        Comment(context, movie.id, movie.commentaire);
                                      }, 
                                      icon: const Icon(Icons.comment),
                                    ),
                                    Text(movie.commentaire.toString(),
                                      style: GoogleFonts.aBeeZee(
                                        color: const Color.fromARGB(255, 44, 50, 80),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),

                                IconButton(
                                  onPressed: () async{
                                    // cree une reférence vers fichier dans le storage
                                    // final docRef = FirebaseFirestore.instance.collection("Publications").doc(document.id);
                                    // //recupère le fichier
                                    // final doc = await docRef.get();
                                    // final data = doc.data() as Map<String, dynamic>;
                                    // print(data);

                                    // String url = data['urlPdf'];

                                    // final file = await PDFApi.loadFirebase(url);

                                    // if (file == null) return;

                                    // //openPDF(context, file);
                                    // Navigator.of(context).push(
                                    // MaterialPageRoute(builder:(context) => Details(file: file)));

                                    //openPDF(context, file, document.id);
                                    //Details(context, document.id);
                                    // Navigator.push(
                                    //   context, 
                                    //   PageRouteBuilder(
                                    //     pageBuilder: (_, __, ___) => Details(docID: document.id)
                                    //   )
                                    // );
                                  }, 
                                  icon: const Icon(Icons.add_circle_rounded, size: 30,),
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
    );
    
  }

  void Comment(BuildContext context, docID, int commentaire)async{

    final _keyForm = GlobalKey<FormState>();

    String comment ='';


    showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        children: [
          Container(
            //height: MediaQuery.of(context).size.height*15,
            height: 180,
            width: 350,
            margin: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child:Form(
              key:_keyForm,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  TextFormField (
                    decoration: const InputDecoration(
                      hintText: "Ajoutez un commentaire...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 39, 49, 111),
                          width: 2
                        ),
                        
                        borderRadius:BorderRadius.all(Radius.circular(30)),
                        
                      ),
                    ),
                    validator: (val) => val!.isEmpty? 'Entrez votre commentaire':null,
                    onChanged: (val) => comment = val,
                  ),
                  const SizedBox(height: 20), 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 220, 53, 53)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Annuler',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            SendComment(docID, comment);
                            addcomment(docID, commentaire);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Commenter'),
                      )
                    ],
                  )
                ],
              )
                
            )
            
            
          ),
        ],
      );
    });
  }

  // void openPDF(BuildContext context, File file) => Navigator.of(context).push(
  //   MaterialPageRoute(builder:(context) => Details(file: file)));

  // Future<String> _getPdfUrl() async {
  //   final docRef = FirebaseFirestore.instance.collection("Publications").doc(widget.docID);
  //   final doc = await docRef.get();
  //   final data = doc.data() as Map<String, dynamic>;
  //   print(data);

  //   String pdfUrl = data['urlPdf'];
  //   //print(pdfUrl);

  //   return pdfUrl;
  // }



}






