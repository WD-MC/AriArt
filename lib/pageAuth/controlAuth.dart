import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
void autPhonenumber(String phone,
  
  {required Function(String value, int? value1)onCodeSend,
  required Function(PhoneAuthCredential value) onAutoVerify,
  required Function(FirebaseAuthException value) onFailed,
  required Function(String value) autoRetrieval}) async {
  //final auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 20),
    //fait  une verification automatique
    verificationCompleted: onAutoVerify,
    verificationFailed: onFailed, 
    codeSent: onCodeSend, 
    codeAutoRetrievalTimeout: autoRetrieval
  );
}

Future <void> validateOTP(String smsCode, String VerificationId)async{
  
  final _credential = PhoneAuthProvider.credential(
    verificationId: VerificationId, smsCode: smsCode
  );
  await _auth.signInWithCredential(_credential);
  return;
}