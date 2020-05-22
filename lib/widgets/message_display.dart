import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:birdcage_app/models/message.dart';

class MessageDisplay extends StatelessWidget {
  final Message message;

  MessageDisplay({this.message});

  Widget build(BuildContext context) {
    Widget messageBox;

    switch (message.type) {
      case 'text':
        messageBox = Container(
          padding: EdgeInsets.all(12),
          child: Text(
            message.message,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        break;
      case 'photo':
        messageBox = InkWell(
          onTap: () async {
            if (await canLaunch(message.url)) launch(message.url);
          },
          child: Container(
            height: 240,
            child: Image.network(
              message.url,
              fit: BoxFit.fitHeight,
            ),
          ),
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.black26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '  ' + message.user,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, h:ma', 'en_AU').format(
                            message.postedWhen.toLocal(),
                          ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              messageBox,
            ],
          ),
        ),
      ),
    );
  }
}
