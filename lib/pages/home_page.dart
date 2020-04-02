import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/common/bottom_bar.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/chats/chats_page.dart';
import 'package:multacc/pages/contacts/contacts_page.dart';
import 'package:multacc/pages/profile/profile_page.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

final globalScaffoldKey = GlobalKey<ScaffoldState>();

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

    initDynamicLinks();

    _tabController.addListener(() {
      if (_tabController.previousIndex != _tabController.index) {
        setState(() {});
      }
    });
  }

  void initDynamicLinks() async {
    SharedPreferences prefs = GetIt.I.get<SharedPreferences>();

    // Deep link back into app to save groupme access token
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.path == '/groupme') {
          String token = deepLink.queryParameters['access_token'];
          prefs.setString('GROUPME_TOKEN', token);
          // @todo Refactor deeplink logic when adding more platforms
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
                  Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(BrandIcons.google)),
                  Text('Sign in with Google', style: kHeaderTextStyle),
                ],
              ),
              onPressed: _signinWithGoogle,
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

  void _signinWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Scaffold _buildHomePageBody(BuildContext context, FirebaseUser user) {
    return Scaffold(
      key: globalScaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(_tabController.index == 2 ? Icons.share : Icons.add),
        onPressed: null,
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
