import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:loops/service/calendar_client.dart';
import 'package:loops/service/google_api_client.dart';
import 'package:get/get.dart';

class LoginRepository {
  final FirebaseFirestore authApi = FirebaseFirestore.instance;

  Future<UserCredential> verifyUser(
      {required String email, required String password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: [cal.CalendarApi.calendarScope, ]
    ).signIn();

    final authHeaders = await googleUser!.authHeaders;

    //service utils onto Service locator, will have to worry about extensive coupling later



    /**
     * What am I doing ? I'm generating a service client to then have it available from login to other requests during the course of usage
     * I have a generic Api Client to generate requests, I need to ask back for Calendar permission and carry on those permissions across the usage
     * missing holes() GoogleApiClient is a service/utils, then I have true service like the Calendar with operational methods,
     * I need this client to then send requests to the actual service and retrieve a valid instance of Calendar
     * For extensibility purposes the Google Api Client should be retrievable from the Get Service Locator
     * Get doesn't seem accessible from here
     * Generate Api Client service
     * Store Api Client onto Service Locator Get
     */

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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}