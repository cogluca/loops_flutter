import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepository {
  
  final FirebaseFirestore authApi = FirebaseFirestore.instance;

  //TODO Might have to wrap instances all together in a service module to be retrieved as single istances, otherwise I have my whole app with multiple instances being called around
  Future<UserCredential> verifyUser (
      {required String email, required String password}) async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential signedInUser = await FirebaseAuth.instance.signInWithCredential(credential);

    return signedInUser;


  }
}
