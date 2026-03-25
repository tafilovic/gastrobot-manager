// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'जारी राख्न साइन इन गर्नुहोस्';

  @override
  String get loginEmailLabel => 'इमेल';

  @override
  String get loginEmailHint => 'उदा. user@example.com';

  @override
  String get loginEmailRequired => 'इमेल प्रविष्ट गर्नुहोस्';

  @override
  String get loginEmailInvalid => 'मान्य इमेल प्रविष्ट गर्नुहोस्';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordRequired => 'पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get loginRememberEmail => 'इमेल सम्झनुहोस्';

  @override
  String get loginButton => 'साइन इन';

  @override
  String get loginFailed => 'साइन इन असफल। फेरि प्रयास गर्नुहोस्।';

  @override
  String get loginRoleNotSupported =>
      'तपाईंको भूमिका समर्थित छैन। यो एप वेटर, रसोइया र बारटेन्डरका लागि हो।';

  @override
  String get profileTitle => 'मेरो प्रोफाइल';

  @override
  String get profileLabelName => 'नाम';

  @override
  String get profileLabelEmail => 'इमेल';

  @override
  String get profileLabelPassword => 'पासवर्ड';

  @override
  String get profileChangePassword => 'परिवर्तन गर्नुहोस्';

  @override
  String get profileReservationReminder => 'आरक्षण स्मरण';

  @override
  String get profileReservationReminderHint =>
      '*पूर्व-अर्डर खाना तयार गर्न सूचना कति चाँडो पाउनुहुन्छ';

  @override
  String get profileReservationReminderValue => '१ घण्टा अगाडि';

  @override
  String get profileLabelLanguage => 'भाषा';

  @override
  String get profileLabelCurrency => 'मुद्रा';

  @override
  String get profileLanguageValue => 'नेपाली';

  @override
  String get profileDrinksList => 'पेय सूची';

  @override
  String get profileShiftScheduleLabel => 'शिफ्ट तालिका';

  @override
  String get profileShiftScheduleView => 'हेर्नुहोस्';

  @override
  String get shiftScheduleDialogTitle => 'शिफ्ट तालिका';

  @override
  String get shiftScheduleLoadError => 'तालिका लोड गर्न सकिएन।';

  @override
  String get shiftScheduleEmpty => 'कुनै तालिका डेटा छैन।';

  @override
  String get shiftScheduleRetry => 'पुनः प्रयास गर्नुहोस्';

  @override
  String get shiftScheduleSelfLabel => 'म';

  @override
  String get profileLogout => 'लगआउट';

  @override
  String get profileImageDialogTitle => 'प्रोफाइल तस्बिर';

  @override
  String get profileImageUploadButton => 'तस्बिर अपलोड गर्नुहोस्';

  @override
  String get profileImageMaxSize => '३ MB (अधिकतम तस्बिर आकार)';

  @override
  String get profileImageSaveChanges => 'परिवर्तन बचत गर्नुहोस्';

  @override
  String get logoutDialogTitle => 'लगआउट';

  @override
  String get logoutDialogMessage => 'के तपाईं लगआउट गर्न निश्चित हुनुहुन्छ?';

  @override
  String get logoutCancel => 'रद्द गर्नुहोस्';

  @override
  String get logoutConfirm => 'लगआउट';

  @override
  String get navOrders => 'अर्डरहरू';

  @override
  String get navReady => 'तयार';

  @override
  String get navPreparing => 'तयारीमा';

  @override
  String get navReservations => 'आरक्षणहरू';

  @override
  String get navMenu => 'मेनु';

  @override
  String get navDrinks => 'पेय';

  @override
  String get navTables => 'टेबलहरू';

  @override
  String get tablesReserve => 'आरक्षण गर्नुहोस्';

  @override
  String get tablesOrder => 'अर्डर गर्नुहोस्';

  @override
  String tablesCount(int count) {
    return '$count टेबल';
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
  String get tableTypeRoom => 'कोठा';

  @override
  String get tableTypeSunbed => 'सनबेड';

  @override
  String seatingNumberTable(String number) {
    return 'टेबल $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'कोठा $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'सनबेड $number';
  }

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get readyTitle => 'सेवा गर्न तयार';

  @override
  String get readySubtitle => 'सेवा गर्न तयार अर्डरहरू';

  @override
  String get readyOrdersCountSuffix => ' तयार अर्डरहरू';

  @override
  String get readyMarkAsServed => 'सर्व गरिएको चिन्ह लगाउनुहोस्';

  @override
  String get readyMarkAsDelivered => 'पुर्‍याइएको चिन्ह लगाउनुहोस्';

  @override
  String get readySectionFood => 'खाना';

  @override
  String get readySectionDrinks => 'पेय';

  @override
  String get readyMarkAsServedSuccess => 'अर्डर सर्व गरिएको चिन्हित';

  @override
  String get readyMarkAsServedError => 'चिन्ह लगाउन असफल';

  @override
  String get ordersTitle => 'अर्डरहरू';

  @override
  String ordersCount(int count) {
    return '$count अर्डर';
  }

  @override
  String get ordersCountSuffix => ' अर्डर';

  @override
  String get ordersTabActive => 'सक्रिय';

  @override
  String get ordersTabHistory => 'इतिहास';

  @override
  String get ordersFilters => 'फिल्टर';

  @override
  String get ordersOrderButton => 'अर्डर गर्नुहोस्';

  @override
  String get ordersFoodLabel => 'खाना:';

  @override
  String get ordersDrinksLabel => 'पेय:';

  @override
  String get orderStatusPending => 'प्रतीक्षामा';

  @override
  String get orderStatusInPreparation => 'तयारीमा';

  @override
  String get orderStatusServed => 'सर्व गरियो';

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
    return 'व्यञ्जन संख्या: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'पेय संख्या: $count';
  }

  @override
  String get orderSeeDetails => 'विवरण हेर्नुहोस्';

  @override
  String orderTimeAgoDays(int count) {
    return '$count दिन अगाडि';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '$hours घण्टा $minutes मिनेट अगाडि';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count घण्टा अगाडि';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count मिनेट अगाडि';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count सेकेन्ड अगाडि';
  }

  @override
  String get orderRejectAll => 'सबै अस्वीकार गर्नुहोस्';

  @override
  String get orderAccept => 'स्वीकार गर्नुहोस्';

  @override
  String get orderMarkAsPaid => 'तिरेको चिन्ह लगाउनुहोस्';

  @override
  String get orderMarkAsPaidConfirmTitle => 'तिरेको चिन्ह लगाउनुहोस्';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'के तपाईं यो कार्य गर्न निश्चित हुनुहुन्छ?';

  @override
  String get dialogYes => 'हो';

  @override
  String get dialogNo => 'होइन';

  @override
  String get orderMarkAsPaidError => 'अर्डर तिरेको चिन्ह लगाउन सकिएन';

  @override
  String get orderMarkAsPaidSuccess => 'अर्डर तिरेको चिन्हित';

  @override
  String get ordersHistoryEmpty => 'अझै इतिहासमा अर्डर छैन';

  @override
  String get orderPaidLabel => 'तिरेको';

  @override
  String orderPaidAt(String dateTime) {
    return '$dateTime मा तिरेको';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'अर्डर \"$orderNumber\" प्रक्रिया पूरा';
  }

  @override
  String get timeEstimationTitle => 'समय अनुमान';

  @override
  String get timeEstimationQuestion => 'यो अर्डर कति समयमा तयार हुन्छ?';

  @override
  String get timeEstimationSkip => 'अनुमान छोड्नुहोस्';

  @override
  String get timeEstimationConfirm => 'समय पुष्टि गर्नुहोस्';

  @override
  String get reservationsTitle => 'आरक्षणहरू';

  @override
  String get reservationsSubtitle => 'टेबल आरक्षण व्यवस्थापन';

  @override
  String get reservationsRequestsTitle => 'आरक्षणहरू';

  @override
  String get reservationsTabRequests => 'अनुरोधहरू';

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
    return '$count व्यञ्जन';
  }

  @override
  String reservationCountList(int count) {
    return '$count आरक्षण';
  }

  @override
  String get reservationsFilters => 'फिल्टर';

  @override
  String get reservationLabelTime => 'समय:';

  @override
  String get reservationLabelRegion => 'क्षेत्र:';

  @override
  String get reservationLabelPartySize => 'व्यक्ति संख्या:';

  @override
  String get preparingTitle => 'तयारीमा';

  @override
  String get preparingSubtitle => 'तयारीमा रहेका वस्तुहरू';

  @override
  String preparingDishCount(int count) {
    return '$count व्यञ्जन';
  }

  @override
  String get preparingDishCountSuffix => ' व्यञ्जन';

  @override
  String get preparingDrinksCountSuffix => ' पेय';

  @override
  String get preparingMarkAsReady => 'तयार चिन्ह लगाउनुहोस्';

  @override
  String get preparingMarkAsReadySuccess => 'अर्डर तयार चिन्हित';

  @override
  String get preparingMarkAsReadyError => 'चिन्ह लगाउन असफल';

  @override
  String get menuTitle => 'मेनु';

  @override
  String get menuSubtitle => 'मेनु वस्तुहरू हेर्नुहोस्';

  @override
  String get menuInstruction =>
      'व्यञ्जन वा पेय उपलब्ध/अनुपलब्ध चिन्ह लगाउनुहोस्';

  @override
  String get menuSearchHint => 'व्यञ्जन खोज्नुहोस्...';

  @override
  String menuAvailableCount(int available, int total) {
    return 'जम्मा $total मध्ये $available उपलब्ध';
  }

  @override
  String get menuAvailableCountMiddle => ' मध्ये ';

  @override
  String get drinksListTitle => 'पेय सूची';

  @override
  String get drinksListInstruction => 'पेय उपलब्ध/अनुपलब्ध चिन्ह लगाउनुहोस्';

  @override
  String get drinksAvailableCountSuffix => ' उपलब्ध पेय';

  @override
  String get menuSearchHintDrinks => 'पेय खोज्नुहोस्...';

  @override
  String get profileTypeWaiter => 'वेटर';

  @override
  String get profileTypeKitchen => 'भान्सा';

  @override
  String get profileTypeBar => 'बार';

  @override
  String get authLoginFailed => 'साइन इन असफल।';

  @override
  String get authInvalidResponse => 'सर्भर प्रतिक्रिया अमान्य।';

  @override
  String get filterTitle => 'फिल्टर';

  @override
  String get filterTableNumber => 'टेबल नम्बर:';

  @override
  String get filterFood => 'खाना:';

  @override
  String get filterDrinks => 'पेय:';

  @override
  String get filterBillAmount => 'बिल रकम:';

  @override
  String get filterStatusPending => 'प्रतीक्षामा ?';

  @override
  String get filterStatusInPreparation => 'तयारीमा ⏱';

  @override
  String get filterStatusServed => 'सर्व गरियो ✔';

  @override
  String get filterStatusRejected => 'अस्वीकृत ✖';

  @override
  String get filterReset => 'फिल्टर रिसेट';

  @override
  String get filterApply => 'फिल्टर लागू गर्नुहोस्';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'मिति:';

  @override
  String get filterDateFrom => 'देखि:';

  @override
  String get filterDateTo => 'सम्म:';

  @override
  String get filterDateToday => 'आज';

  @override
  String get filterDateYesterday => 'हिजो';

  @override
  String get filterDateTomorrow => 'भोलि';

  @override
  String get filterOrderContent => 'अर्डर सामग्री:';

  @override
  String get filterOrderContentDrinks => 'पेय';

  @override
  String get filterOrderContentFood => 'खाना';

  @override
  String get filterPeopleCount => 'व्यक्ति संख्या:';

  @override
  String get filterRegion => 'क्षेत्र:';

  @override
  String get filterRegionIndoors => 'भित्र';

  @override
  String get filterRegionGarden => 'बगैंचा';

  @override
  String get filterReservationContent => 'आरक्षण सामग्री:';

  @override
  String get acceptSheetTitle => 'पुष्टि पूरा गर्नुहोस्';

  @override
  String get acceptSheetSelectRegion => 'रेस्टुरेन्ट क्षेत्र छान्नुहोस्';

  @override
  String get acceptSheetSelectTable => 'टेबल नम्बर छान्नुहोस्';

  @override
  String get acceptSheetNoteHint => 'पाहुनाको नोट... (वैकल्पिक)';

  @override
  String get acceptSheetConfirm => 'आरक्षण पुष्टि गर्नुहोस्';

  @override
  String get acceptSheetNoTables => 'कुनै टेबल उपलब्ध छैन।';

  @override
  String get acceptSheetErrorGeneric =>
      'आरक्षण स्वीकार गर्न सकिएन। फेरि प्रयास गर्नुहोस्।';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'क्षेत्र $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return '$time मा आरक्षण';
  }

  @override
  String get confirmedResUser => 'प्रयोगकर्ता:';

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
  String get confirmedResEditButton => 'आरक्षण सम्पादन';

  @override
  String get confirmedResCancelButton => 'आरक्षण रद्द';

  @override
  String get editResDialogTitle => 'सम्पादन';

  @override
  String get editResNoteHint =>
      'पाहुनाका लागि परिवर्तनको कारण र विवरण लेख्नुहोस्... (आवश्यक)';

  @override
  String get editResConfirm => 'परिवर्तन पुष्टि गर्नुहोस्';

  @override
  String get cancelDialogTitle => 'रद्द';

  @override
  String get cancelReasonHint => 'रद्द कारण लेख्नुहोस् (आवश्यक)';

  @override
  String get rejectDialogTitle => 'अन्तिम पुष्टि';

  @override
  String get rejectReasonHint => 'व्याख्या लेख्नुहोस् (आवश्यक)';

  @override
  String get rejectErrorFallback =>
      'आरक्षण अस्वीकार गर्न सकिएन। फेरि प्रयास गर्नुहोस्।';

  @override
  String get buttonRejectReservation => 'आरक्षण अस्वीकार';

  @override
  String get buttonReject => 'अस्वीकार';

  @override
  String get buttonAccept => 'स्वीकार';

  @override
  String get labelFoodDrink => 'खाना/पेय:';

  @override
  String tableSeatCount(int count) {
    return '$count सिट';
  }

  @override
  String get tableReservationDialogTitle => 'आरक्षण';

  @override
  String get tableReservationNameHint => 'नाममा...';

  @override
  String get tableReservationNameRequired => 'नाम प्रविष्ट गर्नुहोस्';

  @override
  String get tableReservationPartySizeHint => 'व्यक्ति संख्या';

  @override
  String get tableReservationPartySizeRequired => 'व्यक्ति संख्या छान्नुहोस्';

  @override
  String get tableReservationDateHint => 'मिति';

  @override
  String get tableReservationDateRequired => 'मिति छान्नुहोस्';

  @override
  String get tableReservationTimeHint => 'समय';

  @override
  String get tableReservationTimeRequired => 'समय छान्नुहोस्';

  @override
  String get tableReservationTableRequired => 'टेबल छान्नुहोस्';

  @override
  String get tableReservationInternalNoteHint => 'आन्तरिक नोट...';

  @override
  String get tableReservationCreateButton => 'आरक्षण सिर्जना गर्नुहोस्';

  @override
  String get tableOrderScreenTitle => 'नयाँ अर्डर';

  @override
  String get tableOrderAiBanner =>
      'Meli • हाम्रो AI बोटसँग सिफारिस सोध्नुहोस्...';

  @override
  String get billSheetTitle => 'बिल';

  @override
  String get billSheetTotal => 'जम्मा:';

  @override
  String get billSheetEmpty => 'कार्ट खाली छ';

  @override
  String get billSheetOrderButton => 'अर्डर गर्नुहोस्';

  @override
  String get tableOrderSubmitSuccess => 'अर्डर पठाइयो';

  @override
  String get tableOrderSubmitError => 'अर्डर पठाउन सकिएन';

  @override
  String get tableOverviewNoReservations =>
      'यो टेबलका लागि कुनै सक्रिय आरक्षण छैन';

  @override
  String get tableOverviewNoOrders => 'यो टेबलका लागि कुनै सक्रिय अर्डर छैन';

  @override
  String get tableOverviewMakeOrder => 'अर्डर गर्नुहोस्';

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
}
