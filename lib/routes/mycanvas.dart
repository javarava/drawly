import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:drawly/src/datastorage.dart';
import 'package:drawly/src/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import '/src/theme.dart';
import '/src/navigation.dart';
import '/routes/test_data.dart';

import '/routes/savedrawing.dart';

//current color
Color? currentColor = Colors.red;
Color? pickerColor = Colors.red;
double? currentStrokeWidth = 2.0;

List? sentDrawing;
List? canvasDrawing;

Future<ui.Image> getImage(String path) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  final NetworkImage img = NetworkImage(path);
  img.resolve(ImageConfiguration.empty).addListener(
    ImageStreamListener((ImageInfo info, _) {
      completer.complete(info);
    }),
  );

  final ImageInfo imageInfo = await completer.future;

  return imageInfo.image;
}

const Map<String, dynamic> testLine1 = <String, dynamic>{
  'type': 'StraightLine',
  'startPoint': <String, dynamic>{
    'dx': 68.94337550070736,
    'dy': 62.05980083656557
  },
  'endPoint': <String, dynamic>{
    'dx': 277.1373386828114,
    'dy': 277.32029957032194
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294198070,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

const Map<String, dynamic> testLine2 = <String, dynamic>{
  'type': 'StraightLine',
  'startPoint': <String, dynamic>{
    'dx': 106.35164817830423,
    'dy': 255.9575653134524
  },
  'endPoint': <String, dynamic>{
    'dx': 292.76034659254094,
    'dy': 92.125586665872
  },
  'paint': <String, dynamic>{
    'blendMode': 3,
    'color': 4294198070,
    'filterQuality': 3,
    'invertColors': false,
    'isAntiAlias': false,
    'strokeCap': 1,
    'strokeJoin': 1,
    'strokeWidth': 4.0,
    'style': 1
  }
};

/// Custom drawn triangles
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

/// Custom drawn image
/// url: https://web-strapi.mrmilu.com/uploads/flutter_logo_470e9f7491.png
const String imageUrl =
    'https://web-strapi.mrmilu.com/uploads/flutter_logo_470e9f7491.png';

class ImageContent extends PaintContent {
  ImageContent(this.image, {this.imageUrl = ''});

  ImageContent.data({
    required this.startPoint,
    required this.size,
    required this.image,
    required this.imageUrl,
    required Paint paint,
  }) : super.paint(paint);

  factory ImageContent.fromJson(Map<String, dynamic> data) {
    return ImageContent.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      size: jsonToOffset(data['size'] as Map<String, dynamic>),
      imageUrl: data['imageUrl'] as String,
      image: data['image'] as ui.Image,
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;
  Offset size = Offset.zero;
  final String imageUrl;
  final ui.Image image;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => size = nowPoint - startPoint;

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Rect rect = Rect.fromPoints(startPoint, startPoint + this.size);
    paintImage(canvas: canvas, rect: rect, image: image, fit: BoxFit.fill);
  }

  @override
  ImageContent copy() => ImageContent(image);

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'size': size.toJson(),
      'imageUrl': imageUrl,
      'paint': paint.toJson(),
    };
  }
}

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

  /// Add Json test content
  void addTestLine() {
    drawingController.addContent(StraightLine.fromJson(testLine1));
    drawingController
        .addContents(<PaintContent>[StraightLine.fromJson(testLine2)]);
    drawingController.addContent(SimpleLine.fromJson(tData[0]));
    drawingController.addContent(Eraser.fromJson(tData[1]));
  }

  void restBoard() {
    transformationController.value = Matrix4.identity();
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
