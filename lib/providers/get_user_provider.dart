import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:platform_commons_assignment/api_services/api_services.dart';
import 'package:platform_commons_assignment/models/user_model.dart';

class GetUserProvider with ChangeNotifier {
  ApiServices apiServices = ApiServices();

  List<UserModel> userList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;

  final box = Hive.box("users");

  Future<void> getUserData() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();

    try {
      final newUsers = await apiServices.getUserData(currentPage);

      if (newUsers.isNotEmpty) {
        userList.addAll(newUsers);
        currentPage++;

        box.put("cached_users", userList.map((e) => e.toJson()).toList());
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      log(e.toString());
      loadFromHive();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadFromHive() {
    final data = box.get("cached_users");

    if (data != null) {
      userList = (data as List)
          .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    notifyListeners();
  }

  Future<void> postNewUser({
    required String name,
    required String job,
    required bool isConnected,
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> userData = {"name": name, "job": job};

    try {
      if (isConnected) {
        await apiServices.addUser(name, job);
      } else {
        saveOffline(userData);
      }
    } catch (e) {
      log(e.toString());
      saveOffline(userData);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void saveOffline(Map<String, dynamic> data) {
    List pending = box.get("pending_users", defaultValue: []);
    pending.add(data);
    box.put("pending_users", pending);
  }

  Future<void> syncPendingUsers() async {
    List pending = box.get("pending_users", defaultValue: []);

    if (pending.isEmpty) return;

    List remaining = [];

    for (var user in pending) {
      try {
        await apiServices.addUser(user["name"], user["job"]);
      } catch (e) {
        remaining.add(user);
      }
      log(user['name']);
      log(user['job']);
    }

    box.put("pending_users", remaining);
  }
}
