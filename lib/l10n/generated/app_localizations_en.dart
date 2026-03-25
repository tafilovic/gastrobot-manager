// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'e.g. user@example.com';

  @override
  String get loginEmailRequired => 'Enter email';

  @override
  String get loginEmailInvalid => 'Enter a valid email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter password';

  @override
  String get loginRememberEmail => 'Remember email';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginFailed => 'Sign in failed. Please try again.';

  @override
  String get loginRoleNotSupported =>
      'Your role is not supported. This app is for waiters, chefs and bartenders.';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileLabelName => 'NAME';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'PASSWORD';

  @override
  String get profileChangePassword => 'Change';

  @override
  String get profileReservationReminder => 'RESERVATION REMINDER';

  @override
  String get profileReservationReminderHint =>
      '*How early you receive notifications for preparing pre-ordered food';

  @override
  String get profileReservationReminderValue => '1h in advance';

  @override
  String get profileLabelLanguage => 'LANGUAGE';

  @override
  String get profileLabelCurrency => 'CURRENCY';

  @override
  String get profileLanguageValue => 'English';

  @override
  String get profileDrinksList => 'DRINKS LIST';

  @override
  String get profileShiftScheduleLabel => 'SHIFT SCHEDULE';

  @override
  String get profileShiftScheduleView => 'View';

  @override
  String get shiftScheduleDialogTitle => 'Shift schedule';

  @override
  String get shiftScheduleLoadError => 'Could not load schedule.';

  @override
  String get shiftScheduleEmpty => 'No schedule data.';

  @override
  String get shiftScheduleRetry => 'Try again';

  @override
  String get shiftScheduleSelfLabel => 'Me';

  @override
  String get profileLogout => 'LOG OUT';

  @override
  String get profileImageDialogTitle => 'Profile picture';

  @override
  String get profileImageUploadButton => 'UPLOAD PICTURE';

  @override
  String get profileImageMaxSize => '3MB (maximum image size)';

  @override
  String get profileImageSaveChanges => 'SAVE CHANGES';

  @override
  String get logoutDialogTitle => 'Log out';

  @override
  String get logoutDialogMessage => 'Are you sure you want to log out?';

  @override
  String get logoutCancel => 'Cancel';

  @override
  String get logoutConfirm => 'Log out';

  @override
  String get navOrders => 'ORDERS';

  @override
  String get navReady => 'READY';

  @override
  String get navPreparing => 'PREPARING';

  @override
  String get navReservations => 'RESERVATIONS';

  @override
  String get navMenu => 'MENU';

  @override
  String get navDrinks => 'DRINKS';

  @override
  String get navTables => 'TABLES';

  @override
  String get tablesReserve => 'RESERVE';

  @override
  String get tablesOrder => 'ORDER';

  @override
  String tablesCount(int count) {
    return '$count tables';
  }

  @override
  String tableNumber(String number) {
    return 'Table $number';
  }

  @override
  String get tableReservationAt => 'Reservation:';

  @override
  String get tableTypeTable => 'Table';

  @override
  String get tableTypeRoom => 'Room';

  @override
  String get tableTypeSunbed => 'Sunbed';

  @override
  String seatingNumberTable(String number) {
    return 'Table $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Room $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Sunbed $number';
  }

  @override
  String get navProfile => 'PROFILE';

  @override
  String get readyTitle => 'Ready for serving';

  @override
  String get readySubtitle => 'Orders ready to be served';

  @override
  String get readyOrdersCountSuffix => ' ready orders';

  @override
  String get readyMarkAsServed => 'MARK AS SERVED';

  @override
  String get readyMarkAsDelivered => 'MARK AS DELIVERED';

  @override
  String get readySectionFood => 'FOOD';

  @override
  String get readySectionDrinks => 'DRINKS';

  @override
  String get readyMarkAsServedSuccess => 'Order marked as served';

  @override
  String get readyMarkAsServedError => 'Failed to mark as served';

  @override
  String get ordersTitle => 'Orders';

  @override
  String ordersCount(int count) {
    return '$count orders';
  }

  @override
  String get ordersCountSuffix => ' orders';

  @override
  String get ordersTabActive => 'Active';

  @override
  String get ordersTabHistory => 'History';

  @override
  String get ordersFilters => 'FILTERS';

  @override
  String get ordersOrderButton => 'ORDER';

  @override
  String get ordersFoodLabel => 'Food:';

  @override
  String get ordersDrinksLabel => 'Drinks:';

  @override
  String get orderStatusPending => 'PENDING';

  @override
  String get orderStatusInPreparation => 'IN PREPARATION';

  @override
  String get orderStatusServed => 'SERVED';

  @override
  String get orderStatusRejected => 'REJECTED';

  @override
  String get orderBill => 'Bill:';

  @override
  String orderTableNumber(int number) {
    return 'Table $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Dish count: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Number of drinks: $count';
  }

  @override
  String get orderSeeDetails => 'VIEW DETAILS';

  @override
  String orderTimeAgoDays(int count) {
    return '$count day ago';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}min ago';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count hr ago';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count min ago';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count sec ago';
  }

  @override
  String get orderRejectAll => 'REJECT ALL';

  @override
  String get orderAccept => 'ACCEPT';

  @override
  String get orderMarkAsPaid => 'MARK AS PAID';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Mark as paid';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Are you sure you want to perform this action?';

  @override
  String get dialogYes => 'Yes';

  @override
  String get dialogNo => 'No';

  @override
  String get orderMarkAsPaidError => 'Could not mark order as paid';

  @override
  String get orderMarkAsPaidSuccess => 'Order marked as paid';

  @override
  String get ordersHistoryEmpty => 'No orders in history yet';

  @override
  String get orderPaidLabel => 'PAID';

  @override
  String orderPaidAt(String dateTime) {
    return 'Paid on $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Order \"$orderNumber\" processing complete';
  }

  @override
  String get timeEstimationTitle => 'Time estimation';

  @override
  String get timeEstimationQuestion =>
      'In how much time will this order be ready?';

  @override
  String get timeEstimationSkip => 'SKIP ESTIMATION';

  @override
  String get timeEstimationConfirm => 'CONFIRM TIME';

  @override
  String get reservationsTitle => 'Reservations';

  @override
  String get reservationsSubtitle => 'Manage table reservations';

  @override
  String get reservationsRequestsTitle => 'Reservations';

  @override
  String get reservationsTabRequests => 'Requests';

  @override
  String get reservationsTabAccepted => 'Accepted';

  @override
  String get reservationToday => 'Today';

  @override
  String reservationCountDrinks(int count) {
    return '$count drinks';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count dishes';
  }

  @override
  String reservationCountList(int count) {
    return '$count reservations';
  }

  @override
  String get reservationsFilters => 'FILTERS';

  @override
  String get reservationLabelTime => 'Time:';

  @override
  String get reservationLabelRegion => 'Region:';

  @override
  String get reservationLabelPartySize => 'Number of people:';

  @override
  String get preparingTitle => 'Preparing';

  @override
  String get preparingSubtitle => 'Items in preparation';

  @override
  String preparingDishCount(int count) {
    return '$count dishes';
  }

  @override
  String get preparingDishCountSuffix => ' dishes';

  @override
  String get preparingDrinksCountSuffix => ' drinks';

  @override
  String get preparingMarkAsReady => 'MARK AS READY';

  @override
  String get preparingMarkAsReadySuccess => 'Order marked as ready';

  @override
  String get preparingMarkAsReadyError => 'Failed to mark as ready';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSubtitle => 'Browse menu items';

  @override
  String get menuInstruction =>
      'Mark when a dish or drink is available or unavailable';

  @override
  String get menuSearchHint => 'Search dish...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available available out of $total total';
  }

  @override
  String get menuAvailableCountMiddle => ' available out of ';

  @override
  String get drinksListTitle => 'List of drinks';

  @override
  String get drinksListInstruction =>
      'Mark when a drink is available or unavailable';

  @override
  String get drinksAvailableCountSuffix => ' available drinks';

  @override
  String get menuSearchHintDrinks => 'Search drink...';

  @override
  String get profileTypeWaiter => 'Waiter';

  @override
  String get profileTypeKitchen => 'Kitchen';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Sign in failed.';

  @override
  String get authInvalidResponse => 'Invalid server response.';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterTableNumber => 'Table number:';

  @override
  String get filterFood => 'Food:';

  @override
  String get filterDrinks => 'Drinks:';

  @override
  String get filterBillAmount => 'Bill amount:';

  @override
  String get filterStatusPending => 'Pending ?';

  @override
  String get filterStatusInPreparation => 'In preparation ⏱';

  @override
  String get filterStatusServed => 'Served ✔';

  @override
  String get filterStatusRejected => 'Rejected ✖';

  @override
  String get filterReset => 'RESET FILTERS';

  @override
  String get filterApply => 'APPLY FILTERS';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Date:';

  @override
  String get filterDateFrom => 'From:';

  @override
  String get filterDateTo => 'To:';

  @override
  String get filterDateToday => 'Today';

  @override
  String get filterDateYesterday => 'Yesterday';

  @override
  String get filterDateTomorrow => 'Tomorrow';

  @override
  String get filterOrderContent => 'Order content:';

  @override
  String get filterOrderContentDrinks => 'Drinks';

  @override
  String get filterOrderContentFood => 'Food';

  @override
  String get filterPeopleCount => 'Number of people:';

  @override
  String get filterRegion => 'Region:';

  @override
  String get filterRegionIndoors => 'Indoors';

  @override
  String get filterRegionGarden => 'Garden';

  @override
  String get filterReservationContent => 'Reservation content:';

  @override
  String get acceptSheetTitle => 'Complete confirmation';

  @override
  String get acceptSheetSelectRegion => 'Select restaurant region';

  @override
  String get acceptSheetSelectTable => 'Select table number';

  @override
  String get acceptSheetNoteHint => 'Add guest note... (optional)';

  @override
  String get acceptSheetConfirm => 'CONFIRM RESERVATION';

  @override
  String get acceptSheetNoTables => 'No tables available.';

  @override
  String get acceptSheetErrorGeneric =>
      'Cannot accept reservation. Please try again.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Region $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Reservation at $time';
  }

  @override
  String get confirmedResUser => 'User:';

  @override
  String get confirmedResTableNumber => 'Table:';

  @override
  String get confirmedResOccasion => 'Occasion:';

  @override
  String get confirmedResOccasionBirthday => 'Birthday';

  @override
  String get confirmedResOccasionClassic => 'Classic';

  @override
  String get confirmedResNote => 'Note:';

  @override
  String get confirmedResEditButton => 'EDIT RESERVATION';

  @override
  String get confirmedResCancelButton => 'CANCEL RESERVATION';

  @override
  String get editResDialogTitle => 'Edit';

  @override
  String get editResNoteHint =>
      'Enter reasons and details of the change for the guest... (required field)';

  @override
  String get editResConfirm => 'CONFIRM CHANGES';

  @override
  String get cancelDialogTitle => 'Cancellation';

  @override
  String get cancelReasonHint => 'Enter cancellation reason (required)';

  @override
  String get rejectDialogTitle => 'Final confirmation';

  @override
  String get rejectReasonHint => 'Enter explanation (required)';

  @override
  String get rejectErrorFallback =>
      'Unable to reject reservation. Please try again.';

  @override
  String get buttonRejectReservation => 'REJECT RESERVATION';

  @override
  String get buttonReject => 'REJECT';

  @override
  String get buttonAccept => 'ACCEPT';

  @override
  String get labelFoodDrink => 'Food/Drink:';

  @override
  String tableSeatCount(int count) {
    return '$count seats';
  }

  @override
  String get tableReservationDialogTitle => 'Reservation';

  @override
  String get tableReservationNameHint => 'For the name...';

  @override
  String get tableReservationNameRequired => 'Enter name';

  @override
  String get tableReservationPartySizeHint => 'Number of people';

  @override
  String get tableReservationPartySizeRequired => 'Select number of people';

  @override
  String get tableReservationDateHint => 'Date';

  @override
  String get tableReservationDateRequired => 'Select date';

  @override
  String get tableReservationTimeHint => 'Time';

  @override
  String get tableReservationTimeRequired => 'Select time';

  @override
  String get tableReservationTableRequired => 'Select table';

  @override
  String get tableReservationInternalNoteHint => 'Enter internal note...';

  @override
  String get tableReservationCreateButton => 'CREATE RESERVATION';

  @override
  String get tableOrderScreenTitle => 'New Order';

  @override
  String get tableOrderAiBanner =>
      'Meli • Ask our AI bot for recommendations...';

  @override
  String get billSheetTitle => 'Bill';

  @override
  String get billSheetTotal => 'TOTAL:';

  @override
  String get billSheetEmpty => 'Cart is empty';

  @override
  String get billSheetOrderButton => 'ORDER';

  @override
  String get tableOrderSubmitSuccess => 'Order sent';

  @override
  String get tableOrderSubmitError => 'Could not send order';

  @override
  String get tableOverviewNoReservations =>
      'No active reservations for this table';

  @override
  String get tableOverviewNoOrders => 'No active orders for this table';

  @override
  String get tableOverviewMakeOrder => 'MAKE ORDER';

  @override
  String get tableOrdersFilterTypeAny => 'Any';

  @override
  String get tableOrdersFilterStatusLabel => 'Order status:';

  @override
  String get tableOrdersFilterStatusAny => 'Any';

  @override
  String get tableOrdersFilterStatusAwaitingConfirmation =>
      'Awaiting confirmation';

  @override
  String get tableOrdersFilterStatusPending => 'Pending';

  @override
  String get tableOrdersFilterStatusConfirmed => 'Confirmed';

  @override
  String get tableOrdersFilterStatusRejected => 'Rejected';

  @override
  String get tableOrdersFilterStatusExpired => 'Expired';

  @override
  String get tableOrdersFilterStatusPaid => 'Paid';
}
