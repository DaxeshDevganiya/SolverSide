import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;

class SolverPostAssignment extends StatefulWidget {
  const SolverPostAssignment({super.key});

  @override
  State<SolverPostAssignment> createState() => _SolverPostAssignmentState();
}

class _SolverPostAssignmentState extends State<SolverPostAssignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff60467A),
      body: Center(
        child: Text(
          "SolverPostAssignment",
          style: TextStyle(
              color: Colors.white, fontSize: 70, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
