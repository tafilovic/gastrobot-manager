// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

  @override
  String get loginSubtitle => 'Melden Sie sich an, um fortzufahren';

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginEmailHint => 'z.B. benutzer@beispiel.de';

  @override
  String get loginEmailRequired => 'E-Mail eingeben';

  @override
  String get loginEmailInvalid => 'Gültige E-Mail eingeben';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordRequired => 'Passwort eingeben';

  @override
  String get loginRememberEmail => 'E-Mail merken';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get loginFailed =>
      'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get loginRoleNotSupported =>
      'Ihre Rolle wird nicht unterstützt. Diese App ist für Kellner, Köche und Barkeeper.';

  @override
  String get profileTitle => 'Mein Profil';

  @override
  String get profileLabelName => 'NAME';

  @override
  String get profileLabelEmail => 'E-MAIL';

  @override
  String get profileLabelPassword => 'PASSWORT';

  @override
  String get profileChangePassword => 'Ändern';

  @override
  String get profileReservationReminder => 'RESERVIERUNGSERINNERUNG';

  @override
  String get profileReservationReminderHint =>
      '*Wie früh Sie Benachrichtigungen für die Vorbereitung vorbestellter Speisen erhalten';

  @override
  String get profileReservationReminderValue => '1h im Voraus';

  @override
  String get profileLabelLanguage => 'SPRACHE';

  @override
  String get profileLanguageValue => 'Deutsch';

  @override
  String get profileLogout => 'ABMELDEN';

  @override
  String get profileImageDialogTitle => 'Profilbild';

  @override
  String get profileImageUploadButton => 'BILD HOCHLADEN';

  @override
  String get profileImageMaxSize => '3MB (maximale Bildgröße)';

  @override
  String get profileImageSaveChanges => 'ÄNDERUNGEN SPEICHERN';

  @override
  String get logoutDialogTitle => 'Abmelden';

  @override
  String get logoutDialogMessage => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get logoutCancel => 'Abbrechen';

  @override
  String get logoutConfirm => 'Abmelden';

  @override
  String get navOrders => 'BESTELLUNGEN';

  @override
  String get navPreparing => 'IN BERECHITUNG';

  @override
  String get navReservations => 'RESERVIERUNGEN';

  @override
  String get navMenu => 'SPEISEKARTE';

  @override
  String get navProfile => 'PROFIL';

  @override
  String get ordersTitle => 'Bestellungen';

  @override
  String ordersCount(int count) {
    return '$count Bestellungen';
  }

  @override
  String get ordersCountSuffix => ' Bestellungen';

  @override
  String orderTableNumber(int number) {
    return 'Tisch nummer $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Anzahl Gerichte: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Broj pića: $count';
  }

  @override
  String get orderSeeDetails => 'DETAILS ANZEIGEN';

  @override
  String orderTimeAgoDays(int count) {
    return 'vor $count Tag';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'vor ${hours}h ${minutes}min';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'vor $count Std.';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'vor $count Min.';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'vor $count Sek.';
  }

  @override
  String get orderRejectAll => 'ALLE ABLEHNEN';

  @override
  String get orderAccept => 'ACCEPTIEREN';

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Bestellung \"$orderNumber\" abgeschlossen';
  }

  @override
  String get timeEstimationTitle => 'Zeitschätzung';

  @override
  String get timeEstimationQuestion =>
      'In wie viel Zeit wird diese Bestellung fertig sein?';

  @override
  String get timeEstimationSkip => 'SCHÄTZUNG ÜBERSPRINGEN';

  @override
  String get timeEstimationConfirm => 'ZEIT BESTÄTIGEN';

  @override
  String get reservationsTitle => 'Reservierungen';

  @override
  String get reservationsSubtitle => 'Tischreservierungen verwalten';

  @override
  String get preparingTitle => 'In Bereitung';

  @override
  String get preparingSubtitle => 'Gerichte in Bereitung';

  @override
  String preparingDishCount(int count) {
    return '$count Gerichte';
  }

  @override
  String get preparingDishCountSuffix => ' Gerichte';

  @override
  String get preparingMarkAsReady => 'ALS FERTIG MARKIEREN';

  @override
  String get preparingMarkAsReadySuccess => 'Bestellung als fertig markiert';

  @override
  String get preparingMarkAsReadyError => 'Markierung fehlgeschlagen';

  @override
  String get menuTitle => 'Speisekarte';

  @override
  String get menuSubtitle => 'Menüpunkte durchsuchen';

  @override
  String get menuInstruction =>
      'Markieren Sie, wenn ein Gericht oder Getränk verfügbar oder nicht verfügbar ist';

  @override
  String get menuSearchHint => 'Gericht suchen...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available von $total verfügbar';
  }

  @override
  String get menuAvailableCountMiddle => ' von ';

  @override
  String get profileTypeWaiter => 'Kellner';

  @override
  String get profileTypeKitchen => 'Küche';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Anmeldung fehlgeschlagen.';

  @override
  String get authInvalidResponse => 'Ungültige Serverantwort.';
}
