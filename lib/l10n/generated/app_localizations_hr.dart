// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Prijavite se za nastavak';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'npr. korisnik@primjer.com';

  @override
  String get loginEmailRequired => 'Unesite email';

  @override
  String get loginEmailInvalid => 'Unesite ispravan email';

  @override
  String get loginPasswordLabel => 'Lozinka';

  @override
  String get loginPasswordRequired => 'Unesite lozinku';

  @override
  String get loginRememberEmail => 'Zapamti email';

  @override
  String get loginButton => 'Prijava';

  @override
  String get loginFailed => 'Prijava nije uspjela. Pokušajte ponovno.';

  @override
  String get loginRoleNotSupported =>
      'Vaša uloga nije podržana. Ova aplikacija je za konobare, kuhare i barmene.';

  @override
  String get profileTitle => 'Moj profil';

  @override
  String get profileLabelName => 'IME';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'LOZINKA';

  @override
  String get profileChangePassword => 'Promijeni';

  @override
  String get profileReservationReminder => 'PODSJETNIK REZERVACIJE';

  @override
  String get profileReservationReminderHint =>
      '*Koliko ranije primate obavijesti za pripremu prethodno naručene hrane';

  @override
  String get profileReservationReminderValue => '1 sat unaprijed';

  @override
  String get profileLabelLanguage => 'JEZIK';

  @override
  String get profileLabelCurrency => 'VALUTA';

  @override
  String get profileCurrencyDialogTitle => 'Valuta prikaza';

  @override
  String get profileLanguageValue => 'Hrvatski';

  @override
  String get profileDrinksList => 'LISTA PIĆA';

  @override
  String get profileLogout => 'ODJAVA';

  @override
  String get profileImageDialogTitle => 'Slika profila';

  @override
  String get profileImageUploadButton => 'UČITAJ SLIKU';

  @override
  String get profileImageMaxSize => '3 MB (maksimalna veličina)';

  @override
  String get profileImageSaveChanges => 'SPREMI PROMJENE';

  @override
  String get logoutDialogTitle => 'Odjava';

  @override
  String get logoutDialogMessage => 'Jeste li sigurni da se želite odjaviti?';

  @override
  String get logoutCancel => 'Odustani';

  @override
  String get logoutConfirm => 'Odjavi se';

  @override
  String get navOrders => 'NARUDŽBE';

  @override
  String get navReady => 'SPREMNO';

  @override
  String get navPreparing => 'U PRIPREMI';

  @override
  String get navReservations => 'REZERVACIJE';

  @override
  String get navMenu => 'IZBORNIK';

  @override
  String get navDrinks => 'PIĆA';

  @override
  String get navTables => 'STOLOVI';

  @override
  String get tablesReserve => 'REZERVIRAJ';

  @override
  String get tablesOrder => 'NARUČI';

  @override
  String tablesCount(int count) {
    return '$count stolova';
  }

  @override
  String tableNumber(String number) {
    return 'Stol $number';
  }

  @override
  String get tableReservationAt => 'Rezervacija:';

  @override
  String get tableTypeTable => 'Stol';

  @override
  String get tableTypeRoom => 'Soba';

  @override
  String get tableTypeSunbed => 'Ležaljka';

  @override
  String seatingNumberTable(String number) {
    return 'Stol $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Soba $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Ležaljka $number';
  }

  @override
  String get navProfile => 'PROFIL';

  @override
  String get readyTitle => 'Spremno za serviranje';

  @override
  String get readySubtitle => 'Narudžbe spremne za serviranje';

  @override
  String get readyOrdersCountSuffix => ' spremnih narudžbi';

  @override
  String get readyMarkAsServed => 'OZNAČI KAO POSLUŽENO';

  @override
  String get readyMarkAsDelivered => 'OZNAČI KAO DOSTAVLJENO';

  @override
  String get readySectionFood => 'HRANA';

  @override
  String get readySectionDrinks => 'PIĆA';

  @override
  String get readyMarkAsServedSuccess => 'Narudžba označena kao poslužena';

  @override
  String get readyMarkAsServedError => 'Nije uspjelo označiti kao posluženo';

  @override
  String get ordersTitle => 'Narudžbe';

  @override
  String ordersCount(int count) {
    return '$count narudžbi';
  }

  @override
  String get ordersCountSuffix => ' narudžbi';

  @override
  String get ordersTabActive => 'Aktivne';

  @override
  String get ordersTabHistory => 'Povijest';

  @override
  String get ordersFilters => 'FILTRI';

  @override
  String get ordersOrderButton => 'NARUČI';

  @override
  String get ordersFoodLabel => 'Hrana:';

  @override
  String get ordersDrinksLabel => 'Pića:';

  @override
  String get orderStatusPending => 'NA ČEKANJU';

  @override
  String get orderStatusInPreparation => 'U PRIPREMI';

  @override
  String get orderStatusServed => 'POSLUŽENO';

  @override
  String get orderStatusRejected => 'ODBIJENO';

  @override
  String get orderBill => 'Račun:';

  @override
  String orderTableNumber(int number) {
    return 'Stol $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Broj jela: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Broj pića: $count';
  }

  @override
  String get orderSeeDetails => 'VIDI DETALJE';

  @override
  String orderTimeAgoDays(int count) {
    return 'prije $count dan';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'prije ${hours}h ${minutes}min';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'prije $count h';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'prije $count min';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'prije $count sek';
  }

  @override
  String get orderRejectAll => 'ODBIJ SVE';

  @override
  String get orderAccept => 'PRIHVATI';

  @override
  String get orderMarkAsPaid => 'OZNAČI KAO PLAĆENO';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Označi kao plaćeno';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Jeste li sigurni da želite izvršiti ovu radnju?';

  @override
  String get dialogYes => 'Da';

  @override
  String get dialogNo => 'Ne';

  @override
  String get orderMarkAsPaidError =>
      'Nije moguće označiti narudžbu kao plaćenu';

  @override
  String get orderMarkAsPaidSuccess => 'Narudžba označena kao plaćena';

  @override
  String get ordersHistoryEmpty => 'Još nema narudžbi u povijesti';

  @override
  String get orderPaidLabel => 'PLAĆENO';

  @override
  String orderPaidAt(String dateTime) {
    return 'Plaćeno $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Obrada narudžbe \"$orderNumber\" dovršena';
  }

  @override
  String get timeEstimationTitle => 'Procjena vremena';

  @override
  String get timeEstimationQuestion =>
      'Za koliko će vremena biti spremna ova narudžba?';

  @override
  String get timeEstimationSkip => 'PRESKOČI PROCJENU';

  @override
  String get timeEstimationConfirm => 'POTVRDI VRIJEME';

  @override
  String get reservationsTitle => 'Rezervacije';

  @override
  String get reservationsSubtitle => 'Upravljanje rezervacijama stolova';

  @override
  String get reservationsRequestsTitle => 'Rezervacije';

  @override
  String get reservationsTabRequests => 'Zahtjevi';

  @override
  String get reservationsTabAccepted => 'Prihvaćeno';

  @override
  String get reservationToday => 'Danas';

  @override
  String reservationCountDrinks(int count) {
    return '$count pića';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count jela';
  }

  @override
  String reservationCountList(int count) {
    return '$count rezervacije';
  }

  @override
  String get reservationsFilters => 'FILTRI';

  @override
  String get reservationLabelTime => 'Vrijeme:';

  @override
  String get reservationLabelRegion => 'Regija:';

  @override
  String get reservationLabelPartySize => 'Broj ljudi:';

  @override
  String get preparingTitle => 'U pripremi';

  @override
  String get preparingSubtitle => 'Stavke u pripremi';

  @override
  String preparingDishCount(int count) {
    return '$count jela';
  }

  @override
  String get preparingDishCountSuffix => ' jela';

  @override
  String get preparingDrinksCountSuffix => ' pića';

  @override
  String get preparingMarkAsReady => 'OZNAČI KAO SPREMNO';

  @override
  String get preparingMarkAsReadySuccess => 'Narudžba označena kao spremna';

  @override
  String get preparingMarkAsReadyError => 'Nije uspjelo označiti kao spremno';

  @override
  String get menuTitle => 'Izbornik';

  @override
  String get menuSubtitle => 'Pregled stavki izbornika';

  @override
  String get menuInstruction =>
      'Označite kada je jelo ili piće dostupno ili nedostupno';

  @override
  String get menuSearchHint => 'Pretraži jelo...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available dostupno od $total ukupno';
  }

  @override
  String get menuAvailableCountMiddle => ' dostupno od ';

  @override
  String get drinksListTitle => 'Lista pića';

  @override
  String get drinksListInstruction =>
      'Označite kada je piće dostupno ili nedostupno';

  @override
  String get drinksAvailableCountSuffix => ' dostupnih pića';

  @override
  String get menuSearchHintDrinks => 'Pretraži piće...';

  @override
  String get profileTypeWaiter => 'Konobar';

  @override
  String get profileTypeKitchen => 'Kuhinja';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Prijava nije uspjela.';

  @override
  String get authInvalidResponse => 'Nevažeći odgovor poslužitelja.';

  @override
  String get filterTitle => 'Filteri';

  @override
  String get filterTableNumber => 'Broj stola:';

  @override
  String get filterFood => 'Hrana:';

  @override
  String get filterDrinks => 'Pića:';

  @override
  String get filterBillAmount => 'Iznos računa:';

  @override
  String get filterStatusPending => 'Na čekanju ?';

  @override
  String get filterStatusInPreparation => 'U pripremi ⏱';

  @override
  String get filterStatusServed => 'Posluženo ✔';

  @override
  String get filterStatusRejected => 'Odbijeno ✖';

  @override
  String get filterReset => 'RESETIRAJ FILTRE';

  @override
  String get filterApply => 'PRIMJENI FILTRE';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Datum:';

  @override
  String get filterDateFrom => 'Od:';

  @override
  String get filterDateTo => 'Do:';

  @override
  String get filterDateToday => 'Danas';

  @override
  String get filterDateYesterday => 'Jučer';

  @override
  String get filterDateTomorrow => 'Sutra';

  @override
  String get filterOrderContent => 'Sadržaj narudžbe:';

  @override
  String get filterOrderContentDrinks => 'Pića';

  @override
  String get filterOrderContentFood => 'Hrana';

  @override
  String get filterPeopleCount => 'Broj ljudi:';

  @override
  String get filterRegion => 'Region:';

  @override
  String get filterRegionIndoors => 'Unutrašnjost';

  @override
  String get filterRegionGarden => 'Bašta';

  @override
  String get filterReservationContent => 'Sadržaj rezervacije:';

  @override
  String get acceptSheetTitle => 'Dovrši potvrdu';

  @override
  String get acceptSheetSelectRegion => 'Odaberi regiju restorana';

  @override
  String get acceptSheetSelectTable => 'Odaberi broj stola';

  @override
  String get acceptSheetNoteHint => 'Upiši napomenu za gosta... (opciono)';

  @override
  String get acceptSheetConfirm => 'POTVRDI REZERVACIJU';

  @override
  String get acceptSheetNoTables => 'Nema dostupnih stolova.';

  @override
  String get acceptSheetErrorGeneric =>
      'Nije moguće prihvatiti rezervaciju. Pokušaj ponovo.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Zona $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Rezervacija u $time';
  }

  @override
  String get confirmedResUser => 'Korisnik:';

  @override
  String get confirmedResTableNumber => 'Broj stola:';

  @override
  String get confirmedResOccasion => 'Prigoda:';

  @override
  String get confirmedResOccasionBirthday => 'Rođendan';

  @override
  String get confirmedResOccasionClassic => 'Klasična';

  @override
  String get confirmedResNote => 'Napomena:';

  @override
  String get confirmedResEditButton => 'UREDI REZERVACIJU';

  @override
  String get confirmedResCancelButton => 'OTKAŽI REZERVACIJU';

  @override
  String get editResDialogTitle => 'Izmjena';

  @override
  String get editResNoteHint =>
      'Upiši razloge i detalje izmjene za gosta... (obavezno polje)';

  @override
  String get editResConfirm => 'POTVRDI IZMJENE';

  @override
  String get cancelDialogTitle => 'Otkazivanje';

  @override
  String get cancelReasonHint => 'Upiši razlog otkazivanja (obavezno polje)';

  @override
  String get rejectDialogTitle => 'Finalna potvrda';

  @override
  String get rejectReasonHint => 'Upiši objašnjenje (obavezno polje)';

  @override
  String get rejectErrorFallback =>
      'Nije moguće odbiti rezervaciju. Pokušaj ponovo.';

  @override
  String get buttonRejectReservation => 'ODBIJ REZERVACIJU';

  @override
  String get buttonReject => 'ODBIJ';

  @override
  String get buttonAccept => 'PRIHVATI';

  @override
  String get labelFoodDrink => 'Hrana/Piće:';

  @override
  String tableSeatCount(int count) {
    return '$count mjesta';
  }

  @override
  String get tableReservationDialogTitle => 'Rezervacija';

  @override
  String get tableReservationNameHint => 'Na ime...';

  @override
  String get tableReservationNameRequired => 'Unesite ime';

  @override
  String get tableReservationPartySizeHint => 'Broj ljudi';

  @override
  String get tableReservationPartySizeRequired => 'Odaberite broj ljudi';

  @override
  String get tableReservationDateHint => 'Datum';

  @override
  String get tableReservationDateRequired => 'Odaberite datum';

  @override
  String get tableReservationTimeHint => 'Vrijeme';

  @override
  String get tableReservationTimeRequired => 'Odaberite vrijeme';

  @override
  String get tableReservationTableRequired => 'Odaberite stol';

  @override
  String get tableReservationInternalNoteHint => 'Upiši internu napomenu...';

  @override
  String get tableReservationCreateButton => 'KREIRAJ REZERVACIJU';

  @override
  String get tableOrderScreenTitle => 'Nova narudžba';

  @override
  String get tableOrderAiBanner => 'Meli • Pitaj našeg AI bota za preporuke...';

  @override
  String get billSheetTitle => 'Račun';

  @override
  String get billSheetTotal => 'UKUPNO:';

  @override
  String get billSheetEmpty => 'Košarica je prazna';

  @override
  String get billSheetOrderButton => 'NARUČI';

  @override
  String get tableOrderSubmitSuccess => 'Narudžba poslana';

  @override
  String get tableOrderSubmitError => 'Slanje narudžbe nije uspjelo';

  @override
  String get tableOverviewNoReservations =>
      'Nema aktivnih rezervacija za ovaj stol';

  @override
  String get tableOverviewNoOrders => 'Nema aktivnih narudžbi za ovaj stol';

  @override
  String get tableOverviewMakeOrder => 'NARUČI';

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
