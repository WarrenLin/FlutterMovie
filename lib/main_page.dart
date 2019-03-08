import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/assets.dart';
import 'package:flutter_movie_app/home/home_page.dart';
import 'package:flutter_movie_app/view/theater_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

const tabTitles = ["首頁", "搜尋", "戲院"];

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
        leading: Image.asset(ImageAssets.app_logo_icon), //app_logo_icon
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

    return Stack(
      fit: StackFit.expand,
      children: [
        backgroundImage,
        content,
      ],
    );
  }

  void _tabSelected(int newIndex) {
    setState(() {
      _selectedTab = newIndex;
      _tabController.index = newIndex;
    });
  }

  Widget _buildBodyContent() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ///todo 實作三個content widget
            HomePage(),
            Center(child: Text("page2", style: TextStyle(color: Colors.white))),
            TheaterPage()
          ],
        ),
      ),
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
