import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/colorful_button.dart';
import '../../../../common/wy_dialog.dart';

class VipInfoDialog extends StatelessWidget {
  final String tips1 = '''
${'Acceptance of Terms of use '.tr}

${'These terms of use which include our privacy policy (link here to privacy policy) and cookie policy (link to cookie policy).'.tr}

${'Changes to terms of use'.tr}

${'SideQuest from time to time may change these terms of use including the privacy policy and cookie policy, such revisions shall be effective immediately provided however, for existing members, such revision shall, unless otherwise stated, be effective 30 days after posting. We will endeavour to post prior versions (including marked changes) of the Terms of Use, if any, for the preceding 12-month period.'.tr}
${'Privacy'.tr}

${'Personally, identifying information is subject to our Privacy Policy https://sidequesthub.com/privacy, the terms of which are incorporated herein. Please review our Privacy Policy to understand our practices.'.tr}
${'We offer subscription plans for a fee that provide benefits to a comprehensive experience and additional SideQuest exclusive offers. Your payment to us will automatically renew and continue until terminated. All payments are non-refundable. You must cancel your subscription one month in advance to avoid paying the subscription fee for the next billing period. We reserve the right to modify, terminate, or otherwise amend the subscription plans we offer from time to time. If you have purchased a Subscription, we will give you advance notice of significant changes to your plan.'.tr}
${'Payment Method'.tr}
${'Unless otherwise indicated, you are required to provide a credit card or other payment method that we, accept to pay the applicable fee for a Subscription. We will charge the payment method you’ve chosen a subscription fee plus any applicable taxes on a recurring basis corresponding to the term of your Subscription. You are solely responsible for all fees charged to the payment method you’ve chosen. We reserve the right to cancel your Subscription if we are unable to successfully charge your payment method.'.tr}

${'Billing Period'.tr}

${'Recurring Billing. By starting your SideQuest membership, you authorize us to charge you a monthly membership fee at the then current rate, and any other charges you may incur in connection with your use of the SideQuest service to your Payment Method. You acknowledge that the amount billed each month may vary from month to month for reasons that may include differing amounts due to promotional offers and/or changing or adding a plan, and you authorize us to charge your Payment Method for such varying amounts, which may be billed monthly in one or more charges.'.tr}
${'Billing Cycle'.tr}

${'The membership fee for our service will be billed at the beginning of the paying portion of your membership and each month thereafter unless and until you cancel your membership. We automatically bill your Payment Method each month on the calendar day corresponding to the commencement of your paying membership. Membership fees are fully earned upon payment. We reserve the right to change the timing of our billing, in particular, as indicated below, if your Payment Method has not successfully settled. In the event your paying membership began on a day not contained in a given month, we may bill your Payment Method on a day in the applicable month or such other day as we deem appropriate. For example, if you started your SideQuest membership or became a paying member on January 31st, your next payment date is likely to be February 28th, and your Payment Method would be billed on that date.'.tr}

${'Price Changes'.tr}

${'We may change our subscription plans and the price of our service from time to time; however, any price changes or changes to your subscription plans will apply no earlier than 30 days following notice to you.'.tr}
${'No Refunds'.tr}
${'PAYMENTS ARE NONREFUNDABLE AND THERE ARE NO REFUNDS OR CREDITS FOR PARTIALLY USED PERIODS. Following any cancellation, however, you will continue to have access to the service through the end of your current billing period. At any time, and for any reason, we may provide a refund, discount, or other consideration to some or all of our members ("credits"). The amount and form of such credits, and the decision to provide them, are at our sole and absolute discretion. The provision of credits in one instance does not entitle you to credits in the future for similar instances, nor does it obligate us to provide credits in the future, under any circumstance.'.tr}
''';

  final String tips2 = '''
${'Cancellations'.tr}
${'In order to cancel your subscription, you may cancel through the app or by contacting us at  support@sidequestmeta.com, you will continue to have access to the SideQuest service through to the end of your monthly billing period. WE DO NOT PROVIDE REFUNDS OR CREDITS FOR ANY PARTIAL-MONTH MEMBERSHIP PERIODS'.tr}
''';

  final String tips3 = '''
${'Passwords and Account Access'.tr}

${'The member who created the SideQuest account and whose Payment Method is charged (the "Account Owner") is responsible for any activity that occurs through the SideQuest account. To maintain control over the account and to prevent anyone from accessing the account (which would include information on viewing history for the account), the Account Owner should maintain control over the SideQuest ready devices that are used to access the service and not reveal the password or details of the Payment Method associated with the account to anyone. You are responsible for updating and maintaining the accuracy of the information you provide to us relating to your account. We can terminate your account or place your account on hold in order to protect you or SideQuest from identity theft or other fraudulent activity.'.tr}
${'SideQuest Service'.tr}

${'You must be at least 16 years of age to become a member of the SideQuest VIP service. Those under the required age may only have access to the base membership.'.tr}
${'The SideQuest service and the SideQuest equipment used during the service is for the personal use of the account holder. During your SideQuest membership, we grant you a limited, non-exclusive, non-transferable right to access the SideQuest service and SideQuest equipment. Except for the foregoing, no right, title or interest shall be transferred to you.'.tr}
${'You may access SideQuest equipment in our stores, our VIP service allows for varying benefits and access to equipment depending on the VIP service plan that you are currently subscribed to as a member, including access to available beverages and depending on circumstances member nights which include industry talks, events, and challenges.'.tr}
${'Your SideQuest monthly benefits reset on a monthly basis and do not accrue those benefits are hours on SideQuest equipment and bubble teas.'.tr}
${'You agree not to archive, reproduce, distribute, modify, display, perform, publish, license, create derivative works from, offer for sale, or use (except as explicitly authorized in these Terms of Use) content and information contained on or obtained from or through the SideQuest service or equipment. You also agree not to: use any robot, spider, scraper or other automated means to access the SideQuest service or equipment; decompile, reverse engineer or disassemble any software or other products or processes accessible through the SideQuest service or equipment; insert any code or product or manipulate the content of the SideQuest service in any way; or use any data mining, data gathering or extraction method. In addition, you agree not to upload, post, e-mail or otherwise send or transmit any material designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications equipment associated with the SideQuest service, including any software viruses or any other computer code, files or programs. We may terminate or restrict your use of our service if you violate these Terms of Use or are engaged in illegal or fraudulent use of the service.'.tr}
''';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.7;
    return WyDialog(
      height: height,
      child: Column(
        children: <Widget>[
          Text(
            "VIP Upgrade Terms & Conditions".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tips1,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  tips2,
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                Text(
                  tips3,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            )
            ),
          ),
          SizedBox(height: 10,),
          ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "CONFIRM".tr,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                ),
              ),
            height: 40,
            onTap: () {
              Get.back(result: true);
            }
          )
        ],
      ),
    );
  }
}