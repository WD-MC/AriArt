// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ariart/pages/scan/audionoplay.dart';
// //import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
// //import 'package:flutter/services.dart';
// import 'package:path/path.dart';


// class Details extends StatefulWidget {

//   final File file;
//   const Details ({Key? key, required this.file}):super(key: key);
  
//   @override
//   State<Details> createState() => _DetailsState();
// }

// class _DetailsState extends State<Details> {

//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.file.path);
//     return PDFViewerScaffold(
//       appBar: AppBar(  
//         backgroundColor: const Color.fromARGB(255, 172, 95, 40),
//         elevation:0,
//         title: Text(name),
//         iconTheme: const IconThemeData(
//           color: Colors.white, // couleur de l'icône du drawer
//         ),
//       ),
//        path: widget.file.path,
//       );
//   }
// }

// class Details extends StatefulWidget {

//   final String docID;
//   //final File file;
//   const Details({Key? key, required this.docID}) : super(key: key);
//   //const Details({super.key});

//   @override
//   State<Details> createState() => _DetailsState();
// }

// class _DetailsState extends State<Details> {

//   late PDFViewController pdfViewController;
//   //String pdfUrl = '';
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     //final name = basename(widget.file.path);

//     return Scaffold(
//       appBar: AppBar(  
//         backgroundColor: Colors.white.withOpacity(0),
//         elevation:0,
//         //title: Text(name),
//         iconTheme: const IconThemeData(
//           color: Colors.black, // couleur de l'icône du drawer
//         ),
//       ),
//       body:
//       FutureBuilder<String>(
//         future: _getPdfUrl(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             String pdfUrl = snapshot.data!;
//             print(pdfUrl);
//             return PDFView(
//               filePath: pdfUrl,
//             );
//           } else if (snapshot.hasError) {
//             return Text("Erreur: ${snapshot.error}");
//           }
//           return const CircularProgressIndicator();
//         },
//       ), 

//       // FutureBuilder(
//       //   future: _getPdfUrl(),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//       //       return PDFView(
//       //         filePath: snapshot.data!,
//       //         fitEachPage: true,
//       //         fitPolicy: FitPolicy.BOTH,
//       //       );
//       //     } else {
//       //       return CircularProgressIndicator();
//       //     }
//       //   },
//       // )
//       // FutureBuilder(
//       //   future: _getPdfUrl(),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.hasData) {
            
//       //       return Stack(
//       //         children: <Widget>[
//       //           PDFView(
//       //             filePath: snapshot.data,
//       //             enableSwipe: true,
//       //             swipeHorizontal: true,
//       //             autoSpacing: false,
//       //             pageFling: true,
//       //             pageSnap: true,
//       //             defaultPage: currentPage!,
//       //             fitPolicy: FitPolicy.BOTH,
//       //             preventLinkNavigation:
//       //                 false, // if set to true the link is handled in flutter
//       //             onRender: (_pages) {
//       //               setState(() {
//       //                 pages = _pages;
//       //                 isReady = true;
//       //               });
//       //             },
//       //             onError: (error) {
//       //               setState(() {
//       //                 errorMessage = error.toString();
//       //               });
//       //               print(error.toString());
//       //             },
//       //             onPageError: (page, error) {
//       //               setState(() {
//       //                 errorMessage = '$page: ${error.toString()}';
//       //               });
//       //               print('$page: ${error.toString()}');
//       //             },
//       //             onViewCreated: (PDFViewController pdfViewController) {
//       //               (pdfViewController);
//       //             },
//       //             onLinkHandler: (String? uri) {
//       //               print('goto uri: $uri');
//       //             },
//       //             onPageChanged: (int? page, int? total) {
//       //               print('page change: $page/$total');
//       //               setState(() {
//       //                 currentPage = page;
//       //               });
//       //             },
//       //           ),
//       //           errorMessage.isEmpty
//       //               ? !isReady
//       //                   ? Center(
//       //                       child: CircularProgressIndicator(),
//       //                     )
//       //                   : Container()
//       //               : Center(
//       //                   child: Text(errorMessage),
//       //                 )
//       //         ],
//       //       );
//       //       // PDFView(
//       //       //   filePath: snapshot.data!,
//       //       //   autoSpacing: true,
//       //       //   enableSwipe: true,
//       //       //   pageSnap: true,
//       //       //   swipeHorizontal: true,
//       //       //   onRender: (_pages) {
//       //       //     setState(() {});
//       //       //   },
//       //       //   onError: (error) {
//       //       //     print(error.toString());
//       //       //   },
//       //       //   onPageError: (page, error) {
//       //       //     print('$page: ${error.toString()}');
//       //       //   },
//       //       //   onViewCreated: (PDFViewController vc) {
//       //       //     pdfViewController = vc;
//       //       //   },
//       //       //   onPageChanged: (page, total) {
//       //       //     print('page change: $page/$total');
//       //       //   },
//       //       // );
            
//       //       //Container(height: 200, color: Colors.amber,);
//       //       // ClipRRect(
//       //       //   borderRadius: BorderRadius.circular(15.0),
              
//       //       //   child:
//       //       //   FadeInImage.assetNetwork(
//       //       //     placeholder: 'assets/images/icons8-dots-loading.gif',
//       //       //     image: snapshot.data!,
//       //       //     height: 600,
//       //       //     width: 400,
//       //       //     fit: BoxFit.cover,
//       //       //     placeholderFit: BoxFit.none,
//       //       //   ) 
//       //       // );
//       //     } else {
//       //       return const CircularProgressIndicator();
//       //     }
//       //   },
//       // )
      
//     );
    
//   }

//   // Future<String> _getPdfUrl() async {
//   //   final docRef = FirebaseFirestore.instance.collection("Publications").doc(widget.docID);
//   //   docRef.get().then(
//   //     (DocumentSnapshot doc) {
//   //       final data = doc.data() as Map<String, dynamic>;
//   //       print(data);

//   //       pdfUrl = data['downloadUrlPdf'];
//   //       print(pdfUrl);

//   //       return pdfUrl;

//   //     },
//   //     onError: (e) => print("Error getting document: $e"),
//   //   );
    
//   //   return '';
//   // }

//   Future<String> _getPdfUrl() async {
//     final docRef = FirebaseFirestore.instance.collection("Publications").doc(widget.docID);
//     final doc = await docRef.get();
//     final data = doc.data() as Map<String, dynamic>;
//     print(data);

//     String pdfUrl = data['urlPdf'];
//     //print(pdfUrl);

//     return pdfUrl;
//   }

//   // static Future<File> _storeFile(String url, List<int> bytes)async{
//   //   final filename = basename(url);
//   //   final dir = await getApplicationDocumentsDirectory();

//   //   final file = File('${dir.path}/$filename');
//   //   await file.writeAsBytes(bytes, flush: true);
//   //   return file;
//   // }

//   // void openPDF(BuildContext context, File file) => Navigator.of(context).push(
//   //   MaterialPageRoute(builder:(context) => PDFViewerPage()));
// }





// class ViewDetail extends StatefulWidget {
  

//   const ViewDetail({super.key});

//   @override
//   State<ViewDetail> createState() => _ViewDetailState();
// }

// class _ViewDetailState extends State<ViewDetail> {

//   //déclarer un flux de donnée et recupérer un flux de données
//   final Stream<QuerySnapshot> _movieStream = FirebaseFirestore.instance.collection("Publications").snapshots();


//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       //ajouter le flux de données 
//       stream: _movieStream,
//       // construire le flux de données
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const  Center(
//             child:SpinKitFadingFour(
//               color: Color.fromARGB(255, 29, 49, 66),
//               size: 40,
//             )
//           ) ;
//         }

//         return  
//         ListView(
//           // parcourir les informations
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           Map<String, dynamic> movie = document.data()! as Map<String, dynamic>;

//             return SingleChildScrollView(
//               child: Container(
//                 padding: const EdgeInsets.all(25),
//                 child: Column(
//                   children: [
//                     Text(movie['docTitre'],
//                       style: GoogleFonts.adamina(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         color: const Color.fromARGB(255, 46, 44, 82)
//                       ),
                    
//                     ),
//                     const SizedBox(height: 20),

//                     Text(movie['docSousTitre'],
//                       style: GoogleFonts.adamina(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                         color: const Color.fromARGB(255, 46, 44, 82)
//                       ),
                    
//                     ),
//                     const SizedBox(height: 20),

//                     Text(movie['docContent'],
//                     textAlign: TextAlign.justify,
//                       style: GoogleFonts.adamina(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12
//                       ),
                    
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

// }

