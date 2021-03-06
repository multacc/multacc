import 'package:cloud_functions/cloud_functions.dart';

import 'package:multacc/database/contact_model.dart';

class ContactReceiver {
  static final HttpsCallable receiveFunction = FirebaseFunctions.instance.httpsCallable('receiveContact');

  /// Send a contact and get the link to it
  static Future<MultaccContact> receive(String id) async {
    print('Attempting to call receiveContact($id)');
    HttpsCallableResult result = await receiveFunction.call({'id': id}).catchError((e) {
      print('Function call failed in receive: $e');
      return null;
    });
    print(result.data);
    try {
      return MultaccContact.fromJson(Map<String, dynamic>.from(result.data));
    } catch (e) {
      print('Failed to get contact from json: $e');
      return null;
    }
  }
}
