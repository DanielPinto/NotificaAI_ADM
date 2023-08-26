import 'package:dio/dio.dart';

class InviteNotify {
  final Dio dio = Dio();

  inviteNotify(
      {required String id,
      required String body,
      required String title,
      required dynamic zones,
      required String conditions}) async {
    Response response;
    var data = {
      "condition": conditions,
      "notification": {"body": body, "title": title},
      "data": {"route": "/notificacao"},
      "android": {"priority": "high"},
      "time_to_live": 6000
    };
    try {
      response = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        data: data,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAA5mCU7Qs:APA91bH6vYgUYCaj_Lg1bfbfdLSyAaX07C89BzIH-AR-92KvbJxFMjsFFmWmw00NmF4aAVZCaooyW_8uiYcOLhpzW1yv565iaCe9XexyPXjEohL_6yKt8EGarOTooURpsg993lvUfNeF",
        }),
      );
      print("RESPONSE STATUS ${response.statusMessage}");
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print("ERRO: " + e.response.toString());
        return e.response!.statusCode;
      }
    }
  }
}
