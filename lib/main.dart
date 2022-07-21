import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/navigation_infrastructure/navigation/bindings/controllers/controllers_bindings.dart';
import 'package:loops/navigation_infrastructure/navigation/navigation.dart';
import 'package:loops/presentation/login/login.screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/calendar_client.dart';
import 'firebase_options.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  GetStorage getStorage = Get.put(GetStorage());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

/**
  var _clientID = ClientId(Secret.getId(), "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");
  const _scopes = [cal.CalendarApi.calendarScope];


  await

  await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
    print(client);
    CalendarClient.calendar = cal.CalendarApi(client);
  });
    **/
  runApp(const MyApp());
}

void prompt(String url) async {
  await canLaunch(url) ? launch(url): throw "Could not launch $url";
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Loops',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialBinding: LoginControllerBinding(),
      home: LoginScreen(),
      getPages: Nav.routes,
      //Here I should insert the Google Log in and then be able to switch to another page if the auth process allows me to do so
    );
  }
}



