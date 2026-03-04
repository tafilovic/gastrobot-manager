// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

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
  String get profileLanguageValue => 'Srpski';

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
  String get navPreparing => 'U PRIPREMI';

  @override
  String get navReservations => 'REZERVACIJE';

  @override
  String get navMenu => 'JELOVNIK';

  @override
  String get navProfile => 'PROFIL';

  @override
  String get ordersTitle => 'Porudžbine';

  @override
  String ordersCount(int count) {
    return '$count porudžbine';
  }

  @override
  String orderTableNumber(int number) {
    return 'Sto broj $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Broj jela: $count';
  }

  @override
  String get orderSeeDetails => 'VIDI DETALJE';

  @override
  String orderTimeAgoMinutes(int count) {
    return 'Pre $count minuta';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'Pre $count sekundi';
  }

  @override
  String get reservationsTitle => 'Rezervacije';

  @override
  String get reservationsSubtitle => 'Upravljajte rezervacijama stolova';

  @override
  String get preparingTitle => 'U pripremi';

  @override
  String get preparingSubtitle => 'Stavke u pripremi';

  @override
  String get menuTitle => 'Jelovnik';

  @override
  String get menuSubtitle => 'Pregledajte stavke jelovnika';

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
}
