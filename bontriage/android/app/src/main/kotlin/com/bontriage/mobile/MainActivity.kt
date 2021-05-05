package com.bontriage.mobile

import android.content.ContentResolver
import android.content.Context
import android.content.pm.PackageManager
import android.media.RingtoneManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private lateinit var resultOfMethodChannel: MethodChannel.Result
    private val CHANNEL = "method_channel"
    private val STORAGE_RQ = 101

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            resultOfMethodChannel = result
            if(call.method == "getStoragePermission") {
                getStoragePermission()
            } else {
                result.notImplemented()
            }

        }
        MethodChannel(flutterEngine.dartExecutor, "dexterx.dev/flutter_local_notifications_example").setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if ("drawableToUri" == call.method) {
                val resourceId = this@MainActivity.resources.getIdentifier(call.arguments as String, "drawable", this@MainActivity.packageName)
                result.success(resourceToUriString(this@MainActivity.applicationContext, resourceId))
            }
            if ("getAlarmUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
            }
            if ("getTimeZoneName" == call.method) {
                result.success(TimeZone.getDefault().id)
            }
        }
    }

    private fun getStoragePermission() {
        if ((ContextCompat.checkSelfPermission(this, android.Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) &&
                (ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)) {
            resultOfMethodChannel.success(true)
        } else {
            when (PackageManager.PERMISSION_GRANTED) {
                ContextCompat.checkSelfPermission(this, android.Manifest.permission.WRITE_EXTERNAL_STORAGE) -> ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE), STORAGE_RQ)
                ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_EXTERNAL_STORAGE) -> ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE), STORAGE_RQ)
                else -> ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE, android.Manifest.permission.READ_EXTERNAL_STORAGE), STORAGE_RQ)

            }
        }
    }




    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == STORAGE_RQ) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                resultOfMethodChannel.success(true)
            } else
                resultOfMethodChannel.success(false)
        }
    }

    companion object {
        private fun resourceToUriString(context: Context, resId: Int): String {
            return (ContentResolver.SCHEME_ANDROID_RESOURCE
                    + "://"
                    + context.resources.getResourcePackageName(resId)
                    + "/"
                    + context.resources.getResourceTypeName(resId)
                    + "/"
                    + context.resources.getResourceEntryName(resId))
        }
    }
}