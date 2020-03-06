import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/constants.dart';

import 'chats/chats_page.dart';
import 'contacts/contacts_page.dart';
import 'profile/profile_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  _HomePageState() {
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (_tabController.previousIndex != _tabController.index) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(_tabController.index == 2 ? Icons.share : Icons.add),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _MultaccBottomBar(),
      body: SafeArea(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: kTabLabelPadding,
                child: Image.asset('assets/icon.png', height: kToolbarHeight),
              ),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    dragStartBehavior: DragStartBehavior.start,
                    // isScrollable: true,
                    labelPadding: EdgeInsets.all(0),
                    tabs: _buildTabs(),
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.symmetric(horizontal: 16.0 * MediaQuery.of(context).devicePixelRatio),
                      borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(children: _buildTabViews(), controller: _tabController),
          )
        ]),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return <Widget>[
      _buildTab('Contacts', 0),
      _buildTab('Chats', 1),
      _buildTab('Profile', 2),
    ];
  }

  List<Widget> _buildTabViews() {
    return <Widget>[
      ContactsPage(),
      ChatsPage(),
      ProfilePage(),
    ];
  }

  Widget _buildTab(String title, int index) {
    return Tab(child: _MultaccTab(title, _tabController.index == index));
  }
}

class _MultaccTab extends StatefulWidget {
  Text titleText;
  bool isExpanded;

  _MultaccTab(String title, bool isExpanded) {
    titleText = Text(title, style: GoogleFonts.lato(textStyle: kTabBarTextStyle));
    this.isExpanded = isExpanded;
  }

  _MultaccTabState createState() => _MultaccTabState();
}

class _MultaccTabState extends State<_MultaccTab> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: kTabScrollDuration, vsync: this);
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_MultaccTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Center(child: widget.titleText),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _MultaccBottomBar extends StatefulWidget {
  @override
  __MultaccBottomBarState createState() => __MultaccBottomBarState();
}

class __MultaccBottomBarState extends State<_MultaccBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 8.0,
        color: kBackgroundColorLight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu, color: Colors.grey),
              onPressed: () async {
                FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColor);
                await showNavigationSheet(context);
                FlutterStatusbarcolor.setNavigationBarColor(kBackgroundColorLight);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future showNavigationSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Privacy policy'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Sign out'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}
