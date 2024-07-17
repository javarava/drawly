//import 'package:flutter/material.dart';
import 'dart:io';
import 'package:drawly/src/widgets.dart';
import 'package:flutter/foundation.dart';
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
Future<File> writeDrawing(String filename, List? drawing) async {
  final directory = await getApplicationDocumentsDirectory();
  final localPath = directory.path;

  //Creates the drawings directory if it doesn't exist.
  String drawingsDir = "drawings";
  String relativePath = "$localPath/$drawingsDir";
  await Directory(relativePath).create(recursive: true);

  final file = File('$relativePath/$filename.txt');
  final jsonStr = jsonEncode(drawing);
  debugPrint('File written to: ${file.path}');
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

//Delete a drawing on user's device
Future deleteDrawing(String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = directory.path;
    //Get drawings directory
    String relativePath = "$localPath/drawings";
    final file = File('$relativePath$filename.txt');
    await file.delete();
  } catch (e) {
    debugPrint('An error occurred! $e');
    toastInfoLong('An error occurred!');
  }
}

//Delete a file on user device
Future deleteFile(String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = directory.path;
    //Get file path
    final file = File('$localPath/$filename.txt');
    await file.delete();
  } catch (e) {
    debugPrint('An error occurred! $e');
    toastInfoLong('An error occurred!');
  }
}
