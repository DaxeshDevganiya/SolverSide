import 'dart:convert';

import 'dart:io';

import 'package:assignment_system/domain.dart';
import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:assignment_system/main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostAssignment extends StatefulWidget {
  const PostAssignment({super.key});

  @override
  State<PostAssignment> createState() => _PostAssignmentState();
}

class _PostAssignmentState extends State<PostAssignment> {
  final apiUrl = "$apiDomain/post/assignments";
  final _formfield = GlobalKey<FormState>();
  final Assignmentname = TextEditingController();
  var selectedDate;
  late File selectedFile;
  bool isSelected = false;
  final price = TextEditingController();
  String industryController = "";
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

  Future<void> addAssignment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString("token");
    String jwtToken = token.toString();
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': jwtToken.toString()
    });
    request.files
        .add(await http.MultipartFile.fromPath('files', selectedFile!.path));
    request.fields['assignmentName'] = Assignmentname.text;
    request.fields['industry'] = industryController;
    request.fields['price'] = price.text;
    request.fields['deadlineDate'] = selectedDate;
    var responseData = await request.send();
    print(responseData.statusCode);
    if (responseData.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Assignment Posted Successfully.."),
      ));
    } else if (responseData.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Price Must be Greater than 10"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong please try agian"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = [
      'Web Development',
      'Social media marketing',
      'Mobile solution',
      'Health Care',
      'Mobile Solution'
    ];
    String? selectedItem = 'Web Development';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.arrow_back),
      //   title: Text("Post Assignment"),
      // ),
      backgroundColor: Color(0xff60467A),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Form(
                key: _formfield,
                child: Column(
                  children: [
                    SizedBox(height: 20.00),
                    Text("Request for post Assignment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: Assignmentname,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Assignment Name",
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
                          return "Please enter Assignment Name";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    DateTimeFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Enter Date',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.00)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.00)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      firstDate: DateTime.now().add(const Duration(days: 10)),
                      lastDate: DateTime.now().add(const Duration(days: 40)),
                      initialPickerDateTime:
                          DateTime.now().add(const Duration(days: 20)),
                      onChanged: (DateTime? value) {
                        selectedDate = value.toString();
                      },
                    ),
                    SizedBox(height: 20.00),
                    TextFormField(
                      controller: price,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Price",
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
                          return "Please enter a price";
                        }
                      },
                    ),
                    SizedBox(height: 20.00),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the border radius as needed
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          onPressed: () => _pickFile(),
                          child: Text(
                            "Upload File",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                    ),
                    SizedBox(height: 20.00),
                    DropdownButtonFormField(
                        value: selectedItem,
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20.0,
                                    ))))
                            .toList(),
                        onChanged: (item) => setState(() {
                              selectedItem = item;
                              industryController = selectedItem.toString();
                            })),
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
                              addAssignment();
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ))),
    );
  }
}
