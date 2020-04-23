import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:multacc/database/database_interface.dart';
import 'package:multacc/pages/contacts/contact_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/database/contact_model.dart';
import 'package:multacc/pages/contacts/contacts_data.dart';
import 'package:multacc/common/auth.dart';
import 'package:multacc/common/bottom_bar.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/chats/chats_page.dart';
import 'package:multacc/pages/contacts/contacts_page.dart';
import 'package:multacc/pages/profile/profile_page.dart';

import 'chats/chats_data.dart';

Auth _auth = Auth.instance;

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ContactsData contactsData;
  TabController _tabController;
  MultaccContact userContact;

  @override
  bool get wantKeepAlive => true;

  _HomePageState() {
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    contactsData = GetIt.I.get<ContactsData>();
    userContact = GetIt.I.get<DatabaseInterface>().getContact('profile');
    initDynamicLinks();

    _tabController.addListener(() {
      if (_tabController.previousIndex != _tabController.index) {
        setState(() {});
      }
    });
  }

  void initDynamicLinks() async {
    // Deep link back into app to save groupme access token
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.path == '/groupme') {
          String groupmeToken = deepLink.queryParameters['access_token'];
          GetIt.I.get<SharedPreferences>().setString('GROUPME_TOKEN', groupmeToken);
          GetIt.I.get<ChatsData>().getAllChats(groupmeToken: groupmeToken);
          // @todo Refactor deeplink logic when adding more platforms
        } else {
          deepLink.path.trim('/')
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) => snapshot.hasData ? _buildHomePageBody(context, snapshot.data) : _buildLoginPage(),
    );
    // return _currentUser == null ? _buildLoginPage() : _buildHomePageBody(context);
  }

  Widget _buildLoginPage() {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', height: 200),
            SizedBox(height: 20),
            RaisedButton(
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: kBackgroundColorLight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(FontAwesome.google)),
                  Text('Sign in with Google', style: kHeaderTextStyle),
                ],
              ),
              onPressed: _auth.signinWithGoogle,
            ),
            FlatButton(
              child: Text('Skip', style: kBodyTextStyle),
              onPressed: _auth.signInAnonymously,
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _buildHomePageBody(BuildContext context, FirebaseUser user) {
    return Scaffold(
      key: globalScaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(_tabController.index == 2 ? Icons.share : Icons.add), // @todo Make this the actual share button
        onPressed: () {
          switch (_tabController.index) {
            case 0:
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ContactFormPage(isNewContact: true),
              ));
              break;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MultaccBottomBar(user),
      body: SafeArea(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: kTabLabelPadding,
                child: Image.asset('assets/icon.png', height: kToolbarHeight),
              ),
              _buildTabBar(context),
            ],
          ),
          Expanded(
            child: TabBarView(children: _buildTabViews(), controller: _tabController),
          )
        ]),
      ),
    );
  }

  Expanded _buildTabBar(BuildContext context) {
    return Expanded(
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
      ContactFormPage(contact: userContact, isProfile: true, isNewContact: userContact == null),
    ];
  }

  Widget _buildTab(String title, int index) {
    return Tab(child: _MultaccTab(title, _tabController.index == index));
  }
}

class _MultaccTab extends StatefulWidget {
  final Text titleText;
  final bool isExpanded;

  _MultaccTab(String title, bool isExpanded)
      : titleText = Text(title, style: kHeaderTextStyle),
        this.isExpanded = isExpanded;

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
