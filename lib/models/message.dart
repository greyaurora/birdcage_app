import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  static String messageUrl = 'http://greypi:1280/api/message';
  static String photoUrl = 'http://greypi:1280/api/photo';

  int id;
  String user, message, type;
  DateTime postedWhen;

  Message({
    this.id,
    this.user,
    this.message,
    this.type,
    this.postedWhen,
  });

  Message.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        user = jsonData['user'],
        message = jsonData['message'],
        type = jsonData['type'],
        postedWhen = DateTime.parse(jsonData['created_at']);

  static Future<List<Message>> list() async {
    List data = json.decode((await http.get(messageUrl)).body);

    List<Message> result =
        List.generate(data.length, (int i) => Message.fromJson(data[i]));

    return result;
  }

  static Future<void> send(String user, String message) async {
    await http.post(messageUrl, body: {
      'user': user,
      'message': message,
    });
  }

  Future<void> delete() async => await http.delete('$messageUrl/$id');

  static Future<void> sendPhoto(
      {String user, String filename, String filepath}) async {
    http.MultipartRequest rq =
        http.MultipartRequest('POST', Uri.parse(photoUrl))
          ..files.add(await http.MultipartFile.fromPath('image', filepath));

    rq.fields['user'] = user;

    rq.send();
  }

  String get url {
    if (type != 'photo') return '';

    return 'http://greypi:1280/storage/$message.png';
  }
}
