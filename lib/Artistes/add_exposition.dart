
import 'dart:async';
import 'dart:io';

import 'package:ariart/Artistes/movies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
import 'package:ariart/constant/disappearing.dart';
import 'package:ariart/constant/delaiyed_animation.dart';


// Ajouter une nouvelle exposition//

class AddExposition extends StatefulWidget {
  const AddExposition({super.key});

  @override
  State<AddExposition> createState() => _AddExpositionState();
}

class _AddExpositionState extends State<AddExposition> {

  //variable pour recuperer le champ de texte
  final nameController = TextEditingController();
  final lieuController = TextEditingController();
  final dateController = TextEditingController();
  final auteurController = TextEditingController();

  String name ='';     
  String lieu ='';
  String date = '';
  String auteur ='';
  String error ='';


  List<String> categories = [];

  File? file;

  File? filePdf;

  String imageFile = '';

  Timer? _timer;

  final _formkey = GlobalKey<FormState>();



  @override
  void dispose() {
    _timer?.cancel();
    nameController.dispose();
    lieuController.dispose();
    dateController.dispose();
    auteurController.dispose();
    super.dispose();
  }

  // réinitialiser les champs après 5 secondes
  void _startTimer() {
    _timer = Timer(const Duration(seconds:5), () {
      setState(() {
        _formkey.currentState?.reset();
        nameController.text = '';
        lieuController.text='';
        dateController.text='';
        auteurController.text = '';
        imageFile = '';
        file = null;
        filePdf = null;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    final fileName = filePdf != null? (filePdf!.path):'No file';

    return Scaffold(
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child:Column(
          children: [
            const SizedBox(height: 10),
            
            //nouvelle exposition
            const Text("CREER UNE NOUVELLE EXPOSITION",
              style: TextStyle(
                color:Color.fromARGB(241, 26, 26, 86),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 25),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Titre de l'exposition",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 39, 49, 111),
                    width: 2
                  ),
                  
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                  
                ),
              ),
              onChanged: (value) => name = value,
              validator: (val) => val!.isEmpty? error = 'Entrez le titre':null,
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: lieuController,
              decoration: const InputDecoration(
                hintText: "Lieu de l'exposition",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 39, 49, 111),
                    width: 2
                  ),
                  
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                  
                ),
              ),
              onChanged: (value) => lieu = value,
              validator: (val) => val!.isEmpty? error = 'Entrez le lieu':null,
            ),
            const SizedBox(height: 20),
            

            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                hintText: "Entrez la date",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 39, 49, 111),
                    width: 2
                  ),
                  
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                  
                ),
              ),
              onChanged: (value) => date = value,
              validator: (val) => val!.isEmpty? error = 'Entrez une date':null,
              
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: auteurController,
              decoration: const InputDecoration(   
                hintText: "Entrez l'auteur",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 39, 49, 111),
                    width: 2
                  ),
                  
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                  
                ),
              ),
              onChanged: (value) => auteur = value,
              validator: (val) => val!.isEmpty? error = "Entrez le nom d'auteur":null,
            ),
            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Color.fromARGB(221, 123, 123, 123),width: 1.5),
              ),
              title: Row(
                children: [
                  const Text("Ajouter l'image de l'exposition:"),
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

            
            
            file == null
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
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(imageFile,textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 15),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Color.fromARGB(221, 123, 123, 123),width: 1.5),
              ),
              title: Row(
                children: [
                  const Text("Description pdf de l'exposition:"),
                  //donner au champ d'occuper tout l'espace
                  Expanded(
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showPdf();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(184, 248, 79, 6),
                        ),
                      ),
                    )
                    
                    
                  )
                ],
              ),
            ),

            const SizedBox(height: 5),

            fileName.endsWith('.pdf')
            ?Image.asset("assets/images/Check.png", height: 25,)
            :Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/right-arrow.gif", height:50 ,),
                const Text('Aucun fichier selectioné.', style: TextStyle(color:Colors.red),)
              ],
            ), 
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
              ),
              onPressed: () async{
                if (_formkey.currentState!.validate() &&  file != null && filePdf != null) {

                  name = nameController.value.text;
                  lieu = lieuController.value.text;
                  auteur = auteurController.value.text;
                  date = dateController.value.text;
 
                  //Effectuez une requête pour récupérer les informations des expositions
                  final collectionRef = FirebaseFirestore.instance.collection('Movies');
                  final querySnapshot = await collectionRef.get();
                  if (querySnapshot.docs.isNotEmpty) {

                    if (querySnapshot.docs.any((doc) => doc['name'] == name  ||  doc['date'] == date )) {
                      errorExpo(context);
                      
                    }
                    else{
                      _startTimer();
                      SaveExposition(imageFile,name, lieu, auteur, date,fileName);
                      succes(context);
                    }
                    
                  }
                  
                }
              }, 
              child: const Text("Ajoutez l'exposition",
                style: TextStyle(fontSize: 15),
              )
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(340, 50)), 
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.black),
                    
                  ),
                  
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              // style: ElevatedButton.styleFrom(
              //   minimumSize: const Size.fromHeight(50),
              //   backgroundColor:(const Color.fromARGB(141, 41, 41, 115)),
              // ),
              onPressed: () async{
                if (_formkey.currentState!.validate() && file != null && filePdf != null) {

                  name = nameController.value.text;
                  lieu = lieuController.value.text;
                  auteur = auteurController.value.text;
                  date = dateController.value.text;

                  //Effectuez une requête pour récupérer les informations des expositions
                  final collectionRef = FirebaseFirestore.instance.collection('Movies');
                  final querySnapshot = await collectionRef.get();
                  if (querySnapshot.docs.isNotEmpty) {

                    if (querySnapshot.docs.any((doc) => doc['name'] == name  ||  doc['date'] == date )) {
                      errorExpo(context);
                      
                    }
                    else{
                      
                      _startTimer();
                      publierExpo(imageFile,name, lieu, auteur, date,fileName);
                      succes(context);
                    }
                    
                  }

                  
                }
              }, 
              child: const Text("Publiez l'exposition",
                style: TextStyle(fontSize: 15),
              )
            )
          ],
        )), 
      )
    ));
    
  }

  // recupère l'image de l'oeuvre et  l'affiche dans une boîte de dialogue

  void showOeuvreDialog()async{

    //XFile? pickedFile = await ImagePicker().pickImage(source: source);
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //File file = File(pickedFile!.path);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        imageFile = pickedFile.name;

      } else {
        print('No image selected.');
      }
    });

  }

  void showPdf() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    
    if (result == null)return; 
    final path = result.files.single.path!;

    setState(() => filePdf = File(path));
  }

  // méthode pour sauvegarder l'oeuvre dans la galerie
  void SaveExposition(imageFile, name, lieu, auteur, date,fileName) async{
    
    // sauvegarde l'image
    final storageRef = FirebaseStorage.instance.ref().child('exposition/$imageFile');
    final uploadTask = storageRef.putFile(file!);
    await uploadTask.whenComplete(() => print('image file uploaded to Firebase Storage'));
    final downloadUrl = await storageRef.getDownloadURL();

    // sauvegarde le pdf
    final storageRefPdf = FirebaseStorage.instance.ref().child('exposition/Descriptions/${File(fileName).path.split('/').last}');
    final uploadTaskPdf = storageRefPdf.putFile(File(fileName));
    await uploadTaskPdf.whenComplete(() => print('pdf file uploaded to Firebase Storage'));
    final downloadUrlPdf = await storageRefPdf.getDownloadURL();

    // faire appel au package firebase et recupère l'utilisateur courant
    final user = FirebaseAuth.instance.currentUser!;
    
    //methode qui permet d'ajouter un nouveau champ
    FirebaseFirestore.instance.collection("Movies").add({
      
      // recupere les valeurs des champs
      'uid': user.uid,
      'name': name,
      'auteur':auteur,
      'catégorie':'exposition',
      'lieu': lieu,
      'date': date,
      'poster': downloadUrl,
      'description':downloadUrlPdf,
      'urlPdf': File(fileName).path.split('/').last,
      'timestamp': DateTime.now(),
    });
  }

  void publierExpo(imageFile, name, lieu, auteur, date,fileName)async{

    final storageRef = FirebaseStorage.instance.ref().child('exposition/$imageFile');
    final uploadTask = storageRef.putFile(file!);
    await uploadTask.whenComplete(() => print('image file uploaded to Firebase Storage'));
    final downloadUrl = await storageRef.getDownloadURL();

    // sauvegarde le pdf
    final storageRefPdf = FirebaseStorage.instance.ref().child('exposition/Descriptions/${File(fileName).path.split('/').last}');
    final uploadTaskPdf = storageRefPdf.putFile(File(fileName));
    await uploadTaskPdf.whenComplete(() => print('pdf file uploaded to Firebase Storage'));
    final downloadUrlPdf = await storageRefPdf.getDownloadURL();

    // Recupère l'id de l'utilisateur courant
    final user = FirebaseAuth.instance.currentUser!;

    //methode qui permet d'ajouter un nouveau champ
    FirebaseFirestore.instance.collection("Publications").add({
      
      // recupere les valeurs des champs
      'uid': user.uid,
      'name': name,
      'auteur':auteur,
      'catégorie':'exposition',
      'lieu': lieu,
      'date': date,
      'poster':downloadUrl,
      'like':0,
      'commentaire':0,
      'description':downloadUrlPdf,
      'timestamp': DateTime.now(),
    });

    FirebaseFirestore.instance.collection("Movies").add({
      
      // recupere les valeurs des champs
      'uid': user.uid,
      'name': name,
      'auteur':auteur,
      'catégorie':'exposition',
      'lieu': lieu,
      'date': date,
      'poster': downloadUrl,
      'description':downloadUrlPdf,
      'timestamp': DateTime.now(),
    });
  }


  void succes(BuildContext context)async{
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
                
                Image.asset("assets/images/Check.png", height: 75,),
                const SizedBox(height: 10),
                const Text("Succès",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 20
                  ),
                ),
                const Text("Exposition crée!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 17, 17),
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:(const Color.fromARGB(255, 23, 177, 135)),
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
                const Text("Exposition déjà existante!",
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
