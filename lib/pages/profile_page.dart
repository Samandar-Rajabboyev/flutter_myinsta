import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../model/user_model.dart';
import '../services/data_service.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> items = [];
  bool isLoading = false;
  int axisCount = 1;
  int count_posts = 0, count_followers = 0, count_following = 0;

  String fullname = "", email = "", img_url = "";
  void _apiLoadUser(String uid) {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser(userId: uid).then((value) => {
          _showUserInfo(value),
        });
  }

  void _showUserInfo(UserModel user) {
    setState(() {
      isLoading = false;
      fullname = user.fullname;
      email = user.email;
      img_url = user.img_url;
      count_followers = user.followers_count;
      count_following = user.following_count;
    });
  }

  void _apiLoadPosts(String uid) {
    DataService.loadPosts(userId: uid).then((value) => {
          _resLoadPosts(value),
        });
  }

  void _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = items.length;
      isLoading = false;
    });
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
    _apiLoadUser(widget.user.uid);
    _apiLoadPosts(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // #follow #btn
              GestureDetector(
                onTap: () {
                  if (widget.user.followed) {
                    _apiUnfollowUser(widget.user);
                  } else {
                    _apiFollowUser(widget.user);
                  }
                },
                child: Container(
                  width: 100,
                  height: 30,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: widget.user.followed
                        ? const Text(
                            "Following",
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text(
                            "Follow",
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
        title: Text(
          widget.user.fullname,
          style:
              const TextStyle(color: Colors.black, fontFamily: 'Billabong', fontWeight: FontWeight.w400, fontSize: 24),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          splashRadius: 25,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //#myphoto
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                      width: 1.5,
                      color: const Color.fromRGBO(245, 96, 64, 1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: widget.user.img_url == null || widget.user.img_url.isEmpty
                        ? const Image(
                            image: AssetImage("assets/images/avatar.png"),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: NetworkImage(widget.user.img_url),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                //#myinfos
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
                ),
                //mycounts
                SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                count_posts.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "POSTS",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                count_followers.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "FOLLOWERS",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                count_following.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "FOLLOWING",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //listgrid
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              axisCount = 1;
                            });
                          },
                          icon: const Icon(Icons.list_alt),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              axisCount = 2;
                            });
                          },
                          icon: const Icon(Icons.grid_view),
                        ),
                      ),
                    ),
                  ],
                ),
                //#myposts
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount),
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemOfPost(items[index]);
                    },
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

  Widget _itemOfPost(Post post) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post ?? "",
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            post.caption ?? "",
            style: TextStyle(color: Colors.black87.withOpacity(0.7)),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
