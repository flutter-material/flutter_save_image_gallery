import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  /// 初始化照片
  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  Future<void> _asyncInit() async {
    print('save image');
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(
      500,
      500,
    );
    final painter = CirclePainter();
    painter.paint(canvas, size);
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    // await saveImage(image, "example_image");
    print('????  ${image}');
    // 轉成 Uint8List byte image
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    // 請求儲存權限
    await Permission.storage.request();
    final PermissionStatus permissionResult =
        await Permission.storage.request();
    if (permissionResult == PermissionStatus.granted) {
      // 儲存圖片
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 60, name: '${DateTime.now().millisecondsSinceEpoch}');
      print('Save: ${result}');
    } else {
      // 拒絕權限
      throw Exception('Permission required!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Center(
        child: Text('Body Text'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
