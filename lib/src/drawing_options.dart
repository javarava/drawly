import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';

//Get image
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

/// Add Json test content
/* void addTestLine() {
    drawingController.addContent(StraightLine.fromJson(testLine1));
    drawingController
        .addContents(<PaintContent>[StraightLine.fromJson(testLine2)]);
    drawingController.addContent(SimpleLine.fromJson(tData[0]));
    drawingController.addContent(Eraser.fromJson(tData[1]));
  }

  void restBoard() {
    transformationController.value = Matrix4.identity();
  } */

//Test lines
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

final List<Map<String, dynamic>> tData = <Map<String, dynamic>>[
  <String, dynamic>{
    'type': 'SimpleLine',
    'path': <String, dynamic>{
      'fillType': 0,
      'steps': <Map<String, dynamic>>[
        <String, dynamic>{'type': 'moveTo', 'x': 163.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 164.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 165.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 166.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 168.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 170.0, 'y': 122.0},
        <String, dynamic>{'type': 'lineTo', 'x': 170.0, 'y': 123.0},
        <String, dynamic>{'type': 'lineTo', 'x': 171.0, 'y': 124.0},
        <String, dynamic>{'type': 'lineTo', 'x': 173.0, 'y': 125.0},
        <String, dynamic>{'type': 'lineTo', 'x': 175.0, 'y': 126.0},
        <String, dynamic>{'type': 'lineTo', 'x': 178.0, 'y': 128.0},
        <String, dynamic>{'type': 'lineTo', 'x': 182.0, 'y': 131.0},
        <String, dynamic>{'type': 'lineTo', 'x': 184.0, 'y': 132.0},
        <String, dynamic>{'type': 'lineTo', 'x': 188.0, 'y': 135.0},
        <String, dynamic>{'type': 'lineTo', 'x': 194.0, 'y': 137.0},
        <String, dynamic>{'type': 'lineTo', 'x': 195.0, 'y': 139.0},
        <String, dynamic>{'type': 'lineTo', 'x': 200.0, 'y': 141.0},
        <String, dynamic>{'type': 'lineTo', 'x': 206.0, 'y': 144.0},
        <String, dynamic>{'type': 'lineTo', 'x': 211.0, 'y': 146.0},
        <String, dynamic>{'type': 'lineTo', 'x': 217.0, 'y': 150.0},
        <String, dynamic>{'type': 'lineTo', 'x': 220.0, 'y': 151.0},
        <String, dynamic>{'type': 'lineTo', 'x': 225.0, 'y': 154.0},
        <String, dynamic>{'type': 'lineTo', 'x': 234.0, 'y': 160.0},
        <String, dynamic>{'type': 'lineTo', 'x': 250.0, 'y': 169.0},
        <String, dynamic>{'type': 'lineTo', 'x': 259.0, 'y': 173.0},
        <String, dynamic>{'type': 'lineTo', 'x': 265.0, 'y': 176.0},
        <String, dynamic>{'type': 'lineTo', 'x': 270.0, 'y': 178.0},
        <String, dynamic>{'type': 'lineTo', 'x': 274.0, 'y': 180.0},
        <String, dynamic>{'type': 'lineTo', 'x': 280.0, 'y': 182.0},
        <String, dynamic>{'type': 'lineTo', 'x': 285.0, 'y': 183.0},
        <String, dynamic>{'type': 'lineTo', 'x': 288.0, 'y': 185.0},
        <String, dynamic>{'type': 'lineTo', 'x': 290.0, 'y': 186.0},
        <String, dynamic>{'type': 'lineTo', 'x': 293.0, 'y': 186.0},
        <String, dynamic>{'type': 'lineTo', 'x': 296.0, 'y': 188.0},
        <String, dynamic>{'type': 'lineTo', 'x': 297.0, 'y': 189.0},
        <String, dynamic>{'type': 'lineTo', 'x': 299.0, 'y': 189.0},
        <String, dynamic>{'type': 'lineTo', 'x': 300.0, 'y': 190.0},
        <String, dynamic>{'type': 'lineTo', 'x': 301.0, 'y': 190.0},
        <String, dynamic>{'type': 'lineTo', 'x': 302.0, 'y': 191.0},
        <String, dynamic>{'type': 'lineTo', 'x': 303.0, 'y': 191.0},
        <String, dynamic>{'type': 'lineTo', 'x': 304.0, 'y': 191.0}
      ]
    },
    'paint': <String, dynamic>{
      'blendMode': 3,
      'color': 4294198070,
      'filterQuality': 3,
      'invertColors': false,
      'isAntiAlias': false,
      'strokeCap': 1,
      'strokeJoin': 1,
      'strokeWidth': 33.375,
      'style': 1
    }
  },
  <String, dynamic>{
    'type': 'Eraser',
    'color': 4294967295,
    'path': <String, dynamic>{
      'fillType': 0,
      'steps': <Map<String, dynamic>>[
        <String, dynamic>{'type': 'moveTo', 'x': 288.0, 'y': 109.0},
        <String, dynamic>{'type': 'lineTo', 'x': 287.0, 'y': 109.0},
        <String, dynamic>{'type': 'lineTo', 'x': 286.0, 'y': 111.0},
        <String, dynamic>{'type': 'lineTo', 'x': 285.0, 'y': 111.0},
        <String, dynamic>{'type': 'lineTo', 'x': 283.0, 'y': 113.0},
        <String, dynamic>{'type': 'lineTo', 'x': 282.0, 'y': 115.0},
        <String, dynamic>{'type': 'lineTo', 'x': 279.0, 'y': 117.0},
        <String, dynamic>{'type': 'lineTo', 'x': 276.0, 'y': 119.0},
        <String, dynamic>{'type': 'lineTo', 'x': 274.0, 'y': 121.0},
        <String, dynamic>{'type': 'lineTo', 'x': 268.0, 'y': 127.0},
        <String, dynamic>{'type': 'lineTo', 'x': 264.0, 'y': 130.0},
        <String, dynamic>{'type': 'lineTo', 'x': 261.0, 'y': 133.0},
        <String, dynamic>{'type': 'lineTo', 'x': 257.0, 'y': 137.0},
        <String, dynamic>{'type': 'lineTo', 'x': 249.0, 'y': 142.0},
        <String, dynamic>{'type': 'lineTo', 'x': 245.0, 'y': 145.0},
        <String, dynamic>{'type': 'lineTo', 'x': 242.0, 'y': 148.0},
        <String, dynamic>{'type': 'lineTo', 'x': 237.0, 'y': 152.0},
        <String, dynamic>{'type': 'lineTo', 'x': 231.0, 'y': 158.0},
        <String, dynamic>{'type': 'lineTo', 'x': 225.0, 'y': 161.0},
        <String, dynamic>{'type': 'lineTo', 'x': 222.0, 'y': 164.0},
        <String, dynamic>{'type': 'lineTo', 'x': 220.0, 'y': 166.0},
        <String, dynamic>{'type': 'lineTo', 'x': 217.0, 'y': 169.0},
        <String, dynamic>{'type': 'lineTo', 'x': 214.0, 'y': 171.0},
        <String, dynamic>{'type': 'lineTo', 'x': 211.0, 'y': 173.0},
        <String, dynamic>{'type': 'lineTo', 'x': 210.0, 'y': 175.0},
        <String, dynamic>{'type': 'lineTo', 'x': 208.0, 'y': 176.0},
        <String, dynamic>{'type': 'lineTo', 'x': 206.0, 'y': 179.0},
        <String, dynamic>{'type': 'lineTo', 'x': 204.0, 'y': 180.0},
        <String, dynamic>{'type': 'lineTo', 'x': 202.0, 'y': 182.0},
        <String, dynamic>{'type': 'lineTo', 'x': 200.0, 'y': 185.0},
        <String, dynamic>{'type': 'lineTo', 'x': 198.0, 'y': 186.0},
        <String, dynamic>{'type': 'lineTo', 'x': 197.0, 'y': 188.0},
        <String, dynamic>{'type': 'lineTo', 'x': 196.0, 'y': 188.0},
        <String, dynamic>{'type': 'lineTo', 'x': 195.0, 'y': 190.0},
        <String, dynamic>{'type': 'lineTo', 'x': 194.0, 'y': 191.0}
      ]
    },
    'paint': <String, dynamic>{
      'blendMode': 3,
      'color': 4294198070,
      'filterQuality': 3,
      'invertColors': false,
      'isAntiAlias': false,
      'strokeCap': 1,
      'strokeJoin': 1,
      'strokeWidth': 33.375,
      'style': 1
    }
  }
];
