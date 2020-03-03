import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multacc/common/constants.dart';
import 'contact_model.dart';

class ContactInfo extends StatelessWidget {
  final GestureTapCallback onPressed;
  final ContactModel contact;

  ContactInfo({@required this.onPressed, this.contact});

  final kContactInfoTextStyle =
      TextStyle(fontSize: 18, fontFamily: 'Product Sans');
  final kContactSubInfoTextStyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w300, fontFamily: 'Product Sans', color: Color(0xFFD0D0D0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        child: Row(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(left: 35),
              child: Icon(
                Icons.phone,
                size: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('+1 (251)-978-8965', style: kContactInfoTextStyle),
                  Text('Mobile', style: kContactSubInfoTextStyle),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: kBackgroundColorLight))
      ),
    );
  }
}
