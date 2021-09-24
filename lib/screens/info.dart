import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:first_dgapp/models/usermodel.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<UserModel> details = List<UserModel>();

  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  // List data;
// users.add(User(firstName : ));

  usersDetails() async {
    ByteData data = await rootBundle.load("assets/users.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);

      for (var row in excel.tables[table].rows) {
        print("$row this is next>>>>");
        UserModel userModel = new UserModel();
        userModel.firstName = row[0];
        userModel.lastName = row[1];
        userModel.email = row[2];
        userModel.password = row[3];

        details.add(userModel);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    usersDetails();
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

  // void UsersStream() async {
  //   await for (var snapshot in _firestore.collection('Users').snapshots()) {
  //     for (var User in snapshot.documents) {
  //       print(User.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                child: usersDetails(),
              )
            ],
          ),
        ),

        // body: Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         StreamBuilder<QuerySnapshot>(
        //             stream: _firestore.collection('Users').snapshots(),
        //             builder: (context, snapshot) {
        //               if (!snapshot.hasData) {
        //                 return Center(
        //                   child: CircularProgressIndicator(
        //                     backgroundColor: Colors.lightBlueAccent,
        //                   ),
        //                 );
        //               }
        //               final Users = snapshot.data.documents;
        //               List<Text> userWidgets = [];
        //               for (var User in Users) {
        //                 final UserFname = User.data['first name'];
        //                 final UserEmail = User.data['email'];
        //                 final userWidget = Text(
        //                   '$UserFname from $UserEmail',
        //                   style: TextStyle(fontSize: 20),
        //                 );
        //                 userWidgets.add(userWidget);
        //               }
        //               return Expanded(
        //                 child: ListView(
        //                   padding: EdgeInsets.symmetric(
        //                       horizontal: 10, vertical: 10),
        //                   children: userWidgets,
        //                 ),
        //               );
        //             })
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
