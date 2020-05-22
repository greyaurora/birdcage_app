import 'package:birdcage_app/models/message.dart';
import 'package:birdcage_app/widgets/camera_overlay.dart';
import 'package:birdcage_app/widgets/message_feed.dart';
import 'package:birdcage_app/widgets/text_input_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('en_AU', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BirdCage',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(user: 'Nicholas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.user}) : super(key: key);

  final String user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String user;

  @override
  void initState() {
    super.initState();

    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BirdCage")),
      body: Center(child: MessageFeed()),
      floatingActionButton: UnicornDialer(
        parentButton: Icon(Icons.add),
        childButtons: [
          UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.green[300],
              mini: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TextInputDialog(
                      text: user,
                      label: "CHANGE NAME",
                      onDone: (String message) {
                        setState(() => user = message);
                      },
                    );
                  },
                );
              },
              child: Icon(Icons.edit),
            ),
          ),
          UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.blue[300],
              child: Icon(Icons.photo_camera),
              mini: true,
              onPressed: () {
                WidgetsFlutterBinding.ensureInitialized();

                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureBuilder(
                      future: availableCameras(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Container();

                        if (snapshot.data.length == 0) {
                          Navigator.of(context).pop();
                          return Container();
                        }

                        return CameraOverlay(
                          snapshot.data.first,
                          user: user,
                          onPost: () => Future.delayed(Duration(seconds: 1))
                            ..then((_) => setState(() {})),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.red[300],
              mini: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TextInputDialog(
                      onDone: (String message) {
                        Message.send(user, message)
                          ..then((_) => setState(() {}));
                      },
                    );
                  },
                );
              },
              child: Icon(Icons.email),
            ),
          ),
        ],
      ),
    );
  }
}
