import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;

class SolverAccount extends StatefulWidget {
  const SolverAccount({super.key});

  @override
  State<SolverAccount> createState() => _SolverAccountState();
}

class _SolverAccountState extends State<SolverAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff60467A),
      body: Center(
        child: Text(
          "Account",
          style: TextStyle(
              color: Colors.white, fontSize: 70, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
