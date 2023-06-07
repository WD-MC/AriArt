// import 'package:ariart/pages/visiteur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ariart/pages/generate/qrgenerator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//class qui permet d'afficher les données pour la galerie des artistes

class ViewComment extends StatefulWidget {
  const ViewComment({super.key});

  @override
  State<ViewComment> createState() => _ViewCommentState();
}

class _ViewCommentState extends State<ViewComment> {

  //déclarer un flux de donnée et recupérer un flux de données
  final Stream<QuerySnapshot> _movieStream = FirebaseFirestore.instance.collection("Publications").snapshots();

  


  //recupère l'utilisateur couramment connecté
  String? getCurrentUserId(){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return user.uid;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //ajouter le flux de données 
      stream: _movieStream,
      // construire le flux de données
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const  Center(
            child:SpinKitFadingFour(
              color: Color.fromARGB(255, 29, 49, 66),
              size: 40,
            )
          ) ;
        }

        return  
        ListView(
          // parcourir les informations
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> movie = document.data()! as Map<String, dynamic>;

            return Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(241, 26, 26, 86),
                  width: 2.0,
                  style: BorderStyle.solid
                ),
                borderRadius: BorderRadius.circular(20),
                //color: Colors.yellowAccent,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(movie['poster'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(movie['name'],
                    style: GoogleFonts.adamina(
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Publications')
                        .doc(document.id)
                        .collection('Commentaires')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> commentsSnapshot) {
                      if (commentsSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (commentsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      // Map through the comments documents and create a List of Widgets
                      List<Widget> commentsWidgets = commentsSnapshot.data!.docs
                          .map((DocumentSnapshot commentDoc) {
                        Map<String, dynamic> commentData =
                            commentDoc.data() as Map<String, dynamic>;
                        return Container(
                          
                          color: const Color.fromARGB(255, 0, 0, 0),
                          padding: const EdgeInsets.all(10),
                          width: 300,
                          child: 
                            Column(
                              children: [
                                Text(commentData['comment'],textAlign: TextAlign.start,
                                  style: const TextStyle(
                                  color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                        );
                      }).toList();
                      return Column(children: commentsWidgets);
                    },
                  ),
                  
                ],
               ),
            );
          }).toList(),
        );
      },
    );
  }

}
