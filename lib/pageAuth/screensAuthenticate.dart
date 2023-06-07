 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ariart/pageAuth/services/authentification.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:ariart/constant/delaiyed_animation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ariart/pageAuth/common/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {

  final AuthenticationService _auth = AuthenticationService();

  final _formkey = GlobalKey<FormState>();

  //variable pour afficher l'erreur
  String error = '';
  //variable pour la page de chargement
  bool loading = false;


  String name ='';
  String ConfirmPassword ='';
  String number = '';
  String password ='';

  // variables pour les champs email et password
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //variable qui permettra de switcher entre les pages sign et signup
  bool showSignIn =true;
  
  bool _obscureText = true;
  bool isCorrect = false;


  @override
  void dispose(){
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    
    super.dispose();
  }

  // methode qui permettra de switcher entre les pages
  void toogleView(){
    setState(() {
      //rénitialise le formulaire
      _formkey.currentState?.reset();
      //met la chaine de caractère error à vide
      error ='';

      nameController.text = '';
      numberController.text='';
      confirmPasswordController.text='';
      emailController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading? const Loading(): Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 234, 234),
      extendBodyBehindAppBar: true,
       
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation:0,

        leading: 
        
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color:Color.fromARGB(255, 33, 32, 32),
          ),
          onPressed: (){
            
            Navigator.push(
              context, 
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Visiteur()
              )
            );
          },
        ),


      ),

      

      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fond3.png"),
                fit: BoxFit.cover,
              ),
            )
          ),

          SingleChildScrollView(
            child:  Center (child:Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                key: _formkey, 
                child: Column(
                  children: [
                    Image.asset("assets/inkartassets/4.png",
                      height: 250,
                    ),
                   
                    DelayedAnimation(
                      delay: 1500, 
                      child: !showSignIn

                      //Inscription########################################
                      ? Container(
                        height:780,
                        padding: const EdgeInsets.all(15),
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
                          children: <Widget>[

                            const SizedBox(height: 15),

                            Text('INSCRIPTION',
                              style: GoogleFonts.aBeeZee(
                                
                                fontSize: 20,
                                color: const Color.fromARGB(233, 25, 30, 82),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Votre nom d'artiste",
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                
                              ),
                              validator: (val) => val!.isEmpty? 'Entrez votre nom':null,
                            ),
                            const SizedBox(height: 15),

                            // todo gérer les entrées téléphone///

                            IntlPhoneField(
                              controller: numberController,
                              initialCountryCode: "CM",
                              onChanged:(value){
                                print(value.completeNumber);
                                number = value.completeNumber;
                              },
                            ),

                            const SizedBox(height: 15),
                            
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Votre email',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                
                              ),
                              validator: (val) => val!.isEmpty? 'Entrez votre email':null,
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Votre mot de passe',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                suffixIcon: IconButton(
                                  icon:const Icon(
                                    Icons.visibility,
                                    color:Colors.black,
                                    
                                  ),
                                  onPressed: (){
                                    //eviter de rafraîchir le widget
                                    setState(() {
                                      _obscureText =!_obscureText;
                                    });
                                  },
                                )
                              ),
                              onChanged: (val) => password = val,
                              validator: (val) => val!.length < 6? 'votre mot de passe doit être plus de 6 caractères':null,
                            ),
                            
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'confirmer le mot de passe',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                suffixIcon: IconButton(
                                  icon:const Icon(
                                    Icons.visibility,
                                    color:Colors.black,
                                    
                                  ),
                                  onPressed: (){
                                    //eviter de rafraîchir le widget
                                    setState(() {
                                      _obscureText =!_obscureText;
                                    });
                                  },
                                )
                              ),
                              onChanged: (val) => ConfirmPassword = val,
                              validator: (val) => ConfirmPassword != password ? 'Mot de passe ne correspond pas':null,
                            ),

                            const SizedBox(height: 25),

                           // crée le boutton
                            ElevatedButton.icon(
                              
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              icon: const Icon(Icons.lock_open, size:20),
                              //swicht entre les pages
                              onPressed: ()async{
                                if (_formkey.currentState!.validate()) {
                                  setState(() => loading = true);

                                  //recupère les champs de texte
                                  var name = nameController.value.text;
                                  var number = numberController.value.text;
                                  var password = passwordController.value.text;
                                  var email = emailController.value.text;

                                  // todo gérer les entrées téléphone///
                                  //if (number.startsWith("+23769") || number.startsWith("+23767") || number.startsWith("+23768") ||number.startsWith("+23765") ) {
                                    
                                  
                                  //Effectuez une requête pour récupérer les informations des l'utilisateurs
                                  final users = await FirebaseFirestore.instance.collection('utilisateurs').get();
                                  
                                  if (users.docs.isNotEmpty) {
                                    var documentSnapshot = users.docs[0];
                                    var data = documentSnapshot.data();

                                    if (name == data['name'] || number == data['number'] ) {
                                      setState(() {
                                        loading = false;
                                        error = 'Ces données existent déjà';
                                      });
                                      
                                    }
                                    else{
                                      //faire appel à firebase
                                      dynamic result = showSignIn 
                                      ? await _auth.signInWithEmailAndPassword(email, password)
                                      : await _auth.registerWithEmailAndPassword(name,number,email, password);
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error = 'Entrez les données correctes';
                                        });
                                      }
                                    }
                                    
                                  }else{
                                    setState(() {
                                      loading = false;
                                      error = 'Aucun utilisateur existe';
                                    });
                                  }

                                }

                              },
                              label: 
                                const Text("S'inscrire",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),
                            const SizedBox(height: 10),
                            Text(error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12
                              ),
                            ),

                            ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                
                                backgroundColor: Colors.white.withOpacity(0),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              //swicht entre les pages
                              onPressed: ()  => toogleView(),
                              child: 
                                const  Text("Avez-vous déjà un compte?",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),

                            const SizedBox(height: 20),

                            Text("*En activant votre compte, vous aurez droit à un abonnement d'essai gratuit de 30 jours au forfait 'de Découverte' ,après quoi vous serez facturez 50f/jour. vous pouvez vous désinscrire quand vous le souhaiterez!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                               
                                fontSize: 12,
                                color: const Color.fromARGB(255, 150, 149, 149),
                                fontWeight: FontWeight.bold,
                              ),
                            ),


                          ]
                        )
                      )
                      //Inscription########################################

                      //Connexion##########################################
                      :Container(
                        height:500,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(241, 26, 26, 86),
                            width: 2.0,
                            style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(20),
                          
                        ),
                        child: Column(
                          children: <Widget>[

                            const SizedBox(height: 15),

                            Text('CONNEXION',
                              style: GoogleFonts.aBeeZee(
                                
                                fontSize: 20,
                                color: const Color.fromARGB(233, 25, 30, 82),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),
                            
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Votre email',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                
                              ),
                              validator: (val) => val!.isEmpty? 'Entrez votre email':null,
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Votre mot de passe',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                ),
                                suffixIcon: IconButton(
                                  icon:const Icon(
                                    Icons.visibility,
                                    color:Colors.black,
                                    
                                  ),
                                  onPressed: (){
                                    //eviter de rafraîchir le widget
                                    setState(() {
                                      _obscureText =!_obscureText;
                                    });
                                  },
                                )
                              ),
                              onChanged: (val) => password = val,
                              validator: (val) => val!.length < 6? 'votre mot de passe doit être plus de 6 caractères':null,
                            ),
                            
                            const SizedBox(height: 25),

                           // crée le boutton
                            ElevatedButton.icon(
                              
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              icon: const Icon(Icons.lock_open, size:20),
                              //swicht entre les pages
                              onPressed: ()async{
                                if (_formkey.currentState!.validate()) {
                                  setState(() => loading = true);

                                  //recupère les champs de texte
                                  var password = passwordController.value.text;
                                  var email = emailController.value.text;

                                  //faire appel à firebase
                                  dynamic result = showSignIn
                                  ? await _auth.signInWithEmailAndPassword(email, password)
                                  : await _auth.registerWithEmailAndPassword(name,number,email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Entrez les données correctes';
                                    });
                                  }

                                }
                              },
                              label: 
                                const Text("Connexion",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),
                            const SizedBox(height: 10),
                            Text(error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12
                              ),
                            ),

                            ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                
                                backgroundColor: Colors.white.withOpacity(0),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              //swicht entre les pages
                              onPressed: ()  => toogleView(),
                              child: 
                                const  Text("Avez-vous déjà un compte?",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),

                            const SizedBox(height: 20),

                            Text("*En activant votre compte, vous aurez droit à un abonnement d'essai gratuit de 30 jours au forfait 'de Découverte' ,après quoi vous serez facturez 50f/jour. vous pouvez vous désinscrire quand vous le souhaiterez!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                
                                fontSize: 12,
                                color: const Color.fromARGB(255, 150, 149, 149),
                                fontWeight: FontWeight.bold,
                              ),
                            ),


                          ]
                        )
                      )
                      //Connexion##########################################

                    )
                  ]
                )
              )
            )),
          )
        ],
      ),
    );
  }
}
