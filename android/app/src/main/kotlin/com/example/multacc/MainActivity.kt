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

import android.util.Log
import io.flutter.plugin.common.PluginRegistry.Registrar

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.flutter.sms/default-sms"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
	// GeneratedPluginRegistrant.registerWith(new ShimPluginRegistry(flutterEngine));
	
	  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // Note: this method is invoked on the main thread.
      	call, result ->
    //   if (call.method == "getBatteryLevel") {
    //     val batteryLevel = getBatteryLevel()

    //     if (batteryLevel != -1) {
    //       result.success(batteryLevel)
    //     } else {
    //       result.error("UNAVAILABLE", "Battery level not available.", null)
    //     }
        if(call.method == "defaultSMS"){
          // val hello: Int
          // hello = 5
          val setSmsAppIntent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
          setSmsAppIntent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
          startActivityForResult(setSmsAppIntent, 1)
        }
       	else {
        	result.notImplemented()
      	}
    }

  }
  
  // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
  //   super.onActivityResult(requestCode, resultCode, data)
  //   if (requestCode != Activity.RESULT_OK){
  //       return
  //   }
  //   when(resultCode){
  //       REQUEST_DEFAULT_APP -> //user allowed the app to become default
  //   }
  // }

  // override fun onRequestPermissionsResult(requestCode: Int,
  //   permissions: Array<String>, grantResults: IntArray) {
  //     val granted = if(permission.checkPermissionGranted(requestCode, permissions, grantResults)) "permission granted" else "permission not granted"
  //     Toast.makeText(this,granted, Toast.LENGTH_SHORT).show()
  //   }
  
  // fun checkPermissionGranted(requestCode: Int, permissions: Array<String>, grantResults: IntArray): Boolean{
  //       when (requestCode) {
  //           MY_PERMISSIONS_REQUEST_SMS -> {
  //               // If request is cancelled, the result arrays are empty.
  //               return (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
  //           }
  //       }
  //       return false
  // }
  

  // private fun getBatteryLevel(): Int {
  //   val batteryLevel: Int
  //   if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
  //     val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
  //     batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
  //   } else {
  //     val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
  //     batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
  //   }

  //   return batteryLevel
  // }

}
