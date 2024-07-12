import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import '/src/theme.dart';

class Canvas extends StatefulWidget {
  const Canvas({super.key});

  @override
  State<Canvas> createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {
  //Setting controller for drawing board
  final DrawingController drawingController = DrawingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            width: double.infinity,
            alignment: const Alignment(0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'My Canvas',
                    style: AppTheme.text28ExtraBold(),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 600,
                  child: DrawingBoard(
                    controller: drawingController,
                    background: Container(
                      //width: double.infinity,
                      height: 400,
                      color: Colors.white,
                    ),
                    showDefaultActions: true,

                    /// Enable default action options
                    showDefaultTools: true,

                    /// Enable default toolbar
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get drawing board data
  Future<void> getImageData() async {
    print((await drawingController.getImageData())?.buffer.asInt8List());
  }
}
