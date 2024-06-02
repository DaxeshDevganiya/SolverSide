import 'dart:async';
import 'dart:convert';

import 'package:assignment_system/domain.dart';
import 'package:assignment_system/pages/solver/AccpetedAssignment.dart';
import 'package:assignment_system/pages/solver/PostSolverAssignment.dart';
import 'package:assignment_system/pages/solver/navbar.dart';
import 'package:assignment_system/pages/solver/solverAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

class SolverHomePage extends StatefulWidget {
  const SolverHomePage({super.key});

  @override
  State<SolverHomePage> createState() => _SolverHomePageState();
}

class _SolverHomePageState extends State<SolverHomePage>
    with SingleTickerProviderStateMixin {
  bool feed = true;
  bool Accpeted = false;
  bool done = false;
  var assignmentsFuture = [];
  var isLoading = true;
  late Timer _timer;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    getAssignments();
    _tabController = TabController(length: 3, vsync: this);
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() {
        assignmentsFuture = getAssignments();
      });
    });
  }

  Future<void> _refreshAssignments() async {
    setState(() {
      assignmentsFuture = getAssignments();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  getAssignments() async {
    const apiUrl = "$apiDomain/showAssignments";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString("token");
    String jwtToken = token.toString();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': '$token'},
    );
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('data')) {
        // If the 'data' key exists, extract the list from it
        final dataList = jsonData['data'];
        setState(() {
          assignmentsFuture = dataList;
          isLoading = false;
        });
        return dataList;
      } else {
        // If 'data' key is missing, throw an exception
        throw Exception('Data key is missing in the response');
      }
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
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
            title: Text(
              "Homepage",
              style: TextStyle(color: Colors.white),
            )),
        drawer: NavBar(),
        body: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
            child: isLoading
                ? Center(
                    child: GFLoader(
                      type: GFLoaderType.circle,
                      loaderColorOne: Colors.blue,
                      loaderColorTwo: Colors.blue,
                      loaderColorThree: Colors.blue,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: assignmentsFuture.length,
                    itemBuilder: (BuildContext context, int index) {
                      var assignment = assignmentsFuture[index];

                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assignment Name: ${assignment['assignmentName']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Price : \$${assignment['solverPrice']}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Text(
                                'Deadline: ${DateFormat.yMd().format(DateTime.parse(assignment['deadlineDate']))}',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        textStyle: MaterialStateProperty.all(
                                            const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white))),
                                    onPressed: () async {
                                      final apiUrl =
                                          "$apiDomain/sendAssSolvereq/${assignment['_id']}";

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var token =
                                          await prefs.getString("token");
                                      String jwtToken = token.toString();
                                      var response = await http.put(
                                          Uri.parse(apiUrl),
                                          headers: {'Authorization': '$token'},
                                          body: jsonEncode({}));
                                      var responseDataReq =
                                          jsonDecode(response.body);
                                      if (responseDataReq['status'] == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text(responseDataReq['message']),
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text(responseDataReq['message']),
                                        ));
                                      }
                                    },
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                        textStyle: MaterialStateProperty.all(
                                            const TextStyle(
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1)))),
                                    onPressed: () {},
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )));
  }
}
