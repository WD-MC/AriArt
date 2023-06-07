 
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ariart/pages/visiteur.dart';
import 'package:ariart/constant/delaiyed_animation.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class Register extends StatefulWidget {

  final Function basculation;
  const Register({super.key, required this.basculation});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _obscureText = true;


  String email = '';
  String  nom = '';
  String telephone = '';
  String motDePasse = '';
  String verMdp = '';

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
            //Navigator.pop(context);
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
                        height:800 ,
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
                            Text("INSCRIPTION",
                              style: GoogleFonts.aBeeZee(
                                
                                fontSize: 20,
                                color: const Color.fromARGB(233, 25, 30, 82),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Votre nom',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                )
                              ),
                              validator: (val) => val!.isEmpty? 'Entrez votre nom':null,
                              onChanged: (val) => nom = val,
                            ),
                            const SizedBox(height: 15),

                            
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Votre email',
                                labelStyle: TextStyle(
                                  color: Colors.grey[400]
                                )
                              ),
                              validator: (val) => val!.isEmpty? 'Entrez votre email':null,
                              onChanged: (val) => email = val,
                            ),
                            const SizedBox(height: 15),

                            IntlPhoneField(
                              initialCountryCode: "CM",
                              onChanged:(value){
                                print(value.completeNumber);
                                telephone = value.completeNumber;
                              },
                              decoration:
                                const InputDecoration(
                                  labelStyle: TextStyle(
                                  color: Colors.grey
                                )
                                ),
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
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
                              validator: (val) => val!.length < 6? 'Entrez un mot de passe avec 6 ou plus des caractères':null,
                              onChanged: (val) => motDePasse = val,
                              
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Confirmez le mot de passe',
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
                              onChanged: (val) => verMdp = val,
                              validator: (val) => verMdp != motDePasse ? 'Mot de passe ne correspond pas':null,
                            ),
                            const SizedBox(height: 40),

                            // crée le boutton
                            ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              //swicht entre les pages
                              onPressed: (){
                               
                              }, 
                              child: 
                                const  Text("Créer mon compte",
                                style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              )
                            ),
                            const SizedBox(height: 15),

                            ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                               
                                backgroundColor: Colors.white.withOpacity(0),
                                padding: const EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20)
                              ),
                              //swicht entre les pages
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
                                //fontFamily: 'Sticky Candy',
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

