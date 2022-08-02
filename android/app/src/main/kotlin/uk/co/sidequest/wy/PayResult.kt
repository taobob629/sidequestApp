package uk.co.sidequest.wy

import android.text.TextUtils

class PayResult(rawResult: Map<String?, String?>?) {
    /**
     * @return the resultStatus
     */
    var resultStatus: String? = null

    /**
     * @return the result
     */
    var result: String? = null

    /**
     * @return the memo
     */
    private var memo: String? = null

    override fun toString(): String {
        return ("resultStatus={" + resultStatus + "};memo={" + memo
                + "};result={" + result + "}")
    }

    init {
        for (key in rawResult!!.keys) {
            when {
                TextUtils.equals(key, "resultStatus") -> {
                    resultStatus = rawResult[key]
                }
                TextUtils.equals(key, "result") -> {
                    result = rawResult[key]
                }
                TextUtils.equals(key, "memo") -> {
                    memo = rawResult[key]
                }
            }
        }
    }
}