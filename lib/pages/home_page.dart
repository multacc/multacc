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
    _tabController = TabController(length: 3, vsync: this);
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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset('assets/icon.png', height: kToolbarHeight),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: SafeArea(
                  child: TabBar(
                    isScrollable: true,
                    tabs: _buildTabs(),
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
      _buildTab(Icons.people, "Contacts", 0),
      _buildTab(Icons.message, "Chats", 1),
      _buildTab(Icons.person, "Profile", 2),
    ];
  }

  List<Widget> _buildTabViews() {
    return <Widget>[
      ContactsPage(),
      ChatsPage(),
      ProfilePage(),
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
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
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
