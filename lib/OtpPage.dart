import 'dart:convert';

import 'package:assignment_system/EmailPage.dart';
import 'package:assignment_system/PasswordPage.dart';
import 'package:assignment_system/domain.dart';
import 'package:assignment_system/pages/solver/solverHomepage.dart';

import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;
import 'package:assignment_system/pages/signupSolver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final apiUrl = "$apiDomain/otp/login";
  final _formfield = GlobalKey<FormState>();

  final otpController = TextEditingController();

  Future<void> checkOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = await prefs.getString("email").toString();

    final contact = await prefs.getString("contact").toString();
    final fcmToken = await prefs.getString("fcmToken").toString();
    print("tokenotp" + fcmToken);
    var response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "contact": contact,
          "otp": otpController.text,
          "fcmToken": fcmToken
        }));

    var responseData = jsonDecode(response.body);

    if (responseData['status'] == 200) {
      var role = responseData['Data']['role'];

      var token = responseData["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogin", true);
      // await prefs.setBool('isAuthenticated', true);
      await prefs.setString("token", token);
      await prefs.setString("userId", responseData['Data']["_id"]);
      if (role == "solver") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SolverHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You are not Authorized as Solver to this portal"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message']),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                )),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formfield,
        child: Column(
          children: [
            Container(
              width: screenWidth * 1,
              height: screenHeight * 0.3,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(120),
                  )),
              child: Center(
                child: Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            SizedBox(height: 20.00),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.password),
                        hintText: "Otp",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Otp";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.4,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          onPressed: () {
                            if (_formfield.currentState!.validate()) {
                              checkOtp();
                            }
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
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
                      child: Text("Don't have account ? click here",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.00,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
