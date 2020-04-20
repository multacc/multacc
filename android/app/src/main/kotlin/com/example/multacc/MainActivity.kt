package com.multacc

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Telephony
import android.telephony.SmsManager
import android.telephony.SmsMessage
import android.os.Bundle
import android.content.BroadcastReceiver
import android.widget.Toast

import android.util.Log
import io.flutter.plugin.common.PluginRegistry.Registrar

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.multacc/sms-handler"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if(call.method == "defaultSMS"){
        val setSmsAppIntent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
        setSmsAppIntent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
        startActivityForResult(setSmsAppIntent, 1)
      }
      // else if (call.method == "encryptSMS"){
      //   // Encrypts string and encode in Base64
      //   @Throws(Exception::class)
      //   fun encrypt(data: String): String {
      //       val encrypted = cryptoOperation(Cipher.ENCRYPT_MODE, data.toByteArray())
      //       return Base64.encodeToString(encrypted, Base64.DEFAULT)
      //   } 
      // }
      // else if (call.method == "decryptSMS"){
      //   // Decrypts string encoded in Base64
      //   @Throws(Exception::class)
      //   fun decrypt(encryptedData: String): String {
      //       val encrypted = Base64.decode( encryptedData, Base64.DEFAULT )
      //       val decrypted = cryptoOperation(Cipher.DECRYPT_MODE, encrypted)
      //       return String(decrypted)
      //   }
      // }
      else if (call.method == "sendText"){
        val arguments = call.arguments<Map<String, Any>>()

        val msg: String = arguments["message"] as String
        val num: String = arguments["num"] as String

        val smsManager = SmsManager.getDefault() as SmsManager
        smsManager.sendTextMessage(num, null, msg, null, null)

        result.success(5)
      }
      else {
        result.notImplemented()
      }
    }
  }
}

class SmsReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context?, intent: Intent?) {
    // Get SMS map from Intent
    if(context == null || intent == null || intent.action == null){
        return
    }
    if (intent.action != (Telephony.Sms.Intents.SMS_RECEIVED_ACTION)) {
        return
    }
    val contentResolver = context.contentResolver
    val smsMessages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
    for (message in smsMessages) {
        Toast.makeText(context, "Message from ${message.displayOriginatingAddress} : body ${message.messageBody}", Toast.LENGTH_SHORT)
            .show()
        putSmsToDatabase(contentResolver, message)
    }
  }
}