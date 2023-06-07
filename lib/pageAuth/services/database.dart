import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

  late final String uid;


  DatabaseService({required this.uid});

  //variable pour créer une collection pour les utilisateurs
  final CollectionReference collectionUtil = FirebaseFirestore.instance.collection('utilisateurs');

  
  //methode pour sauvegarder un utilisateur
  Future<void> saveUser(String name, String number)async{

    return await collectionUtil.doc(uid).set({
      'name':name,
      'number':number,
    });
  }


}

