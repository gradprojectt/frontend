import 'dart:convert';

import 'package:dio/dio.dart';

const _API_PREFIX = "http://3.35.249.235:5000/classifier";

class Server {
  Dio dio = Dio();

  Future<void> postReqWithBody() async {
    try {
      Response response = await dio.post(_API_PREFIX, data: {
        "pccs": "dark_grayish",
        "season": "winter",
        "tone": "cool",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.data);
        String pccs = data["pccs"];
        String season = data["season"];
        String tone = data["tone"];
        print("pccs: $pccs, season: $season, tone: $tone");
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> postReqWithQuery() async {
    try {
      Response response = await dio.post(_API_PREFIX, queryParameters: {
        "pccs": "dark_grayish",
        "season": "winter",
        "tone": "cool",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.data);
        String pccs = data["pccs"];
        String season = data["season"];
        String tone = data["tone"];
        print("pccs: $pccs, season: $season, tone: $tone");
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

void main() {
  Server server = Server();

  server.postReqWithBody();
  server.postReqWithQuery();
}
