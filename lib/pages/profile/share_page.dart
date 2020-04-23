import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:multacc/common/theme.dart';

class SharePage extends StatefulWidget {
  final String url;

  SharePage(this.url);

  @override
  _Share createState() => _Share(url);
}

class _Share extends State<SharePage> {
  String url;

  _Share(this.url);

  @override
  void initState() {
    super.initState();
  }

  // Mayank pls fix this
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.close, color: Colors.grey, size: 30),
          ),
          centerTitle: false,
          title: Text('Share', style: kHeaderTextStyle),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: QrImage(
                data: url,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
//                embeddedImage: AssetImage('assets/logo.png'),
              )
            ),
            Text(url), // @todo Add a button to copy url after creating share link
          ],
        ),
      ),
    );
  }
}
