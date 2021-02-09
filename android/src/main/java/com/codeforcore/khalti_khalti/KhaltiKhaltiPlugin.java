package com.codeforcore.khalti_khalti;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import com.khalti.checkout.helper.KhaltiCheckOut;
import com.khalti.checkout.helper.OnCheckOutListener;
import com.khalti.checkout.helper.PaymentPreference;
import com.khalti.checkout.helper.Config;
import com.khalti.checkout.helper.Config.Builder;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static java.util.Collections.emptyList;

/**
 * KhaltiKhaltiPlugin
 */
public class KhaltiKhaltiPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "khalti_khalti");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("khaltiPayment")) {
            final String publicKey = call.argument("publicKey");
            final String productId = call.argument("productId");
            final String productName = call.argument("productName");
            final Integer amount = call.argument("amount");
            final List<String> paymentTypes = call.argument("paymentPreferences");
            System.out.println(paymentTypes);
            List<PaymentPreference> paymentPreferences = new ArrayList<PaymentPreference>();
            for (int i = 0; i < paymentTypes.size(); i++) {
                paymentPreferences.add(getPaymentPreference(paymentTypes.get(i)));
            }
            final Map<String, Object> customData = call.argument("customData");
            final String pUrl = call.argument("productUrl");
            System.out.println(pUrl);
            final String mobile = call.argument("mobile");
//            Start payment process

            Builder builder = new Config.Builder(publicKey, productId, productName, amount.longValue(), new OnCheckOutListener() {
                @Override
                public void onError(@NonNull String action, @NonNull Map<String, String> errorMap) {
                    Map<String, Object> message = new HashMap<>();
                    message.put("action", action);
                    message.put("errorMessage",errorMap);
                    channel.invokeMethod("khaltiError", errorMap);
                }

                @Override
                public void onSuccess(@NonNull Map<String, Object> data) {
                    channel.invokeMethod("khaltiSucess", data);
                }
            })
                    .paymentPreferences(paymentPreferences)
                    .additionalData(customData)
                    .productUrl(pUrl)
                    .mobile(mobile);

            Config config = builder.build();
            KhaltiCheckOut khaltiCheckOut = new KhaltiCheckOut(activity, config);

            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    khaltiCheckOut.show();
                }
            });
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    PaymentPreference getPaymentPreference(String paymeType) {
        switch (paymeType) {
            case "ebanking":
                return PaymentPreference.EBANKING;
            case "mobilebanking":
                return PaymentPreference.MOBILE_BANKING;
            case "connectips":
                return PaymentPreference.CONNECT_IPS;
            case "sct":
                return PaymentPreference.SCT;
            default:
                return PaymentPreference.KHALTI;
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
