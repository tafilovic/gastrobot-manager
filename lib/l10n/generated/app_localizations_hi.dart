// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'जारी रखने के लिए साइन इन करें';

  @override
  String get loginEmailLabel => 'ईमेल';

  @override
  String get loginEmailHint => 'उदा. user@example.com';

  @override
  String get loginEmailRequired => 'ईमेल दर्ज करें';

  @override
  String get loginEmailInvalid => 'मान्य ईमेल दर्ज करें';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordRequired => 'पासवर्ड दर्ज करें';

  @override
  String get loginRememberEmail => 'ईमेल याद रखें';

  @override
  String get loginButton => 'साइन इन';

  @override
  String get loginFailed => 'साइन इन विफल। कृपया पुनः प्रयास करें।';

  @override
  String get loginRoleNotSupported =>
      'आपकी भूमिका समर्थित नहीं है। यह ऐप वेटर, रसोइये और बारटेंडर के लिए है।';

  @override
  String get loginRegisterButton => 'पंजीकरण';

  @override
  String get registerTitle => 'खाता बनाएं';

  @override
  String get registerFirstnameLabel => 'पहला नाम';

  @override
  String get registerLastnameLabel => 'अंतिम नाम';

  @override
  String get registerEmailLabel => 'ईमेल';

  @override
  String get registerPasswordConfirmLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get registerPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get registerFieldRequired => 'यह फ़ील्ड आवश्यक है';

  @override
  String get registerSubmitButton => 'पंजीकरण करें';

  @override
  String get registerSuccessTitle => 'पंजीकरण सफल';

  @override
  String registerSuccessMessage(String email) {
    return '$email पर सत्यापन लिंक भेजा गया है। कृपया ईमेल खोलें और अपना खाता सक्रिय करने के लिए लिंक पर क्लिक करें। उसके बाद आप ऐप में साइन इन कर सकते हैं।';
  }

  @override
  String get registerSuccessOk => 'ठीक';

  @override
  String get registerErrorGeneric => 'कुछ गलत हुआ। पुनः प्रयास करें।';

  @override
  String get registerBackToLogin => 'साइन इन पर वापस जाएं';

  @override
  String get profileTitle => 'मेरी प्रोफ़ाइल';

  @override
  String get profileLabelName => 'नाम';

  @override
  String get profileLabelEmail => 'ईमेल';

  @override
  String get profileLabelPassword => 'पासवर्ड';

  @override
  String get profileChangePassword => 'बदलें';

  @override
  String get profileReservationReminder => 'आरक्षण अनुस्मारक';

  @override
  String get profileReservationReminderHint =>
      '*पूर्व-ऑर्डर भोजन तैयार करने की सूचना आप कितनी जल्दी पाते हैं';

  @override
  String get profileReservationReminderValue => '1 घंटे पहले';

  @override
  String get profileLabelLanguage => 'भाषा';

  @override
  String get profileDeleteAccount => 'खाता हटाएं';

  @override
  String get profileDeleteAccountAction => 'हटाने के लिए टैप करें';

  @override
  String get profileDeleteAccountWarning =>
      'यदि आप अपनी प्रोफ़ाइल हटाते हैं, तो उसे पुनर्स्थापित नहीं किया जा सकेगा।';

  @override
  String get profileLabelCurrency => 'मुद्रा';

  @override
  String get profileLanguageValue => 'हिन्दी';

  @override
  String get profileDrinksList => 'पेय सूची';

  @override
  String get profileShiftScheduleLabel => 'शिफ्ट अनुसूची';

  @override
  String get profileShiftScheduleView => 'देखें';

  @override
  String get shiftScheduleDialogTitle => 'शिफ्ट अनुसूची';

  @override
  String get shiftScheduleLoadError => 'अनुसूची लोड नहीं हो सकी।';

  @override
  String get shiftScheduleEmpty => 'कोई अनुसूची डेटा नहीं।';

  @override
  String get shiftScheduleRetry => 'पुनः प्रयास करें';

  @override
  String get shiftScheduleSelfLabel => 'मैं';

  @override
  String get profileLogout => 'लॉग आउट';

  @override
  String get profileImageDialogTitle => 'प्रोफ़ाइल चित्र';

  @override
  String get profileImageUploadButton => 'चित्र अपलोड करें';

  @override
  String get profileImageMaxSize => '3MB (अधिकतम चित्र आकार)';

  @override
  String get profileImageSaveChanges => 'परिवर्तन सहेजें';

  @override
  String get logoutDialogTitle => 'लॉग आउट';

  @override
  String get logoutDialogMessage => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get logoutCancel => 'रद्द करें';

  @override
  String get logoutConfirm => 'लॉग आउट';

  @override
  String get navOrders => 'ऑर्डर';

  @override
  String get navReady => 'तैयार';

  @override
  String get navPreparing => 'तैयारी में';

  @override
  String get navReservations => 'आरक्षण';

  @override
  String get navMenu => 'मेनू';

  @override
  String get navDrinks => 'पेय';

  @override
  String get navZones => 'ज़ोन';

  @override
  String get tablesReserve => 'आरक्षित करें';

  @override
  String get tablesOrder => 'ऑर्डर करें';

  @override
  String zonesCount(int count) {
    return '$count ज़ोन';
  }

  @override
  String tableNumber(String number) {
    return 'टेबल $number';
  }

  @override
  String get tableReservationAt => 'आरक्षण:';

  @override
  String get tableTypeTable => 'टेबल';

  @override
  String get tableTypeRoom => 'कमरा';

  @override
  String get tableTypeSunbed => 'सनबेड';

  @override
  String seatingNumberTable(String number) {
    return 'टेबल $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'कमरा $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'सनबेड $number';
  }

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get readyTitle => 'सर्व करने के लिए तैयार';

  @override
  String get readySubtitle => 'सर्व करने के लिए तैयार ऑर्डर';

  @override
  String get readyOrdersCountSuffix => ' तैयार ऑर्डर';

  @override
  String get readyMarkAsServed => 'सर्व किया चिह्नित करें';

  @override
  String get readyMarkAsDelivered => 'पहुँचाया चिह्नित करें';

  @override
  String get readySectionFood => 'भोजन';

  @override
  String get readySectionDrinks => 'पेय';

  @override
  String get readyMarkAsServedSuccess => 'ऑर्डर सर्व किया चिह्नित';

  @override
  String get readyMarkAsServedError => 'चिह्नित करने में विफल';

  @override
  String get ordersTitle => 'ऑर्डर';

  @override
  String ordersCount(int count) {
    return '$count ऑर्डर';
  }

  @override
  String get ordersCountSuffix => ' ऑर्डर';

  @override
  String get ordersTabActive => 'सक्रिय';

  @override
  String get ordersTabHistory => 'इतिहास';

  @override
  String get ordersFilters => 'फ़िल्टर';

  @override
  String get ordersOrderButton => 'ऑर्डर करें';

  @override
  String get ordersFoodLabel => 'भोजन:';

  @override
  String get ordersDrinksLabel => 'पेय:';

  @override
  String get orderStatusPending => 'लंबित';

  @override
  String get orderStatusInPreparation => 'तैयारी में';

  @override
  String get orderStatusServed => 'सर्व किया';

  @override
  String get orderStatusRejected => 'अस्वीकृत';

  @override
  String get orderBill => 'बिल:';

  @override
  String orderTableNumber(int number) {
    return 'टेबल $number';
  }

  @override
  String orderDishCount(int count) {
    return 'व्यंजन संख्या: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'पेय संख्या: $count';
  }

  @override
  String get orderSeeDetails => 'विवरण देखें';

  @override
  String orderTimeAgoDays(int count) {
    return '$count दिन पहले';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '$hours घंटा $minutes मिनट पहले';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count घंटे पहले';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count मिनट पहले';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count सेकंड पहले';
  }

  @override
  String get orderRejectAll => 'सभी अस्वीकार करें';

  @override
  String get orderAccept => 'स्वीकार करें';

  @override
  String get orderMarkAsPaid => 'भुगतान किया चिह्नित करें';

  @override
  String get orderMarkAsPaidConfirmTitle => 'भुगतान किया चिह्नित करें';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'क्या आप वाकई यह कार्रवाई करना चाहते हैं?';

  @override
  String get dialogYes => 'हाँ';

  @override
  String get dialogNo => 'नहीं';

  @override
  String get orderMarkAsPaidError =>
      'ऑर्डर को भुगतान किया चिह्नित नहीं किया जा सका';

  @override
  String get orderMarkAsPaidSuccess => 'ऑर्डर भुगतान किया चिह्नित';

  @override
  String get ordersHistoryEmpty => 'अभी तक इतिहास में कोई ऑर्डर नहीं';

  @override
  String get orderPaidLabel => 'भुगतान किया';

  @override
  String orderPaidAt(String dateTime) {
    return '$dateTime को भुगतान';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'ऑर्डर \"$orderNumber\" प्रक्रिया पूर्ण';
  }

  @override
  String get timeEstimationTitle => 'समय अनुमान';

  @override
  String get timeEstimationQuestion => 'यह ऑर्डर कितने समय में तैयार होगा?';

  @override
  String get timeEstimationSkip => 'अनुमान छोड़ें';

  @override
  String get timeEstimationConfirm => 'समय पुष्टि करें';

  @override
  String get reservationsTitle => 'आरक्षण';

  @override
  String get reservationsSubtitle => 'टेबल आरक्षण प्रबंधन';

  @override
  String get reservationsRequestsTitle => 'आरक्षण';

  @override
  String get reservationsTabRequests => 'अनुरोध';

  @override
  String get reservationsTabAccepted => 'स्वीकृत';

  @override
  String get reservationToday => 'आज';

  @override
  String reservationCountDrinks(int count) {
    return '$count पेय';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count व्यंजन';
  }

  @override
  String reservationCountList(int count) {
    return '$count आरक्षण';
  }

  @override
  String get reservationsFilters => 'फ़िल्टर';

  @override
  String get reservationLabelTime => 'समय:';

  @override
  String get reservationLabelRegion => 'क्षेत्र:';

  @override
  String get reservationLabelPartySize => 'व्यक्ति संख्या:';

  @override
  String get preparingTitle => 'तैयारी में';

  @override
  String get preparingSubtitle => 'तैयारी में वस्तुएँ';

  @override
  String preparingDishCount(int count) {
    return '$count व्यंजन';
  }

  @override
  String get preparingDishCountSuffix => ' व्यंजन';

  @override
  String get preparingDrinksCountSuffix => ' पेय';

  @override
  String get preparingMarkAsReady => 'तैयार चिह्नित करें';

  @override
  String get preparingMarkAsReadySuccess => 'ऑर्डर तैयार चिह्नित';

  @override
  String get preparingMarkAsReadyError => 'चिह्नित करने में विफल';

  @override
  String get menuTitle => 'मेनू';

  @override
  String get menuSubtitle => 'मेनू आइटम देखें';

  @override
  String get menuInstruction =>
      'जब कोई व्यंजन या पेय उपलब्ध/अनुपलब्ध हो तो चिह्नित करें';

  @override
  String get menuSearchHint => 'व्यंजन खोजें...';

  @override
  String menuAvailableCount(int available, int total) {
    return 'कुल $total में से $available उपलब्ध';
  }

  @override
  String get menuAvailableCountMiddle => ' में से ';

  @override
  String get drinksListTitle => 'पेय सूची';

  @override
  String get drinksListInstruction =>
      'जब कोई पेय उपलब्ध/अनुपलब्ध हो तो चिह्नित करें';

  @override
  String get drinksAvailableCountSuffix => ' उपलब्ध पेय';

  @override
  String get menuSearchHintDrinks => 'पेय खोजें...';

  @override
  String get profileTypeWaiter => 'वेटर';

  @override
  String get profileTypeKitchen => 'रसोई';

  @override
  String get profileTypeBar => 'बार';

  @override
  String get authLoginFailed => 'साइन इन विफल।';

  @override
  String get authInvalidResponse => 'अमान्य सर्वर प्रतिक्रिया।';

  @override
  String get filterTitle => 'फ़िल्टर';

  @override
  String get filterTableNumber => 'टेबल नंबर:';

  @override
  String get filterFood => 'भोजन:';

  @override
  String get filterDrinks => 'पेय:';

  @override
  String get filterBillAmount => 'बिल राशि:';

  @override
  String get filterStatusPending => 'लंबित ?';

  @override
  String get filterStatusInPreparation => 'तैयारी में ⏱';

  @override
  String get filterStatusServed => 'सर्व किया ✔';

  @override
  String get filterStatusRejected => 'अस्वीकृत ✖';

  @override
  String get filterReset => 'फ़िल्टर रीसेट';

  @override
  String get filterApply => 'फ़िल्टर लागू करें';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'तारीख:';

  @override
  String get filterDateFrom => 'से:';

  @override
  String get filterDateTo => 'तक:';

  @override
  String get filterDateToday => 'आज';

  @override
  String get filterDateYesterday => 'बीता कल';

  @override
  String get filterDateTomorrow => 'आने वाला कल';

  @override
  String get filterOrderContent => 'ऑर्डर सामग्री:';

  @override
  String get filterOrderContentDrinks => 'पेय';

  @override
  String get filterOrderContentFood => 'भोजन';

  @override
  String get filterPeopleCount => 'व्यक्ति संख्या:';

  @override
  String get filterRegion => 'क्षेत्र:';

  @override
  String get filterRegionIndoors => 'अंदर';

  @override
  String get filterRegionGarden => 'बगीचा';

  @override
  String get filterReservationContent => 'आरक्षण सामग्री:';

  @override
  String get acceptSheetTitle => 'पुष्टि पूर्ण करें';

  @override
  String get acceptSheetSelectRegion => 'रेस्तरां क्षेत्र चुनें';

  @override
  String get acceptSheetSelectTable => 'टेबल नंबर चुनें';

  @override
  String get acceptSheetNoteHint => 'अतिथि के लिए नोट... (वैकल्पिक)';

  @override
  String get acceptSheetConfirm => 'आरक्षण पुष्टि करें';

  @override
  String get acceptSheetNoTables => 'कोई टेबल उपलब्ध नहीं।';

  @override
  String get acceptSheetErrorGeneric =>
      'आरक्षण स्वीकार नहीं किया जा सका। पुनः प्रयास करें।';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'क्षेत्र $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return '$time पर आरक्षण';
  }

  @override
  String get confirmedResUser => 'उपयोगकर्ता:';

  @override
  String get confirmedResTableNumber => 'टेबल:';

  @override
  String get confirmedResOccasion => 'अवसर:';

  @override
  String get confirmedResOccasionBirthday => 'जन्मदिन';

  @override
  String get confirmedResOccasionClassic => 'क्लासिक';

  @override
  String get confirmedResNote => 'नोट:';

  @override
  String get confirmedResMessageLabel => 'संदेश:';

  @override
  String get confirmedResMessageConfirmed =>
      'आपकी आरक्षण की पुष्टि हो गई है। जल्द मिलते हैं!';

  @override
  String confirmedResMessageConfirmedWithNote(String note) {
    return 'आपकी आरक्षण की पुष्टि हो गई है। जल्द मिलते हैं! नोट: $note';
  }

  @override
  String get confirmedResEditButton => 'आरक्षण संपादित करें';

  @override
  String get confirmedResCancelButton => 'आरक्षण रद्द करें';

  @override
  String get editResDialogTitle => 'संपादन';

  @override
  String get editResNoteHint =>
      'अतिथि के लिए परिवर्तन का कारण और विवरण दर्ज करें... (आवश्यक)';

  @override
  String get editResConfirm => 'परिवर्तन पुष्टि करें';

  @override
  String get cancelDialogTitle => 'रद्दीकरण';

  @override
  String get cancelReasonHint => 'रद्द करने का कारण दर्ज करें (आवश्यक)';

  @override
  String get rejectDialogTitle => 'अंतिम पुष्टि';

  @override
  String get rejectReasonHint => 'व्याख्या दर्ज करें (आवश्यक)';

  @override
  String get rejectErrorFallback =>
      'आरक्षण अस्वीकार नहीं किया जा सका। पुनः प्रयास करें।';

  @override
  String get buttonRejectReservation => 'आरक्षण अस्वीकार करें';

  @override
  String get buttonReject => 'अस्वीकार';

  @override
  String get buttonAccept => 'स्वीकार';

  @override
  String get labelFoodDrink => 'भोजन/पेय:';

  @override
  String tableSeatCount(int count) {
    return '$count सीट';
  }

  @override
  String get tableReservationDialogTitle => 'आरक्षण';

  @override
  String get tableReservationNameHint => 'नाम पर...';

  @override
  String get tableReservationNameRequired => 'नाम दर्ज करें';

  @override
  String get tableReservationPartySizeHint => 'व्यक्ति संख्या';

  @override
  String get tableReservationPartySizeRequired => 'व्यक्ति संख्या चुनें';

  @override
  String get tableReservationDateHint => 'तारीख';

  @override
  String get tableReservationDateRequired => 'तारीख चुनें';

  @override
  String get tableReservationTimeHint => 'समय';

  @override
  String get tableReservationTimeRequired => 'समय चुनें';

  @override
  String get tableReservationTableRequired => 'टेबल चुनें';

  @override
  String get tableReservationInternalNoteHint => 'आंतरिक नोट...';

  @override
  String get tableReservationCreateButton => 'आरक्षण बनाएँ';

  @override
  String get tableOrderScreenTitle => 'नया ऑर्डर';

  @override
  String get tableOrderAiBanner => 'Meli • हमारे AI बॉट से सिफ़ारिशें पूछें...';

  @override
  String get billSheetTitle => 'बिल';

  @override
  String get billSheetTotal => 'कुल:';

  @override
  String get billSheetEmpty => 'कार्ट खाली है';

  @override
  String get billSheetOrderButton => 'ऑर्डर करें';

  @override
  String get tableOrderSubmitSuccess => 'ऑर्डर भेज दिया गया';

  @override
  String get tableOrderSubmitError => 'ऑर्डर नहीं भेजा जा सका';

  @override
  String get tableOverviewNoReservations =>
      'इस टेबल के लिए कोई सक्रिय आरक्षण नहीं';

  @override
  String get tableOverviewNoOrders => 'इस टेबल के लिए कोई सक्रिय ऑर्डर नहीं';

  @override
  String get tableOverviewMakeOrder => 'ऑर्डर करें';

  @override
  String get tableOrdersFilterTypeAny => 'Bilo koji';

  @override
  String get tableOrdersFilterStatusLabel => 'Status porudžbine:';

  @override
  String get tableOrdersFilterStatusAny => 'Bilo koji';

  @override
  String get tableOrdersFilterStatusAwaitingConfirmation => 'Čeka potvrdu';

  @override
  String get tableOrdersFilterStatusPending => 'Na čekanju';

  @override
  String get tableOrdersFilterStatusConfirmed => 'Potvrđeno';

  @override
  String get tableOrdersFilterStatusRejected => 'Odbijeno';

  @override
  String get tableOrdersFilterStatusExpired => 'Isteklo';

  @override
  String get tableOrdersFilterStatusPaid => 'Plaćeno';

  @override
  String notificationOrderForTableTitle(String table) {
    return 'Order for table $table';
  }

  @override
  String notificationOrderForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderKitchenForTableTitle(String table) {
    return 'Kitchen Order for table $table';
  }

  @override
  String notificationOrderKitchenForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderBarForTableTitle(String table) {
    return 'Bar Order for table $table';
  }

  @override
  String notificationOrderBarForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderRejectedTitle(String orderNumber) {
    return 'Order $orderNumber rejected';
  }

  @override
  String notificationOrderRejectedBody(String table, String rejectionNote) {
    return 'Table $table. $rejectionNote';
  }

  @override
  String notificationOrderConfirmedTitle(String orderNumber) {
    return 'Order $orderNumber confirmed';
  }

  @override
  String notificationOrderConfirmedBody(String table, String venueName) {
    return 'Table $table at $venueName';
  }

  @override
  String get notificationOrderCompletionTimeTitle => 'Order completion time';

  @override
  String notificationOrderCompletionTimeBody(String time) {
    return 'Estimated completion time: $time';
  }

  @override
  String notificationOrderItemRejectedTitle(String productName) {
    return 'Item Rejected: $productName';
  }

  @override
  String notificationOrderItemRejectedCustomerBody(String productName) {
    return 'We are sorry, but \"$productName\" is currently unavailable. It has been removed from your order bill.';
  }

  @override
  String notificationOrderItemRejectedWaiterTitle(String table) {
    return 'Item Rejected: $table';
  }

  @override
  String notificationOrderItemRejectedWaiterBody(String productName) {
    return '\"$productName\" was rejected and removed from the order.';
  }

  @override
  String notificationOrderItemEtaTitle(String table) {
    return 'ETA Set: $table';
  }

  @override
  String notificationOrderItemEtaBody(String minutes, String productName) {
    return 'Kitchen set $minutes min estimate for $productName';
  }

  @override
  String notificationOrderItemAcceptedTitle(String productName) {
    return 'Item Accepted: $productName';
  }

  @override
  String notificationOrderItemAcceptedBody(String productName) {
    return '\"$productName\" has been accepted and is being prepared.';
  }

  @override
  String get notificationReservationNewRequestTitle =>
      'New Reservation Request';

  @override
  String notificationReservationNewRequestBody(
    String people,
    String time,
    String table,
  ) {
    return '$people guests at $time. Table: $table';
  }

  @override
  String notificationReservationConfirmedTitle(String reservationNumber) {
    return 'Reservation $reservationNumber confirmed';
  }

  @override
  String notificationReservationConfirmedBody(String table, String venueName) {
    return 'Table: $table at $venueName';
  }

  @override
  String notificationReservationRejectedTitle(String reservationNumber) {
    return 'Reservation $reservationNumber rejected';
  }

  @override
  String notificationReservationRejectedBody(String reason) {
    return '$reason';
  }

  @override
  String notificationReservationCancelledTitle(String reservationNumber) {
    return 'Reservation $reservationNumber cancelled';
  }

  @override
  String notificationReservationCancelledBody(String venueName) {
    return '$venueName';
  }

  @override
  String get notificationReservationReminderTitle => 'Reservation Reminder';

  @override
  String get notificationReservationReminderBody =>
      'Your reservation is in 8 hours';

  @override
  String get notificationKitchenStartPreparationTitle =>
      'Start Preparation: Reservation Order';

  @override
  String notificationKitchenStartPreparationBody(
    String reservationNumber,
    String time,
  ) {
    return 'Time to prepare food for Reservation #$reservationNumber. Guests arrive at $time.';
  }

  @override
  String notificationFoodReadyTitle(String table) {
    return 'Food Ready: Table $table';
  }

  @override
  String notificationFoodReadyBody(String items) {
    return '$items are ready to serve.';
  }

  @override
  String notificationDrinksReadyTitle(String table) {
    return 'Drinks Ready: Table $table';
  }

  @override
  String notificationDrinksReadyBody(String items) {
    return '$items are ready at the bar.';
  }
}
