import 'package:flutter/material.dart';
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void initState() {
    super.initState();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.previousIndex != _tabController.index) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'Multacc',
      //     style: kHeaderTextStyle,
      //   ),
      // ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              isScrollable: true,
              labelPadding: EdgeInsets.zero,
              tabs: _buildTabs(),
              controller: _tabController,
              // indicator: UnderlineTabIndicator(borderSide: BorderSide(style: BorderStyle.none)),
            ),
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
      _buildTab(Icons.people, "Contacts", 0),
      _buildTab(Icons.message, "Chats", 1),
      _buildTab(Icons.person, "Profile", 2),
      _buildTab(Icons.settings, "Settings", 3),
    ];
  }

  List<Widget> _buildTabViews() {
    return <Widget>[
      ContactsPage(),
      ChatsPage(),
      ProfilePage(),
      SettingsPage(),
    ];
  }

  Widget _buildTab(IconData iconData, String title, int index) {
    return _MultaccScreen(Icon(iconData), title, _tabController.index == index);
  }
}

class _MultaccScreen extends StatefulWidget {
  Text titleText;
  Icon icon;
  bool isExpanded;

  _MultaccScreen(Icon icon, String title, bool isExpanded) {
    titleText = Text(title, style: GoogleFonts.lato(textStyle: kTabBarTextStyle));
    this.icon = icon;
    this.isExpanded = isExpanded;
  }

  _MultaccScreenState createState() => _MultaccScreenState();
}

class _MultaccScreenState extends State<_MultaccScreen> with SingleTickerProviderStateMixin {
  Animation<double> _titleSizeAnimation;
  Animation<double> _titleFadeAnimation;
  Animation<double> _iconFadeAnimation;
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _titleSizeAnimation = CurvedAnimation(parent: Tween(begin: 0.0, end: 1.0).animate(_controller), curve: Curves.linear);
    _titleFadeAnimation = CurvedAnimation(parent: Tween(begin: 0.0, end: 1.0).animate(_controller), curve: Curves.easeOut);
    _iconFadeAnimation = CurvedAnimation(parent: Tween(begin: 0.6, end: 1.0).animate(_controller), curve: Curves.linear);
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_MultaccScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 56,
      // width: width / 3.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(child: widget.titleText),
      ),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
