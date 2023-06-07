
import 'package:ariart/pages/Jeux/quizz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen ({super.key});

  @override
  State<QuizScreen > createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen > {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },

      child: Scaffold(
        
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        
          backgroundColor: Colors.white.withOpacity(0),
          elevation:0,
          leading: 
            
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color:Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 530,
                
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0,3), // Décalez l'ombre horizontalement et verticalement
                    ),
                  ],
                  // image: const DecorationImage(
                  //   image: AssetImage("assets/images/fond_quiz.png"),  
                    
                  //   fit: BoxFit.cover
                  // )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset("assets/images/come-accettare.png"),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/ZOJDEB2YCNDI3BGGQAIK7DDTI4.jpg"),  
                          
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Est-ce que tu es un expert en art et culture ?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amarante(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 238, 106, 45),
                      ),
                    ),
                    // Image.asset("assets/images/le_monument_de_la_renaissance_africaine.png",),
                  ],
                ),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                style: ButtonStyle(
                  // minimumSize: MaterialStateProperty.all<Size>(const Size(200, 35)), // Définir la largeur et la hauteur minimales du bouton
                  fixedSize: MaterialStateProperty.all<Size>(const Size(200, 35)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                    
                  ),
                  
                  
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 238, 106, 45)),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context, 
                  //   PageRouteBuilder(
                  //     pageBuilder: (_, __, ___) => const Quizz()
                  //   )
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.play_circle_outline),
                    Text("  Joue maintenant!"),
                  ],
                ) 
              )
            ],
          )
        ),
      )
    );
  }
}