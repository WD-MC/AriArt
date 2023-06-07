import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ariart/pages/artistes.dart';


class Verification extends StatefulWidget {
  const Verification({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  //ajout
  String smsCode = "";
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    print(widget.verificationId);  
    return Scaffold(
      body:WillPopScope(
        // empêcher l'utilisateur de faire un retour en arrière
        onWillPop: ()async{
          return true;
        },
        child:Center(
        child:SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Text("VERIFICATION",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(233, 25, 30, 82)
              ),
            ),
            const Text("Consuter vos messages pour valider",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(233, 25, 30, 82)
              ),
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Entrer un code à 6 chiffres',
                labelStyle: TextStyle(
                  color: Colors.grey[400]
                )
              ),
              keyboardType: TextInputType.number,
              validator: (val) => val!.length < 6? 'entrez un code de 6 chiffres':null,
              onChanged: (val) => smsCode = val,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: (){},
                child: const Text("Renvoyer le code") 
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:(const Color.fromARGB(184, 248, 79, 6)),
                    padding: const EdgeInsets.symmetric(vertical:15),
                  ),
                  onPressed:smsCode.length <6?null: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => const Artistes() )
                    );
                  }, 
                  child: loading? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ):const Text("Vérifier",
                    style: TextStyle(fontSize: 20),
                  )
                )
              ],
            )
          ],
        ),
      ),
    )));
  }
}