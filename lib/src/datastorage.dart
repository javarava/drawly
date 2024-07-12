//import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

//Write user details in a text file on user's device
Future<File> writeDetails(Map<dynamic, dynamic> detailsMap) async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/details.txt');
  final jsonStr = jsonEncode(detailsMap);
  //debugPrint('Details written to file! $jsonStr');
  // Write the file
  return file.writeAsString(jsonStr);
}

//Read user details from details.txt file on user's device
Future<Map<String, dynamic>> readDetailsFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/details.txt');
  //debugPrint('Details File Path: $localPath/details.txt');
  final jsonStr = await file.readAsString();
  return jsonDecode(jsonStr) as Map<String, dynamic>;
}

//Write all user's drawings in a text file on user's device
Future<File> writeAllDrawings(List? drawings) async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/alldrawings.txt');
  final jsonStr = jsonEncode(drawings);
  //debugPrint('Address written to file!');
  // Write the file
  return file.writeAsString(jsonStr);
}

//Read all user's drawings from drawings.txt file on user's device
Future<List> readAllDrawingsFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/alldrawings.txt');
  //debugPrint('All drawings File Path: $localPath/email.txt');
  final jsonStr = await file.readAsString();
  return jsonDecode(jsonStr);
}

//Write a user drawing in a text file on user's device
Future<File> writeDrawing(String filename, Map? drawing) async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/drawings/$filename.txt');
  final jsonStr = jsonEncode(drawing);
  //debugPrint('Drawing written to file!');
  // Write the file
  return file.writeAsString(jsonStr);
}

//Read a user drawing file from user's device
Future<String> readDrawingFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;
  final file = File('$localPath/drawings/$filename.txt');
  //debugPrint('Drawing File Path: $localPath/pin.txt');
  final jsonStr = await file.readAsString();
  return jsonDecode(jsonStr);
}
