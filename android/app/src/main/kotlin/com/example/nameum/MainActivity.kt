package com.example.nameum
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.dexterous.flutterlocalnotifications.models.NotificationDetails
import com.example.nameum.Channel.CHANNEL_NOTIFICATION
import com.example.nameum.ChannelInfo.CHANNEL_DISCRIPTION
import com.example.nameum.ChannelInfo.CHANNEL_ID
import com.example.nameum.ChannelInfo.CHANNEL_NAME
import com.example.nameum.ChannelInfo.IMPORTANCE
import com.example.nameum.MethodChannelMethods.SHOW
import com.example.nameum.NotificationActions.NOTIFICATION_CLICKED
import com.example.nameum.NotificationEvents.EVENT_TO_EVENT
import com.example.nameum.NotificationInfo.NOTIFICATION_INFO
import com.example.nameum.NotificationInfo.ON_CLICK_EVENT_TYPE
import com.example.nameum.NotificationInfo.STORE_ID
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        if (intent?.action == NOTIFICATION_CLICKED) {
            flutterEngine?.dartExecutor?.let {
                EVENT_TO_EVENT[intent.getStringExtra(ON_CLICK_EVENT_TYPE).toString()]?.let { it1 ->
                    MethodChannel(it.binaryMessenger, CHANNEL_NOTIFICATION).invokeMethod(
                        it1,
                        mapOf(STORE_ID to intent.getStringExtra(STORE_ID)))
                }
            }
        }
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NOTIFICATION).setMethodCallHandler {
            call, result ->
            if (call.method == SHOW){
                if (call.arguments != null){
                    show(call)
                }
            }
        }
    }
    private fun show(call: MethodCall) {
        try {
            var arguments: Map<String, Object> = call.arguments()!!
            var details: NotificationDetails = NotificationDetails.from(arguments)
            var channelDetails = ChannelProperties(
                id = arguments[CHANNEL_ID] as String,
                name = arguments[CHANNEL_NAME] as String,
                description = arguments[CHANNEL_DISCRIPTION] as String,
                importance = arguments[IMPORTANCE] as Int
            )

            createNotificationChannel(channelDetails)

            val intent = Intent(this, MainActivity::class.java)

            intent.action = NOTIFICATION_CLICKED
            val notifInfo = arguments[NOTIFICATION_INFO] as Map<String, Any>

            // 일단 가게 관련한 알람들만 사용한다고 가정
            intent.putExtra(STORE_ID, notifInfo[STORE_ID].toString())
            intent.putExtra(ON_CLICK_EVENT_TYPE, notifInfo[ON_CLICK_EVENT_TYPE].toString())
            val pendingIntent: PendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
            var builder = NotificationCompat.Builder(this, channelDetails.id)
                .setSmallIcon(R.drawable.splash)
                .setContentTitle(details.title)
                .setContentText(details.body)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            with(NotificationManagerCompat.from(this)) {
                // notificationId is a unique int for each notification that you must define
                notify(details.id, builder.build())
            }
        } catch (e: java.lang.Exception) {
            e.message?.let { Log.e("Exception", it) }
        }
    }
    private fun createNotificationChannel(details: ChannelProperties) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                val channel = NotificationChannel(details.id, details.name, details.importance).apply {
                    description = details.description
                }
                notificationManager.createNotificationChannel(channel)
            }
        } catch (e: java.lang.Exception) {
            e.message?.let { Log.e("Exception", it) }
        }
    }
    
}
