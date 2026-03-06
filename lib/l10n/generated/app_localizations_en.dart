// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

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
  String get profileLanguageValue => 'English';

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
  String get navPreparing => 'PREPARING';

  @override
  String get navReservations => 'RESERVATIONS';

  @override
  String get navMenu => 'MENU';

  @override
  String get navProfile => 'PROFILE';

  @override
  String get ordersTitle => 'Orders';

  @override
  String ordersCount(int count) {
    return '$count orders';
  }

  @override
  String get ordersCountSuffix => ' orders';

  @override
  String orderTableNumber(int number) {
    return 'Table number $number';
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
  String get reservationsRequestsTitle => 'Reservations - Requests';

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
  String get profileTypeWaiter => 'Waiter';

  @override
  String get profileTypeKitchen => 'Kitchen';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Sign in failed.';

  @override
  String get authInvalidResponse => 'Invalid server response.';
}
