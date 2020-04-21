import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const GROUPME_REDIRECT_URL = 'https://oauth.groupme.com/oauth/authorize?client_id=qUSMuMym9ticy1pCtC0LqRXXgIzEHzAWuYfJq3DlaV7HaCKh';
const GROUPME_API_URL = 'https://api.groupme.com/v3';
const GROUPME_BACKGROUND_TASK = 'groupme_fetch';
const GROUPME_ANDROID_NOTIFICATION_DETAILS = AndroidNotificationDetails(
  GROUPME_BACKGROUND_TASK,
  'GroupMe messages',
  'Direct messages on GroupMe',
  importance: Importance.Default,
  priority: Priority.Default,
  ticker: 'GroupMe',
);

const ANDROID_DIALER_PACKAGE = 'com.google.android.dialer';
const GOOGLE_DUO_PACKAGE = 'com.google.android.apps.tachyon';
const GOOGLE_VOICE_PACKAGE = 'com.google.android.apps.googlevoice';
const GOOGLE_VOICE_INTENT_ACTIVITY = 'com.google.android.apps.voice.home.androidintents.AndroidIntentActivity';
