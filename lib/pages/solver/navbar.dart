import 'dart:convert';

// import 'package:assignment_system/ChangePassword.dart';
import 'package:assignment_system/ChangePassword.dart';
import 'package:assignment_system/EmailPage.dart';
import 'package:assignment_system/domain.dart';
import 'package:assignment_system/pages/solver/AccpetedAssignment.dart';
import 'package:assignment_system/pages/solver/DoneAssignment.dart';
import 'package:assignment_system/pages/solver/SolverHomepage.dart';
import 'package:assignment_system/pages/solver/PostSolverAssignment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late String firstname = '';
  late String lastname = '';
  late String profilepic = '';
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    const apiUrl = "$apiDomain/getUserInfo";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString("token");
    String jwtToken = token.toString();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': '$token'},
    );
    var responseData = jsonDecode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var data = responseData['data'];
      setState(() {
        firstname = data['firstname'];
        lastname = data['lastname'];
        const String apiDomain = "http://192.168.0.27:3000/uploads/";
        profilepic = apiDomain + data['profilepic'];
      });
      // firstname = responseData['data']['firstname'];
      // print(firstname);
      // lastname = responseData['data']['lastname'];
      // profilepic = "{$fileupload}" + responseData['data']['profilepic'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: GFAvatar(
                      backgroundImage: NetworkImage(profilepic),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "$firstname $lastname",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text('View Assignments'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SolverHomePage()),
              );
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.upload),
            title: Text('Upload Assignments'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccpetedAssignment()),
              );
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Done Assignments'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DoneAssignments()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.account_circle),
          //   title: Text('Profile Management'),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.key),
            title: Text('Change Password'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswod()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Email()),
              );
            },
          ),
        ],
      ),
    );
  }
}
