
import 'package:ariart/Visiteurs/Visiteurs_oeuvre.dart';
import 'package:ariart/Visiteurs/viewcomment.dart';
import 'package:ariart/pages/Jeux/quizscreen.dart';
import 'package:ariart/pages/video360/panorama.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ariart/Visiteurs/Visiteurs_expo.dart';
import 'package:ariart/pageAuth/mainPageartist.dart';
// import 'package:ariart/pages/generate/qrgenerator.dart';
import 'package:ariart/pages/home_page.dart';

import 'Scanqr.dart';
// import 'package:ariart/Artistes/arprojector.dart';
// import 'package:ariart/Artistes/place.dart';
// import 'package:ariart/Artistes/boutique.dart';
// import 'package:ariart/Artistes/service.dart';
// import 'package:ariart/Artistes/VR.dart';


// import 'package:provider/provider.dart';
// import 'package:ariart/pageAuth/models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Visiteur extends StatefulWidget {
  const Visiteur({super.key});

  @override
  State<Visiteur> createState() => _VisiteurState();
}

class _VisiteurState extends State<Visiteur> {

  bool connect = true;

  final ScrollController _scrollController = ScrollController();

  Color appBarColor = Colors.white.withOpacity(0);

 
  @override
  Widget build(BuildContext context) {

 
    return Scaffold(

      extendBodyBehindAppBar: true,

      appBar: AppBar (
        //backgroundColor: Colors.white.withOpacity(0),
        backgroundColor: appBarColor,
        elevation:0,

        iconTheme: connect 
        ?const IconThemeData(
          color:  Colors.black, // couleur de l'icône du drawer
        )
        :const IconThemeData(
          color:  Colors.white, // couleur de l'icône du drawer
        ),

        
        actions: <Widget>[

          
          TextButton(
            
            onPressed: (){
                
                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const MainPageArtist(),
                  )
                );
              
            }, 
            child: connect
            ?const 
              Text("Connexion",
                style: TextStyle(
               
                color:  Colors.black,
              ),
            )
            :
            const 
              Text("Connexion",
                style: TextStyle(
               
                color:  Colors.white,
              ),
            ),
          ),
          
          IconButton(
            icon: connect
            ?const Icon(
              Icons.home,
              color:Colors.black,
            )
            :const Icon(
              Icons.home,
              color:Colors.white,
            ),
            onPressed: (){
              
              Navigator.push(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomePage()
                )
              );
            },
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ],

      ),

      //barre de menu
      drawer: const NavigationDrawer(),
      //barre de menu

      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (scrollNotification) {
          // Change la couleur de fond de l'AppBar en fonction de la position de défilement
          if (scrollNotification.metrics.pixels > 0) {
            setState(() {
              appBarColor = const Color.fromARGB(255, 47, 46, 46);
              connect = false; // votre nouvelle couleur de fond de l'AppBar
            });
          } else {
            setState(() {
              appBarColor = Colors.transparent;
              connect =true; // la couleur de fond transparente de l'AppBar lorsqu'elle est en haut
            });
          }
          return true;
        },
      
        child: screens.elementAt(currentIndex),
      ),
      

      // footer navigation
      bottomNavigationBar:BottomNavigationBar(
        
        unselectedItemColor: const Color.fromARGB(255, 28, 28, 28),
        selectedItemColor: const Color.fromARGB(184, 248, 79, 6),
        type: BottomNavigationBarType.shifting,

        currentIndex: currentIndex,
        onTap: _onItemTapped,

        items:const <BottomNavigationBarItem> [
          
          BottomNavigationBarItem(
            
            icon: Icon(
              Icons.photo_library
            ),
            label: 'Expositions',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(
              Icons.extension_sharp
            ),
            label: 'Oeuvres',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_scanner
            ),
            label: 'Scaner'
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people
            ),
            label: 'commentaires'
          ),

        ]
      ) ,
      // footer navigation
      
    );
  }

  // cree la liste de widget
  
  List<Widget> screens = [
    
    SingleChildScrollView(
      
      child:Center(
        child:Column(
          children:[

            const Padding(padding: EdgeInsets.only(top: 150)),

            Text("COLLECTIONS DISPONIBLES",
            textAlign: TextAlign.center,
              style: GoogleFonts.ptSerifCaption(
                color:const Color.fromARGB(240, 19, 19, 19),
                fontSize: 18,
              )
            ),
            const SizedBox(height: 10),

            
            SvgPicture.asset("assets/inkartassets/divide.svg"),

            const SizedBox(height: 30),
            
            //MenuCategorie(),

            const PageVisiteur(),

          ],
        ),
      ),
    ),
    SingleChildScrollView(
      
      child:Center(
        child:Column(
          children:[

            const Padding(padding: EdgeInsets.only(top: 150)),

            Text("OEUVRES DISPONIBLES",
            textAlign: TextAlign.center,
              style: GoogleFonts.ptSerifCaption(
                color:const Color.fromARGB(240, 19, 19, 19),
                fontSize: 18,
              )
            ),
            const SizedBox(height: 10),

            
            SvgPicture.asset("assets/inkartassets/divide3.svg"),

            const SizedBox(height: 30),

            const VisiteurOeuvre(),

          ],
        ),
      ),
    ),

    // const MenuCategorie(),
    ScanQr(),

   
    const ViewComment()
  ];

  //creer une methode pour la navigation du bottombar
  int currentIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      currentIndex = index;
    });
  }

}

//class pour le dropdown button des catégories
class MenuCategorie extends StatefulWidget {
  const MenuCategorie({super.key});

  @override
  State<MenuCategorie> createState() => _MenuCategorieState();
}

class _MenuCategorieState extends State<MenuCategorie> {
  
  // creer le constructeur de la classe
  _MenuCategorie(){
    _selectedVal = _productSizesList[0];
  }

  // variables
  final _productSizesList= [
    "Toutes les catégories",
    "Peinture", 
    "Illustrations", 
    "Dessin murale", 
    "Peinture abstraite", 
    "Décoration d'intérieur", 
    "Fashion et design de mode", 
    "Design d'objets et mobiliers", 
    "Design fer forge"
  ];
  
  String? _selectedVal = "Toutes les catégories";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 100)),
            Text("OEUVRES DISPONIBLE",
            textAlign: TextAlign.center,
              style: GoogleFonts.ptSerifCaption(
                color:const Color.fromARGB(240, 19, 19, 19),
                fontSize: 18,
              )
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: 
              // dropdown button pour les catégories
              DropdownButtonFormField(
                value: _selectedVal,
                items: _productSizesList.map(
                  (e) => DropdownMenuItem(child:Text(e), value: e,)
                ).toList(), 
                onChanged: (val){
                  setState(() {
                    _selectedVal = val as String; 
                  });
                },

                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color:Color.fromARGB(184, 248, 79, 6),
                ),

                dropdownColor: Colors.deepPurple.shade50,

                decoration: const InputDecoration(
                  labelText: "catégories",
                  prefixIcon: Icon(
                    Icons.category,
                    color:Color.fromARGB(184, 248, 79, 6),
                  ),
                  border: OutlineInputBorder()
                ),
              ),
            )
            
          ],
        ),
      ),
    );
    
  }
}

// class pour gérer la drawer menu
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

 

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 214, 212, 212),
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget> [
            
            // entête du drawer
            const DrawerHeader(
              decoration: BoxDecoration(
               
                image: DecorationImage(
                  image: AssetImage("assets/inkartassets/4.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: 
                Text("",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  )
                ),
              
            ),

            const SizedBox(height: 20),
            buildMenuItem(
              text: 'Mes collections',
              icon:Icons.collections,
              onCliked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: 'langue',
              icon:Icons.language,
              onCliked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: 'Aide',
              icon:Icons.help,
              onCliked: () => selectedItem(context, 2),
            ),
            buildMenuItem(
              text: 'Paramètre',
              icon:Icons.settings,
              onCliked: () => selectedItem(context, 3),
            ),
            const Divider(color:Color.fromARGB(179, 114, 109, 109)),
            buildMenuItem(
              text: "Je découvre l'art",
              icon:Icons.games_outlined,
              onCliked: () => selectedItem(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onCliked,
  }){
    const color = Color.fromARGB(241, 26, 26, 86);
    const hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color:color),
      title: Text(text, style:const TextStyle(color:color)),
      hoverColor: hoverColor,
      onTap: onCliked ,
    );
  }

  void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop();
    switch(index){
      case 0:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder:(context) =>  PanoramaText(),
        // ));
      break;
      // case 1:
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder:(context) => const Place(),
      //   ));
      // break;
      // case 2:
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder:(context) => const Boutique(),
      //   ));
      // break;
      // case 3:
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder:(context) => const Service(),
      //   ));
      // break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const QuizScreen(),
        ));
      break;
    }
  }
}