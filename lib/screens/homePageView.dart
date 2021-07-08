import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/callScreens/pickup/pickup_layout.dart';
import 'package:teams_clone/screens/teamsScreen/teams_screen.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'PageView/chat_list_screen.dart';
import 'home_screen.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  late PageController pageController;
  int _page =0;

  void onPageChange(int page){
    setState(() {
      _page = page;
    });

  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }


  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize =10;
    return PickupLayout(
      
      scaffold: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          children: [
            HomeScreen(),
            ChatListScreen(),
            Teamsscreen()
          ],
          controller: pageController,
          onPageChanged: onPageChange,
          physics: NeverScrollableScrollPhysics(),
    
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: Color(0xff19191b),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: (_page == 0)
                          ? color
                          : Colors.grey),
                  title: Text(
                    "Home",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? color
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 1)
                          ? color
                          : Colors.grey),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? color
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group,
                      color: (_page == 2)
                          ? color
                          : Colors.grey),
                  title: Text(
                    "Teams",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? color
                            : Colors.grey),
                  ),
                )
              ],
              currentIndex: _page,
              onTap: navigationTapped,
            ),
          ),
    
        ),
      ),
    );
  }
}
