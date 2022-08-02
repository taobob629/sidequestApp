package uk.co.sidequest.wy

import android.util.Log
import com.pay360.mobilesdk.payment.PPOPaymentDelegate
import com.pay360.mobilesdk.payment.PPOPaymentResponse
import com.pay360.mobilesdk.payment.PPOPaymentType

class CardPayResult : PPOPaymentDelegate {
    override fun cardPaymentProceedWithSuccess(
        ppoPaymentType: PPOPaymentType?,
        ppoPaymentResponse: PPOPaymentResponse?
    ) {
        Log.e("test", "cardPaymentProceedWithSuccess")
    }

    override fun cardPaymentProceedWithFailure(ppoPaymentType: PPOPaymentType, s: String) {
        Log.e("test", "cardPaymentProceedWithFailure--" + ppoPaymentType.name + "---" + s)
    }

}