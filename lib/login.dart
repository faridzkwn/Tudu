import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tudu/menu.dart'; 
import 'package:tudu/misc.dart' show EmailValidator;
import 'menu.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email =' ' , _password=' '  ;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            SizedBox( height: 50),
            Container(
              height: 200,
              child: Image(image: AssetImage("images/Tudu.png"),
              fit: BoxFit.contain,
              ),
            ),
            SizedBox( height: 50),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[


                    Container(
                      child: TextFormField(
                        validator: (input)
                          {
                          if(input!.isEmpty)
                            {
                            return 'Email cannot be empty.';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.mail)
                          ),
                          onSaved: (input) => _email = input.toString(),

                      ),
                    ),
                    Container(
                      child: TextFormField(
                        validator: (input)
                        {
                          if(input!.isEmpty)
                          {
                            return 'Password cannot be empty.';
                          }

                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)
                        ),
                        obscureText: true,
                        onSaved: (input) => _email = input.toString(),

                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          print('Pressed');
                          final form = _formKey.currentState;
                          form?.save();

                          if (form!.validate()) {
                            try {
                              await auth.FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: _email, password: _password);

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                              print('Signed In');
                            } on auth.FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                _showMyDialog(
                                    context, 'No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                                _showMyDialog(context,
                                    'Wrong password provided for that user.');
                              }
                            }
                          }
                        },
                        child: const Text('LOGIN'),

                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff79E0C1),
                            padding: EdgeInsets.only(
                              left: 100.0,
                              right: 100.0
                            ),
                            textStyle: TextStyle(

                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)
                            ),
                        )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> _showMyDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text('Invalid Login'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text(message)],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}
