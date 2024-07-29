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
import com.pay360.mobilesdk.payment.*
import com.pay360.mobilesdk.utils.PPOLuhn
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


class MainActivity: FlutterFragmentActivity(),PPOPaymentDelegate {
    private lateinit var eventChannel: EventChannel
    var eventSink: EventChannel.EventSink? = null
    var wxApi: IWXAPI?  = null
    private val _wxAppId = "wx736c6b186e6f1da8"
    private var mMessageReceiver:BroadcastReceiver? = null

    private lateinit var methodChannel: MethodChannel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val notificationManager: NotificationManager =
            getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val systemChannel = NotificationChannel("system", "System Notification", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(systemChannel)

            val msgChannel = NotificationChannel("message", "Users Message", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(msgChannel)
        }

        wxApi = WXAPIFactory.createWXAPI(this, _wxAppId)
        wxApi?.registerApp(_wxAppId)

        mMessageReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                wxApi?.registerApp(_wxAppId) // 将该app注册到微信
            }
        }
        registerReceiver(mMessageReceiver, IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP), Context.RECEIVER_NOT_EXPORTED)
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

    private fun sendMsgEvent(custom: String?){
        if (custom != null && custom.isNotEmpty()) {
            val mainThread = Handler(Looper.getMainLooper())
            mainThread.postDelayed({eventSink?.success(custom)},200)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "uk.co.wanyoo.wy.event.msg")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                eventSink = events
                Log.d("Android", "EventChannel onListen called")
            }
            override fun onCancel(arguments: Any?) {
                Log.w("Android", "EventChannel onCancel called")
            }
        })

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "uk.co.wanyoo.wy.method")
        methodChannel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            when (methodCall.method) {
                "test" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "flutter call test info = $info")
                }
                "getAlipay" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "alipay info = $info")
                    val orderInfo: String = info
                    val payRunnable = Runnable {
                        val alipay = PayTask(this)
                        val ret = alipay.payV2(orderInfo, true)
                        val msg = Message()
                        msg.what = 1
                        msg.obj = ret
                        mHandler.sendMessage(msg)
                    }
                    val payThread = Thread(payRunnable)
                    payThread.start()
                    val list = listOf("")
                    result.success(list)
                }
                "getWxpay" -> {
                    val info = methodCall.argument<String>("info").toString()
                    Log.d("Android", "wx pay info = $info")
                    val json = JSONObject(info)
                    val req = PayReq()
                    req.appId			= json.getString("appid")
                    req.partnerId		= json.getString("partnerid")
                    req.prepayId		= json.getString("prepayid")
                    req.nonceStr		= json.getString("noncestr")
                    req.timeStamp		= json.getString("timestamp")
                    req.packageValue	= json.getString("package")
                    req.sign			= json.getString("sign")
                    wxApi?.sendReq(req)
                    result.success(info)
                }
                "verifyCard" ->{
                    val cardNumber = methodCall.argument<String>("cardNumber").toString()
                    val cardFine = PPOLuhn.validateCreditCardNumber(cardNumber)
                    result.success(cardFine)
                }
                "getCardPay" -> {

                    val token = methodCall.argument<String>("token").toString()
                    val cardNumber = methodCall.argument<String>("cardNumber").toString()
                    val cardHolder = methodCall.argument<String>("cardHolder").toString()
                    val exDate = methodCall.argument<String>("exDate").toString()
                    val cvCode = methodCall.argument<String>("cvCode").toString()
                    val orderId = methodCall.argument<String>("orderId").toString()
                    val amount = methodCall.argument<String>("amount").toString()
                    val recurring = methodCall.argument<String>("recurring").toString()

                    val transaction = PPOTransaction()
                        .setCurrency("GBP")
                        .setAmount(amount.toDouble())
                        .setTransactionDescription("SideQuest Transaction")
                        .setMerchantRef(orderId)
                        .setIsRecurring(recurring)
                        .setIsDeferred("false")

                    val card = PPOCard()
                        .setPan(cardNumber)
                        .setCv2(cvCode)
                        .setExpiryDate(exDate)
                        .setCardHolderName(cardHolder)

                    val address = PPOBillingAddress()
                        .setLine1("")
                        .setLine2("")
                        .setLine3("")
                        .setLine4("")
                        .setCity("")
                        .setRegion("")
                        .setPostcode("")
                        .setCountryCode("GBR")

                    val customer = PPOCustomer()
                        .setEmail("")
                        .setDateOfBirthday("")
                        .setTelephone("")

                    val credentials = PPOCredentials(token, "8001699")

                    val payment = PPOPayment(this@MainActivity, this@MainActivity)
                        .setCredentials(credentials)
                        .setTransaction(transaction)
                        .setCard(card)
                        .setBillingAddress(address)
                        .setCustomer(customer)


                    try {
                        payment.processGuestPayment()
                    } catch (e: Exception) {
                        Log.e("test", e.message!!)
                    }

                    result.success("")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
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
                    val resultInfo : String = payResult.result !!// 同步返回需要验证的信息
                    val resultStatus: String = payResult.resultStatus !!
                    println(resultInfo)
                    println(resultStatus)
                    eventSink?.success(resultStatus)
                }
                else -> {
                }
            }
        }
    }

    override fun cardPaymentProceedWithSuccess(
        ppoPaymentType: PPOPaymentType?,
        ppoPaymentResponse: PPOPaymentResponse?) {
        Log.e("test", "cardPaymentProceedWithSuccess:"+
                ppoPaymentResponse?.processing?.status+"-"+ppoPaymentResponse?.processing?.result)

        val mainThread = Handler(Looper.getMainLooper())
        mainThread.post {
            val result = HashMap<String, String?>()
            if("SUCCESS" == ppoPaymentResponse?.processing?.status) {
                Log.e("test", "send transactionId back")
                result["code"] = "1"
                result["data"] = ppoPaymentResponse.transaction?.transactionId
            }else{
                result["code"] = "0"
                result["data"] = ppoPaymentResponse?.processing?.result
            }
            eventSink?.success(result)
        }
        return

    }

    override fun cardPaymentProceedWithFailure(ppoPaymentType: PPOPaymentType, s: String) {
        Log.e("test", "cardPaymentProceedWithFailure--" + ppoPaymentType.name + "---" + s)
        val result = HashMap<String, String?>()
        result["code"] = "0"
        result["data"] = s
        eventSink?.success(result)
    }
}
