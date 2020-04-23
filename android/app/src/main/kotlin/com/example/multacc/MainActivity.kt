package com.multacc

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
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
import android.content.ContentResolver
import android.content.ContentValues
import android.util.Base64
import javax.crypto.*
import javax.crypto.spec.SecretKeySpec
import javax.crypto.spec.PBEKeySpec
import java.util.Random
import java.security.SecureRandom
import android.net.Uri
import android.app.role.RoleManager
import android.database.Cursor
// import android.support.v4.app.ActivityCompat
// import android.support.v7.app.AppCompatActivity
// import android.content.pm.PackageManager

import android.util.Log
import io.flutter.plugin.common.PluginRegistry.Registrar

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.multacc/sms-handler"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if(call.method == "defaultSMS"){
         if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            var mContext : Context = getApplicationContext()
            var roleManager : RoleManager = mContext.getSystemService(Context.ROLE_SERVICE) as RoleManager
            // check if the app is having permission to be as default SMS app
            var isRoleAvailable = roleManager.isRoleAvailable(RoleManager.ROLE_SMS)
            if (isRoleAvailable){
                // check whether your app is already holding the default SMS app role.
                var isRoleHeld = roleManager.isRoleHeld(RoleManager.ROLE_SMS)
                if (!isRoleHeld){
                    var roleRequestIntent = roleManager.createRequestRoleIntent(RoleManager.ROLE_SMS)
                    startActivityForResult(roleRequestIntent,2)
                }
            }
        } else {
            val setSmsAppIntent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
            setSmsAppIntent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
            startActivityForResult(setSmsAppIntent, 1)
        }
      }
      else if (call.method == "sendText"){
        val arguments = call.arguments<Map<String, Any>>()

        val msg: String = arguments["message"] as String
        val num: String = arguments["num"] as String

        val contentResolver : ContentResolver = getApplicationContext().contentResolver

        val smsManager = SmsManager.getDefault() as SmsManager
        smsManager.sendTextMessage(num, null, msg, null, null)

        putSentSmsToDatabase(contentResolver, num, msg)

        result.success(5)
      }
      else if (call.method == "readTexts") {

        var msgs = mutableListOf<String>()

        var cursor : Cursor = getContentResolver().query(Uri.parse("content://sms"), null, null, null, null)!!

        if (cursor.moveToFirst()) { // must check the result to prevent exception
            do {
              var msgData : String = ""
              for(idx in 0 until cursor.getColumnCount())
              {
                  msgData += " " + cursor.getColumnName(idx) + ":" + cursor.getString(idx);
              }
            
              msgs.add(msgData)

            } while (cursor.moveToNext());
        } else {
          // empty box, no SMS
        }

        result.success(msgs)
      }
      else {
        result.notImplemented()
      }
    }
  }

  fun putSentSmsToDatabase(contentResolver: ContentResolver, num: String, msg: String){
    var SMS_URI = "content://sms"
    var MESSAGE_IS_READ = 1
    var MESSAGE_TYPE_OUTBOX = 0
    var MESSAGE_IS_SEEN = 1
    var PASSWORD = "password"
    
    // Create SMS row
    var values = ContentValues()
    values.put("address", num)
    values.put("read", MESSAGE_IS_READ )
    values.put("type", MESSAGE_TYPE_OUTBOX )
    values.put("seen", MESSAGE_IS_SEEN )
    try{
        values.put("body", msg)
    }
    catch (e: Exception) { 
        e.printStackTrace()
    }

    // Push row into the SMS table
    contentResolver.insert( Uri.parse(SMS_URI), values )
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

  fun putSmsToDatabase(contentResolver: ContentResolver, sms: SmsMessage){
    var SMS_URI = "content://sms"
    var MESSAGE_IS_NOT_READ = 0
    var MESSAGE_TYPE_INBOX = 1
    var MESSAGE_IS_NOT_SEEN = 0
    var PASSWORD = "password"
    
    // Create SMS row
    var values = ContentValues()
    values.put( "address", sms.getOriginatingAddress() )
    values.put( "date", sms.getTimestampMillis() )
    values.put( "read", MESSAGE_IS_NOT_READ )
    values.put( "status", sms.getStatus() )
    values.put( "type", MESSAGE_TYPE_INBOX )
    values.put( "seen", MESSAGE_IS_NOT_SEEN )
    try{
        var encryptedPassword = sms.getMessageBody().toString()
        // var encryptedPassword : String = encrypt( PASSWORD, sms.getMessageBody().toString() );
        values.put("body", encryptedPassword)
    }
    catch (e: Exception) { 
        e.printStackTrace()
    }

    // Push row into the SMS table
    contentResolver.insert( Uri.parse(SMS_URI), values )
  }

  //Encrypting stuff that we might want to use later, but didn't bother implementing for now
  //because if you switch back to old SMS app, the message text is scrambled
  var CIPHER_ALGORITHM = "AES"
  var RANDOM_KEY_SIZE = 128
  var RANDOM_GENERATOR_ALGORITHM = "SHA1PRNG"

  @Throws(Exception::class)
  fun encrypt(password: String, data: String) : String {
    var secretKey = generateKey(password.toByteArray())
    var clear = data.toByteArray()

    var secretKeySpec : SecretKeySpec = SecretKeySpec( secretKey, CIPHER_ALGORITHM )
    var cipher : Cipher = Cipher.getInstance( CIPHER_ALGORITHM )
    cipher.init( Cipher.ENCRYPT_MODE, secretKeySpec )

    var encrypted = cipher.doFinal(clear)
    var encryptedString : String = Base64.encodeToString( encrypted, Base64.DEFAULT )

    return encryptedString
  }

  // Decrypts string encoded in Base64
  @Throws(Exception::class)
  fun decrypt(password : String, encryptedData : String ) : String {
      var secretKey = generateKey( password.toByteArray() )

      var secretKeySpec : SecretKeySpec = SecretKeySpec( secretKey, CIPHER_ALGORITHM )
      var cipher : Cipher = Cipher.getInstance( CIPHER_ALGORITHM )
      cipher.init( Cipher.DECRYPT_MODE, secretKeySpec )

      var encrypted = Base64.decode( encryptedData, Base64.DEFAULT )
      var decrypted = cipher.doFinal( encrypted )

      return decrypted.toString()
  }

  @Throws(Exception::class)
  fun generateKey(seed : ByteArray) : ByteArray {
      var keyGenerator : KeyGenerator = KeyGenerator.getInstance( CIPHER_ALGORITHM )
      var secureRandom : SecureRandom = SecureRandom.getInstance( RANDOM_GENERATOR_ALGORITHM )
      secureRandom.setSeed( seed )
      keyGenerator.init( RANDOM_KEY_SIZE, secureRandom )
      var secretKey : SecretKey = keyGenerator.generateKey()
      return secretKey.getEncoded()
  }
}


