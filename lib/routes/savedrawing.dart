import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';
import '/src/widgets.dart';
import '/src/datastorage.dart';

String? filename;

class SaveDrawing extends StatefulWidget {
  final List jsonContent;
  const SaveDrawing(this.jsonContent, {super.key});

  @override
  State<SaveDrawing> createState() => _SaveDrawingState();
}

class _SaveDrawingState extends State<SaveDrawing> {
  //Set controller
  TextEditingController? filenameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Get drawing content from passed parameter
    List jsonContent = widget.jsonContent;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Save Drawing'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(children: [
            Text(
              'Name drawing',
              style: AppTheme.text16(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: filenameController,
                      onChanged: (value) {
                        setState(() {
                          filename = value;
                        });
                      },
                      style: AppTheme.text16(),
                      decoration: AppTheme.grey1OutlinedFieldWithHint(' '),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: InkWell(
                    child: AppTheme.blackButtonContainer8('Save'),
                    onTap: () {
                      if (filename == '') {
                        toastInfoLong('Please provide a file name.');
                      } else {
                        //Hide keyboard
                        FocusManager.instance.primaryFocus?.unfocus();

                        try {
                          //Save file
                          writeDrawing(filename!, jsonContent);

                          //Initialize file map
                          Map fileMap = {filename: jsonContent};

                          //Add file to allDrawings Provider
                          context.read<UserProvider>().addNewDrawing(fileMap);

                          //Get current drawings
                          List? allDrawings =
                              Provider.of<UserProvider>(context, listen: false)
                                  .allDrawings;

                          //Write all drawings to file
                          writeAllDrawings(allDrawings!);

                          //Display toast message
                          toastInfoLong('Drawing saved!');

                          //Pop route
                          context.pop();
                        } catch (e) {
                          debugPrint('An error occurred! $e');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
