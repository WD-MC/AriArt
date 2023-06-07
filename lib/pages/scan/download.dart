// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';

// class DownloadFile extends StatefulWidget {
//   const DownloadFile({super.key});

//   @override
//   State<DownloadFile> createState() => _DownloadFileState();
// }

// class _DownloadFileState extends State<DownloadFile> {
//   @override

//   Future<void> initState() async {
//     super.initState();
//     // Initialise le téléchargeur
//     FlutterDownloader.initialize(
//       debug: true,
//       // Optionnel: Définit le répertoire de destination par défaut pour les téléchargements
//       // Vous pouvez également utiliser d'autres répertoires spécifiques à votre besoin
//       // Ici, je l'ai défini sur le répertoire "Download" du stockage externe.
//       // Assurez-vous d'ajouter la permission WRITE_EXTERNAL_STORAGE dans votre fichier AndroidManifest.xml
//       // si vous utilisez le stockage externe.
//       defaultSaveDirectory: (Platform.isAndroid)
//           ? "/storage/emulated/0/Download/"
//           : (Platform.isIOS)
//               ? (await getApplicationDocumentsDirectory()).path
//               : '',
//     );
//   }
//   Future<void> downloadFile(String audioData) async {
//   var fichierAudio = audioData.substring(audioData.lastIndexOf('/') + 1);
//   var downloadUrl = '';

//   final docRef = await FirebaseFirestore.instance
//       .collection("audio")
//       .where("storagePath", isEqualTo: fichierAudio)
//       .get();

//   if (docRef.docs.isNotEmpty) {
//     var documentSnapshot = docRef.docs[0];
//     var data = documentSnapshot.data();
//     downloadUrl = data['downloadUrl'];
//   }

//   if (downloadUrl.isNotEmpty) {
//     final directory = (await getExternalStorageDirectory())!.path;
//     final taskId = await FlutterDownloader.enqueue(
//       url: downloadUrl,
//       savedDir: directory,
//       fileName: fichierAudio,
//       showNotification: true,
//       openFileFromNotification: true,
//     );
//   } else {
//     // Gérer le cas où le lien de téléchargement n'est pas disponible
//   }
// }

//   Widget build(BuildContext context) {
//     return Container();
//   }
// }