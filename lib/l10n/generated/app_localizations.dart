import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('sr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In sr, this message translates to:
  /// **'GastroBot Manager'**
  String get appTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Prijavite se da biste nastavili'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In sr, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In sr, this message translates to:
  /// **'npr. korisnik@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In sr, this message translates to:
  /// **'Unesite email'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In sr, this message translates to:
  /// **'Unesite ispravan email'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In sr, this message translates to:
  /// **'Unesite lozinku'**
  String get loginPasswordRequired;

  /// No description provided for @loginRememberEmail.
  ///
  /// In sr, this message translates to:
  /// **'Zapamti email'**
  String get loginRememberEmail;

  /// No description provided for @loginButton.
  ///
  /// In sr, this message translates to:
  /// **'Prijava'**
  String get loginButton;

  /// No description provided for @loginFailed.
  ///
  /// In sr, this message translates to:
  /// **'Prijava nije uspela. Pokušajte ponovo.'**
  String get loginFailed;

  /// No description provided for @loginRoleNotSupported.
  ///
  /// In sr, this message translates to:
  /// **'Vaša uloga nije podržana. Aplikacija je namenjena konobarima, kuvarima i šankerima.'**
  String get loginRoleNotSupported;

  /// No description provided for @profileTitle.
  ///
  /// In sr, this message translates to:
  /// **'Moj profil'**
  String get profileTitle;

  /// No description provided for @profileLabelName.
  ///
  /// In sr, this message translates to:
  /// **'IME'**
  String get profileLabelName;

  /// No description provided for @profileLabelEmail.
  ///
  /// In sr, this message translates to:
  /// **'EMAIL'**
  String get profileLabelEmail;

  /// No description provided for @profileLabelPassword.
  ///
  /// In sr, this message translates to:
  /// **'LOZINKA'**
  String get profileLabelPassword;

  /// No description provided for @profileChangePassword.
  ///
  /// In sr, this message translates to:
  /// **'Promeni'**
  String get profileChangePassword;

  /// No description provided for @profileReservationReminder.
  ///
  /// In sr, this message translates to:
  /// **'NAPOMENA ZA REZERVACIJU'**
  String get profileReservationReminder;

  /// No description provided for @profileReservationReminderHint.
  ///
  /// In sr, this message translates to:
  /// **'*Koliko ranije dobijate obaveštenje za spremanje unapred naručene hrane'**
  String get profileReservationReminderHint;

  /// No description provided for @profileReservationReminderValue.
  ///
  /// In sr, this message translates to:
  /// **'1h unapr'**
  String get profileReservationReminderValue;

  /// No description provided for @profileLabelLanguage.
  ///
  /// In sr, this message translates to:
  /// **'JEZIK'**
  String get profileLabelLanguage;

  /// No description provided for @profileLanguageValue.
  ///
  /// In sr, this message translates to:
  /// **'Srpski'**
  String get profileLanguageValue;

  /// No description provided for @profileLogout.
  ///
  /// In sr, this message translates to:
  /// **'IZLOGUJ SE'**
  String get profileLogout;

  /// No description provided for @profileImageDialogTitle.
  ///
  /// In sr, this message translates to:
  /// **'Profilna slika'**
  String get profileImageDialogTitle;

  /// No description provided for @profileImageUploadButton.
  ///
  /// In sr, this message translates to:
  /// **'UBACI SLIKU'**
  String get profileImageUploadButton;

  /// No description provided for @profileImageMaxSize.
  ///
  /// In sr, this message translates to:
  /// **'3MB (maksimalna veličina slike)'**
  String get profileImageMaxSize;

  /// No description provided for @profileImageSaveChanges.
  ///
  /// In sr, this message translates to:
  /// **'SAČUVAJ IZMENE'**
  String get profileImageSaveChanges;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In sr, this message translates to:
  /// **'Odjava'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In sr, this message translates to:
  /// **'Da li ste sigurni da želite da se odjavite?'**
  String get logoutDialogMessage;

  /// No description provided for @logoutCancel.
  ///
  /// In sr, this message translates to:
  /// **'Odustani'**
  String get logoutCancel;

  /// No description provided for @logoutConfirm.
  ///
  /// In sr, this message translates to:
  /// **'Odjavi se'**
  String get logoutConfirm;

  /// No description provided for @navOrders.
  ///
  /// In sr, this message translates to:
  /// **'PORUDŽBINE'**
  String get navOrders;

  /// No description provided for @navPreparing.
  ///
  /// In sr, this message translates to:
  /// **'U PRIPREMI'**
  String get navPreparing;

  /// No description provided for @navReservations.
  ///
  /// In sr, this message translates to:
  /// **'REZERVACIJE'**
  String get navReservations;

  /// No description provided for @navMenu.
  ///
  /// In sr, this message translates to:
  /// **'JELOVNIK'**
  String get navMenu;

  /// No description provided for @navProfile.
  ///
  /// In sr, this message translates to:
  /// **'PROFIL'**
  String get navProfile;

  /// No description provided for @ordersTitle.
  ///
  /// In sr, this message translates to:
  /// **'Porudžbine'**
  String get ordersTitle;

  /// No description provided for @ordersCount.
  ///
  /// In sr, this message translates to:
  /// **'{count} porudžbine'**
  String ordersCount(int count);

  /// No description provided for @ordersCountSuffix.
  ///
  /// In sr, this message translates to:
  /// **' porudžbine'**
  String get ordersCountSuffix;

  /// No description provided for @orderTableNumber.
  ///
  /// In sr, this message translates to:
  /// **'Sto broj {number}'**
  String orderTableNumber(int number);

  /// No description provided for @orderDishCount.
  ///
  /// In sr, this message translates to:
  /// **'Broj jela: {count}'**
  String orderDishCount(int count);

  /// No description provided for @orderDrinksCount.
  ///
  /// In sr, this message translates to:
  /// **'Broj pića: {count}'**
  String orderDrinksCount(int count);

  /// No description provided for @orderSeeDetails.
  ///
  /// In sr, this message translates to:
  /// **'VIDI DETALJE'**
  String get orderSeeDetails;

  /// No description provided for @orderTimeAgoDays.
  ///
  /// In sr, this message translates to:
  /// **'Pre {count} dan'**
  String orderTimeAgoDays(int count);

  /// No description provided for @orderTimeAgoHoursMinutes.
  ///
  /// In sr, this message translates to:
  /// **'Pre {hours}h {minutes}min'**
  String orderTimeAgoHoursMinutes(int hours, int minutes);

  /// No description provided for @orderTimeAgoHours.
  ///
  /// In sr, this message translates to:
  /// **'Pre {count} sat'**
  String orderTimeAgoHours(int count);

  /// No description provided for @orderTimeAgoMinutes.
  ///
  /// In sr, this message translates to:
  /// **'Pre {count} minuta'**
  String orderTimeAgoMinutes(int count);

  /// No description provided for @orderTimeAgoSeconds.
  ///
  /// In sr, this message translates to:
  /// **'Pre {count} sekundi'**
  String orderTimeAgoSeconds(int count);

  /// No description provided for @orderRejectAll.
  ///
  /// In sr, this message translates to:
  /// **'ODBIJ SVE'**
  String get orderRejectAll;

  /// No description provided for @orderAccept.
  ///
  /// In sr, this message translates to:
  /// **'PRIHVATI'**
  String get orderAccept;

  /// No description provided for @orderProcessingComplete.
  ///
  /// In sr, this message translates to:
  /// **'Završena obrada porudžbine \"{orderNumber}\"'**
  String orderProcessingComplete(String orderNumber);

  /// No description provided for @timeEstimationTitle.
  ///
  /// In sr, this message translates to:
  /// **'Procjena vremena'**
  String get timeEstimationTitle;

  /// No description provided for @timeEstimationQuestion.
  ///
  /// In sr, this message translates to:
  /// **'Za koliko vremena će ova porudžbina biti spremna?'**
  String get timeEstimationQuestion;

  /// No description provided for @timeEstimationSkip.
  ///
  /// In sr, this message translates to:
  /// **'PRESKOČI PROCENU'**
  String get timeEstimationSkip;

  /// No description provided for @timeEstimationConfirm.
  ///
  /// In sr, this message translates to:
  /// **'POTVRDI VREME'**
  String get timeEstimationConfirm;

  /// No description provided for @reservationsTitle.
  ///
  /// In sr, this message translates to:
  /// **'Rezervacije'**
  String get reservationsTitle;

  /// No description provided for @reservationsSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Upravljajte rezervacijama stolova'**
  String get reservationsSubtitle;

  /// No description provided for @preparingTitle.
  ///
  /// In sr, this message translates to:
  /// **'U pripremi'**
  String get preparingTitle;

  /// No description provided for @preparingSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Stavke u pripremi'**
  String get preparingSubtitle;

  /// No description provided for @preparingDishCount.
  ///
  /// In sr, this message translates to:
  /// **'{count} jela'**
  String preparingDishCount(int count);

  /// No description provided for @preparingDishCountSuffix.
  ///
  /// In sr, this message translates to:
  /// **' jela'**
  String get preparingDishCountSuffix;

  /// No description provided for @preparingDrinksCountSuffix.
  ///
  /// In sr, this message translates to:
  /// **' pića'**
  String get preparingDrinksCountSuffix;

  /// No description provided for @preparingMarkAsReady.
  ///
  /// In sr, this message translates to:
  /// **'OZNAČI KAO GOTOVO'**
  String get preparingMarkAsReady;

  /// No description provided for @preparingMarkAsReadySuccess.
  ///
  /// In sr, this message translates to:
  /// **'Porudžbina označena kao gotova'**
  String get preparingMarkAsReadySuccess;

  /// No description provided for @preparingMarkAsReadyError.
  ///
  /// In sr, this message translates to:
  /// **'Greška pri označavanju'**
  String get preparingMarkAsReadyError;

  /// No description provided for @menuTitle.
  ///
  /// In sr, this message translates to:
  /// **'Jelovnik'**
  String get menuTitle;

  /// No description provided for @menuSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Pregledajte stavke jelovnika'**
  String get menuSubtitle;

  /// No description provided for @menuInstruction.
  ///
  /// In sr, this message translates to:
  /// **'Označi kada je neko jelo dostupno ili nedostupno'**
  String get menuInstruction;

  /// No description provided for @menuSearchHint.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži jelo...'**
  String get menuSearchHint;

  /// No description provided for @menuAvailableCount.
  ///
  /// In sr, this message translates to:
  /// **'{available} dostupnih od ukupno {total}'**
  String menuAvailableCount(int available, int total);

  /// No description provided for @menuAvailableCountMiddle.
  ///
  /// In sr, this message translates to:
  /// **' dostupnih od ukupno '**
  String get menuAvailableCountMiddle;

  /// No description provided for @profileTypeWaiter.
  ///
  /// In sr, this message translates to:
  /// **'Konobar'**
  String get profileTypeWaiter;

  /// No description provided for @profileTypeKitchen.
  ///
  /// In sr, this message translates to:
  /// **'Kuhinja'**
  String get profileTypeKitchen;

  /// No description provided for @profileTypeBar.
  ///
  /// In sr, this message translates to:
  /// **'Šank'**
  String get profileTypeBar;

  /// No description provided for @authLoginFailed.
  ///
  /// In sr, this message translates to:
  /// **'Prijava nije uspela.'**
  String get authLoginFailed;

  /// No description provided for @authInvalidResponse.
  ///
  /// In sr, this message translates to:
  /// **'Neispravan odgovor servera.'**
  String get authInvalidResponse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
