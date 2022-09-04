import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../model/post_model.dart';
import '../services/data_service.dart';
import '../services/utils_service.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;
  const MyFeedPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];
  void _apiLoadFeeds() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    DataService.loadFeeds().then((value) => {
          _resLoadFeeds(value),
        });
  }

  void _resLoadFeeds(List<Post> posts) {
    if (mounted) {
      setState(() {
        items = posts;
        isLoading = false;
      });
    }
  }

  void _apiPostLike(Post post) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await DataService.likePost(post, true);
    if (mounted) {
      setState(() {
        isLoading = false;
        post.liked = true;
      });
    }
  }

  void _apiPostUnLike(Post post) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await DataService.likePost(post, false);
    if (mounted) {
      setState(() {
        isLoading = false;
        post.liked = false;
      });
    }
  }

  _actionRemovePost(Post post) async {
    bool result = await Utils.dialogCommon(context, "Remove", "Do you want to remove this post", false);
    if (result != null && result) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      DataService.removePost(post).then((value) => {_apiLoadFeeds()});
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Instagram",
          style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Billabong"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController?.animateToPage(
                2,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            splashRadius: 24,
            icon: const Icon(
              Icons.camera_alt,
              color: Color.fromRGBO(245, 96, 64, 1),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) => _itemOfPost(items[index]),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
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
                      child: post.img_user == null || (post.img_user?.isEmpty ?? true)
                          ? const Image(
                              image: AssetImage("assets/images/avatar.png"),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image(
                              image: NetworkImage(post.img_user!),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // #username
                        Text(
                          post.fullname ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        // #date
                        Text(
                          post.date ?? '',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
                post.mine
                    ? IconButton(
                        onPressed: () {
                          _actionRemovePost(post);
                        },
                        splashRadius: 24,
                        icon: const Icon(SimpleLineIcons.options),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),

          // #image
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: post.img_post ?? "",
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
                      if (!post.liked) {
                        _apiPostLike(post);
                      } else {
                        _apiPostUnLike(post);
                      }
                    },
                    icon: post.liked
                        ? const Icon(
                            FontAwesome.heart,
                            color: Colors.red,
                          )
                        : const Icon(FontAwesome.heart_o),
                  ),
                  IconButton(
                    onPressed: () => Share.share('Image: ${post.img_post} \n Caption: ${post.caption}'),
                    icon: const Icon(Icons.share_outlined),
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
    );
  }
}
