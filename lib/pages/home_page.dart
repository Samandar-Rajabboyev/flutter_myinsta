import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/pages/my_feed_page.dart';
import 'package:flutter_myinsta/pages/my_likes_page.dart';
import 'package:flutter_myinsta/pages/my_profile_page.dart';
import 'package:flutter_myinsta/pages/my_search_page.dart';
import 'package:flutter_myinsta/pages/my_upload_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentTap = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentTap = index;
          });
        },
        children: [
          MyFeedPage(pageController: _pageController),
          const MySearchPage(),
          const MyUploadPage(),
          const MyLikesPage(),
          const MyProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index) {
          setState(() {
            _currentTap = index;
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        currentIndex: _currentTap,
        activeColor: const Color.fromRGBO(245, 96, 64, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
