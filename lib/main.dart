import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'login.dart';
import 'menu.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]
    );
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: MaterialApp(
          initialRoute: '/',

          routes: {

            '/login': (context) => LoginPage(),

          },
          
          debugShowCheckedModeBanner: false,
          title: 'Tudu',
          theme: ThemeData(primarySwatch: Colors.cyan),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: 
            (BuildContext context, AsyncSnapshot<User?> snapshot)
            {
              if (snapshot.hasData)
              {
                print("There is a user logged in");
                return HomePage();
              }
              else
              {
                return LoginPage();
              }
            },
          )
        ),
    )  ;
  }
}
