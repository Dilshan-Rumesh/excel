import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_dgapp/screens/info.dart';
import 'package:first_dgapp/widgets/rounded_button.dart';
import 'package:first_dgapp/screens/signIn_screen.dart';
import 'package:first_dgapp/widgets/rounded_password_textfield.dart';
import 'package:first_dgapp/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'body';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getUserDetails() async {
  //   final Users = await _firestore.collection('Users').getDocuments();
  //   for (var User in Users.documents) {
  //     print(User.data);
  //   }
  // }

  // void UsersStream() async{
  //  await for(var snapshot in _firestore.collection('Users').snapshots()){
  //    for(var User in snapshot.documents){
  //      print(User.data);
  //    }
  //  }
  // }

  bool showSpinner = false;
  String email;
  String password;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50, top: 100),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RoundedInputField(
                  onChanged: (value) {
                    email = value;
                  },
                  hintText: 'Email',
                  icon: Icons.person,
                ),
                RoundedPasswordInputField(
                  onChanged: (value) {
                    password = value;
                  },
                  hintText: 'Password',
                  icon: Icons.lock,
                ),
                RoundedButton(
                  text: 'Login',
                  onPressed: () async {
                    // getUserDetails();
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoPage()),
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New User?',
                      style: TextStyle(
                          color: Color(0XFF546E7A),
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(),
                            ));
                      },
                      child: Text(
                        '  Register',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
