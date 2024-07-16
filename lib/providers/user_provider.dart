import 'package:flutter/material.dart';
import 'dart:async';
import '/src/datastorage.dart';

class UserProvider with ChangeNotifier {
  Map? loggedinUser;
  String? userID;

  String? userFullName;
  int? userAge;

  List? allDrawings;

  var userDetails = List<Map<String, dynamic>?>.filled(1, {});

  UserProvider() {
    readDetailsFromFile();
    readAllDrawings();
  }

  //Read user details from text file on device
  Future<void> readDetailsFromFile() async {
    try {
      final detailsFile = await readDetailsFile();
      if (detailsFile.isEmpty) {
        //debugPrint('User details file does not exist or empty');
        loggedinUser = null;
        notifyListeners();
      } else {
        loggedinUser = detailsFile;
        //debugPrint('User details from file: $detailsFile');
        notifyListeners();
      }
    } catch (e) {
      debugPrint("An error occurred! Error: ${e.toString()}");
    }

    notifyListeners();
  }

  //Read all drawings from text file on device
  Future<void> readAllDrawings() async {
    try {
      final drawingsFile = await readAllDrawingsFile();
      if (drawingsFile.isEmpty) {
        //debugPrint('Drawings file does not exist or empty');
        allDrawings = [];
        notifyListeners();
      } else {
        allDrawings = drawingsFile;
        //debugPrint('Drawings file from file: $drawingsFile');
        notifyListeners();
      }
    } catch (e) {
      debugPrint("An error occurred! Error: ${e.toString()}");
    }

    notifyListeners();
  }

  Map? get lUser => loggedinUser;

  bool get isLoggedIn => loggedinUser != null;

  String get fullname => userFullName!;

  List<Map<String, dynamic>?> get details => userDetails;

  int get age => userAge!;

  List? get drawings => allDrawings;

  //Set user
  void setUser(Map? user) {
    loggedinUser = user;
    userID = user!['id'];
    userFullName = user['full_name'];
    userAge = user['age'];
    notifyListeners();
  }

  //Logout User
  void logOut() async {
    loggedinUser = null;
    userID = null;
    userFullName = null;
    userDetails[0] = {};

    notifyListeners();
  }

  //Set user first name
  void addUserFullName(String item) {
    userFullName = (item);
    notifyListeners();
  }

  //Set user details
  void addUserDetails(Map<String, dynamic>? item) {
    userDetails[0] = (item);
    notifyListeners();
  }

  //Update user details
  void updateUserDetails(key, newvalue) {
    userDetails[0]!.update(key, (value) => newvalue);
    notifyListeners();
  }

  //Set user age
  void addUserAge(int item) {
    userAge = (item);
    notifyListeners();
  }

  //Update user details
  void addAllDrawings(List drawings) {
    allDrawings = drawings;
    notifyListeners();
  }

  //add a new drawing line to all drawings
  void addNewDrawing(Map? item) {
    allDrawings!.add(item);
    notifyListeners();
  }
}
