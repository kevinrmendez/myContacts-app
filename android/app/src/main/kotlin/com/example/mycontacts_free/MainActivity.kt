package com.kevinrmendez.contact_app

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

import 	android.telecom.TelecomManager
import 	android.content.ContentValues
import 	android.provider.BlockedNumberContract.BlockedNumbers
import android.net.Uri
import 	android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "myContacts/blockedContacts"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when(call.method){
            "addBlockedNumber" -> {
                val  phoneNumber = call.argument<Int>("number")!!
            val nativeNumber: String = addBlockedNumber(phoneNumber)
            result.success(nativeNumber)}
            "getText" -> {  val hello = getText()
                result.success(hello)}
            
            "launchBlockedNumber" -> {  
                launchBlockedNumber(this)
            }
            }
         
          }
        }
    
    private fun getText(): String {
        return "Hello from kotlin"
      }
    private fun launchBlockedNumber(context: Context) {
        val telecomManager : TelecomManager = context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
        context.startActivity(telecomManager.createManageBlockedNumbersIntent(), null)
      }
    // private fun addBlockedNumber(number:Int): String {
    private fun addBlockedNumber(number: Int): String {
        val blockedNumber = number.toString()
         var values: ContentValues = ContentValues()
        values.put(BlockedNumbers.COLUMN_ORIGINAL_NUMBER, blockedNumber)
        val uri: Uri = getContentResolver().insert(BlockedNumbers.CONTENT_URI, values)
        return number.toString()
      }
    // private fun addBlockedNumber(number: Int): String {
    //     val blockedNumber = number.toString()
    //     ContentValues values = new ContentValues();
    //     values.put(BlockedNumbers.COLUMN_ORIGINAL_NUMBER, blockedNumber);
    //     Uri uri = getContentResolver().insert(BlockedNumbers.CONTENT_URI, values);
    //     return number.toString()
    //   }
}
