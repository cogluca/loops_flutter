import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:loops/services/calendar_client.dart';
import 'package:loops/services/google_api_client.dart';
import 'package:get/get.dart';

class LoginRepository {
  final FirebaseFirestore authApi = FirebaseFirestore.instance;

  ///signs in with email and password
  Future<UserCredential> verifyUser(
      {required String email, required String password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  ///Signs in through google and includes calendar access permissions on the app
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: [cal.CalendarApi.calendarScope, ]
    ).signIn();

    final authHeaders = await googleUser!.authHeaders;

    //service utils onto Service locator, will have to worry about extensive coupling later


    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential signedInUser =
        await FirebaseAuth.instance.signInWithCredential(credential);


    GoogleAPIClient httpClient = GoogleAPIClient(authHeaders);

    final cal.CalendarApi calendarApi = cal.CalendarApi(httpClient);

    CalendarClient calendarClient = CalendarClient(calendar: calendarApi);

    Get.put(calendarClient);

    Get.put(httpClient);

    return signedInUser;
  }

  ///Signs out by destroying the user authentication instance on firebase
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
