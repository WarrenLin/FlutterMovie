import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/view/page/home_page.dart';
import 'package:flutter_movie_app/view/page/search_page.dart';
import 'package:flutter_movie_app/view/page/theater_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

const tabTitles = ["熱映中", "搜尋", "戲院"];

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = Image.asset(
      ImageAssets.backgroundImage,
      fit: BoxFit.cover,
    );

    final content = Scaffold(
      appBar: AppBar(
        title: new Text(tabTitles[_selectedTab],
            style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF152451),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(ImageAssets.app_logo_icon),
        ), //app_logo_icon
      ),
      body: Stack(
        children: [
          _buildBodyContent(),
          _BottomTabs(
            selectedTab: _selectedTab,
            onTap: _tabSelected,
          ),
        ],
      ),
    );

    ///touch任何一處關閉鍵盤
    final gestureWrapper = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: content,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        backgroundImage,
        gestureWrapper,
      ],
    );
  }

  void _tabSelected(int newIndex) {
    setState(() => _selectedTab = newIndex);
  }

  Widget _buildBodyContent() {
    return Positioned.fill(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          child: IndexedStack(
            children: <Widget>[HomePage(), SearchPage(), TheaterPage()],
            index: _selectedTab,
          )),
    );
  }
}

class _BottomTabs extends StatelessWidget {
  _BottomTabs({
    @required this.selectedTab,
    @required this.onTap,
  });

  final int selectedTab;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: CupertinoTabBar(
          backgroundColor: Colors.black54,
          inactiveColor: Colors.white54,
          activeColor: Colors.white,
          iconSize: 24.0,
          currentIndex: selectedTab,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              title: Text(tabTitles[0]),
              icon: const Icon(Icons.local_movies),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              title: Text(tabTitles[1]),
              icon: const Icon(Icons.search),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              title: Text(tabTitles[2]),
              icon: const Icon(Icons.store_mall_directory),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ));
  }
}
