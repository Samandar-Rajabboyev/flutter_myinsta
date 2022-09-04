import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/data_service.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<UserModel> items = [];

  void _apiSearchUsers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DataService.searchUsers(keyword).then((users) => {
          _respSearchUsers(users),
        });
  }

  void _respSearchUsers(List<UserModel> users) {
    if (mounted) {
      setState(() {
        items = users;
        isLoading = false;
      });
    }
  }

  void _apiFollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnfollowUser(UserModel someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.unfollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
    _apiSearchUsers("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black, fontFamily: 'Billabong', fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                //#searchuser
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 45,
                  child: TextField(
                    style: const TextStyle(color: Colors.black87),
                    controller: searchController,
                    onChanged: (input) {
                      _apiSearchUsers(input);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index) => _itemOfUser(items[index]),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfUser(UserModel user) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                width: 1.5,
                color: const Color.fromRGBO(193, 53, 132, 1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: user.img_url == null || user.img_url.isEmpty
                  ? const Image(
                      image: AssetImage("assets/images/avatar.png"),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      image: NetworkImage(user.img_url),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (user.followed) {
                      _apiUnfollowUser(user);
                    } else {
                      _apiFollowUser(user);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: user.followed ? const Text("Following") : const Text("Follow"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
