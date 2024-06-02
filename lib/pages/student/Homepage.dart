import 'dart:convert';

import 'package:assignment_system/domain.dart';
import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> StudassignmentsFuture;

  @override
  void initState() {
    super.initState();
    StudassignmentsFuture = getStudAssignments();
  }

  Future<void> _refreshAssignments() async {
    setState(() {
      StudassignmentsFuture = getStudAssignments();
    });
  }

  Future<List<dynamic>> getStudAssignments() async {
    const apiUrl = "$apiDomain/showstudAssignments";
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
    return FutureBuilder<List<dynamic>>(
        future: getStudAssignments(),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Color(0xff60467A),
              body: RefreshIndicator(
                  onRefresh: _refreshAssignments,
                  child: FutureBuilder<List<dynamic>>(
                      future: StudassignmentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Center(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0)),
                                height: screenHeight * 1,
                                width: screenWidth * 1,
                                child: ListView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (snapshot.data != null) {
                                      var assignment = snapshot.data?[index];

                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Assignment Name: ${assignment['assignmentName']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Price: ${assignment['price']}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                'Deadline: ${DateFormat.yMd().format(DateTime.parse(assignment['deadlineDate']))}',
                                                style: TextStyle(fontSize: 18)),
                                            SizedBox(height: 10),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                    textStyle:
                                                        MaterialStateProperty
                                                            .all(const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white))),
                                                onPressed: () async {
                                                  final apiUrl =
                                                      "$apiDomain/delete/assignment/${assignment['_id']}";

                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var token = await prefs
                                                      .getString("token");
                                                  String jwtToken =
                                                      token.toString();
                                                  var response = await http
                                                      .delete(Uri.parse(apiUrl),
                                                          headers: {
                                                            'Authorization':
                                                                '$token'
                                                          },
                                                          body: jsonEncode({}));
                                                  var responseDataReq =
                                                      jsonDecode(response.body);
                                                  if (responseDataReq[
                                                          'status'] ==
                                                      200) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          responseDataReq[
                                                              'message']),
                                                    ));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          responseDataReq[
                                                              'message']),
                                                    ));
                                                  }
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Image.network(
                                          "https://img.freepik.com/free-vector/no-data-concept-illustration_114360-2506.jpg");
                                    }
                                  },
                                )),
                          );
                        }
                      })));
        });
  }
}
