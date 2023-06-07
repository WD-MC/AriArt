 
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ariart/pageAuth/controlAuth.dart';
import 'package:ariart/pageAuth/v%C3%A9rification.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:ariart/constant/delaiyed_animation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:firebase_auth/firebase_auth.dart';



class Login extends StatefulWidget {


  final Function basculation;
  const Login({super.key,  required this.basculation });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _obscureText = true;

  String? phoneNumber ='';

  //ajout
  bool Loading = false;

  void sendCode(){
    Loading = true;
    setState(() { });
    final auth = FirebaseAuth.instance;
    if (phoneNumber!.isNotEmpty) {
      autPhonenumber(phoneNumber!, 
      onCodeSend: (verificationid,v){
        Loading = false;
        setState(() { });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => Verification(verificationId: verificationid)
        ));
      }, 
      onAutoVerify: (v)async{
        await auth.signInWithCredential(v);
      }, 
      onFailed: (e){
        print("Le code est erroné"); 
      }, 
      autoRetrieval: (v){});
    }
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
            child:Container(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
              child: Form(
                key: _formkey, 
                child: Column(
                  children: [
                    Image.asset("assets/inkartassets/4.png",
                      height: 200,
                    ),

                    const SizedBox(height: 25),

                    DelayedAnimation(
                      delay: 1500, 
                      child: Container(
                        height:430,
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
                            Text("CONNEXION",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                color: const Color.fromARGB(233, 25, 30, 82),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            IntlPhoneField(
                              initialCountryCode: "CM",
                              onChanged:(value){
                                print(value.completeNumber);
                                phoneNumber = value.completeNumber;
                              },
                              decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 10),

                           
          
                            const SizedBox(height: 15),

                            // crée le boutton
                            ElevatedButton(
                              //style: const ButtonStyle(backgroundColor:MaterialStatePropertyAll(Color.fromRGBO(245, 142, 82, 100))),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              //swicht entre les pages
                              //ajout
                              onPressed:Loading ?null:sendCode,
                              //ajout
                              child: Loading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                )
                                :const  Text("Connexion",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),
                            const SizedBox(height: 10),

                            ElevatedButton(
                         
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                            
                                backgroundColor: Colors.white.withOpacity(0),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                          
                              onPressed: (){
                                widget.basculation();
                               
                              }, 
                              child: 
                                const  Text("Avez-vous déjà un compte?",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),

                            const SizedBox(height: 30),

                            Text("*En activant votre compte, vous aurez droit à un abonnement d'essai gratuit de 30 jours au forfait 'de Découverte' ,après quoi vous serez facturez 50f/jour. vous pouvez vous désinscrire quand vous le souhaiterez!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                               
                                fontSize: 12,
                                color: const Color.fromARGB(255, 150, 149, 149),
                                fontWeight: FontWeight.bold,
                              ),
                            ),


                          ],
                        ),
                        
                      )
                    )
                  ],
                )
              )

            ),
          ) ,
          
        ],
      ),
    );
  }
}

