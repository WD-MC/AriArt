import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  
  
  //Recupère les fichiers mutimédia
  File? file;
  
  String qrString = 'Ajouter le contenu du QR code';
  //Recupère les fichiers mutimédia
  
  // recupère l'image pour le multimédia
  File? fileImage;

  String imageFile = '';
  // recupère l'image pour le multimédia 

  bool isMp3 =false;
  bool isPng = false;
  bool isSelect = false;

  @override
  void initState(){
    super.initState();
    setState(() {
      fileImage = null;
      imageFile = '';
      isMp3 =false;
      isPng = false;

    });
  }

  @override
  Widget build(BuildContext context) {

    final fileName = file != null? (file!.path):'No file';

    qrString = fileName;

    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 228, 225, 225),

      body: SingleChildScrollView( 
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          const SizedBox(height: 40),
          BarcodeWidget(
            color: Colors.black,
            height: 250,
            width: 250,
            data: fileName, 
            barcode: Barcode.qrCode(),
          ),
          const SizedBox(height: 40),
          Container(
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              children: [
                
                Visibility(
                  visible: isMp3,
                  child: Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Color.fromARGB(221, 123, 123, 123),width: 1.5),
                        ),
                        title: Row(
                          children: [
                            const Text("Choisir l'image de l'audio:"),
                            //donner au champ d'occuper tout l'espace
                            Expanded(
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showOeuvreDialog();
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(184, 248, 79, 6),
                                  )
                                ),
                              )
                              
                              
                            )
                          ],
                        ),
                      ),
                      
                      fileImage == null
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/right-arrow.gif", height:50 ,),
                          const Text('Aucune image selectionée.', style: TextStyle(color:Colors.red),)
                        ],
                      ) 
                      : Column(children: [
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(fileImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(imageFile,textAlign: TextAlign.center),
                      ]), 
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(const Size(100, 40)), 
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 220, 53, 53)),
                            ),
                            onPressed: () {
                              setState(() {
                                isMp3 = false;
                                isSelect = false;
                                if (fileImage != null) {
                                  fileImage = null;
                                }
                              });
                            },
                            child: const Text('Annuler',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),

                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(const Size(100, 40)), 
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
                              if (file != null && fileImage != null) {
                                SaveAudio(imageFile,fileImage);
                                _createPdf();
                                //Navigator.pop(context);
                              }
                            },
                            child: const Text('Sauvegarder'),
                          )
                        ],
                      )
                      
                    ],
                  )
                ),

                Visibility(
                  visible: !isSelect,
                  child: const Text("Format des fichiers valide: mp3, mp4, png !"),
                ),
                
                Visibility(
                  visible: !isSelect,
                  child: ButtonWidget(
                    icon: Icons.attach_file,
                    onCliked: selectFile, 
                    text: 'SelectFile'
                  ),
                ),
                const SizedBox(height: 20),

                Visibility(
                  visible: !isSelect,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                      padding: const EdgeInsets.only(top: 3,bottom: 3,right: 50,left: 50)
                    ),
                    //swicht entre les pages
                    onPressed: () {

                      if (fileName.endsWith('.mp3')){
                        setState(() {
                          isMp3 = true;
                          isSelect = true;
                          print(isMp3);
                          print(isSelect);
                        });
                      }
                      if (fileName.endsWith('mp4')) {
                        SaveVideo();
                        _createPdf();
                      }

                      if (fileName.endsWith('.PNG')) {

                        AddLink(context);
                        
                      }
                      
                    }, 
                    child: 
                      const  Text("Générer le pdf",
                      style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)
                      ),
                    )
                  ),
                ),

              ],
            )
            
          ),
          SizedBox( width: MediaQuery.of(context).size.width,)
        ],
      ),
    ));
  }
  
  void _createPdf()async{
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context){
          return pw.Center(
            child: pw.BarcodeWidget(
            height: 250,
            width: 250,
            data: qrString, 
            barcode: Barcode.qrCode(),
            
          ),

          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save()); 
    
  }

  void SaveAudio(imageFile,fileImage)async{

      final audioFile = File(qrString);
      final storageRef = FirebaseStorage.instance.ref().child('audio/${audioFile.path.split('/').last}');
      final uploadTask = storageRef.putFile(audioFile);
      await uploadTask.whenComplete(() => print('Audio file uploaded to Firebase Storage'));
      final downloadUrl = await storageRef.getDownloadURL();

      final storageRef1 = FirebaseStorage.instance.ref().child('audio/image/$imageFile');
      final uploadTask1 = storageRef1.putFile(fileImage!);
      await uploadTask1.whenComplete(() => print('image file uploaded to Firebase Storage'));
      final downloadUrl1 = await storageRef1.getDownloadURL();


      final audioRef = FirebaseFirestore.instance.collection('audio').doc();

      await audioRef.set({
        'downloadUrl': downloadUrl,
        'storagePath': storageRef.name,
        'imageUrl': downloadUrl1,
        'timestamp': DateTime.now(),
      });
    
    
  } 

  void SaveVideo()async{
      
      final audioFile = File(qrString);
      final storageRef = FirebaseStorage.instance.ref().child('video/${audioFile.path.split('/').last}');
      final uploadTask = storageRef.putFile(audioFile);
      await uploadTask.whenComplete(() => print('Audio file uploaded to Firebase Storage'));

      final downloadUrl = await storageRef.getDownloadURL();
      final audioRef = FirebaseFirestore.instance.collection('vidéo').doc();

      await audioRef.set({
        'downloadUrl': downloadUrl,
        //'storagePath': storageRef.fullPath,
        'storagePath': storageRef.name,
        //'timestamp': FieldValue.serverTimestamp(),
      });
    
    
  }

  void SaveLink(String lien)async{
      
      final audioFile = File(qrString);
      final storageRef = FirebaseStorage.instance.ref().child('audio/image/${audioFile.path.split('/').last}');
      final uploadTask = storageRef.putFile(audioFile);
      await uploadTask.whenComplete(() => print('Audio file uploaded to Firebase Storage'));

      final downloadUrl = await storageRef.getDownloadURL();
      final audioRef = FirebaseFirestore.instance.collection('infosEntrepreneur').doc();

      await audioRef.set({
        'downloadUrl': downloadUrl,
        //'storagePath': storageRef.fullPath,
        'storagePath': storageRef.name,
        'link': lien,
        //'timestamp': FieldValue.serverTimestamp(),
      });
    
    
  }


  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    
    if (result == null)return; 
    final path = result.files.single.path!;

    setState(() => file = File(path));
    
  }

  // recupère l'image de l'oeuvre et  l'affiche dans une boîte de dialogue
  void showOeuvreDialog()async{

    //XFile? pickedFile = await ImagePicker().pickImage(source: source);
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //File file = File(pickedFile!.path);

    setState(() {
      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
        imageFile = pickedFile.name;

      } else {
        print('No image selected.');
      }
    });

  }


  // boîte de dialogue pour choisir le lien de l'image
  void AddLink(BuildContext context)async{


    final keyForm = GlobalKey<FormState>();
    String lien = '';

    showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        children: [
          Container(
            height: 180,
            width: 300,
            margin: const EdgeInsets.all(8.0),
            child:Column(
              children: [
                Form(
                  key:keyForm,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Ajoutez un lien",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 39, 49, 111),
                          width: 2
                        ),
                        
                        borderRadius:BorderRadius.all(Radius.circular(30)),
                        
                      ),
                    ),
                    validator: (val) => val!.isEmpty? 'Entrez un lien':null,
                    onChanged: (val) => lien = val,
                  )
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

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
                        if (keyForm.currentState!.validate()) {
                          SaveLink(lien);
                          _createPdf();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Sauvegarder'),
                    )
                  ],
                )
              ],
            )
            
            
          ),
        ],
      );
    });
  }
  
}


class ButtonWidget extends StatelessWidget {
  //const ButtonWidget({super.key});

  final IconData icon;
  final String text;
  final VoidCallback onCliked;

  const ButtonWidget({
      Key? key,
      required this.icon,
      required this.text,
      required this.onCliked,
  }):super(key: key);


  @override
  Widget build(BuildContext context) => ElevatedButton(
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
    onPressed: onCliked, 
    child: buildContent(),
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 28),
      const SizedBox(width: 16),
      Text(text,
        style: const TextStyle(fontSize: 18, color:Colors.black),
      )
    ],
  );
    
  
}




