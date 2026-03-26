// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Prijavite se da biste nastavili';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'npr. korisnik@example.com';

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
  String get loginFailed => 'Prijava nije uspela. Pokušajte ponovo.';

  @override
  String get loginRoleNotSupported =>
      'Vaša uloga nije podržana. Aplikacija je namenjena konobarima, kuvarima i šankerima.';

  @override
  String get loginRegisterButton => 'Registracija';

  @override
  String get registerTitle => 'Registracija';

  @override
  String get registerFirstnameLabel => 'Ime';

  @override
  String get registerLastnameLabel => 'Prezime';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordConfirmLabel => 'Potvrdi lozinku';

  @override
  String get registerPasswordMismatch => 'Lozinke se ne poklapaju';

  @override
  String get registerFieldRequired => 'Polje je obavezno';

  @override
  String get registerSubmitButton => 'Registruj se';

  @override
  String get registerSuccessTitle => 'Uspešna registracija';

  @override
  String registerSuccessMessage(String email) {
    return 'Na vašu e-adresu ($email) poslat je link za verifikaciju. Molimo otvorite e-poštu i kliknite na link za verifikaciju kako biste aktivirali vaš nalog. Nakon toga se možete prijaviti u aplikaciju.';
  }

  @override
  String get registerSuccessOk => 'U redu';

  @override
  String get registerErrorGeneric => 'Došlo je do greške. Pokušajte ponovo.';

  @override
  String get registerBackToLogin => 'Nazad na prijavu';

  @override
  String get profileTitle => 'Moj profil';

  @override
  String get profileLabelName => 'IME';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'LOZINKA';

  @override
  String get profileChangePassword => 'Promeni';

  @override
  String get profileReservationReminder => 'NAPOMENA ZA REZERVACIJU';

  @override
  String get profileReservationReminderHint =>
      '*Koliko ranije dobijate obaveštenje za spremanje unapred naručene hrane';

  @override
  String get profileReservationReminderValue => '1h unapr';

  @override
  String get profileLabelLanguage => 'JEZIK';

  @override
  String get profileDeleteAccount => 'OBRIŠI NALOG';

  @override
  String get profileDeleteAccountAction => 'Klikni za brisanje';

  @override
  String get profileDeleteAccountWarning =>
      'Ako obrišete profil, više nećete moći da ga povratite.';

  @override
  String get profileLabelCurrency => 'VALUTA';

  @override
  String get profileLanguageValue => 'Srpski';

  @override
  String get profileDrinksList => 'LISTA PIĆA';

  @override
  String get profileShiftScheduleLabel => 'RASPORED SMENA';

  @override
  String get profileShiftScheduleView => 'Pogledaj';

  @override
  String get shiftScheduleDialogTitle => 'Raspored smena';

  @override
  String get shiftScheduleLoadError => 'Ne može da se učita raspored.';

  @override
  String get shiftScheduleEmpty => 'Nema podataka o rasporedu.';

  @override
  String get shiftScheduleRetry => 'Pokušaj ponovo';

  @override
  String get shiftScheduleSelfLabel => 'Ja';

  @override
  String get profileLogout => 'IZLOGUJ SE';

  @override
  String get profileImageDialogTitle => 'Profilna slika';

  @override
  String get profileImageUploadButton => 'UBACI SLIKU';

  @override
  String get profileImageMaxSize => '3MB (maksimalna veličina slike)';

  @override
  String get profileImageSaveChanges => 'SAČUVAJ IZMENE';

  @override
  String get logoutDialogTitle => 'Odjava';

  @override
  String get logoutDialogMessage =>
      'Da li ste sigurni da želite da se odjavite?';

  @override
  String get logoutCancel => 'Odustani';

  @override
  String get logoutConfirm => 'Odjavi se';

  @override
  String get navOrders => 'PORUDŽBINE';

  @override
  String get navReady => 'SPREMNO';

  @override
  String get navPreparing => 'U PRIPREMI';

  @override
  String get navReservations => 'REZERVACIJE';

  @override
  String get navMenu => 'JELOVNIK';

  @override
  String get navDrinks => 'PIĆA';

  @override
  String get navZones => 'ZONE';

  @override
  String get tablesReserve => 'REZERVIŠI';

  @override
  String get tablesOrder => 'PORUČI';

  @override
  String zonesCount(int count) {
    return '$count zona';
  }

  @override
  String tableNumber(String number) {
    return 'Sto $number';
  }

  @override
  String get tableReservationAt => 'Rezervacija:';

  @override
  String get tableTypeTable => 'Sto';

  @override
  String get tableTypeRoom => 'Soba';

  @override
  String get tableTypeSunbed => 'Ležaljka';

  @override
  String seatingNumberTable(String number) {
    return 'Sto $number';
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
  String get readyTitle => 'Spremno za usluživanje';

  @override
  String get readySubtitle => 'Porudžbine spremne za serviranje';

  @override
  String get readyOrdersCountSuffix => ' spremne porudžbine';

  @override
  String get readyMarkAsServed => 'OZNAČI KAO SERVIRANO';

  @override
  String get readyMarkAsDelivered => 'OZNAČI KAO ODNETO';

  @override
  String get readySectionFood => 'HRANA';

  @override
  String get readySectionDrinks => 'PIĆA';

  @override
  String get readyMarkAsServedSuccess => 'Porudžbina označena kao servirana';

  @override
  String get readyMarkAsServedError => 'Greška pri označavanju';

  @override
  String get ordersTitle => 'Porudžbine';

  @override
  String ordersCount(int count) {
    return '$count porudžbine';
  }

  @override
  String get ordersCountSuffix => ' porudžbine';

  @override
  String get ordersTabActive => 'Aktivne';

  @override
  String get ordersTabHistory => 'Istorija';

  @override
  String get ordersFilters => 'FILTERI';

  @override
  String get ordersOrderButton => 'PORUČI';

  @override
  String get ordersFoodLabel => 'Hrana:';

  @override
  String get ordersDrinksLabel => 'Piće:';

  @override
  String get orderStatusPending => 'NA ČEKANJU';

  @override
  String get orderStatusInPreparation => 'U PRIPREMI';

  @override
  String get orderStatusServed => 'SERVIRANO';

  @override
  String get orderStatusRejected => 'ODBIJENO';

  @override
  String get orderBill => 'Račun:';

  @override
  String orderTableNumber(int number) {
    return 'Sto $number';
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
    return 'Pre $count dan';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'Pre ${hours}h ${minutes}min';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'Pre $count sat';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'Pre $count minuta';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'Pre $count sekundi';
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
      'Da li ste sigurni da želite da izvršite ovu radnju?';

  @override
  String get dialogYes => 'Da';

  @override
  String get dialogNo => 'Ne';

  @override
  String get orderMarkAsPaidError =>
      'Nije moguće označiti porudžbinu kao plaćenu';

  @override
  String get orderMarkAsPaidSuccess => 'Porudžbina označena kao plaćena';

  @override
  String get ordersHistoryEmpty => 'Još nema porudžbina u istoriji';

  @override
  String get orderPaidLabel => 'PLAĆENO';

  @override
  String orderPaidAt(String dateTime) {
    return 'Plaćeno $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Završena obrada porudžbine \"$orderNumber\"';
  }

  @override
  String get timeEstimationTitle => 'Procjena vremena';

  @override
  String get timeEstimationQuestion =>
      'Za koliko vremena će ova porudžbina biti spremna?';

  @override
  String get timeEstimationSkip => 'PRESKOČI PROCENU';

  @override
  String get timeEstimationConfirm => 'POTVRDI VREME';

  @override
  String get reservationsTitle => 'Rezervacije';

  @override
  String get reservationsSubtitle => 'Upravljajte rezervacijama stolova';

  @override
  String get reservationsRequestsTitle => 'Rezervacije';

  @override
  String get reservationsTabRequests => 'Zahtevi';

  @override
  String get reservationsTabAccepted => 'Prihvaćeno';

  @override
  String get reservationToday => 'Danas';

  @override
  String reservationCountDrinks(int count) {
    return '$count piće';
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
  String get reservationsFilters => 'FILTERI';

  @override
  String get reservationLabelTime => 'Vreme:';

  @override
  String get reservationLabelRegion => 'Region:';

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
  String get preparingMarkAsReady => 'OZNAČI KAO GOTOVO';

  @override
  String get preparingMarkAsReadySuccess => 'Porudžbina označena kao gotova';

  @override
  String get preparingMarkAsReadyError => 'Greška pri označavanju';

  @override
  String get menuTitle => 'Jelovnik';

  @override
  String get menuSubtitle => 'Pregledajte stavke jelovnika';

  @override
  String get menuInstruction =>
      'Označi kada je neko jelo dostupno ili nedostupno';

  @override
  String get menuSearchHint => 'Pretraži jelo...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available dostupnih od ukupno $total';
  }

  @override
  String get menuAvailableCountMiddle => ' dostupnih od ukupno ';

  @override
  String get drinksListTitle => 'Lista pića';

  @override
  String get drinksListInstruction =>
      'Označi kada je neko piće dostupno ili nedostupno';

  @override
  String get drinksAvailableCountSuffix => ' dostupnih pića';

  @override
  String get menuSearchHintDrinks => 'Pretraži piće...';

  @override
  String get profileTypeWaiter => 'Konobar';

  @override
  String get profileTypeKitchen => 'Kuhinja';

  @override
  String get profileTypeBar => 'Šank';

  @override
  String get authLoginFailed => 'Prijava nije uspela.';

  @override
  String get authInvalidResponse => 'Neispravan odgovor servera.';

  @override
  String get filterTitle => 'Filteri';

  @override
  String get filterTableNumber => 'Broj stola:';

  @override
  String get filterFood => 'Hrana:';

  @override
  String get filterDrinks => 'Piće:';

  @override
  String get filterBillAmount => 'Iznos računa:';

  @override
  String get filterStatusPending => 'Na čekanju ?';

  @override
  String get filterStatusInPreparation => 'U pripremi ⏱';

  @override
  String get filterStatusServed => 'Servirano ✔';

  @override
  String get filterStatusRejected => 'Odbijeno ✖';

  @override
  String get filterReset => 'RESETUJ FILTERE';

  @override
  String get filterApply => 'PRIMENI FILTERE';

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
  String get filterDateYesterday => 'Juče';

  @override
  String get filterDateTomorrow => 'Sutra';

  @override
  String get filterOrderContent => 'Sadržaj porudžbine:';

  @override
  String get filterOrderContentDrinks => 'Piće';

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
  String get acceptSheetSelectRegion => 'Izaberi region restorana';

  @override
  String get acceptSheetSelectTable => 'Izaberi broj stola';

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
    return 'Region $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Rezervacija u $time';
  }

  @override
  String get confirmedResUser => 'Korisnik:';

  @override
  String get confirmedResTableNumber => 'Sto broj:';

  @override
  String get confirmedResOccasion => 'Povod:';

  @override
  String get confirmedResOccasionBirthday => 'Rođendan';

  @override
  String get confirmedResOccasionClassic => 'Klasična';

  @override
  String get confirmedResNote => 'Napomena:';

  @override
  String get confirmedResEditButton => 'IZMENI REZERVACIJU';

  @override
  String get confirmedResCancelButton => 'OTKAŽI REZERVACIJU';

  @override
  String get editResDialogTitle => 'Izmena';

  @override
  String get editResNoteHint =>
      'Upiši razloge i detalje izmene za gosta... (obavezno polje)';

  @override
  String get editResConfirm => 'POTVRDI IZMENE';

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
    return '$count mesta';
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
  String get tableReservationPartySizeRequired => 'Izaberite broj ljudi';

  @override
  String get tableReservationDateHint => 'Datum';

  @override
  String get tableReservationDateRequired => 'Izaberite datum';

  @override
  String get tableReservationTimeHint => 'Vreme';

  @override
  String get tableReservationTimeRequired => 'Izaberite vreme';

  @override
  String get tableReservationTableRequired => 'Izaberite sto';

  @override
  String get tableReservationInternalNoteHint => 'Upiši internu napomenu...';

  @override
  String get tableReservationCreateButton => 'KREIRAJ REZERVACIJU';

  @override
  String get tableOrderScreenTitle => 'Nova porudžbina';

  @override
  String get tableOrderAiBanner => 'Meli • Pitaj našeg AI bota za preporuke...';

  @override
  String get billSheetTitle => 'Račun';

  @override
  String get billSheetTotal => 'UKUPNO:';

  @override
  String get billSheetEmpty => 'Korpa je prazna';

  @override
  String get billSheetOrderButton => 'NARUČI';

  @override
  String get tableOrderSubmitSuccess => 'Porudžbina poslata';

  @override
  String get tableOrderSubmitError => 'Slanje porudžbine nije uspelo';

  @override
  String get tableOverviewNoReservations =>
      'Nema aktivnih rezervacija za ovaj sto';

  @override
  String get tableOverviewNoOrders => 'Nema aktivnih porudžbina za ovaj sto';

  @override
  String get tableOverviewMakeOrder => 'PORUČI';

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
