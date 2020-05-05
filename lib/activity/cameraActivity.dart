import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CameraActivity extends StatefulWidget {
  final CameraDescription camera;

  const CameraActivity({Key key, @required this.camera}) : super(key: key);

  @override
  CameraActivityState createState() => CameraActivityState();
}

class CameraActivityState extends State<CameraActivity> {
  CameraController _controller;
  Future<void> _initializedControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        enableAudio: false);
    _initializedControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('camera'),
      ),
      body: FutureBuilder(
        future: _initializedControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () async {
          try {
            await _initializedControllerFuture;
            final path = join(
                (await getTemporaryDirectory()).path, '${DateTime.now()}.png');
            await _controller.takePicture(path);
            Navigator.pop(context, path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
