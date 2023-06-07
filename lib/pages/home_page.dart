import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'visiteur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      

      body: SingleChildScrollView (
        
        child: currentWidth<650 
        ?Column(
          children: [

            Container(
              color: Colors.black,
              height: 470,
              child: Column(
                children: [
                  SvgPicture.asset("assets/inkartassets/logo.svg"),
                  MySlider()
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text("Bienvenue sur AriArt",
              textAlign: TextAlign.center,
              style: GoogleFonts.gabriela(
              
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text("La galerie qui vit",
              textAlign: TextAlign.center,
                style: GoogleFonts.gaegu(
                  
                  fontSize: 18,
                  color: const Color.fromARGB(255, 150, 149, 149),
                ),
            ),

            const SizedBox(height: 25),
          
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
                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const Visiteur()
                  )
                );
              },
              child: const Text('Découvrir'),
            )


          ],
        )
        :Column(
          children: [

            Container(
              color: Colors.black,
              height: 900,
              child: Column(
                children: [
                  SvgPicture.asset("assets/inkartassets/logo.svg",
                    height: 443,
                    width: 773,
                  ),
                  MySlider()
                ],
              ),
            ),

            const SizedBox(height: 50),

            Text("Bienvenue sur AriArt",
              textAlign: TextAlign.center,
              style: GoogleFonts.gabriela(
              
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("La galerie qui vit",
              textAlign: TextAlign.center,
                style: GoogleFonts.gaegu(
                  
                  fontSize: 18,
                  color: const Color.fromARGB(255, 150, 149, 149),
                ),
            ),

            const SizedBox(height: 50),
          
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                  
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10,left: 90,right: 90,bottom: 10)),
                
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const Visiteur()
                  )
                );
              },
              child: const Text('Découvrir',
                style: TextStyle(
                  fontSize: 15
                ),
              ),
            )


          ],
        )
      ),


    );
    
  }
}




class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  

  final List description = [

    'assets/inkartassets/AriArtEcoutez.png', 
    'assets/inkartassets/AriArtScanQr.png',
    'assets/inkartassets/AriArtRegarder.png',

  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: description.map((oeuvre) {
        return Container(
                height: 220,
                //color:Colors.green,
                child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(oeuvre,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
              );
      }).toList(),
    );
  }
}




