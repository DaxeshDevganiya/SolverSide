import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:assignment_system/domain.dart';
import 'package:assignment_system/download.dart';
import 'package:assignment_system/pages/solver/PostSolverAssignment.dart';
import 'package:assignment_system/pages/solver/navbar.dart';
import 'package:assignment_system/pages/solver/solverAccount.dart';
import 'package:assignment_system/pages/solver/solverDashboard.dart';
import 'package:assignment_system/pages/solver/solverHomepage.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneAssignments extends StatefulWidget {
  const DoneAssignments({super.key});

  @override
  State<DoneAssignments> createState() => _DoneAssignmentsState();
}

class _DoneAssignmentsState extends State<DoneAssignments> {
  var assignmentsFuture = [];
  var isLoading = true;
  late Timer _timer;
  bool isSuccess = false;
  bool isDownloading = false;
  bool isDownloaded = false;
  late File selectedFile;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    getAssignments();
    _timer = Timer.periodic(Duration(minutes: 2), (Timer timer) {
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        isSelected = true;
        selectedFile = File(result.files.single.path!);
        // print("SELECTED FILE ${_selectedFile}");
        // print("Selected File: $_selectedFile");
      });
    } else {
      setState(() {
        selectedFile;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  getAssignments() async {
    const apiUrl = "$apiDomain/doneAssignment";
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
        print(assignmentsFuture);
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
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Done Assignments",
            style: TextStyle(color: Colors.white),
          )),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price: ${assignment['solverPrice']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      'Deadline: ${DateFormat.yMd().format(DateTime.parse(assignment['deadlineDate']))}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
