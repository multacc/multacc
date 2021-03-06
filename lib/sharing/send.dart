import 'package:cloud_functions/cloud_functions.dart';

import 'package:multacc/database/contact_model.dart';

class ContactSender {
  static final HttpsCallable sendFunction = FirebaseFunctions.instance.httpsCallable('sendContact');

  /// Send a contact and get the link to it
  static Future<String> send(MultaccContact contact) async {
    HttpsCallableResult result = await sendFunction.call(contact.toJson()).catchError((e) {
      print('Function call failed in send: $e');
      return null;
    });
    return 'https://multa.cc/' + (result?.data ?? '');
  }
}
