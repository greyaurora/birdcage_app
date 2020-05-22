import 'package:flutter/material.dart';

import 'package:birdcage_app/models/message.dart';
import 'message_display.dart';

class MessageFeed extends StatefulWidget {
  @override
  _MessageFeedState createState() => _MessageFeedState();
}

class _MessageFeedState extends State<MessageFeed> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>setState(() {}),
      child: FutureBuilder<List<Message>>(
        future: Message.list(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.hasData) {
            List<Message> data = snapshot.data.reversed.toList();

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  MessageDisplay(message: data[index]),
            );
          } else {
            return Column();
          }
        },
      ),
    );
  }
}
