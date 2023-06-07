

import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart';
import 'package:path/path.dart';

class PDFRead {

  static Future<File?> loadFirebase(String url) async {
    //final urlPdf = PDFApi()._getPdfUrl(docID);
    try {
      final refPdf = FirebaseStorage.instance.ref().child('exposition/Descriptions/$url');
      final bytes = await refPdf.getData();

      
      return _storeFile(url, bytes!);
    } catch (e) {
      return null;
    }
    

  }

  // Future<String> _getPdfUrl(docID) async {
  //   final docRef = FirebaseFirestore.instance.collection("Publications").doc(docID);
  //   final doc = await docRef.get();
  //   final data = doc.data() as Map<String, dynamic>;
  //   print(data);

  //   String pdfUrl = data['urlPdf'];
  //   //print(pdfUrl);

  //   return pdfUrl;
  // }

  static Future<File> _storeFile(String url, List<int> bytes)async{
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}