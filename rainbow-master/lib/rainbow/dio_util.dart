import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow/main.dart';

Dio dio = Dio();

fetchUserId() async {
  // final Dio dio = Dio();
  try {
    final res = await dio.get(
      'http://3.35.249.235:8080/user_id',
      options: Options(
        headers: {
          // 'Accept': 'application/json',
          // 'Content-Type': 'application/json',
        },
      ),
    );
    if (res.statusCode == 200) {
      debugPrint('userId : ${res.data}');

      return res.data;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

fetchNickName(String nickname) async {
  final res = await dio.put(
    'http://3.35.249.235:8080/nick_name',
    data: {
      'userId': userId,
      'newNickname': nickname,
    },
  );
  if (res.statusCode == 200) {
    debugPrint('userId : ${res.data}');
    return res.data;
  }
}

fetchUserInfo() async {
  if (userId.isNotEmpty) {
    final res = await dio.post(
      'http://3.35.249.235:8080/user_info',
      data: {
        'userId': userId,
      },
    );
    if (res.statusCode == 200) {
      debugPrint('UserInfo : ${res.data}');
      return res.data;
    }
  }
}
