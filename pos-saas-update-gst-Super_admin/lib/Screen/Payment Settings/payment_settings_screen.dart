import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:salespro_saas_admin/Provider/bank_info_provider.dart';
import 'package:salespro_saas_admin/Provider/paypal_info_provider.dart';
import 'package:salespro_saas_admin/Screen/Widgets/static_string/static_string.dart';
import 'package:salespro_saas_admin/model/bank_info_model.dart';
import 'package:salespro_saas_admin/model/paypal_info_model.dart';

import '../Widgets/Constant Data/constant.dart';

class PaymentSettings extends ConsumerStatefulWidget {
  const PaymentSettings({super.key});

  static const String route = '/payment_settings';

  @override
  ConsumerState<PaymentSettings> createState() => _PaymentSettingsState();
}

class _PaymentSettingsState extends ConsumerState<PaymentSettings> {
  // Bank Controllers
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController bankCurrencyController = TextEditingController();

  // PayPal Controllers
  TextEditingController paypalClientIdController = TextEditingController();
  TextEditingController paypalClientSecretController = TextEditingController();

  // Stripe Controllers
  TextEditingController stripePublishableKeyController =
      TextEditingController();
  TextEditingController stripeSecretKeyController = TextEditingController();
  TextEditingController stripeCurrencyController = TextEditingController();

  // SSL Commerz Controllers
  TextEditingController sslStoreIdController = TextEditingController();
  TextEditingController sslStoreSecretController = TextEditingController();

  // FlutterWave Controllers
  TextEditingController flutterWavePublicKeyController =
      TextEditingController();
  TextEditingController flutterWaveSecretKeyController =
      TextEditingController();
  TextEditingController flutterWaveEncKeyController = TextEditingController();
  TextEditingController flutterWaveCurrencyController = TextEditingController();

  // Razorpay Controllers
  TextEditingController razorpayIdController = TextEditingController();
  TextEditingController razorpayCurrencyController = TextEditingController();

  // Tap Controllers
  TextEditingController tapIdController = TextEditingController();

  // KkiPay Controllers
  TextEditingController kkiPayApiKeyController = TextEditingController();

  // PayStack Controllers
  TextEditingController payStackPublicKeyController = TextEditingController();

  // BillPlz Controllers
  TextEditingController billPlzSecretKeyController = TextEditingController();

  // CashFree Controllers
  TextEditingController cashFreeClientIdController = TextEditingController();
  TextEditingController cashFreeClientSecretController =
      TextEditingController();
  TextEditingController cashFreeApiVersionController = TextEditingController();
  TextEditingController cashFreeRequestIdController = TextEditingController();

  // Iyzico Controllers
  TextEditingController iyzicoPublicKeyController = TextEditingController();
  TextEditingController iyzicoSecretKeyController = TextEditingController();

  bool isBankLive = false;
  bool isPaypalLive = false;
  bool isStripeLive = false;
  bool isSSLLive = false;
  bool isFlutterWaveLive = false;
  bool isRazorpayLive = false;
  bool isTapLive = false;
  bool isKkiPayLive = false;
  bool isPayStackLive = false;
  bool isBillPlzLive = false;
  bool isCashFreeLive = false;
  bool isIyzicoLive = false;

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  void postDataIfNoData({required WidgetRef ref}) async {
    PaypalInfoModel paypalInfoModel = PaypalInfoModel(
        paypalClientId: 'paypalClientId',
        paypalClientSecret: 'paypalClientSecret',
        isLive: true);
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Paypal Info');
    adRef.set(paypalInfoModel.toJson());
    ref.refresh(paypalInfoProvider);
  }

  void postDataIfNoDataBank({required WidgetRef ref}) async {
    BankInfoModel paypalInfoModel = BankInfoModel(
        accountName: 'name',
        accountNumber: 'account Number',
        bankAccountCurrency: '',
        bankName: 'Bank Name',
        branchName: '',
        isActive: false,
        swiftCode: 'Code');
    final DatabaseReference adRef =
        FirebaseDatabase.instance.ref().child('Admin Panel').child('Bank Info');
    adRef.set(paypalInfoModel.toJson());
    ref.refresh(paypalInfoProvider);
  }

  void postStripeDataIfNoData({required WidgetRef ref}) async {
    StripeInfoModel stripeInfoModel = StripeInfoModel(
        stripePublishableKey: '',
        stripeSecretKey: '',
        isLive: false,
        stripeCurrency: 'USD');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Stripe Info');
    adRef.set(stripeInfoModel.toJson());
    ref.refresh(stripeInfoProvider);
  }

  void postSSLDataIfNoData({required WidgetRef ref}) async {
    SSLInfoModel sslInfoModel =
        SSLInfoModel(sslStoreId: "", sslStoreSecret: "", isLive: false);
    final DatabaseReference adRef =
        FirebaseDatabase.instance.ref().child('Admin Panel').child('SSL Info');
    adRef.set(sslInfoModel.toJson());
    ref.refresh(sslInfoProvider);
  }

  void postFlutterWaveDataIfNoData({required WidgetRef ref}) async {
    FlutterWaveInfoModel flutterWaveInfoModel = FlutterWaveInfoModel(
        flutterWavePublicKey: "",
        flutterWaveSecretKey: "",
        flutterWaveCurrency: "USD",
        flutterWaveEncKey: "",
        isLive: false);
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('FlutterWave Info');
    adRef.set(flutterWaveInfoModel.toJson());
    ref.refresh(flutterWaveInfoProvider);
  }

  void postRazorpayDataIfNoData({required WidgetRef ref}) async {
    RazorpayInfoModel razorpayInfoModel =
        RazorpayInfoModel(isLive: false, razorpayId: '', razorpayCurrency: '');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Razorpay Info');
    adRef.set(razorpayInfoModel.toJson());
    ref.refresh(razorpayInfoProvider);
  }

  void postTapDataIfNoData({required WidgetRef ref}) async {
    TapInfoModel tapInfoModel = TapInfoModel(isLive: false, tapId: '');
    final DatabaseReference adRef =
        FirebaseDatabase.instance.ref().child('Admin Panel').child('Tap Info');
    adRef.set(tapInfoModel.toJson());
    ref.refresh(tapInfoProvider);
  }

  void postKkiPayDataIfNoData({required WidgetRef ref}) async {
    KkiPayInfoModel kkiPayInfoModel =
        KkiPayInfoModel(isLive: false, kkiPayApiKey: '');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('KkiPay Info');
    adRef.set(kkiPayInfoModel.toJson());
    ref.refresh(kkiPayInfoProvider);
  }

  void postPayStackDataIfNoData({required WidgetRef ref}) async {
    PayStackInfoModel payStackInfoModel =
        PayStackInfoModel(isLive: false, payStackPublicKey: '');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('PayStack Info');
    adRef.set(payStackInfoModel.toJson());
    ref.refresh(payStackInfoProvider);
  }

  void postBillPlzIfNoData({required WidgetRef ref}) async {
    BillPlzInfoModel billPlzInfoModel =
        BillPlzInfoModel(isLive: false, billPlzSecretKey: '');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Billplz Info');
    adRef.set(billPlzInfoModel.toJson());
    ref.refresh(billplzInfoProvider);
  }

  void postCashFreeIfNoData({required WidgetRef ref}) async {
    CashFreeInfoModel cashFreeInfoModel = CashFreeInfoModel(
      isLive: false,
      cashFreeClientId: '',
      cashFreeClientSecret: '',
      cashFreeApiVersion: '',
      cashFreeRequestId: '',
    );
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('CashFree Info');
    adRef.set(cashFreeInfoModel.toJson());
    ref.refresh(cashFreeInfoProvider);
  }

  void postIyzicoIfNoData({required WidgetRef ref}) async {
    IyzicoInfoModel iyzicoInfoModel = IyzicoInfoModel(
        isLive: false, iyzicoSecretKey: '', iyzicoPublicKey: '');
    final DatabaseReference adRef = FirebaseDatabase.instance
        .ref()
        .child('Admin Panel')
        .child('Iyzico Info');
    adRef.set(iyzicoInfoModel.toJson());
    ref.refresh(iyzicoInfoProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          const rf.Condition.between(start: 320, end: 500, value: true)
        ]).value;
    final isDesktop = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.MD.name, value: true)
        ]).value;

    final kBodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: isMobile
            ? 12
            : isDesktop
                ? 16
                : 14);
    final kTitleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: isMobile
            ? 14
            : isDesktop
                ? 18
                : 16,
        fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(
        builder: (_, ref, watch) {
          final paypal = ref.watch(paypalInfoProvider);
          final bank = ref.watch(bankInfoProvider);
          final stripe = ref.watch(stripeInfoProvider);
          final sslCom = ref.watch(sslInfoProvider);
          final flutterWave = ref.watch(flutterWaveInfoProvider);
          final razorpay = ref.watch(razorpayInfoProvider);
          final tap = ref.watch(tapInfoProvider);
          final kkiPay = ref.watch(kkiPayInfoProvider);
          final payStack = ref.watch(payStackInfoProvider);
          final billplz = ref.watch(billplzInfoProvider);
          final cashFree = ref.watch(cashFreeInfoProvider);
          final iyzico = ref.watch(iyzicoInfoProvider);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kWhiteTextColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Settings',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(
                      height: 1,
                      color: Colors.black12,
                    ),
                    const SizedBox(height: 10.0),
                    MediaQuery.of(context).size.width > 778
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  ///_______Bank_info_________________________
                                  bank.when(
                                    data: (bankData) {
                                      bankNameController.text =
                                          bankData.bankName;
                                      branchNameController.text =
                                          bankData.branchName;
                                      accountNumberController.text =
                                          bankData.accountNumber;
                                      accountNameController.text =
                                          bankData.accountName;
                                      swiftCodeController.text =
                                          bankData.swiftCode;
                                      bankCurrencyController.text =
                                          bankData.bankAccountCurrency;
                                      isBankLive = bankData.isActive;
                                      return _buildBankInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          BankInfoModel bankInfo =
                                              BankInfoModel(
                                            bankName: bankNameController.text,
                                            branchName:
                                                branchNameController.text,
                                            accountName:
                                                accountNameController.text,
                                            accountNumber:
                                                accountNumberController.text,
                                            swiftCode: swiftCodeController.text,
                                            bankAccountCurrency:
                                                bankCurrencyController.text,
                                            isActive: isBankLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Bank Info');
                                          await adRef.set(bankInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(bankInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postDataIfNoDataBank(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______Stripe_info_________________________
                                  stripe.when(
                                    data: (stripeData) {
                                      stripePublishableKeyController.text =
                                          stripeData.stripePublishableKey;
                                      stripeSecretKeyController.text =
                                          stripeData.stripeSecretKey;
                                      stripeCurrencyController.text =
                                          stripeData.stripeCurrency;
                                      isStripeLive = stripeData.isLive;
                                      return _buildStripeInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          StripeInfoModel stripeInfo =
                                              StripeInfoModel(
                                            stripePublishableKey:
                                                stripePublishableKeyController
                                                    .text,
                                            stripeSecretKey:
                                                stripeSecretKeyController.text,
                                            stripeCurrency:
                                                stripeCurrencyController.text,
                                            isLive: isStripeLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Stripe Info');
                                          await adRef.set(stripeInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(stripeInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postStripeDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______FlutterWave_info_________________________
                                  flutterWave.when(
                                    data: (flutterData) {
                                      flutterWavePublicKeyController.text =
                                          flutterData.flutterWavePublicKey;
                                      flutterWaveSecretKeyController.text =
                                          flutterData.flutterWaveSecretKey;
                                      flutterWaveEncKeyController.text =
                                          flutterData.flutterWaveEncKey;
                                      flutterWaveCurrencyController.text =
                                          flutterData.flutterWaveCurrency;
                                      isFlutterWaveLive = flutterData.isLive;
                                      return _buildFlutterWaveInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          FlutterWaveInfoModel flutterWaveInfo =
                                              FlutterWaveInfoModel(
                                            flutterWavePublicKey:
                                                flutterWavePublicKeyController
                                                    .text,
                                            flutterWaveSecretKey:
                                                flutterWaveSecretKeyController
                                                    .text,
                                            flutterWaveCurrency:
                                                flutterWaveCurrencyController
                                                    .text,
                                            flutterWaveEncKey:
                                                flutterWaveEncKeyController
                                                    .text,
                                            isLive: isFlutterWaveLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('FlutterWave Info');
                                          await adRef
                                              .set(flutterWaveInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(flutterWaveInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postFlutterWaveDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______Razorpay_info_________________________
                                  razorpay.when(
                                    data: (razorData) {
                                      razorpayIdController.text =
                                          razorData.razorpayId;
                                      razorpayCurrencyController.text =
                                          razorData.razorpayCurrency;
                                      isRazorpayLive = razorData.isLive;
                                      return _buildRazorpayInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          RazorpayInfoModel razorpayInfo =
                                              RazorpayInfoModel(
                                            razorpayId:
                                                razorpayIdController.text,
                                            razorpayCurrency:
                                                razorpayCurrencyController.text,
                                            isLive: isRazorpayLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Razorpay Info');
                                          await adRef
                                              .set(razorpayInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(razorpayInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postRazorpayDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______KkiPay_info_________________________
                                  kkiPay.when(
                                    data: (kkiData) {
                                      kkiPayApiKeyController.text =
                                          kkiData.kkiPayApiKey;
                                      isKkiPayLive = kkiData.isLive;
                                      return _buildKkiPayInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          KkiPayInfoModel kkiPayInfo =
                                              KkiPayInfoModel(
                                            kkiPayApiKey:
                                                kkiPayApiKeyController.text,
                                            isLive: isKkiPayLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('KkiPay Info');
                                          await adRef.set(kkiPayInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(kkiPayInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postKkiPayDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______BillPlz_info_________________________
                                  billplz.when(
                                    data: (billplzData) {
                                      billPlzSecretKeyController.text =
                                          billplzData.billPlzSecretKey;
                                      isBillPlzLive = billplzData.isLive;
                                      return _buildBillPlzInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          BillPlzInfoModel billPlzInfo =
                                              BillPlzInfoModel(
                                            billPlzSecretKey:
                                                billPlzSecretKeyController.text,
                                            isLive: isBillPlzLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Billplz Info');
                                          await adRef.set(billPlzInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(billplzInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postBillPlzIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  ///_______Paypal_info_________________________
                                  paypal.when(
                                    data: (paypalData) {
                                      paypalClientIdController.text =
                                          paypalData.paypalClientId;
                                      paypalClientSecretController.text =
                                          paypalData.paypalClientSecret;
                                      isPaypalLive = paypalData.isLive;
                                      return _buildPaypalInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          PaypalInfoModel paypalInfo =
                                              PaypalInfoModel(
                                            paypalClientId:
                                                paypalClientIdController.text,
                                            paypalClientSecret:
                                                paypalClientSecretController
                                                    .text,
                                            isLive: isPaypalLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Paypal Info');
                                          await adRef.set(paypalInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(paypalInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______SSL_Commerz_info_________________________
                                  sslCom.when(
                                    data: (sslData) {
                                      sslStoreIdController.text =
                                          sslData.sslStoreId;
                                      sslStoreSecretController.text =
                                          sslData.sslStoreSecret;
                                      isSSLLive = sslData.isLive;
                                      return _buildSSLCommerzInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          SSLInfoModel sslInfo = SSLInfoModel(
                                            sslStoreId:
                                                sslStoreIdController.text,
                                            sslStoreSecret:
                                                sslStoreSecretController.text,
                                            isLive: isSSLLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('SSL Info');
                                          await adRef.set(sslInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(sslInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postSSLDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______Razorpay_info_________________________
                                  razorpay.when(
                                    data: (razorData) {
                                      razorpayIdController.text =
                                          razorData.razorpayId;
                                      razorpayCurrencyController.text =
                                          razorData.razorpayCurrency;
                                      isRazorpayLive = razorData.isLive;
                                      return _buildRazorpayInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          RazorpayInfoModel razorpayInfo =
                                              RazorpayInfoModel(
                                            razorpayId:
                                                razorpayIdController.text,
                                            razorpayCurrency:
                                                razorpayCurrencyController.text,
                                            isLive: isRazorpayLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Razorpay Info');
                                          await adRef
                                              .set(razorpayInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(razorpayInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postRazorpayDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______Tap_info_________________________
                                  tap.when(
                                    data: (tapData) {
                                      tapIdController.text = tapData.tapId;
                                      isTapLive = tapData.isLive;
                                      return _buildTapInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          TapInfoModel tapInfo = TapInfoModel(
                                            tapId: tapIdController.text,
                                            isLive: isTapLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Tap Info');
                                          await adRef.set(tapInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(tapInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postTapDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______PayStack_info_________________________
                                  payStack.when(
                                    data: (payStackData) {
                                      payStackPublicKeyController.text =
                                          payStackData.payStackPublicKey;
                                      isPayStackLive = payStackData.isLive;
                                      return _buildPayStackInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          PayStackInfoModel payStackInfo =
                                              PayStackInfoModel(
                                            payStackPublicKey:
                                                payStackPublicKeyController
                                                    .text,
                                            isLive: isPayStackLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('PayStack Info');
                                          await adRef
                                              .set(payStackInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(payStackInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postPayStackDataIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______CashFree_info_________________________
                                  cashFree.when(
                                    data: (cashFreeData) {
                                      cashFreeClientIdController.text =
                                          cashFreeData.cashFreeClientId;
                                      cashFreeClientSecretController.text =
                                          cashFreeData.cashFreeClientSecret;
                                      cashFreeApiVersionController.text =
                                          cashFreeData.cashFreeApiVersion;
                                      cashFreeRequestIdController.text =
                                          cashFreeData.cashFreeRequestId;
                                      isCashFreeLive = cashFreeData.isLive;
                                      return _buildCashFreeInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          CashFreeInfoModel cashFreeInfo =
                                              CashFreeInfoModel(
                                            cashFreeClientId:
                                                cashFreeClientIdController.text,
                                            cashFreeClientSecret:
                                                cashFreeClientSecretController
                                                    .text,
                                            cashFreeApiVersion:
                                                cashFreeApiVersionController
                                                    .text,
                                            cashFreeRequestId:
                                                cashFreeRequestIdController
                                                    .text,
                                            isLive: isCashFreeLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('CashFree Info');
                                          await adRef
                                              .set(cashFreeInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(cashFreeInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postCashFreeIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),

                                  ///_______Iyzico_info_________________________
                                  iyzico.when(
                                    data: (iyzicoData) {
                                      iyzicoPublicKeyController.text =
                                          iyzicoData.iyzicoPublicKey;
                                      iyzicoSecretKeyController.text =
                                          iyzicoData.iyzicoSecretKey;
                                      isIyzicoLive = iyzicoData.isLive;
                                      return _buildIyzicoInfoSection(
                                        context: context,
                                        kTitleStyle: kTitleStyle,
                                        kBodyStyle: kBodyStyle,
                                        onSave: () async {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              dismissOnTap: false);
                                          IyzicoInfoModel iyzicoInfo =
                                              IyzicoInfoModel(
                                            iyzicoPublicKey:
                                                iyzicoPublicKeyController.text,
                                            iyzicoSecretKey:
                                                iyzicoSecretKeyController.text,
                                            isLive: isIyzicoLive,
                                          );
                                          final DatabaseReference adRef =
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Admin Panel')
                                                  .child('Iyzico Info');
                                          await adRef.set(iyzicoInfo.toJson());
                                          EasyLoading.showSuccess(
                                              'Added Successfully');
                                          ref.refresh(iyzicoInfoProvider);
                                        },
                                      );
                                    },
                                    error: (e, stack) {
                                      if (e.toString().contains(
                                          "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                        postIyzicoIfNoData(ref: ref);
                                      }
                                      return Center(child: Text(e.toString()));
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
                              )),
                            ],
                          )
                        : ResponsiveGridRow(children: [
                            ///_______Bank_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: bank.when(
                                data: (bankData) {
                                  bankNameController.text = bankData.bankName;
                                  branchNameController.text =
                                      bankData.branchName;
                                  accountNumberController.text =
                                      bankData.accountNumber;
                                  accountNameController.text =
                                      bankData.accountName;
                                  swiftCodeController.text = bankData.swiftCode;
                                  bankCurrencyController.text =
                                      bankData.bankAccountCurrency;
                                  isBankLive = bankData.isActive;
                                  return _buildBankInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      BankInfoModel bankInfo = BankInfoModel(
                                        bankName: bankNameController.text,
                                        branchName: branchNameController.text,
                                        accountName: accountNameController.text,
                                        accountNumber:
                                            accountNumberController.text,
                                        swiftCode: swiftCodeController.text,
                                        bankAccountCurrency:
                                            bankCurrencyController.text,
                                        isActive: isBankLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Bank Info');
                                      await adRef.set(bankInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(bankInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postDataIfNoDataBank(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______Paypal_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: paypal.when(
                                data: (paypalData) {
                                  paypalClientIdController.text =
                                      paypalData.paypalClientId;
                                  paypalClientSecretController.text =
                                      paypalData.paypalClientSecret;
                                  isPaypalLive = paypalData.isLive;
                                  return _buildPaypalInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      PaypalInfoModel paypalInfo =
                                          PaypalInfoModel(
                                        paypalClientId:
                                            paypalClientIdController.text,
                                        paypalClientSecret:
                                            paypalClientSecretController.text,
                                        isLive: isPaypalLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Paypal Info');
                                      await adRef.set(paypalInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(paypalInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______Stripe_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: stripe.when(
                                data: (stripeData) {
                                  stripePublishableKeyController.text =
                                      stripeData.stripePublishableKey;
                                  stripeSecretKeyController.text =
                                      stripeData.stripeSecretKey;
                                  stripeCurrencyController.text =
                                      stripeData.stripeCurrency;
                                  isStripeLive = stripeData.isLive;
                                  return _buildStripeInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      StripeInfoModel stripeInfo =
                                          StripeInfoModel(
                                        stripePublishableKey:
                                            stripePublishableKeyController.text,
                                        stripeSecretKey:
                                            stripeSecretKeyController.text,
                                        stripeCurrency:
                                            stripeCurrencyController.text,
                                        isLive: isStripeLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Stripe Info');
                                      await adRef.set(stripeInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(stripeInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postStripeDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______SSL_Commerz_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: sslCom.when(
                                data: (sslData) {
                                  sslStoreIdController.text =
                                      sslData.sslStoreId;
                                  sslStoreSecretController.text =
                                      sslData.sslStoreSecret;
                                  isSSLLive = sslData.isLive;
                                  return _buildSSLCommerzInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      SSLInfoModel sslInfo = SSLInfoModel(
                                        sslStoreId: sslStoreIdController.text,
                                        sslStoreSecret:
                                            sslStoreSecretController.text,
                                        isLive: isSSLLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('SSL Info');
                                      await adRef.set(sslInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(sslInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postSSLDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______FlutterWave_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: flutterWave.when(
                                data: (flutterData) {
                                  flutterWavePublicKeyController.text =
                                      flutterData.flutterWavePublicKey;
                                  flutterWaveSecretKeyController.text =
                                      flutterData.flutterWaveSecretKey;
                                  flutterWaveEncKeyController.text =
                                      flutterData.flutterWaveEncKey;
                                  flutterWaveCurrencyController.text =
                                      flutterData.flutterWaveCurrency;
                                  isFlutterWaveLive = flutterData.isLive;
                                  return _buildFlutterWaveInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      FlutterWaveInfoModel flutterWaveInfo =
                                          FlutterWaveInfoModel(
                                        flutterWavePublicKey:
                                            flutterWavePublicKeyController.text,
                                        flutterWaveSecretKey:
                                            flutterWaveSecretKeyController.text,
                                        flutterWaveCurrency:
                                            flutterWaveCurrencyController.text,
                                        flutterWaveEncKey:
                                            flutterWaveEncKeyController.text,
                                        isLive: isFlutterWaveLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('FlutterWave Info');
                                      await adRef.set(flutterWaveInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(flutterWaveInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postFlutterWaveDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______Razorpay_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: razorpay.when(
                                data: (razorData) {
                                  razorpayIdController.text =
                                      razorData.razorpayId;
                                  razorpayCurrencyController.text =
                                      razorData.razorpayCurrency;
                                  isRazorpayLive = razorData.isLive;
                                  return _buildRazorpayInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      RazorpayInfoModel razorpayInfo =
                                          RazorpayInfoModel(
                                        razorpayId: razorpayIdController.text,
                                        razorpayCurrency:
                                            razorpayCurrencyController.text,
                                        isLive: isRazorpayLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Razorpay Info');
                                      await adRef.set(razorpayInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(razorpayInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postRazorpayDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______Tap_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: tap.when(
                                data: (tapData) {
                                  tapIdController.text = tapData.tapId;
                                  isTapLive = tapData.isLive;
                                  return _buildTapInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      TapInfoModel tapInfo = TapInfoModel(
                                        tapId: tapIdController.text,
                                        isLive: isTapLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Tap Info');
                                      await adRef.set(tapInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(tapInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postTapDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______KkiPay_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: kkiPay.when(
                                data: (kkiData) {
                                  kkiPayApiKeyController.text =
                                      kkiData.kkiPayApiKey;
                                  isKkiPayLive = kkiData.isLive;
                                  return _buildKkiPayInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      KkiPayInfoModel kkiPayInfo =
                                          KkiPayInfoModel(
                                        kkiPayApiKey:
                                            kkiPayApiKeyController.text,
                                        isLive: isKkiPayLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('KkiPay Info');
                                      await adRef.set(kkiPayInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(kkiPayInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postKkiPayDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______PayStack_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: payStack.when(
                                data: (payStackData) {
                                  payStackPublicKeyController.text =
                                      payStackData.payStackPublicKey;
                                  isPayStackLive = payStackData.isLive;
                                  return _buildPayStackInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      PayStackInfoModel payStackInfo =
                                          PayStackInfoModel(
                                        payStackPublicKey:
                                            payStackPublicKeyController.text,
                                        isLive: isPayStackLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('PayStack Info');
                                      await adRef.set(payStackInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(payStackInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postPayStackDataIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______BillPlz_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: billplz.when(
                                data: (billplzData) {
                                  billPlzSecretKeyController.text =
                                      billplzData.billPlzSecretKey;
                                  isBillPlzLive = billplzData.isLive;
                                  return _buildBillPlzInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      BillPlzInfoModel billPlzInfo =
                                          BillPlzInfoModel(
                                        billPlzSecretKey:
                                            billPlzSecretKeyController.text,
                                        isLive: isBillPlzLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Billplz Info');
                                      await adRef.set(billPlzInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(billplzInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postBillPlzIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______CashFree_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: cashFree.when(
                                data: (cashFreeData) {
                                  cashFreeClientIdController.text =
                                      cashFreeData.cashFreeClientId;
                                  cashFreeClientSecretController.text =
                                      cashFreeData.cashFreeClientSecret;
                                  cashFreeApiVersionController.text =
                                      cashFreeData.cashFreeApiVersion;
                                  cashFreeRequestIdController.text =
                                      cashFreeData.cashFreeRequestId;
                                  isCashFreeLive = cashFreeData.isLive;
                                  return _buildCashFreeInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      CashFreeInfoModel cashFreeInfo =
                                          CashFreeInfoModel(
                                        cashFreeClientId:
                                            cashFreeClientIdController.text,
                                        cashFreeClientSecret:
                                            cashFreeClientSecretController.text,
                                        cashFreeApiVersion:
                                            cashFreeApiVersionController.text,
                                        cashFreeRequestId:
                                            cashFreeRequestIdController.text,
                                        isLive: isCashFreeLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('CashFree Info');
                                      await adRef.set(cashFreeInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(cashFreeInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postCashFreeIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),

                            ///_______Iyzico_info_________________________
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              xs: 12,
                              child: iyzico.when(
                                data: (iyzicoData) {
                                  iyzicoPublicKeyController.text =
                                      iyzicoData.iyzicoPublicKey;
                                  iyzicoSecretKeyController.text =
                                      iyzicoData.iyzicoSecretKey;
                                  isIyzicoLive = iyzicoData.isLive;
                                  return _buildIyzicoInfoSection(
                                    context: context,
                                    kTitleStyle: kTitleStyle,
                                    kBodyStyle: kBodyStyle,
                                    onSave: () async {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          dismissOnTap: false);
                                      IyzicoInfoModel iyzicoInfo =
                                          IyzicoInfoModel(
                                        iyzicoPublicKey:
                                            iyzicoPublicKeyController.text,
                                        iyzicoSecretKey:
                                            iyzicoSecretKeyController.text,
                                        isLive: isIyzicoLive,
                                      );
                                      final DatabaseReference adRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('Admin Panel')
                                              .child('Iyzico Info');
                                      await adRef.set(iyzicoInfo.toJson());
                                      EasyLoading.showSuccess(
                                          'Added Successfully');
                                      ref.refresh(iyzicoInfoProvider);
                                    },
                                  );
                                },
                                error: (e, stack) {
                                  if (e.toString().contains(
                                      "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                                    postIyzicoIfNoData(ref: ref);
                                  }
                                  return Center(child: Text(e.toString()));
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),
                          ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBankInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bank Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isBankLive,
                        onChanged: (value) {
                          setState(() {
                            isBankLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Bank Name',
                      hintText: 'Enter Bank Name',
                    ),
                    controller: bankNameController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Branch Name',
                      hintText: 'Enter Branch Name',
                    ),
                    controller: branchNameController,
                  ),
                ),
              ),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Account Name',
                    ),
                    controller: accountNameController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      hintText: 'Enter Account Number',
                    ),
                    controller: accountNumberController,
                  ),
                ),
              ),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      border: OutlineInputBorder(),
                      hintText: 'Enter SWIFT Code',
                    ),
                    controller: swiftCodeController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                lg: 6,
                md: 6,
                xs: 12,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Bank Currency',
                      hintText: 'Enter Bank Account Currency',
                    ),
                    controller: bankCurrencyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaypalInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PayPal Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isPaypalLive,
                        onChanged: (value) {
                          setState(() {
                            isPaypalLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Client ID',
                      hintText: 'Enter PayPal Client ID',
                    ),
                    controller: paypalClientIdController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Client Secret',
                      hintText: 'Enter PayPal Client Secret',
                    ),
                    controller: paypalClientSecretController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stripe Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isStripeLive,
                        onChanged: (value) {
                          setState(() {
                            isStripeLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Publishable Key',
                      hintText: 'Enter Stripe Publishable Key',
                    ),
                    controller: stripePublishableKeyController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Secret Key',
                      hintText: 'Enter Stripe Secret Key',
                    ),
                    controller: stripeSecretKeyController,
                  ),
                ),
              ),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Currency',
                      hintText: 'Enter Stripe Currency',
                    ),
                    controller: stripeCurrencyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSSLCommerzInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SSL Commerz Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isSSLLive,
                        onChanged: (value) {
                          setState(() {
                            isSSLLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Store ID',
                      hintText: 'Enter SSL Store ID',
                    ),
                    controller: sslStoreIdController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Store Password',
                      hintText: 'Enter SSL Store Password',
                    ),
                    controller: sslStoreSecretController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFlutterWaveInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FlutterWave Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isFlutterWaveLive,
                        onChanged: (value) {
                          setState(() {
                            isFlutterWaveLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Public Key',
                      hintText: 'Enter FlutterWave Public Key',
                    ),
                    controller: flutterWavePublicKeyController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Secret Key',
                      hintText: 'Enter FlutterWave Secret Key',
                    ),
                    controller: flutterWaveSecretKeyController,
                  ),
                ),
              ),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Encryption Key',
                      hintText: 'Enter FlutterWave Encryption Key',
                    ),
                    controller: flutterWaveEncKeyController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Currency',
                      hintText: 'Enter FlutterWave Currency',
                    ),
                    controller: flutterWaveCurrencyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRazorpayInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Razorpay Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isRazorpayLive,
                        onChanged: (value) {
                          setState(() {
                            isRazorpayLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Razorpay ID',
                      hintText: 'Enter Razorpay ID',
                    ),
                    controller: razorpayIdController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Currency',
                      hintText: 'Enter Razorpay Currency',
                    ),
                    controller: razorpayCurrencyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTapInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tap Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isTapLive,
                        onChanged: (value) {
                          setState(() {
                            isTapLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Tap ID',
                      hintText: 'Enter Tap ID',
                    ),
                    controller: tapIdController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKkiPayInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('KkiPay Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isKkiPayLive,
                        onChanged: (value) {
                          setState(() {
                            isKkiPayLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'API Key',
                      hintText: 'Enter KkiPay API Key',
                    ),
                    controller: kkiPayApiKeyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPayStackInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PayStack Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isPayStackLive,
                        onChanged: (value) {
                          setState(() {
                            isPayStackLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Public Key',
                      hintText: 'Enter PayStack Public Key',
                    ),
                    controller: payStackPublicKeyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBillPlzInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BillPlz Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isBillPlzLive,
                        onChanged: (value) {
                          setState(() {
                            isBillPlzLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Secret Key',
                      hintText: 'Enter BillPlz Secret Key',
                    ),
                    controller: billPlzSecretKeyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFreeInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CashFree Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isCashFreeLive,
                        onChanged: (value) {
                          setState(() {
                            isCashFreeLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Client ID',
                      hintText: 'Enter CashFree Client ID',
                    ),
                    controller: cashFreeClientIdController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Client Secret',
                      hintText: 'Enter CashFree Client Secret',
                    ),
                    controller: cashFreeClientSecretController,
                  ),
                ),
              ),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'API Version',
                      hintText: 'Enter CashFree API Version',
                    ),
                    controller: cashFreeApiVersionController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Request ID',
                      hintText: 'Enter CashFree Request ID',
                    ),
                    controller: cashFreeRequestIdController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIyzicoInfoSection({
    required BuildContext context,
    required TextStyle? kTitleStyle,
    required TextStyle? kBodyStyle,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kNutral300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Iyzico Information', style: kTitleStyle),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.red,
                        value: isIyzicoLive,
                        onChanged: (value) {
                          setState(() {
                            isIyzicoLive = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kNutral300, height: 1),
            const SizedBox(height: 20),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Public Key',
                      hintText: 'Enter Iyzico Public Key',
                    ),
                    controller: iyzicoPublicKeyController,
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                md: 6,
                lg: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    style: kBodyStyle,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Secret Key',
                      hintText: 'Enter Iyzico Secret Key',
                    ),
                    controller: iyzicoSecretKeyController,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSaveCancelButtons(context: context, onSave: onSave),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveCancelButtons({
    required BuildContext context,
    required VoidCallback onSave,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.go('/payment_settings'),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  'Cancel',
                  style: kTextStyle.copyWith(color: kRedTextColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onSave,
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: kBlueTextColor,
            ),
            child: Column(
              children: [
                Text(
                  'Save',
                  style: kTextStyle.copyWith(color: kWhiteTextColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///-------------------hello new -------------------------------------------------------------------------

// class PaymentSettings extends StatefulWidget {
//   const PaymentSettings({super.key});
//
//   static const String route = '/payment_settings';
//
//   @override
//   State<PaymentSettings> createState() => _PaymentSettingsState();
// }
//
// class _PaymentSettingsState extends State<PaymentSettings> {
//   TextEditingController bankNameController = TextEditingController();
//   TextEditingController branchNameController = TextEditingController();
//   TextEditingController accountNameController = TextEditingController();
//   TextEditingController accountNumberController = TextEditingController();
//   TextEditingController swiftCodeController = TextEditingController();
//   TextEditingController bankCurrencyController = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkCurrentUserAndRestartApp();
//   }
//
//   void postDataIfNoData({required WidgetRef ref}) async {
//     PaypalInfoModel paypalInfoModel = PaypalInfoModel(
//         paypalClientId: 'paypalClientId',
//         paypalClientSecret: 'paypalClientSecret',
//         isLive: true);
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('Paypal Info');
//     adRef.set(paypalInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(paypalInfoProvider);
//   }
//
//   void postDataIfNoDataBank({required WidgetRef ref}) async {
//     BankInfoModel paypalInfoModel = BankInfoModel(
//         accountName: 'name',
//         accountNumber: 'account Number',
//         bankAccountCurrency: '',
//         bankName: 'Bank Name',
//         branchName: '',
//         isActive: false,
//         swiftCode: 'Code');
//     final DatabaseReference adRef =
//         FirebaseDatabase.instance.ref().child('Admin Panel').child('Bank Info');
//     adRef.set(paypalInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(paypalInfoProvider);
//   }
//
//   void postStripeDataIfNoData({required WidgetRef ref}) async {
//     StripeInfoModel stripeInfoModel = StripeInfoModel(
//         stripePublishableKey: '',
//         stripeSecretKey: '',
//         isLive: false,
//         stripeCurrency: 'USD');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('Stripe Info');
//     adRef.set(stripeInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(stripeInfoProvider);
//   }
//
//   void postSSLDataIfNoData({required WidgetRef ref}) async {
//     SSLInfoModel sslInfoModel =
//         SSLInfoModel(sslStoreId: "", sslStoreSecret: "", isLive: false);
//     final DatabaseReference adRef =
//         FirebaseDatabase.instance.ref().child('Admin Panel').child('SSL Info');
//     adRef.set(sslInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(sslInfoProvider);
//   }
//
//   void postFlutterWaveDataIfNoData({required WidgetRef ref}) async {
//     FlutterWaveInfoModel flutterWaveInfoModel = FlutterWaveInfoModel(
//         flutterWavePublicKey: "",
//         flutterWaveSecretKey: "",
//         flutterWaveCurrency: "USD",
//         flutterWaveEncKey: "",
//         isLive: false);
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('FlutterWave Info');
//     adRef.set(flutterWaveInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(flutterWaveInfoProvider);
//   }
//
//   void postRazorpayDataIfNoData({required WidgetRef ref}) async {
//     RazorpayInfoModel razorpayInfoModel =
//         RazorpayInfoModel(isLive: false, razorpayId: '', razorpayCurrency: '');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('Razorpay Info');
//     adRef.set(razorpayInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(razorpayInfoProvider);
//   }
//
//   void postTapDataIfNoData({required WidgetRef ref}) async {
//     TapInfoModel tapInfoModel = TapInfoModel(isLive: false, tapId: '');
//     final DatabaseReference adRef =
//         FirebaseDatabase.instance.ref().child('Admin Panel').child('Tap Info');
//     adRef.set(tapInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(tapInfoProvider);
//   }
//
//   void postKkiPayDataIfNoData({required WidgetRef ref}) async {
//     KkiPayInfoModel kkiPayInfoModel =
//         KkiPayInfoModel(isLive: false, kkiPayApiKey: '');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('KkiPay Info');
//     adRef.set(kkiPayInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(kkiPayInfoProvider);
//   }
//
//   void postPayStackDataIfNoData({required WidgetRef ref}) async {
//     PayStackInfoModel payStackInfoModel =
//         PayStackInfoModel(isLive: false, payStackPublicKey: '');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('PayStack Info');
//     adRef.set(payStackInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(payStackInfoProvider);
//   }
//
//   void postBillPlzIfNoData({required WidgetRef ref}) async {
//     BillPlzInfoModel billPlzInfoModel =
//         BillPlzInfoModel(isLive: false, billPlzSecretKey: '');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('Billplz Info');
//     adRef.set(billPlzInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(billplzInfoProvider);
//   }
//
//   void postCashFreeIfNoData({required WidgetRef ref}) async {
//     CashFreeInfoModel cashFreeInfoModel = CashFreeInfoModel(
//       isLive: false,
//       cashFreeClientId: '',
//       cashFreeClientSecret: '',
//       cashFreeApiVersion: '',
//       cashFreeRequestId: '',
//     );
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('CashFree Info');
//     adRef.set(cashFreeInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(cashFreeInfoProvider);
//   }
//
//   void postIyzicoIfNoData({required WidgetRef ref}) async {
//     IyzicoInfoModel iyzicoInfoModel = IyzicoInfoModel(
//         isLive: false, iyzicoSecretKey: '', iyzicoPublicKey: '');
//     final DatabaseReference adRef = FirebaseDatabase.instance
//         .ref()
//         .child('Admin Panel')
//         .child('Iyzico Info');
//     adRef.set(iyzicoInfoModel.toJson());
//
//     ///____provider_refresh____________________________________________
//     ref.refresh(iyzicoInfoProvider);
//   }
//
//   bool isLive = false;
//   bool isBankLive = false;
//   String id = '';
//   String secret = '';
//
//   int i = 0;
//   int j = 0;
//   int stripe = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final isMobile = rf.ResponsiveValue<bool>(context,
//         defaultValue: false,
//         conditionalValues: [
//           const rf.Condition.between(start: 320, end: 500, value: true)
//         ]).value;
//     final isDesktop = rf.ResponsiveValue<bool>(context,
//         defaultValue: false,
//         conditionalValues: [
//           rf.Condition.largerThan(name: BreakpointName.MD.name, value: true)
//         ]).value;
//
//     final kBodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
//         fontSize: isMobile
//             ? 12
//             : isDesktop
//                 ? 16
//                 : 14);
//     final kTitleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
//         fontSize: isMobile
//             ? 14
//             : isDesktop
//                 ? 18
//                 : 16,
//         fontWeight: FontWeight.w600);
//     return Scaffold(
//       backgroundColor: kDarkWhite,
//       // drawer: const Drawer(
//       //   child: SideBarWidget(
//       //     index: 5,
//       //     isTab: false,
//       //   ),
//       // ),
//       // appBar: const GlobalAppbar(),
//       body: Consumer(
//         builder: (_, ref, watch) {
//           final paypal = ref.watch(paypalInfoProvider);
//           final bank = ref.watch(bankInfoProvider);
//           final stripe = ref.watch(stripeInfoProvider);
//           final sslCom = ref.watch(sslInfoProvider);
//           final flutterWave = ref.watch(flutterWaveInfoProvider);
//           final razorpay = ref.watch(razorpayInfoProvider);
//           final tap = ref.watch(tapInfoProvider);
//           final kkiPay = ref.watch(kkiPayInfoProvider);
//           final payStack = ref.watch(payStackInfoProvider);
//           final billplz = ref.watch(billplzInfoProvider);
//           final cashFree = ref.watch(cashFreeInfoProvider);
//           final iyzico = ref.watch(iyzicoInfoProvider);
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: kWhiteTextColor),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Payment Settings',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge
//                           ?.copyWith(fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 10.0),
//                     const Divider(
//                       height: 1,
//                       color: Colors.black12,
//                     ),
//                     const SizedBox(height: 10.0),
//                     ResponsiveGridRow(children: [
//                       ///_______Bank_info_________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: bank.when(
//                           data: (bankData) {
//                             bankNameController.text = bankData.bankName;
//                             branchNameController.text = bankData.branchName;
//                             accountNumberController.text =
//                                 bankData.accountNumber;
//                             accountNameController.text = bankData.accountName;
//                             swiftCodeController.text = bankData.swiftCode;
//                             bankCurrencyController.text =
//                                 bankData.bankAccountCurrency;
//                             j == 0 ? isBankLive = bankData.isActive : null;
//                             j++;
//                             return Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: kNutral300),
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 12),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text('Bank Information',
//                                             style: kTitleStyle),
//                                         SizedBox(
//                                           height: 20,
//                                           width: 36,
//                                           child: Transform.scale(
//                                             scale: 0.7,
//                                             child: CupertinoSwitch(
//                                               trackColor: Colors.red,
//                                               value: isBankLive,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   isBankLive = value;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Divider(
//                                     color: kNutral300,
//                                     height: 1,
//                                   ),
//                                   const SizedBox(height: 20),
//
//                                   ResponsiveGridRow(children: [
//                                     ///________bank_Name____________________________
//                                     ResponsiveGridCol(
//                                       xs: 12,
//                                       md: 6,
//                                       lg: 6,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: TextFormField(
//                                           style: kBodyStyle,
//                                           decoration: kInputDecoration.copyWith(
//                                             labelText: 'Bank Name',
//                                             hintText: 'Enter Bank Name',
//                                           ),
//                                           controller: bankNameController,
//                                         ),
//                                       ),
//                                     ),
//
//                                     ///________Branch_name_____________________________
//                                     ResponsiveGridCol(
//                                       xs: 12,
//                                       md: 6,
//                                       lg: 6,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: TextFormField(
//                                           style: kBodyStyle,
//                                           decoration: kInputDecoration.copyWith(
//                                             labelText: 'Branch Name',
//                                             hintText: 'Enter Branch Name',
//                                           ),
//                                           controller: branchNameController,
//                                         ),
//                                       ),
//                                     ),
//                                   ]),
//
//                                   ResponsiveGridRow(children: [
//                                     ///________Account_name_____________________________
//                                     ResponsiveGridCol(
//                                         lg: 6,
//                                         md: 6,
//                                         xs: 12,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(12.0),
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             decoration:
//                                                 kInputDecoration.copyWith(
//                                               border: OutlineInputBorder(),
//                                               hintText: 'Enter Account Name',
//                                             ),
//                                             controller: accountNameController,
//                                           ),
//                                         )),
//
//                                     ///________Account_Number____________________________
//                                     ResponsiveGridCol(
//                                         lg: 6,
//                                         md: 6,
//                                         xs: 12,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(12.0),
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             decoration:
//                                                 kInputDecoration.copyWith(
//                                               hintText: 'Enter Account Number',
//                                             ),
//                                             controller: accountNumberController,
//                                           ),
//                                         )),
//                                   ]),
//
//                                   ResponsiveGridRow(children: [
//                                     ///________Swift code_____________________________
//                                     ResponsiveGridCol(
//                                         lg: 6,
//                                         md: 6,
//                                         xs: 12,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(12.0),
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             decoration:
//                                                 kInputDecoration.copyWith(
//                                               border: OutlineInputBorder(),
//                                               hintText: 'Enter SWIFT Code',
//                                             ),
//                                             controller: swiftCodeController,
//                                           ),
//                                         )),
//
//                                     ///________Bank currency____________________________
//                                     ResponsiveGridCol(
//                                         lg: 6,
//                                         md: 6,
//                                         xs: 12,
//                                         child: Padding(
//                                             padding: const EdgeInsets.all(12.0),
//                                             child: TextFormField(
//                                               style: kBodyStyle,
//                                               decoration:
//                                                   kInputDecoration.copyWith(
//                                                 labelText: 'Bank Currency',
//                                                 hintText:
//                                                     'Enter Bank Account Currency',
//                                               ),
//                                               controller:
//                                                   bankCurrencyController,
//                                             ))),
//                                   ]),
//
//                                   const SizedBox(height: 20),
//
//                                   ///_________Buttons_____________________________________
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               border:
//                                                   Border.all(color: Colors.red),
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.white),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                   color: kRedTextColor,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           BankInfoModel bankInfo =
//                                               BankInfoModel(
//                                             bankName: bankNameController.text,
//                                             branchName:
//                                                 branchNameController.text,
//                                             accountName:
//                                                 accountNameController.text,
//                                             accountNumber:
//                                                 accountNumberController.text,
//                                             swiftCode: swiftCodeController.text,
//                                             bankAccountCurrency:
//                                                 bankCurrencyController.text,
//                                             isActive: isBankLive,
//                                           );
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Bank Info');
//                                           await adRef.set(bankInfo.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(bankInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             print("Error: $e"); // Print the error message
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postDataIfNoDataBank(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Paypal_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: paypal.when(
//                           data: (reports) {
//                             i == 0 ? isLive = reports.isLive : null;
//                             i == 0 ? id = reports.paypalClientId : null;
//                             i == 0 ? secret = reports.paypalClientSecret : null;
//                             i++;
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('PayPal:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           // width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           // width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'PayPal Clint Id',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           // width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.paypalClientId,
//                                             onChanged: (value) {
//                                               id = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           // width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'PayPal Clint Secret',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           // width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.paypalClientSecret,
//                                             onChanged: (value) {
//                                               secret = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           if (reports.isLive != isLive ||
//                                               reports.paypalClientId != id ||
//                                               reports.paypalClientSecret !=
//                                                   secret) {
//                                             EasyLoading.show(
//                                                 status: 'Loading...',
//                                                 dismissOnTap: false);
//                                             final DatabaseReference adRef =
//                                                 FirebaseDatabase.instance
//                                                     .ref()
//                                                     .child('Admin Panel')
//                                                     .child('Paypal Info');
//                                             await adRef.update({
//                                               'isLive': isLive,
//                                               'paypalClientId': id,
//                                               'paypalClientSecret': secret,
//                                             });
//                                             EasyLoading.showSuccess(
//                                                 'Added Successfully');
//
//                                             ///____provider_refresh____________________________________________
//                                             ref.refresh(paypalInfoProvider);
//                                           } else {
//                                             EasyLoading.showError(
//                                                 'No change found!');
//                                           }
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             print("paypal: $e");
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Stripe_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: stripe.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Stripe:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Stripe Publishable Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.stripePublishableKey,
//                                             onChanged: (value) {
//                                               reports.stripePublishableKey =
//                                                   value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Stripe Secret Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.stripeSecretKey,
//                                             onChanged: (value) {
//                                               reports.stripeSecretKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Stripe Currency',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: TextFormField(
//                                           style: kBodyStyle,
//                                           initialValue: reports.stripeCurrency,
//                                           onChanged: (value) {
//                                             reports.stripeCurrency = value;
//                                           },
//                                           decoration: const InputDecoration(
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Stripe Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(paypalInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postStripeDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________SSL_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: sslCom.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('SSL Commerz:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Store ID',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue: reports.sslStoreId,
//                                             onChanged: (value) {
//                                               reports.sslStoreId = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Store Password',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: TextFormField(
//                                           style: kBodyStyle,
//                                           initialValue: reports.sslStoreSecret,
//                                           onChanged: (value) {
//                                             reports.sslStoreSecret = value;
//                                           },
//                                           decoration: const InputDecoration(
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('SSL Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(sslInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postSSLDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Flutterwave_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: flutterWave.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Flutter Wave:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Public Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.flutterWavePublicKey,
//                                             onChanged: (value) {
//                                               reports.flutterWavePublicKey =
//                                                   value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Secret Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.flutterWaveSecretKey,
//                                             onChanged: (value) {
//                                               reports.flutterWaveSecretKey =
//                                                   value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Encryption Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.flutterWaveEncKey,
//                                             onChanged: (value) {
//                                               reports.flutterWaveEncKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('FlutterWave Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(flutterWaveInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postFlutterWaveDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Razorpay_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: razorpay.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Razorpay:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Razorpay Id',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue: reports.razorpayId,
//                                             onChanged: (value) {
//                                               reports.razorpayId = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Currency',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: TextFormField(
//                                           style: kBodyStyle,
//                                           initialValue:
//                                               reports.razorpayCurrency,
//                                           onChanged: (value) {
//                                             reports.razorpayCurrency = value;
//                                           },
//                                           decoration: const InputDecoration(
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Razorpay Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(razorpayInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postRazorpayDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Tap_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: tap.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Tap:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Public Key',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue: reports.tapId,
//                                             onChanged: (value) {
//                                               reports.tapId = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Tap Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(tapInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postTapDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________kkipay_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: kkiPay.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Kki Pay:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Public Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue: reports.kkiPayApiKey,
//                                             onChanged: (value) {
//                                               reports.kkiPayApiKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('KkiPay Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(kkiPayInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postKkiPayDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Paystack_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: payStack.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('PayStack:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 2,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Public Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.payStackPublicKey,
//                                             onChanged: (value) {
//                                               reports.payStackPublicKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('PayStack Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(payStackInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postPayStackDataIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________BillPlz_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: billplz.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('BillPlz:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Secret Key',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.billPlzSecretKey,
//                                             onChanged: (value) {
//                                               reports.billPlzSecretKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Billplz Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(billplzInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postBillPlzIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________CashFree_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: cashFree.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('CashFree:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Is Live',
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: CupertinoSwitch(
//                                           trackColor: Colors.red,
//                                           value: reports.isLive,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               reports.isLive = value;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Client Id',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.cashFreeClientId,
//                                             onChanged: (value) {
//                                               reports.cashFreeClientId = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Client Secret',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.cashFreeClientSecret,
//                                             onChanged: (value) {
//                                               reports.cashFreeClientSecret =
//                                                   value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'API Version',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.cashFreeApiVersion,
//                                             onChanged: (value) {
//                                               reports.cashFreeApiVersion =
//                                                   value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Request ID',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.cashFreeRequestId,
//                                             onChanged: (value) {
//                                               reports.cashFreeRequestId = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('CashFree Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(cashFreeInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postCashFreeIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//
//                       ///_________Iyzico_info___________________________
//                       ResponsiveGridCol(
//                         lg: 6,
//                         md: 12,
//                         xs: 12,
//                         child: iyzico.when(
//                           data: (reports) {
//                             return SizedBox(
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 20),
//                                   Text('Iyzico:', style: kTitleStyle),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         width: 130,
//                                         height: 50,
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(
//                                           'Is Live',
//                                           style: kBodyStyle,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       CupertinoSwitch(
//                                         trackColor: Colors.red,
//                                         value: reports.isLive,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             reports.isLive = value;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Public Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             initialValue:
//                                                 reports.iyzicoPublicKey,
//                                             onChanged: (value) {
//                                               reports.iyzicoPublicKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 130,
//                                           height: 50,
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             'Secret Key',
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: kBodyStyle,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       Expanded(
//                                         flex: 6,
//                                         child: SizedBox(
//                                           width: 500,
//                                           child: TextFormField(
//                                             style: kBodyStyle,
//                                             initialValue:
//                                                 reports.iyzicoSecretKey,
//                                             onChanged: (value) {
//                                               reports.iyzicoSecretKey = value;
//                                             },
//                                             decoration: const InputDecoration(
//                                               border: OutlineInputBorder(),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: (() {
//                                           // Navigator.pop(context);
//                                           // const PaymentSettings().launch(context);
//                                           context.go('/payment_settings');
//                                         }),
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: Colors.red),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Cancel',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 20),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           EasyLoading.show(
//                                               status: 'Loading...',
//                                               dismissOnTap: false);
//                                           final DatabaseReference adRef =
//                                               FirebaseDatabase.instance
//                                                   .ref()
//                                                   .child('Admin Panel')
//                                                   .child('Iyzico Info');
//                                           await adRef.set(reports.toJson());
//                                           EasyLoading.showSuccess(
//                                               'Added Successfully');
//
//                                           ///____provider_refresh____________________________________________
//                                           ref.refresh(iyzicoInfoProvider);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           padding: const EdgeInsets.all(10.0),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5.0),
//                                               color: kBlueTextColor),
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 'Save',
//                                                 style: kTextStyle.copyWith(
//                                                     color: kWhiteTextColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           },
//                           error: (e, stack) {
//                             if (e.toString().contains(
//                                 "TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
//                               postIyzicoIfNoData(ref: ref);
//                             }
//                             return Center(
//                               child: Text(e.toString()),
//                             );
//                           },
//                           loading: () {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
