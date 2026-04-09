import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:platform_commons_assignment/models/user_model.dart';

class ApiServices {
  // Get User Data
  Future<List<UserModel>> getUserData(int pages) async {
    final String baseUrl = "https://reqres.in/api/users?page=$pages";
    Uri uri = Uri.parse(baseUrl);
    http.Response response = await http.get(
      uri,
      headers: {'x-api-key': 'reqres_e774a0c7f7304c8dada64174eec14af1'},
    );

    List<UserModel> userList = [];

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      List<dynamic> users = userData['data'];
      for (Map<String, dynamic> user in users) {
        userList.add(UserModel.fromJson(user));
      }
    }
    return userList;
  }

  // Add User Data
  Future<void> addUser(String name, String job) async {
    final url = Uri.parse("https://reqres.in/api/users");

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_e774a0c7f7304c8dada64174eec14af1',
      },
      body: jsonEncode({"name": name, "job": job}),
    );
    log("Response Body: ${response.body}");
  }

  //Get Movies Data
  Future<List<dynamic>> getMovies(int page) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY&page=$page",
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    return data['results'];
  }
}
