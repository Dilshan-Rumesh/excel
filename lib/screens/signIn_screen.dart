import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_dgapp/constants.dart';
import 'package:first_dgapp/screens/body.dart';
import 'package:first_dgapp/screens/rounded_button.dart';
import 'package:first_dgapp/widgets/department_items.dart';
import 'package:first_dgapp/widgets/education_list.dart';
import 'package:first_dgapp/widgets/rounded_password_textfield.dart';
import 'package:first_dgapp/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'regpage';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

DateTime date;

class _RegistrationPageState extends State<RegistrationPage> {
  File _image;

  Future _imgFromCamera() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = (_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploadNew/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done: $value");
      imageUrl = value;
    });
  }
  //

  String selectedDepartment = 'Non';
  String selectedGendar = 'Male';
  String selectedEducation = 'Non';
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String fname;
  String lname;
  String phoneNo;
  String uCode;
  String bDay;
  String department;
  String gender;
  String eduction;
  String imageUrl;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

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

  String getText() {
    if (date == null) {
      return 'Birth Day';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  //
  List<DropdownMenuItem> getDropdownItems() {
    //
    List<DropdownMenuItem<String>> dropdownItems = [];
    //
    for (String department in departmentList) {
      // String department = departmentList[i];
      var newItem = DropdownMenuItem(
        //
        child: Text(department),
        value: department,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  List<DropdownMenuItem> getDropdownItemsEdu() {
    //
    List<DropdownMenuItem<String>> dropdownItems1 = [];
    //
    for (String education in educationList) {
      // String department = departmentList[i];
      var newItem1 = DropdownMenuItem(
        //
        child: Text(education),
        value: education,
      );
      dropdownItems1.add(newItem1);
    }
    return dropdownItems1;
  }

  @override
  Widget build(BuildContext context) {
    getDropdownItems();
    getDropdownItemsEdu();
    Future pickDate(BuildContext context) async {
      final initialDate = DateTime.now();
      final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (newDate == null) return;
      setState(() => date = newDate);
    }

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/user.png'),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Align(
                            alignment: Alignment(1, 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                    // _image != null ? _image : AssetImage('assets/user.png'),
                    // child: Align(
                    //   alignment: Alignment(1, 1),
                    //   child: CircleAvatar(
                    //     // radius: 20,
                    //     // backgroundColor: Color(0XFFBDBDBD),
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         _showPicker(context);
                    //       },
                    //       child: CircleAvatar(
                    //         radius: 55,
                    //         backgroundColor: Color(0xffFDCF09),
                    //         // child: _image != null
                    //         //     ? ClipRRect(
                    //         //         borderRadius: BorderRadius.circular(50),
                    //         //         child: Image.file(
                    //         //           _image,
                    //         //           width: 100,
                    //         //           height: 100,
                    //         //           fit: BoxFit.fitWidth,

                    //         //         ),
                    //         //       )
                    //         //     : Container(
                    //         //         decoration: BoxDecoration(
                    //         //             color: Colors.grey[200],
                    //         //             borderRadius: BorderRadius.circular(50)),
                    //         //         width: 100,
                    //         //         height: 100,
                    //         //         child: Icon(
                    //         //           Icons.camera_alt,
                    //         //           color: Colors.grey[800],
                    //         //         ),
                    //         //       ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedInputField(
                      onChanged: (value) {
                        fname = value;
                      },
                      icon: Icons.person,
                      hintText: 'First Name',
                    ),
                    RoundedInputField(
                      onChanged: (value) {
                        lname = value;
                      },
                      icon: Icons.person,
                      hintText: 'Last Name',
                    ),
                    RoundedInputField(
                      onChanged: (value) {
                        phoneNo = value;
                      },
                      icon: Icons.phone,
                      hintText: 'Phone',
                    ),
                    RoundedInputField(
                      onChanged: (value) {
                        uCode = value;
                      },
                      icon: Icons.format_list_numbered,
                      hintText: 'User Code',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getText(),
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          GestureDetector(
                              onTap: () => pickDate(context),
                              child: Icon(
                                Icons.calendar_today,
                                color: kPrimaryColor,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Department',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedDepartment,
                                //
                                items: getDropdownItems(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartment = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Gendar',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedGendar,
                                //
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Male'),
                                    value: 'Male',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Female'),
                                    value: 'Female',
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedGendar = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Education',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedEducation,
                                //
                                items: getDropdownItemsEdu(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedEducation = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    RoundedInputField(
                      icon: Icons.email,
                      hintText: 'Email',
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    RoundedInputField(
                      onChanged: (value) {
                        email = value;
                      },
                      icon: Icons.email,
                      hintText: 'Confirm Email',
                    ),
                    RoundedPasswordInputField(
                      onChanged: (value) {
                        password = value;
                      },
                      icon: Icons.lock,
                      hintText: 'Password',
                    ),
                    RoundedPasswordInputField(
                      onChanged: (value) {
                        password = value;
                      },
                      icon: Icons.lock,
                      hintText: 'Confirm Password',
                    ),
                    RoundedButton(
                      text: 'Register',
                      onPressed: () async {
                        try {
                          final user =
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          uploadImageToFirebase(context);

                          if (user != null) {
                            _firestore.collection('Users').add({
                              'first name': fname,
                              'last name': lname,
                              'birthday': date,
                              'email': email,
                              'confirm email': email,
                              'password': password,
                              'confirm password': password,
                              'department': selectedDepartment,
                              'education': selectedEducation,
                              'gender': selectedGendar,
                              'phone no': phoneNo,
                              'user code': uCode,
                              'image': imageUrl,
                            });

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Body()),
                            // );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account?',
                          style: TextStyle(
                              color: Color(0XFF546E7A),
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Body(),
                                ));
                          },
                          child: Text(
                            '  Login.',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
