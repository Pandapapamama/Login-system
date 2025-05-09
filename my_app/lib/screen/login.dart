import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_app/model/profile.dart';
import 'package:my_app/screen/home.dart';
import 'package:my_app/screen/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>(); //Check status form
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //ถ้าเกิดมี error ให้แสดง error
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //เชื่อมต่อสำเร็จให้แสดงหน้าแอป
          return Scaffold(
            appBar: AppBar(title: Text("Login")),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formkey, //connect key with formkey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email", style: TextStyle(fontSize: 20)),
                    TextFormField(
                      //ช่องสำหรับพิมพ์ข้อความ
                      validator:
                          MultiValidator([
                            RequiredValidator(
                              errorText: "Please enter your password.",
                            ), //check blank space
                            EmailValidator(
                              errorText: "Invalid email address",
                            ), //check stlye email
                          ]).call,
                      keyboardType: TextInputType.emailAddress, //Show @
                      onSaved: (String? email) {
                        //Use onSaved to get data
                        profile.email = email; //เก็บค่า email => profile
                      },
                    ),

                    SizedBox(height: 25),
                    Text("Password", style: TextStyle(fontSize: 20)),
                    TextFormField(
                      validator:
                          RequiredValidator(
                            //check blank space
                            errorText: "Please enter your password.",
                          ).call,
                      obscureText: true, //hide password
                      onSaved: (String? password) {
                        profile.password = password;
                      },
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          //save data when press button
                          if (formkey.currentState!.validate()) {
                            //! คือเมื่อไม่ได้รับค่าให้แสดง validate
                            formkey.currentState
                                ?.save(); //ให้แบบฟอร์มเรียก save ทุกตัวใน formfield
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: profile.email ?? "",
                                    password: profile.password ?? "",
                                  )
                                  .then((value) {
                                    formkey.currentState
                                        ?.reset(); //clear formfield
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return WelcomeScreen();
                                        },
                                      ),
                                    );
                                  });
                            } on FirebaseAuthException catch (e) {
                              // จัดการกับ error
                              // print(e.message);
                              // print(e.code);
                              Fluttertoast.showToast(
                                msg: e.message.toString(),
                                gravity: ToastGravity.TOP,
                              );
                            }
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
