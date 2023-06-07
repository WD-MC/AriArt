
import 'package:ariart/Artistes/add_oeuvre.dart';
import 'package:ariart/Artistes/profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ariart/Artistes/add_exposition.dart';
// import 'package:ariart/pageAuth/connexion.dart';
import 'package:ariart/pageAuth/services/authentification.dart';
import 'package:ariart/pages/generate/qrgenerator.dart';

import 'package:ariart/pages/mode_version.dart';
import 'package:ariart/pages/visiteur.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ariart/pageAuth/liaisonAuth.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'package:ariart/Artistes/movies.dart';



class Artistes extends StatefulWidget {
  const Artistes({super.key});

  @override
  State<Artistes> createState() => _ArtistesState();
}
class _ArtistesState extends State<Artistes> {

  final AuthenticationService _auth = AuthenticationService();
  
  
  @override
  Widget build(BuildContext context) {

    //recupère l'utilisateur courant
    final user = FirebaseAuth.instance.currentUser!; 

    return DefaultTabController(
      length: 5, 
      child:  Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(163, 25, 30, 82),
          backgroundColor: const Color.fromARGB(226, 26, 26, 26),
          elevation:2,

          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.qr_code_2)),
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.add)),
              Tab(icon: Icon(Icons.add)),
              Tab(icon: Icon(Icons.account_circle)),
            ],
            // labelColor: Colors.yellow,
            indicatorColor: Color.fromARGB(255, 248, 79, 6),
          ),
          centerTitle: true,
          //title: const Text("GALERIE"),

          actions: <Widget>[
            MaterialButton(
              onPressed: ()async{
                await _auth.signOut();
              }, 
              child: const 
                Text("Déconnexion ",
                  style: TextStyle(
                  
                  color: Colors.white,
                ),
              ),
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),

        //menu de navigation
        drawer: const NavigationDrawer(),

        body: const TabBarView(children: [

          CreateScreen(),
          // ma qrCode

          //MaGalerie(),
          MovieScreen(),
          // ma galerie

          // créer une nouvelle exposition
          
          AddExposition(),
          // créer une nouvelle exposition

          // créer une nouvelle oeuvre
          
          AddOeuvre(),
          // créer une nouvelle oeuvre


          
          Profil()
        ]
        ),

        )
      );
  }
}

// class pour gérer la drawer menu
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  //cree une variable
  //final padding = const EdgeInsets.symmetric(horizontal: 20);
 
  @override
  Widget build(BuildContext context){

    
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 214, 212, 212),
        child: ListView(
          padding: EdgeInsets.zero,
          children:<Widget> [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.account_circle,size:90),
               

              ],
            )),

            //const SizedBox(height: 20),

            buildMenuItem(
              text: 'Explorer',
              icon:Icons.explore,
              onCliked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: 'Aller à',
              icon:Icons.g_mobiledata_outlined,
              onCliked: () => selectedItem(context, 0),
            ),
            const Divider(color:Color.fromARGB(179, 114, 109, 109)),

            buildMenuItem(
              text: 'Ma galerie',
              icon:Icons.collections,
              onCliked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: 'Statistiques',
              icon:Icons.auto_graph,
              onCliked: () => selectedItem(context, 2),
            ),
            buildMenuItem(
              text: 'Porte feuille',
              icon:Icons.attach_money,
            ),
            buildMenuItem(
              text: 'Commandes',
              icon:Icons.book,
            ),
            const Divider(color:Color.fromARGB(179, 114, 109, 109)),
            buildMenuItem(
              text: 'Projeter une oeuvre',
              icon:Icons.camera_indoor,
            ),
            buildMenuItem(
              text: 'Rechercher un lieu de vente',
              icon:Icons.location_city,
            ),
            buildMenuItem(
              text: 'Boutique',
              icon:Icons.shopping_basket,
            ),
            buildMenuItem(
              text: 'Services',
              icon:Icons.business,
            ),
            buildMenuItem(
              text: 'Effectuer une visite virtuelle',
              icon:Icons.center_focus_weak,
            ),
            const Divider(color:Color.fromARGB(179, 114, 109, 109)),
            buildMenuItem(
              text: 'langue',
              icon:Icons.language,
            ),
            buildMenuItem(
              text: 'Aide',
              icon:Icons.help,
            ),
            buildMenuItem(
              text: 'Paramètre',
              icon:Icons.settings,
            ),
            const Divider(color:Color.fromARGB(179, 114, 109, 109)),
            buildMenuItem(
              text: 'Contrat de licence',
              icon:Icons.copyright,
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
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Visiteur(),
        ));
      break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Version(),
        ));
      break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Version(),
        ));
      break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Version(),
        ));
      break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Version(),
        ));
      break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => const Version(),
        ));
      break;
    }
  }
}

// class afichage de la galerie
class MaGalerie extends StatefulWidget {
  const MaGalerie({super.key});

  @override
  State<MaGalerie> createState() => _MaGalerieState();
}

class _MaGalerieState extends State<MaGalerie> {

  List images = [
    "assets/images/Peinture.png",
    "assets/images/designmobilier.png",
    "assets/images/illustration.png",
    "assets/images/designmobilier.png",
    "assets/images/peintureabstraite.png",
    "assets/images/decoInterieur.png",
    "assets/images/illustration.png",
    "assets/images/designmobilier.png",
  ];
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        //return Image.asset(images[index], fit: BoxFit.cover);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Version()
              )
            );
          },
          child:ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(images[index],
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          )
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
    );
    
  }
}

