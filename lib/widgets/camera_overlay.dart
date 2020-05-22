import 'dart:io';

import 'package:birdcage_app/models/message.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraOverlay extends StatefulWidget {
  final CameraDescription camera;
  final VoidCallback onPost;
  final String user;

  CameraOverlay(this.camera, {this.onPost, this.user = ''});

  @override
  CameraOverlayState createState() => CameraOverlayState();
}

class CameraOverlayState extends State<CameraOverlay> {
  CameraController _controller;
  Future<void> _initFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Container();

          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.clear),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned.fill(
                top: null,
                bottom: 32,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.photo_camera),
                  onPressed: () async {
                    final String path = join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );

                    await _controller.takePicture(path);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding:EdgeInsets.all(12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.file(File(path)),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      FloatingActionButton(
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.clear),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      FloatingActionButton(
                                        backgroundColor: Colors.green,
                                        child: Icon(Icons.done),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();

                                          Message.sendPhoto(
                                            user: widget.user,
                                            filepath: path,
                                          )..then((_) => widget.onPost());
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    // Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }
}
