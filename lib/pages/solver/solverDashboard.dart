import 'dart:convert';

import 'package:assignment_system/pages/solver/AccpetedAssignment.dart';
import 'package:assignment_system/pages/solver/PostSolverAssignment.dart';
import 'package:assignment_system/pages/solver/solverHomepage.dart';
import 'package:assignment_system/pages/student/Account.dart';
import 'package:assignment_system/pages/student/Homepage.dart';
import 'package:assignment_system/pages/student/PostAssignment.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;

class SolverDashBoard extends StatefulWidget {
  const SolverDashBoard({super.key});

  @override
  State<SolverDashBoard> createState() => _SolverDashBoardState();
}

class _SolverDashBoardState extends State<SolverDashBoard> {
  int index = 0;
  final List<Widget> screens = [
    SolverHomePage(),
    SolverPostAssignment(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff60467A),
        extendBody: true,
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          height: 60,
          index: index,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 600),
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.add, size: 30),
              label: 'Post',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.account_circle, size: 30),
              label: 'Account',
            ),
          ],
          onTap: (index) => setState(() => this.index = index),
        ));
  }
}
