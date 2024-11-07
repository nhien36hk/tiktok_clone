import 'package:app_tiktok/controllers/search_controller.dart';
import 'package:app_tiktok/views/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchUserController searchUserController =
      Get.put(SearchUserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onFieldSubmitted: (value) => searchUserController.searchUser(value),
          ),
        ),
        body: searchUserController.searchedUsers.isEmpty
            ? Center(
                child: Text(
                  'Search for user!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchUserController.searchedUsers.length,
                itemBuilder: (context, index) {
                  var data = searchUserController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: data.uid),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(data.profilePhoto),
                      ),
                      title: Text(
                        '${data.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
