import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../model/post_model.dart';
import '../services/data_service.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DataService.loadLikes().then((value) => {
          _resLoadLikes(value),
        });
  }

  void _resLoadLikes(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnLike(Post post) {
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DataService.likePost(post, false).then((value) => {
          _apiLoadLikes(),
        });
  }

  // _actionRemovePost(Post post) async{
  //   var result = await Utils.dialogCommon(context, "Insta Clone", "Do you want to remove this post?", false);
  //   if(result != null && result){
  //     setState(() {
  //       isLoading = true;
  //     });
  //     DataService.removePost(post).then((value) => {
  //       _apiLoadLikes(),
  //     });
  //   }
  // }

  @override
  void initState() {
    _apiLoadLikes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Likes",
          style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Billabong"),
        ),
      ),
      body: Stack(
        children: [
          items.length > 0
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, index) => _itemOfPost(items[index]),
                )
              : const Center(
                  child: Text("No liked posts"),
                ),
          isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              const Divider(),

              //userInfo
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // userAvatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: const Image(
                            image: AssetImage("assets/images/avatar.png"),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // #username
                            Text(
                              "Username",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            // #date
                            Text(
                              "February 2, 2020",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(onPressed: () {}, splashRadius: 24, icon: const Icon(SimpleLineIcons.options)),
                  ],
                ),
              ),

              // #image
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                imageUrl: post.img_post ?? '',
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),

              // #like and #share
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _apiPostUnLike(post);
                        },
                        icon: const Icon(FontAwesome.heart, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesome.send),
                      ),
                    ],
                  ),
                ],
              ),

              // #caption
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: RichText(
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: " ${post.caption}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
