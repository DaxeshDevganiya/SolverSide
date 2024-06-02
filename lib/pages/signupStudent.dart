import 'dart:convert';

import 'package:assignment_system/domain.dart';
import 'package:assignment_system/pages/login.dart';
import 'package:assignment_system/pages/signupSolver.dart';
import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final apiUrl = "$apiDomain/signup";
  final _formfield = GlobalKey<FormState>();
  final fistnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String userType = "student";

  Future<void> addUser() async {
    var response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstname": fistnameController.text,
          "lastname": lastnameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "role": userType,
          "industry": "-",
        }));

    // var data=jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message']),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      var responseData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message']),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Signup()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff60467A),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Form(
                key: _formfield,
                child: Column(
                  children: [
                    SizedBox(height: 50.00),
                    Text("Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: fistnameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "FirstName",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter firstname";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: lastnameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "LastName",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Lastname";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Password";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    SizedBox(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.4,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          onPressed: () {
                            if (_formfield.currentState!.validate()) {
                              addUser();
                            }
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                    ),
                    SizedBox(height: 20.00),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text("Already have account ? click here",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.00,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 20.00),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupSolver()));
                      },
                      child: Text("Do you want join as Solver ? click here",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.00,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ))),
    );
  }
}
