import 'package:flutter/material.dart';
import 'package:platform_commons_assignment/providers/conectiviity_provider.dart';
import 'package:platform_commons_assignment/providers/get_user_provider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GetUserProvider provider = Provider.of<GetUserProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: TextField(
              controller: jobController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter Job",
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await addNewUser();
            },
            child: provider.isLoading
                ? CircularProgressIndicator()
                : Text("Add User"),
          ),
        ],
      ),
    );
  }

  Future<void> addNewUser() async {
    final internetProvider = Provider.of<InternetProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<GetUserProvider>(context, listen: false);
    if (nameController.text.trim().isNotEmpty &&
        jobController.text.trim().isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Adding user...")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }
    await userProvider.postNewUser(
      name: nameController.text.trim(),
      job: jobController.text.trim(),
      isConnected: internetProvider.isConnected,
    );

    Navigator.pop(context);
  }
}
