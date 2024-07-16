import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '/src/theme.dart';
import '/src/drawing_options.dart';
import '/src/datastorage.dart';
import '/src/widgets.dart';
import '/routes/savedrawing.dart';

//current color
Color? currentColor = Colors.red;
Color? pickerColor = Colors.red;
double? currentStrokeWidth = 2.0;

List? sentDrawing;
List? canvasDrawing;

class MyCanvas extends StatefulWidget {
  final List? list;
  const MyCanvas({super.key, this.list});

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  /// Drawing Controller
  final DrawingController drawingController = DrawingController();

  final TransformationController transformationController =
      TransformationController();

  //Selected icon
  int selectedIndex = -1;

  @override
  void dispose() {
    drawingController.dispose();
    super.dispose();
  }

  /// Get artboard data `getImageData()`
  Future<void> getImageData() async {
    final Uint8List? data =
        (await drawingController.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('Failed to obtain image data');
      return;
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => Navigator.pop(c), child: Image.memory(data)),
          );
        },
      );
    }
  }

  /// Get the content of the artboard Json `getJsonList()`
  Future<void> getJson() async {
    jsonEncode(drawingController.getJsonList());

    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return Center(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.pop(c),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 800),
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ')
                      .convert(drawingController.getJsonList()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //CHANGE BACKGROUND COLOR
  Color backgroundColor = Colors.white;
  OverlayEntry? overlayEntry;

  void changeBackgroundColor(Color color) {
    setState(() {
      backgroundColor = color;
      //overlayEntry?.remove();
    });
  }

  void showColorIcons(BuildContext context) {
    overlayEntry = createOverlayEntry(context);
    Overlay.of(context).insert(overlayEntry!);
  }

  //Create overlay entry
  OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            bottom: 100,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  buildColorIcon(Colors.white),
                  buildColorIcon(Colors.green.shade50),
                  buildColorIcon(Colors.blue.shade50),
                  buildColorIcon(Colors.yellow.shade50),
                  buildColorIcon(Colors.purple.shade50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Build Color wudget
  Widget buildColorIcon(Color color) {
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                style: BorderStyle.solid,
                width: 1,
                color: drawlyBlack.shade400,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
            ),
          ),
          onTap: () {
            changeBackgroundColor(color);
            overlayEntry?.remove();
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  //Using FutureBuilder to check if a drawing is passed to Canvas
  Future? loadDrawing() async {
    if (sentDrawing != null) {
      for (var content in sentDrawing!) {
        var type = content['type'];
        if (type == 'SimpleLine') {
          drawingController.addContent(SimpleLine.fromJson(content));
        } else if (type == 'StraightLine') {
          drawingController.addContent(StraightLine.fromJson(content));
        } else if (type == 'SmoothLine') {
          drawingController.addContent(SmoothLine.fromJson(content));
        } else if (type == 'Rectangle') {
          drawingController.addContent(Rectangle.fromJson(content));
        } else if (type == 'Triangle') {
          drawingController.addContent(Triangle.fromJson(content));
        } else if (type == 'Circle') {
          drawingController.addContent(Circle.fromJson(content));
        } else if (type == 'Eraser') {
          drawingController.addContent(Eraser.fromJson(content));
        }
      }
      return sentDrawing!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //Getting optional passed drawing parameter
    sentDrawing = widget.list;

    return FutureBuilder(
      future: loadDrawing(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return DrawingBoard(
                      transformationController: transformationController,
                      controller: drawingController,
                      background: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        color: backgroundColor,
                      ),
                      showDefaultActions: false,
                      showDefaultTools: false,
                    );
                  },
                ),
              ),

              Container(
                width: double.infinity,
                color: drawlyBlack.shade50,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Background color
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(MdiIcons.fromString('format-color-fill')),
                        tooltip: 'Change background color',
                        onPressed: () {
                          showColorIcons(context);
                        },
                      ),
                    ),

                    //Brush color
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.color_lens, color: pickerColor),
                        onPressed: () {
                          showColorDialog(context);
                        },
                      ),
                    ),

                    //Stroke width
                    SizedBox(
                      width: 100,
                      child: Slider(
                        min: 1.0,
                        max: 50.0,
                        value: currentStrokeWidth!,
                        onChanged: (value) {
                          setState(() {
                            currentStrokeWidth = value;
                            drawingController.setStyle(
                              strokeWidth: currentStrokeWidth,
                            );
                          });
                        },
                      ),
                    ),

                    //Undo button
                    InkWell(
                      onTap: drawingController.undo,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.undo,
                        ),
                      ),
                    ),

                    //Redo button
                    InkWell(
                      onTap: drawingController.redo,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.redo,
                        ),
                      ),
                    ),

                    //Clear button
                    InkWell(
                      onTap: drawingController.clear,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(MdiIcons.fromString('trash-can')),
                      ),
                    ),

                    //Save Drawing
                    InkWell(
                      onTap: () {
                        //pust to save drawing
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                SaveDrawing(drawingController.getJsonList()),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(MdiIcons.fromString('content-save')),
                      ),
                    ),
                  ],
                ),
              ),

              //tool bar
              Container(
                width: double.infinity,
                color: drawlyBlack.shade50,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SimpleLine
                    canvasIcon(0, MdiIcons.fromString('gesture'), SimpleLine()),
                    //Brush
                    canvasIcon(1, MdiIcons.fromString('brush'), SmoothLine()),

                    //Straight line
                    canvasIcon(2, MdiIcons.fromString('chart-line-variant'),
                        StraightLine()),

                    //Rectangle
                    canvasIcon(3, MdiIcons.fromString('rectangle-outline'),
                        Rectangle()),

                    //Triangle
                    canvasIcon(
                        4, MdiIcons.fromString('triangle-outline'), Triangle()),

                    //Circle
                    canvasIcon(
                        5, MdiIcons.fromString('circle-outline'), Circle()),
                    //Eraser
                    canvasIcon(6, MdiIcons.fromString('eraser'),
                        Eraser(color: backgroundColor)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//Vuild canvas icons
  Widget canvasIcon(int index, IconData? iconData, PaintContent paintContent) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        drawingController.setPaintContent(paintContent);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          iconData,
          color: selectedIndex == index ? Colors.blue : Colors.black,
          //size: 40,
        ),
      ),
    );
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      drawingController.setStyle(
        color: pickerColor,
      );
    });
  }

  //Color Alert Dialog
  showColorDialog(
    BuildContext context,
  ) {
    // set up the AlertDialog
    AlertDialog colorAlert = AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: pickerColor!,
          onColorChanged: changeColor,
          //showLabel: true, // only on portrait mode
        ),

        /* ColorPicker(
          pickerColor: pickerColor!,
          onColorChanged: changeColor,
          displayThumbColor: true,
        ), */
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return colorAlert;
      },
    );
  }

  //Show saveDialog
  showSaveDialog(
    BuildContext context,
    List jsonContent,
  ) {
    String? filename;
    TextEditingController? filenameController;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: AppTheme.text16Bold(),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Save",
        style: AppTheme.text16Bold(),
      ),
      onPressed: () async {
        try {
          //Save drawing
        } catch (e) {
          debugPrint('An error occurred during signout! $e');
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Save drawing',
        style: AppTheme.text20Bold(),
      ),
      content: Column(
        children: [
          Text(
            'Name drawing',
            style: AppTheme.text16(),
          ),
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
              SizedBox(
                width: 100,
                child: InkWell(
                  child: AppTheme.blackButtonContainer8('Save'),
                  onTap: () {
                    if (filenameController!.text == '') {
                      toastInfoLong('Please provide a file name.');
                    } else {
                      //save file
                      writeDrawing(filename!, jsonContent);

                      //add file to allDrawings Provider
                      setState(() {
                        //context.read<UserProvider>().setNewCategory(category);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
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
