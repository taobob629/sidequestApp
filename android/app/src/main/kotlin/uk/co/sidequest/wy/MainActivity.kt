package uk.co.sidequest.wy

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.util.Log
import androidx.annotation.NonNull
import com.alipay.sdk.app.PayTask
import com.tencent.mm.opensdk.constants.ConstantsAPI
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import com.iap.basic.alipay.config.IAPConfiguration
import com.iap.alipayplusclient.AlipayPlusClient
import com.iap.cashier.callback.IAPPaymentSheetEventCallback
import com.iap.cashier.data.model.IAPPaymentSheetEvent

class MainActivity : FlutterFragmentActivity() {
    private lateinit var eventChannel: EventChannel
    var eventSink: EventChannel.EventSink? = null
    var wxApi: IWXAPI? = null
    private val _wxAppId = "wx736c6b186e6f1da8"
    private var mMessageReceiver: BroadcastReceiver? = null

    private lateinit var methodChannel: MethodChannel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val notificationManager: NotificationManager =
            getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val systemChannel = NotificationChannel(
                "system",
                "System Notification",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(systemChannel)

            val msgChannel =
                NotificationChannel("message", "Users Message", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(msgChannel)
        }

        wxApi = WXAPIFactory.createWXAPI(this, _wxAppId)
        wxApi?.registerApp(_wxAppId)

        mMessageReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                wxApi?.registerApp(_wxAppId) // 将该app注册到微信
            }
        }
        registerReceiver(
            mMessageReceiver,
            IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP),
            Context.RECEIVER_NOT_EXPORTED
        )
    }

    override fun onDestroy() {
        unregisterReceiver(mMessageReceiver)
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun onStart() {
        super.onStart()
        val custom = this.intent.getStringExtra("custom")//远程推送启动app后跳转页面
        sendMsgEvent(custom)
    }

    private fun sendMsgEvent(custom: String?) {
        if (custom != null && custom.isNotEmpty()) {
            val mainThread = Handler(Looper.getMainLooper())
            mainThread.postDelayed({ eventSink?.success(custom) }, 200)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        eventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "uk.co.wanyoo.wy.event.msg")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                eventSink = events
                Log.d("Android", "EventChannel onListen called")
            }

            override fun onCancel(arguments: Any?) {
                Log.w("Android", "EventChannel onCancel called")
            }
        })

        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "uk.co.wanyoo.wy.method")
        methodChannel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            when (methodCall.method) {
                "test" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "flutter call test info = $info")
                }

                "getAlipay" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "alipay info = $info")
                    initPay(this@MainActivity, result, info)
                }

                "getWxpay" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "wx pay info = $info")
                    val json = JSONObject(info)
                    val req = PayReq()
                    req.appId = json.getString("appid")
                    req.partnerId = json.getString("partnerid")
                    req.prepayId = json.getString("prepayid")
                    req.nonceStr = json.getString("noncestr")
                    req.timeStamp = json.getString("timestamp")
                    req.packageValue = json.getString("package")
                    req.sign = json.getString("sign")
                    wxApi?.sendReq(req)
                    result.success(info)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * 调用 alipay+支付
     */
    private fun initPay(context: Context, result: MethodChannel.Result, orderInfo: String) {
        val configuration = IAPConfiguration()
        configuration.acquirerId = "5Y39882YDWFU05385"; //fusionpay提供
        configuration.merchantId = "AEF11846594";//fusionpay提供
        configuration.language = "zh_CN";
        AlipayPlusClient.setConfiguration(configuration)
        val callback =
            IAPPaymentSheetEventCallback<IAPPaymentSheetEvent> {
                Log.i("zengchao", "${it.name}, ${it.message}")
                when (it.name) {
                    "EVENT_SELECT_AND_PAY" -> {
                        Log.d("Android", "zengchao EVENT_SELECT_AND_PAY")
                        val mainThread = Handler(Looper.getMainLooper())
                        mainThread.postDelayed({
                            result.success("gotopay")
                        }, 200)
                    }

                    "EVENT_USER_CANCEL" -> {
                        Log.d("Android", "zengchao EVENT_USER_CANCEL")
                        val mainThread = Handler(Looper.getMainLooper())
                        mainThread.postDelayed({
                            result.error("-1","cancel", null)
                        }, 200)
                    }
                }
            }
        AlipayPlusClient.showPaymentSheet(
            context,
            orderInfo,
            callback
        )
        sendMsgEvent("dismissloading")
    }

    @SuppressLint("HandlerLeak")
    private val mHandler: Handler = object : Handler() {
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                1 -> {
                    val payResult = PayResult(msg.obj as Map<String?, String?>)

                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    val resultInfo: String = payResult.result!!// 同步返回需要验证的信息
                    val resultStatus: String = payResult.resultStatus!!
                    println(resultInfo)
                    println(resultStatus)
                    eventSink?.success(resultStatus)
                }

                else -> {
                }
            }
        }
    }
}
