import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';
import 'package:flutter_myinsta/services/utils_service.dart';

import '../model/post_model.dart';
import '../model/user_model.dart';

class DataService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = 'users';
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";

  // User Related
  static Future storeUser(UserModel user) async {
    user.uid = await Prefs.loadUserId();
    return _firestore.collection(folder_users).doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> loadUser() async {
    String? uid = await Prefs.loadUserId();
    var value = await _firestore.collection(folder_users).doc(uid).get();
    UserModel user = UserModel.fromJson(value.data()!);
    return user;
  }

  static Future updateUser(UserModel user) async {
    user.uid = await Prefs.loadUserId();
    return _firestore.collection(folder_users).doc(user.uid).update(user.toJson());
  }

  static Future<List<UserModel>> searchUsers(String keyword) async {
    List<UserModel> users = [];
    String? uid = await Prefs.loadUserId();

    var querySnapshot = await _firestore.collection(folder_users).orderBy("email").startAt([keyword]).get();

    querySnapshot.docs.forEach((result) {
      UserModel newUser = UserModel.fromJson(result.data());
      if (newUser.uid != uid) {
        users.add(newUser);
      }
    });
    return users;
  }
  // Post Related

  static Future<Post> storePost(Post post) async {
    UserModel me = await loadUser();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = _firestore.collection(folder_users).doc(me.uid).collection(folder_posts).doc().id;
    post.id = postId;

    await _firestore.collection(folder_users).doc(me.uid).collection(folder_posts).doc(postId).set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String? uid = await Prefs.loadUserId();

    await _firestore.collection(folder_users).doc(uid).collection(folder_feeds).doc(post.id).set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String? uid = await Prefs.loadUserId();
    var querySnapshot = await _firestore.collection(folder_users).doc(uid).collection(folder_feeds).get();

    querySnapshot.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String? uid = await Prefs.loadUserId();

    var querySnapshot = await _firestore.collection(folder_users).doc(uid).collection(folder_posts).get();

    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });
    return posts;
  }
}
