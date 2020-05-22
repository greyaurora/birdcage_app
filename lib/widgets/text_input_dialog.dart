import 'package:flutter/material.dart';

class TextInputDialog extends Dialog {
  final void Function(String) onDone;
  final String text, label;

  TextInputDialog({
    this.onDone,
    this.text = "",
    this.label = "SEND",
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: text);

    return Dialog(
      backgroundColor: Colors.deepPurpleAccent[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 12),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white70,
            ),
            child: TextField(
              decoration: InputDecoration(border: InputBorder.none),
              controller: controller,
              minLines: 2,
              maxLines: 6,
            ),
          ),
          FlatButton(
            color: Colors.deepPurple,
            onPressed: () {
              if (controller.text.isNotEmpty) onDone(controller.text);

              Navigator.of(context).pop();
            },
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
