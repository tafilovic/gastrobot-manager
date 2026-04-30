// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Συνδεθείτε για να συνεχίσετε';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'π.χ. user@example.com';

  @override
  String get loginEmailRequired => 'Εισάγετε email';

  @override
  String get loginEmailInvalid => 'Εισάγετε έγκυρο email';

  @override
  String get loginPasswordLabel => 'Κωδικός';

  @override
  String get loginPasswordRequired => 'Εισάγετε κωδικό';

  @override
  String get loginRememberEmail => 'Απομνημόνευση email';

  @override
  String get loginButton => 'Σύνδεση';

  @override
  String get loginFailed => 'Η σύνδεση απέτυχε. Δοκιμάστε ξανά.';

  @override
  String get loginRoleNotSupported =>
      'Ο ρόλος σας δεν υποστηρίζεται. Η εφαρμογή είναι για σερβιτόρους, μάγειρες και μπαρίστες.';

  @override
  String get loginRegisterButton => 'Εγγραφή';

  @override
  String get registerTitle => 'Δημιουργία λογαριασμού';

  @override
  String get registerFirstnameLabel => 'Όνομα';

  @override
  String get registerLastnameLabel => 'Επώνυμο';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordConfirmLabel => 'Επιβεβαίωση κωδικού';

  @override
  String get registerPasswordMismatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get registerFieldRequired => 'Υποχρεωτικό πεδίο';

  @override
  String get registerSubmitButton => 'Εγγραφή';

  @override
  String get registerSuccessTitle => 'Επιτυχής εγγραφή';

  @override
  String registerSuccessMessage(String email) {
    return 'Στο $email στάλθηκε σύνδεσμος επαλήθευσης. Ανοίξτε το email σας και ακολουθήστε τον σύνδεσμο για να ενεργοποιήσετε τον λογαριασμό. Στη συνέχεια μπορείτε να συνδεθείτε στην εφαρμογή.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric => 'Κάτι πήγε στραβά. Δοκιμάστε ξανά.';

  @override
  String get registerBackToLogin => 'Πίσω στη σύνδεση';

  @override
  String get profileTitle => 'Το προφίλ μου';

  @override
  String get profileLabelName => 'ΟΝΟΜΑ';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'ΚΩΔΙΚΟΣ';

  @override
  String get profileChangePassword => 'Αλλαγή';

  @override
  String get profileReservationReminder => 'ΥΠΕΝΘΥΜΙΣΗ ΚΡΑΤΗΣΗΣ';

  @override
  String get profileReservationReminderHint =>
      '*Πόσο νωρίτερα λαμβάνετε ειδοποιήσεις για προετοιμασία προπαραγγελθέντος φαγητού';

  @override
  String get profileReservationReminderValue => '1 ώρα νωρίτερα';

  @override
  String get profileLabelLanguage => 'ΓΛΩΣΣΑ';

  @override
  String get profileDeleteAccount => 'ΔΙΑΓΡΑΦΗ ΛΟΓΑΡΙΑΣΜΟΥ';

  @override
  String get profileDeleteAccountAction => 'Πατήστε για διαγραφή';

  @override
  String get profileDeleteAccountWarning =>
      'Αν διαγράψετε το προφίλ σας, δεν μπορεί να αποκατασταθεί.';

  @override
  String get profileLabelCurrency => 'ΝΟΜΙΣΜΑ';

  @override
  String get profileLanguageValue => 'Ελληνικά';

  @override
  String get profileDrinksList => 'ΛΙΣΤΑ ΠΟΤΩΝ';

  @override
  String get profileShiftScheduleLabel => 'ΠΡΟΓΡΑΜΜΑ ΒΑΡΔΙΩΝ';

  @override
  String get profileShiftScheduleView => 'Προβολή';

  @override
  String get shiftScheduleDialogTitle => 'Πρόγραμμα βαρδιών';

  @override
  String get shiftScheduleLoadError =>
      'Δεν ήταν δυνατή η φόρτωση του προγράμματος.';

  @override
  String get shiftScheduleEmpty => 'Δεν υπάρχουν δεδομένα προγράμματος.';

  @override
  String get shiftScheduleRetry => 'Δοκιμάστε ξανά';

  @override
  String get shiftScheduleSelfLabel => 'Εγώ';

  @override
  String get profileLogout => 'ΑΠΟΣΥΝΔΕΣΗ';

  @override
  String get profileImageDialogTitle => 'Φωτογραφία προφίλ';

  @override
  String get profileImageUploadButton => 'ΑΝΕΒΑΣΜΑ ΦΩΤΟΓΡΑΦΙΑΣ';

  @override
  String get profileImageMaxSize => '3MB (μέγιστο μέγεθος εικόνας)';

  @override
  String get profileImageSaveChanges => 'ΑΠΟΘΗΚΕΥΣΗ ΑΛΛΑΓΩΝ';

  @override
  String get logoutDialogTitle => 'Αποσύνδεση';

  @override
  String get logoutDialogMessage =>
      'Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;';

  @override
  String get logoutCancel => 'Ακύρωση';

  @override
  String get logoutConfirm => 'Αποσύνδεση';

  @override
  String get navOrders => 'ΠΑΡΑΓΓΕΛΙΕΣ';

  @override
  String get navReady => 'ΕΤΟΙΜΑ';

  @override
  String get navPreparing => 'ΣΕ ΕΤΟΙΜΑΣΙΑ';

  @override
  String get navReservations => 'ΚΡΑΤΗΣΕΙΣ';

  @override
  String get navMenu => 'ΜΕΝΟΥ';

  @override
  String get navDrinks => 'ΠΟΤΑ';

  @override
  String get navZones => 'ΖΩΝΕΣ';

  @override
  String get tablesReserve => 'ΚΡΑΤΗΣΗ';

  @override
  String get tablesOrder => 'ΠΑΡΑΓΓΕΛΙΑ';

  @override
  String zonesCount(int count) {
    return '$count ζώνες';
  }

  @override
  String tableNumber(String number) {
    return 'Τραπέζι $number';
  }

  @override
  String get tableReservationAt => 'Κράτηση:';

  @override
  String get tableTypeTable => 'Τραπέζι';

  @override
  String get tableTypeRoom => 'Δωμάτιο';

  @override
  String get tableTypeSunbed => 'Ξαπλώστρα';

  @override
  String seatingNumberTable(String number) {
    return 'Τραπέζι $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Δωμάτιο $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Ξαπλώστρα $number';
  }

  @override
  String get navProfile => 'ΠΡΟΦΙΛ';

  @override
  String get readyTitle => 'Έτοιμα για σερβίρισμα';

  @override
  String get readySubtitle => 'Παραγγελίες έτοιμες για σερβίρισμα';

  @override
  String get readyOrdersCountSuffix => ' έτοιμες παραγγελίες';

  @override
  String get readyMarkAsServed => 'ΣΗΜΕΙΩΣΗ ΩΣ ΣΕΡΒΙΡΙΣΜΕΝΗ';

  @override
  String get readyMarkAsDelivered => 'ΣΗΜΕΙΩΣΗ ΩΣ ΠΑΡΑΔΟΘΕΙΣΑ';

  @override
  String get readySectionFood => 'ΦΑΓΗΤΟ';

  @override
  String get readySectionDrinks => 'ΠΟΤΑ';

  @override
  String get readyMarkAsServedSuccess =>
      'Η παραγγελία σημειώθηκε ως σερβιρισμένη';

  @override
  String get readyMarkAsServedError => 'Αποτυχία σημείωσης';

  @override
  String get ordersTitle => 'Παραγγελίες';

  @override
  String ordersCount(int count) {
    return '$count παραγγελίες';
  }

  @override
  String get ordersCountSuffix => ' παραγγελίες';

  @override
  String get ordersTabActive => 'Ενεργές';

  @override
  String get ordersTabHistory => 'Ιστορικό';

  @override
  String get ordersFilters => 'ΦΙΛΤΡΑ';

  @override
  String get ordersOrderButton => 'ΠΑΡΑΓΓΕΛΙΑ';

  @override
  String get ordersFoodLabel => 'Φαγητό:';

  @override
  String get ordersDrinksLabel => 'Ποτά:';

  @override
  String get orderStatusPending => 'ΕΚΚΡΕΜΕΙ';

  @override
  String get orderStatusInPreparation => 'ΣΕ ΕΤΟΙΜΑΣΙΑ';

  @override
  String get orderStatusServed => 'ΣΕΡΒΙΡΙΣΤΗΚΕ';

  @override
  String get orderStatusRejected => 'ΑΠΟΡΡΙΦΘΗΚΕ';

  @override
  String get orderBill => 'Λογαριασμός:';

  @override
  String orderTableNumber(int number) {
    return 'Τραπέζι $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Αριθμός πιάτων: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Αριθμός ποτών: $count';
  }

  @override
  String get orderSeeDetails => 'ΠΡΟΒΟΛΗ ΛΕΠΤΟΜΕΡΕΙΩΝ';

  @override
  String orderTimeAgoDays(int count) {
    return 'Πριν $count ημέρα';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'Πριν $hoursώ $minutesλ';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'Πριν $count ώρες';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'Πριν $count λεπτά';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'Πριν $count δευτ.';
  }

  @override
  String get orderRejectAll => 'ΑΠΟΡΡΙΨΗ ΟΛΩΝ';

  @override
  String get orderAccept => 'ΑΠΟΔΟΧΗ';

  @override
  String get orderMarkAsPaid => 'ΣΗΜΕΙΩΣΗ ΩΣ ΠΛΗΡΩΜΕΝΗ';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Σημείωση ως πληρωμένη';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Είστε σίγουροι ότι θέλετε να εκτελέσετε αυτή την ενέργεια;';

  @override
  String get dialogYes => 'Ναι';

  @override
  String get dialogNo => 'Όχι';

  @override
  String get orderMarkAsPaidError =>
      'Δεν ήταν δυνατή η σημείωση της παραγγελίας ως πληρωμένης';

  @override
  String get orderMarkAsPaidSuccess => 'Η παραγγελία σημειώθηκε ως πληρωμένη';

  @override
  String get ordersHistoryEmpty =>
      'Δεν υπάρχουν ακόμα παραγγελίες στο ιστορικό';

  @override
  String get orderPaidLabel => 'ΠΛΗΡΩΜΕΝΗ';

  @override
  String orderPaidAt(String dateTime) {
    return 'Πληρώθηκε στις $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Ολοκληρώθηκε η επεξεργασία της παραγγελίας \"$orderNumber\"';
  }

  @override
  String get timeEstimationTitle => 'Εκτίμηση χρόνου';

  @override
  String get timeEstimationQuestion =>
      'Σε πόσο χρόνο θα είναι έτοιμη αυτή η παραγγελία;';

  @override
  String get timeEstimationSkip => 'ΠΑΡΑΛΕΙΨΗ ΕΚΤΙΜΗΣΗΣ';

  @override
  String get timeEstimationConfirm => 'ΕΠΙΒΕΒΑΙΩΣΗ ΧΡΟΝΟΥ';

  @override
  String get reservationsTitle => 'Κρατήσεις';

  @override
  String get reservationsSubtitle => 'Διαχείριση κρατήσεων τραπεζιών';

  @override
  String get reservationsRequestsTitle => 'Κρατήσεις';

  @override
  String get reservationsTabRequests => 'Αιτήματα';

  @override
  String get reservationsTabAccepted => 'Αποδεκτές';

  @override
  String get reservationToday => 'Σήμερα';

  @override
  String reservationCountDrinks(int count) {
    return '$count ποτά';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count πιάτα';
  }

  @override
  String reservationCountList(int count) {
    return '$count κρατήσεις';
  }

  @override
  String get reservationsFilters => 'ΦΙΛΤΡΑ';

  @override
  String get reservationLabelTime => 'Ώρα:';

  @override
  String get reservationLabelRegion => 'Περιοχή:';

  @override
  String get reservationLabelPartySize => 'Αριθμός ατόμων:';

  @override
  String get preparingTitle => 'Σε ετοιμασία';

  @override
  String get preparingSubtitle => 'Είδη σε ετοιμασία';

  @override
  String preparingDishCount(int count) {
    return '$count πιάτα';
  }

  @override
  String get preparingDishCountSuffix => ' πιάτα';

  @override
  String get preparingDrinksCountSuffix => ' ποτά';

  @override
  String get preparingMarkAsReady => 'ΣΗΜΕΙΩΣΗ ΩΣ ΕΤΟΙΜΗ';

  @override
  String get preparingMarkAsReadySuccess => 'Η παραγγελία σημειώθηκε ως έτοιμη';

  @override
  String get preparingMarkAsReadyError => 'Αποτυχία σημείωσης';

  @override
  String get menuTitle => 'Μενού';

  @override
  String get menuSubtitle => 'Περιήγηση στο μενού';

  @override
  String get menuInstruction =>
      'Σημειώστε όταν ένα πιάτο ή ποτό είναι διαθέσιμο ή μη διαθέσιμο';

  @override
  String get menuSearchHint => 'Αναζήτηση πιάτου...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available διαθέσιμα από $total συνολικά';
  }

  @override
  String get menuAvailableCountMiddle => ' διαθέσιμα από ';

  @override
  String get drinksListTitle => 'Λίστα ποτών';

  @override
  String get drinksListInstruction =>
      'Σημειώστε όταν ένα ποτό είναι διαθέσιμο ή μη διαθέσιμο';

  @override
  String get drinksAvailableCountSuffix => ' διαθέσιμα ποτά';

  @override
  String get menuSearchHintDrinks => 'Αναζήτηση ποτού...';

  @override
  String get profileTypeWaiter => 'Σερβιτόρος';

  @override
  String get profileTypeKitchen => 'Κουζίνα';

  @override
  String get profileTypeBar => 'Μπαρ';

  @override
  String get authLoginFailed => 'Η σύνδεση απέτυχε.';

  @override
  String get authInvalidResponse => 'Μη έγκυρη απάντηση διακομιστή.';

  @override
  String get filterTitle => 'Φίλτρα';

  @override
  String get filterTableNumber => 'Αριθμός τραπεζιού:';

  @override
  String get filterFood => 'Φαγητό:';

  @override
  String get filterDrinks => 'Ποτά:';

  @override
  String get filterBillAmount => 'Ποσό λογαριασμού:';

  @override
  String get filterStatusPending => 'Εκκρεμεί ?';

  @override
  String get filterStatusInPreparation => 'Σε ετοιμασία ⏱';

  @override
  String get filterStatusServed => 'Σερβιρίστηκε ✔';

  @override
  String get filterStatusRejected => 'Απορρίφθηκε ✖';

  @override
  String get filterReset => 'ΕΠΑΝΑΦΟΡΑ ΦΙΛΤΡΩΝ';

  @override
  String get filterApply => 'ΕΦΑΡΜΟΓΗ ΦΙΛΤΡΩΝ';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Ημερομηνία:';

  @override
  String get filterDateFrom => 'Από:';

  @override
  String get filterDateTo => 'Έως:';

  @override
  String get filterDateToday => 'Σήμερα';

  @override
  String get filterDateYesterday => 'Χθες';

  @override
  String get filterDateTomorrow => 'Αύριο';

  @override
  String get filterOrderContent => 'Περιεχόμενο παραγγελίας:';

  @override
  String get filterOrderContentDrinks => 'Ποτά';

  @override
  String get filterOrderContentFood => 'Φαγητό';

  @override
  String get filterPeopleCount => 'Αριθμός ατόμων:';

  @override
  String get filterRegion => 'Περιοχή:';

  @override
  String get filterRegionIndoors => 'Εσωτερικό';

  @override
  String get filterRegionGarden => 'Κήπος';

  @override
  String get filterReservationContent => 'Περιεχόμενο κράτησης:';

  @override
  String get acceptSheetTitle => 'Ολοκλήρωση επιβεβαίωσης';

  @override
  String get acceptSheetSelectRegion => 'Επιλέξτε περιοχή εστιατορίου';

  @override
  String get acceptSheetSelectTable => 'Επιλέξτε αριθμό τραπεζιού';

  @override
  String get acceptSheetNoteHint => 'Σημείωση για τον πελάτη... (προαιρετικό)';

  @override
  String get acceptSheetConfirm => 'ΕΠΙΒΕΒΑΙΩΣΗ ΚΡΑΤΗΣΗΣ';

  @override
  String get acceptSheetNoTables => 'Δεν υπάρχουν διαθέσιμα τραπέζια.';

  @override
  String get acceptSheetErrorGeneric =>
      'Δεν ήταν δυνατή η αποδοχή της κράτησης. Δοκιμάστε ξανά.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Περιοχή $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Κράτηση στις $time';
  }

  @override
  String get confirmedResUser => 'Χρήστης:';

  @override
  String get confirmedResTableNumber => 'Τραπέζι:';

  @override
  String get confirmedResOccasion => 'Περίσταση:';

  @override
  String get confirmedResOccasionBirthday => 'Γενέθλια';

  @override
  String get confirmedResOccasionClassic => 'Κλασική';

  @override
  String get confirmedResNote => 'Σημείωση:';

  @override
  String get confirmedResMessageLabel => 'Μήνυμα:';

  @override
  String get confirmedResMessageConfirmed =>
      'Η κράτησή σας επιβεβαιώθηκε. Τα λέμε σύντομα!';

  @override
  String confirmedResMessageConfirmedWithNote(String note) {
    return 'Η κράτησή σας επιβεβαιώθηκε. Τα λέμε σύντομα! Σημείωση: $note';
  }

  @override
  String get confirmedResEditButton => 'ΕΠΕΞΕΡΓΑΣΙΑ ΚΡΑΤΗΣΗΣ';

  @override
  String get confirmedResCancelButton => 'ΑΚΥΡΩΣΗ ΚΡΑΤΗΣΗΣ';

  @override
  String get editResDialogTitle => 'Επεξεργασία';

  @override
  String get editResNoteHint =>
      'Εισάγετε λόγους και λεπτομέρειες της αλλαγής για τον πελάτη... (υποχρεωτικό)';

  @override
  String get editResConfirm => 'ΕΠΙΒΕΒΑΙΩΣΗ ΑΛΛΑΓΩΝ';

  @override
  String get cancelDialogTitle => 'Ακύρωση';

  @override
  String get cancelReasonHint => 'Εισάγετε λόγο ακύρωσης (υποχρεωτικό)';

  @override
  String get rejectDialogTitle => 'Τελική επιβεβαίωση';

  @override
  String get rejectReasonHint => 'Εισάγετε επεξήγηση (υποχρεωτικό)';

  @override
  String get rejectErrorFallback =>
      'Δεν ήταν δυνατή η απόρριψη της κράτησης. Δοκιμάστε ξανά.';

  @override
  String get buttonRejectReservation => 'ΑΠΟΡΡΙΨΗ ΚΡΑΤΗΣΗΣ';

  @override
  String get buttonReject => 'ΑΠΟΡΡΙΨΗ';

  @override
  String get buttonAccept => 'ΑΠΟΔΟΧΗ';

  @override
  String get labelFoodDrink => 'Φαγητό/Ποτό:';

  @override
  String tableSeatCount(int count) {
    return '$count θέσεις';
  }

  @override
  String get tableReservationDialogTitle => 'Κράτηση';

  @override
  String get tableReservationNameHint => 'Στο όνομα...';

  @override
  String get tableReservationNameRequired => 'Εισάγετε όνομα';

  @override
  String get tableReservationPartySizeHint => 'Αριθμός ατόμων';

  @override
  String get tableReservationPartySizeRequired => 'Επιλέξτε αριθμό ατόμων';

  @override
  String get tableReservationDateHint => 'Ημερομηνία';

  @override
  String get tableReservationDateRequired => 'Επιλέξτε ημερομηνία';

  @override
  String get tableReservationTimeHint => 'Ώρα';

  @override
  String get tableReservationTimeRequired => 'Επιλέξτε ώρα';

  @override
  String get tableReservationTableRequired => 'Επιλέξτε τραπέζι';

  @override
  String get tableReservationInternalNoteHint => 'Εσωτερική σημείωση...';

  @override
  String get tableReservationCreateButton => 'ΔΗΜΙΟΥΡΓΙΑ ΚΡΑΤΗΣΗΣ';

  @override
  String get tableOrderScreenTitle => 'Νέα παραγγελία';

  @override
  String get tableOrderAiBanner =>
      'Meli • Ρωτήστε το AI bot μας για προτάσεις...';

  @override
  String get billSheetTitle => 'Λογαριασμός';

  @override
  String get billSheetTotal => 'ΣΥΝΟΛΟ:';

  @override
  String get billSheetEmpty => 'Το καλάθι είναι άδειο';

  @override
  String get billSheetOrderButton => 'ΠΑΡΑΓΓΕΛΙΑ';

  @override
  String get tableOrderSubmitSuccess => 'Η παραγγελία στάλθηκε';

  @override
  String get tableOrderSubmitError =>
      'Δεν ήταν δυνατή η αποστολή της παραγγελίας';

  @override
  String get tableOverviewNoReservations =>
      'Δεν υπάρχουν ενεργές κρατήσεις για αυτό το τραπέζι';

  @override
  String get tableOverviewNoOrders =>
      'Δεν υπάρχουν ενεργές παραγγελίες για αυτό το τραπέζι';

  @override
  String get tableOverviewMakeOrder => 'ΠΑΡΑΓΓΕΛΙΑ';

  @override
  String get tableOrdersFilterTypeAny => 'Οποιοδήποτε';

  @override
  String get tableOrdersFilterStatusLabel => 'Κατάσταση παραγγελίας:';

  @override
  String get tableOrdersFilterStatusAny => 'Οποιοδήποτε';

  @override
  String get tableOrdersFilterStatusAwaitingConfirmation =>
      'Αναμονή επιβεβαίωσης';

  @override
  String get tableOrdersFilterStatusPending => 'Εκκρεμεί';

  @override
  String get tableOrdersFilterStatusConfirmed => 'Επιβεβαιωμένη';

  @override
  String get tableOrdersFilterStatusRejected => 'Απορρίφθηκε';

  @override
  String get tableOrdersFilterStatusExpired => 'Έληξε';

  @override
  String get tableOrdersFilterStatusPaid => 'Πληρωμένη';
}
