import 'package:flutter/material.dart';
import 'package:platform_commons_assignment/providers/conectiviity_provider.dart';
import 'package:platform_commons_assignment/view/add_user_screen.dart';
import 'package:platform_commons_assignment/providers/get_user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    final provider = Provider.of<GetUserProvider>(context, listen: false);
    final internet = Provider.of<InternetProvider>(context, listen: false);

    if (internet.isConnected) {
      Future.microtask(() {
        provider.getUserData();
        provider.syncPendingUsers();
      });
    } else {
      provider.loadFromHive();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.getUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getUserProvider = Provider.of<GetUserProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Assignment by Platform Commons")),
      body: getUserProvider.userList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Consumer<GetUserProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.userList.length,
                  itemBuilder: (context, index) {
                    if (provider.userList.isNotEmpty) {
                      final user = provider.userList[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        title: Text(user.firstName),
                        subtitle: Text(user.email),
                      );
                    } else {
                      return provider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
