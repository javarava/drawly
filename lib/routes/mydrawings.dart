import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';
import '/src/widgets.dart';
import '/src/datastorage.dart';
import '/routes/mycanvas.dart';

List? myDrawings;

class MyDrawings extends StatefulWidget {
  const MyDrawings({super.key});

  @override
  State<MyDrawings> createState() => _MyDrawingsState();
}

class _MyDrawingsState extends State<MyDrawings> {
  @override
  Widget build(BuildContext context) {
    //Get user data from provider
    myDrawings = context.watch<UserProvider>().allDrawings;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('My Drawings'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //List drawings
              myDrawings != null || myDrawings!.isEmpty
                  ? ListView.separated(
                      // render the list
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myDrawings!.length,
                      itemBuilder: (BuildContext context, int index) {
                        String filename =
                            myDrawings![index].keys.toList().first;
                        var content = myDrawings![index][filename];
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 8),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Image(
                                                fit: BoxFit.fitHeight,
                                                image: AssetImage(
                                                    'assets/images/drawly-gray.png'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              child: Text(
                                                filename,
                                                style: AppTheme.text20Bold(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        //display file in canvas

                                        //context.go('/my-canvas', extra: content);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                MyCanvas(
                                              list: content,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: InkWell(
                                      child: Icon(
                                        MdiIcons.fromString('delete'),
                                        size: 24,
                                        color: drawlyBlack.shade300,
                                      ),
                                      onTap: () {
                                        //show delete alert dialog
                                        showDeleteAlertDialog(
                                            context, filename);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              /* (myDrawings![index] != myDrawings!.length - 1)
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        dividerGray1(),
                                        const SizedBox(height: 5),
                                      ],
                                    )
                                  : Container(), */
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          dividerGray1(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        'You don\'t have any saved drawings.',
                        style: AppTheme.text16Bold(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  //Delete Drawing Alert Dialog
  showDeleteAlertDialog(
    BuildContext context,
    String filename,
  ) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: AppTheme.text16Bold(),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: AppTheme.text16Bold(),
      ),
      onPressed: () async {
        try {
          //Remove drawing from provider
          List? allDrawings =
              Provider.of<UserProvider>(context, listen: false).allDrawings;

          //Loop through List to delete drawing with filename
          for (var drawing in allDrawings!) {
            if (drawing.keys.toList().first == filename) {
              allDrawings.remove(drawing);
            }
          }

          //write new version to Provider
          context.read<UserProvider>().addAllDrawings(allDrawings);

          //write all drawings to file
          writeAllDrawings(allDrawings);

          //delete the file
          deleteDrawing(filename);

          //display toast message
          toastInfoLong('$filename deleted!');

          Navigator.of(context, rootNavigator: true).pop();

          //setState
          setState(() {});

          //pop route
        } catch (e) {
          debugPrint('An error occurred during signout! $e');

          //display toast message
          toastInfoLong('An error occurred');

          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Delete $filename',
        style: AppTheme.text20Bold(),
      ),
      content: Text(
        'Are you sure you want to delete $filename?',
        style: AppTheme.text16(),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
