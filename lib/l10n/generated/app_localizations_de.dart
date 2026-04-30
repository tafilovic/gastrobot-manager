// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

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
  String get loginRegisterButton => 'Registrieren';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get registerFirstnameLabel => 'Vorname';

  @override
  String get registerLastnameLabel => 'Nachname';

  @override
  String get registerEmailLabel => 'E-Mail';

  @override
  String get registerPasswordConfirmLabel => 'Passwort bestätigen';

  @override
  String get registerPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get registerFieldRequired => 'Pflichtfeld';

  @override
  String get registerSubmitButton => 'Registrieren';

  @override
  String get registerSuccessTitle => 'Registrierung erfolgreich';

  @override
  String registerSuccessMessage(String email) {
    return 'An $email wurde ein Bestätigungslink gesendet. Bitte öffnen Sie Ihre E-Mails und klicken Sie auf den Link, um Ihr Konto zu aktivieren. Anschließend können Sie sich in der App anmelden.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte erneut versuchen.';

  @override
  String get registerBackToLogin => 'Zurück zur Anmeldung';

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
  String get profileDeleteAccount => 'KONTO LÖSCHEN';

  @override
  String get profileDeleteAccountAction => 'Zum Löschen tippen';

  @override
  String get profileDeleteAccountWarning =>
      'Wenn Sie Ihr Profil löschen, kann es nicht wiederhergestellt werden.';

  @override
  String get profileLabelCurrency => 'WÄHRUNG';

  @override
  String get profileLanguageValue => 'Deutsch';

  @override
  String get profileDrinksList => 'GETRÄNKELISTE';

  @override
  String get profileShiftScheduleLabel => 'SCHICHTPLAN';

  @override
  String get profileShiftScheduleView => 'Ansehen';

  @override
  String get shiftScheduleDialogTitle => 'Schichtplan';

  @override
  String get shiftScheduleLoadError =>
      'Schichtplan konnte nicht geladen werden.';

  @override
  String get shiftScheduleEmpty => 'Keine Schichtplandaten.';

  @override
  String get shiftScheduleRetry => 'Erneut versuchen';

  @override
  String get shiftScheduleSelfLabel => 'Ich';

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
  String get navReady => 'BEREIT';

  @override
  String get navPreparing => 'IN BERECHITUNG';

  @override
  String get navReservations => 'RESERVIERUNGEN';

  @override
  String get navMenu => 'SPEISEKARTE';

  @override
  String get navDrinks => 'GETRÄNKE';

  @override
  String get navZones => 'ZONEN';

  @override
  String get tablesReserve => 'RESERVIEREN';

  @override
  String get tablesOrder => 'BESTELLEN';

  @override
  String zonesCount(int count) {
    return '$count Zonen';
  }

  @override
  String tableNumber(String number) {
    return 'Tisch $number';
  }

  @override
  String get tableReservationAt => 'Reservierung:';

  @override
  String get tableTypeTable => 'Tisch';

  @override
  String get tableTypeRoom => 'Raum';

  @override
  String get tableTypeSunbed => 'Liegestuhl';

  @override
  String seatingNumberTable(String number) {
    return 'Tisch $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Raum $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Liegestuhl $number';
  }

  @override
  String get navProfile => 'PROFIL';

  @override
  String get readyTitle => 'Bereit zum Servieren';

  @override
  String get readySubtitle => 'Bestellungen bereit zum Servieren';

  @override
  String get readyOrdersCountSuffix => ' fertige Bestellungen';

  @override
  String get readyMarkAsServed => 'ALS SERVIERT MARKIEREN';

  @override
  String get readyMarkAsDelivered => 'ALS GELIEFERT MARKIEREN';

  @override
  String get readySectionFood => 'ESSEN';

  @override
  String get readySectionDrinks => 'GETRÄNKE';

  @override
  String get readyMarkAsServedSuccess => 'Bestellung als serviert markiert';

  @override
  String get readyMarkAsServedError => 'Markierung fehlgeschlagen';

  @override
  String get ordersTitle => 'Bestellungen';

  @override
  String ordersCount(int count) {
    return '$count Bestellungen';
  }

  @override
  String get ordersCountSuffix => ' Bestellungen';

  @override
  String get ordersTabActive => 'Aktiv';

  @override
  String get ordersTabHistory => 'Verlauf';

  @override
  String get ordersFilters => 'FILTER';

  @override
  String get ordersOrderButton => 'BESTELLEN';

  @override
  String get ordersFoodLabel => 'Essen:';

  @override
  String get ordersDrinksLabel => 'Getränke:';

  @override
  String get orderStatusPending => 'AUSSTEHEND';

  @override
  String get orderStatusInPreparation => 'IN BERECHITUNG';

  @override
  String get orderStatusServed => 'SERVIERT';

  @override
  String get orderStatusRejected => 'ABGELEHNT';

  @override
  String get orderBill => 'Rechnung:';

  @override
  String orderTableNumber(int number) {
    return 'Tisch $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Anzahl Gerichte: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Anzahl Getränke: $count';
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
  String get orderMarkAsPaid => 'ALS BEZAHLT MARKIEREN';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Als bezahlt markieren';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Möchten Sie diese Aktion wirklich ausführen?';

  @override
  String get dialogYes => 'Ja';

  @override
  String get dialogNo => 'Nein';

  @override
  String get orderMarkAsPaidError =>
      'Bestellung konnte nicht als bezahlt markiert werden';

  @override
  String get orderMarkAsPaidSuccess => 'Bestellung als bezahlt markiert';

  @override
  String get ordersHistoryEmpty => 'Noch keine Bestellungen in der Historie';

  @override
  String get orderPaidLabel => 'BEZAHLT';

  @override
  String orderPaidAt(String dateTime) {
    return 'Bezahlt am $dateTime';
  }

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
  String get reservationsRequestsTitle => 'Reservierungen';

  @override
  String get reservationsTabRequests => 'Anfragen';

  @override
  String get reservationsTabAccepted => 'Angenommen';

  @override
  String get reservationToday => 'Heute';

  @override
  String reservationCountDrinks(int count) {
    return '$count Getränke';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count Gerichte';
  }

  @override
  String reservationCountList(int count) {
    return '$count Reservierungen';
  }

  @override
  String get reservationsFilters => 'FILTER';

  @override
  String get reservationLabelTime => 'Zeit:';

  @override
  String get reservationLabelRegion => 'Bereich:';

  @override
  String get reservationLabelPartySize => 'Personen:';

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
  String get preparingDrinksCountSuffix => ' Getränke';

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
  String get drinksListTitle => 'Getränkeliste';

  @override
  String get drinksListInstruction =>
      'Markieren Sie, wenn ein Getränk verfügbar oder nicht verfügbar ist';

  @override
  String get drinksAvailableCountSuffix => ' verfügbare Getränke';

  @override
  String get menuSearchHintDrinks => 'Getränk suchen...';

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

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterTableNumber => 'Tischnummer:';

  @override
  String get filterFood => 'Essen:';

  @override
  String get filterDrinks => 'Getränke:';

  @override
  String get filterBillAmount => 'Rechnungsbetrag:';

  @override
  String get filterStatusPending => 'Ausstehend ?';

  @override
  String get filterStatusInPreparation => 'In Bereitung ⏱';

  @override
  String get filterStatusServed => 'Serviert ✔';

  @override
  String get filterStatusRejected => 'Abgelehnt ✖';

  @override
  String get filterReset => 'FILTER ZURÜCKSETZEN';

  @override
  String get filterApply => 'FILTER ANWENDEN';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Datum:';

  @override
  String get filterDateFrom => 'Von:';

  @override
  String get filterDateTo => 'Bis:';

  @override
  String get filterDateToday => 'Heute';

  @override
  String get filterDateYesterday => 'Gestern';

  @override
  String get filterDateTomorrow => 'Morgen';

  @override
  String get filterOrderContent => 'Bestellinhalt:';

  @override
  String get filterOrderContentDrinks => 'Getränke';

  @override
  String get filterOrderContentFood => 'Essen';

  @override
  String get filterPeopleCount => 'Anzahl Personen:';

  @override
  String get filterRegion => 'Bereich:';

  @override
  String get filterRegionIndoors => 'Innenbereich';

  @override
  String get filterRegionGarden => 'Garten';

  @override
  String get filterReservationContent => 'Reservierungsinhalt:';

  @override
  String get acceptSheetTitle => 'Bestätigung abschließen';

  @override
  String get acceptSheetSelectRegion => 'Restaurantbereich wählen';

  @override
  String get acceptSheetSelectTable => 'Tischnummer wählen';

  @override
  String get acceptSheetNoteHint => 'Notiz für Gast hinzufügen... (optional)';

  @override
  String get acceptSheetConfirm => 'RESERVIERUNG BESTÄTIGEN';

  @override
  String get acceptSheetNoTables => 'Keine Tische verfügbar.';

  @override
  String get acceptSheetErrorGeneric =>
      'Reservierung kann nicht angenommen werden. Bitte erneut versuchen.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Bereich $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Reservierung um $time';
  }

  @override
  String get confirmedResUser => 'Gast:';

  @override
  String get confirmedResTableNumber => 'Tisch:';

  @override
  String get confirmedResOccasion => 'Anlass:';

  @override
  String get confirmedResOccasionBirthday => 'Geburtstag';

  @override
  String get confirmedResOccasionClassic => 'Klassisch';

  @override
  String get confirmedResNote => 'Notiz:';

  @override
  String get confirmedResMessageLabel => 'Nachricht:';

  @override
  String get confirmedResMessageConfirmed =>
      'Ihre Reservierung ist bestätigt. Bis bald!';

  @override
  String confirmedResMessageConfirmedWithNote(String note) {
    return 'Ihre Reservierung ist bestätigt. Bis bald! Hinweis: $note';
  }

  @override
  String get confirmedResEditButton => 'RESERVIERUNG BEARBEITEN';

  @override
  String get confirmedResCancelButton => 'RESERVIERUNG STORNIEREN';

  @override
  String get editResDialogTitle => 'Bearbeitung';

  @override
  String get editResNoteHint =>
      'Gründe und Details der Änderung für den Gast eingeben... (Pflichtfeld)';

  @override
  String get editResConfirm => 'ÄNDERUNGEN BESTÄTIGEN';

  @override
  String get cancelDialogTitle => 'Stornierung';

  @override
  String get cancelReasonHint => 'Stornierungsgrund eingeben (Pflichtfeld)';

  @override
  String get rejectDialogTitle => 'Endbestätigung';

  @override
  String get rejectReasonHint => 'Erklärung eingeben (Pflichtfeld)';

  @override
  String get rejectErrorFallback =>
      'Reservierung kann nicht abgelehnt werden. Bitte versuchen Sie es erneut.';

  @override
  String get buttonRejectReservation => 'RESERVIERUNG ABLEHNEN';

  @override
  String get buttonReject => 'ABLEHNEN';

  @override
  String get buttonAccept => 'ANNEHMEN';

  @override
  String get labelFoodDrink => 'Essen/Trinken:';

  @override
  String tableSeatCount(int count) {
    return '$count Plätze';
  }

  @override
  String get tableReservationDialogTitle => 'Reservierung';

  @override
  String get tableReservationNameHint => 'Auf den Namen...';

  @override
  String get tableReservationNameRequired => 'Name eingeben';

  @override
  String get tableReservationPartySizeHint => 'Anzahl Personen';

  @override
  String get tableReservationPartySizeRequired => 'Anzahl Personen auswählen';

  @override
  String get tableReservationDateHint => 'Datum';

  @override
  String get tableReservationDateRequired => 'Datum auswählen';

  @override
  String get tableReservationTimeHint => 'Uhrzeit';

  @override
  String get tableReservationTimeRequired => 'Uhrzeit auswählen';

  @override
  String get tableReservationTableRequired => 'Tisch auswählen';

  @override
  String get tableReservationInternalNoteHint => 'Interne Notiz eingeben...';

  @override
  String get tableReservationCreateButton => 'RESERVIERUNG ERSTELLEN';

  @override
  String get tableOrderScreenTitle => 'Neue Bestellung';

  @override
  String get tableOrderAiBanner =>
      'Meli • Fragen Sie unseren KI-Bot nach Empfehlungen...';

  @override
  String get billSheetTitle => 'Rechnung';

  @override
  String get billSheetTotal => 'GESAMT:';

  @override
  String get billSheetEmpty => 'Warenkorb ist leer';

  @override
  String get billSheetOrderButton => 'BESTELLEN';

  @override
  String get tableOrderSubmitSuccess => 'Bestellung gesendet';

  @override
  String get tableOrderSubmitError => 'Bestellung konnte nicht gesendet werden';

  @override
  String get tableOverviewNoReservations =>
      'Keine aktiven Reservierungen für diesen Tisch';

  @override
  String get tableOverviewNoOrders =>
      'Keine aktiven Bestellungen für diesen Tisch';

  @override
  String get tableOverviewMakeOrder => 'BESTELLEN';

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
