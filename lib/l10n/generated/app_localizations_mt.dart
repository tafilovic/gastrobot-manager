// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Maltese (`mt`).
class AppLocalizationsMt extends AppLocalizations {
  AppLocalizationsMt([String locale = 'mt']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Idħol biex tkompli';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'eż. user@example.com';

  @override
  String get loginEmailRequired => 'Daħħal l-email';

  @override
  String get loginEmailInvalid => 'Daħħal email validu';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Daħħal il-password';

  @override
  String get loginRememberEmail => 'Ftakar l-email';

  @override
  String get loginButton => 'Idħol';

  @override
  String get loginFailed => 'Id-dħul falla. Erġa\' pprova.';

  @override
  String get loginRoleNotSupported =>
      'Ir-rwol tiegħek mhux appoġġjat. Din l-app hija għall-kelliema, iċ-ċkejken u l-barman.';

  @override
  String get loginRegisterButton => 'Irreġistra';

  @override
  String get registerTitle => 'Oħloq kont';

  @override
  String get registerFirstnameLabel => 'Isem';

  @override
  String get registerLastnameLabel => 'Kunjom';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordConfirmLabel => 'Ikkonferma l-password';

  @override
  String get registerPasswordMismatch => 'Il-passwords mhumiex l-istess';

  @override
  String get registerFieldRequired => 'Dan il-qasam huwa meħtieġ';

  @override
  String get registerSubmitButton => 'Irreġistra';

  @override
  String get registerSuccessTitle => 'Reġistrazzjoni b\'suċċess';

  @override
  String registerSuccessMessage(String email) {
    return 'Link ta\' verifika ntbagħat lil $email. Jekk jogħġbok iftaħ l-email u kklikkja fuq il-link biex tivverifika u tattiva l-kont. Imbagħad tista\' tidħol fl-app.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric => 'Xi ħaġa marret ħażin. Erġa\' pprova.';

  @override
  String get registerBackToLogin => 'Lura għad-dħul';

  @override
  String get profileTitle => 'Il-profil tiegħi';

  @override
  String get profileLabelName => 'ISEM';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'PASSWORD';

  @override
  String get profileChangePassword => 'Ibdel';

  @override
  String get profileReservationReminder => 'TFAKKIRA TAR-RIŻERVAZZJONI';

  @override
  String get profileReservationReminderHint =>
      '*Kemm qabel tirċievi notifiki biex tipprepara ikel minn qabel';

  @override
  String get profileReservationReminderValue => '1 siegħa qabel';

  @override
  String get profileLabelLanguage => 'LINGWA';

  @override
  String get profileDeleteAccount => 'ĦASSAR IL-KONT';

  @override
  String get profileDeleteAccountAction => 'Ikklikkja biex tħassar';

  @override
  String get profileDeleteAccountWarning =>
      'Jekk tħassar il-profil tiegħek, ma jistax jiġi restawrut.';

  @override
  String get profileLabelCurrency => 'MUNITA';

  @override
  String get profileLanguageValue => 'Malti';

  @override
  String get profileDrinksList => 'LISTA TAX-XORB';

  @override
  String get profileShiftScheduleLabel => 'SKEDA TAL-VARDJI';

  @override
  String get profileShiftScheduleView => 'Ara';

  @override
  String get shiftScheduleDialogTitle => 'Skeda tal-vardji';

  @override
  String get shiftScheduleLoadError => 'Ma stajtx nilħaq l-iskeda.';

  @override
  String get shiftScheduleEmpty => 'L-ebda dejta tal-iskeda.';

  @override
  String get shiftScheduleRetry => 'Erġa\' pprova';

  @override
  String get shiftScheduleSelfLabel => 'Jien';

  @override
  String get profileLogout => 'OĦROĠ';

  @override
  String get profileImageDialogTitle => 'Ritratt tal-profil';

  @override
  String get profileImageUploadButton => 'ITTELLA\' RITRATT';

  @override
  String get profileImageMaxSize => '3MB (daqs massimu tal-immaġni)';

  @override
  String get profileImageSaveChanges => 'ISSEJVJA L-BIDLIET';

  @override
  String get logoutDialogTitle => 'Oħroġ';

  @override
  String get logoutDialogMessage => 'Int żgur li trid toħroġ?';

  @override
  String get logoutCancel => 'Annulla';

  @override
  String get logoutConfirm => 'Oħroġ';

  @override
  String get navOrders => 'ORDNIJIET';

  @override
  String get navReady => 'LEST';

  @override
  String get navPreparing => 'QED JIPPREPARA';

  @override
  String get navReservations => 'RIŻERVAZZJONIJIET';

  @override
  String get navMenu => 'MENU';

  @override
  String get navDrinks => 'XORB';

  @override
  String get navZones => 'ŻONI';

  @override
  String get tablesReserve => 'IRRIŻERVA';

  @override
  String get tablesOrder => 'ORDNA';

  @override
  String zonesCount(int count) {
    return '$count żoni';
  }

  @override
  String tableNumber(String number) {
    return 'Mejda $number';
  }

  @override
  String get tableReservationAt => 'Riżervazzjoni:';

  @override
  String get tableTypeTable => 'Mejda';

  @override
  String get tableTypeRoom => 'Kamra';

  @override
  String get tableTypeSunbed => 'Sunbed';

  @override
  String seatingNumberTable(String number) {
    return 'Mejda $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Kamra $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Sunbed $number';
  }

  @override
  String get navProfile => 'PROFIL';

  @override
  String get readyTitle => 'Lest għas-servizz';

  @override
  String get readySubtitle => 'Ordniijiet lesti biex isiru servizz';

  @override
  String get readyOrdersCountSuffix => ' ordniijiet lesti';

  @override
  String get readyMarkAsServed => 'IMMARKA BĦALA SERVUT';

  @override
  String get readyMarkAsDelivered => 'IMMARKA BĦALA MOĦDLI';

  @override
  String get readySectionFood => 'IKEL';

  @override
  String get readySectionDrinks => 'XORB';

  @override
  String get readyMarkAsServedSuccess => 'L-ordni immarkata bħala servuta';

  @override
  String get readyMarkAsServedError => 'Falliet l-immarkar';

  @override
  String get ordersTitle => 'Ordniijiet';

  @override
  String ordersCount(int count) {
    return '$count ordniijiet';
  }

  @override
  String get ordersCountSuffix => ' ordniijiet';

  @override
  String get ordersTabActive => 'Attivi';

  @override
  String get ordersTabHistory => 'Kronoloġija';

  @override
  String get ordersFilters => 'FILTRI';

  @override
  String get ordersOrderButton => 'ORDNA';

  @override
  String get ordersFoodLabel => 'Ikel:';

  @override
  String get ordersDrinksLabel => 'Xorb:';

  @override
  String get orderStatusPending => 'PENDENTI';

  @override
  String get orderStatusInPreparation => 'QED JIPPREPARA';

  @override
  String get orderStatusServed => 'SERVUT';

  @override
  String get orderStatusRejected => 'RIFJUTAT';

  @override
  String get orderBill => 'Kont:';

  @override
  String orderTableNumber(int number) {
    return 'Mejda $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Numru ta\' platti: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Numru ta\' xorb: $count';
  }

  @override
  String get orderSeeDetails => 'ARA D-DETTAJJI';

  @override
  String orderTimeAgoDays(int count) {
    return '$count jum ilu';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}min ilu';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count siegħat ilu';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count minuti ilu';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count sekondi ilu';
  }

  @override
  String get orderRejectAll => 'IRRIFJUTA KOLLHA';

  @override
  String get orderAccept => 'AĊĊETTA';

  @override
  String get orderMarkAsPaid => 'IMMARKA BĦALA ĦALLAS';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Immarka bħala ħallas';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Int żgur li trid tagħmel din l-azzjoni?';

  @override
  String get dialogYes => 'Iva';

  @override
  String get dialogNo => 'Le';

  @override
  String get orderMarkAsPaidError => 'Ma stajtx nimmarka l-ordni bħala ħallasa';

  @override
  String get orderMarkAsPaidSuccess => 'L-ordni immarkata bħala ħallasa';

  @override
  String get ordersHistoryEmpty => 'Għad m\'hemm l-ebda ordni fil-kronoloġija';

  @override
  String get orderPaidLabel => 'ĦALLAS';

  @override
  String orderPaidAt(String dateTime) {
    return 'Ħallas fi $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Ipproċessar tal-ordni \"$orderNumber\" lesta';
  }

  @override
  String get timeEstimationTitle => 'Stima tal-ħin';

  @override
  String get timeEstimationQuestion => 'Fi kemm ħin tkun lesta din l-ordni?';

  @override
  String get timeEstimationSkip => 'AQTA\' L-ISTIMA';

  @override
  String get timeEstimationConfirm => 'IKKONFERMA L-ĦIN';

  @override
  String get reservationsTitle => 'Riżervazzjonijiet';

  @override
  String get reservationsSubtitle => 'Immaniġġja r-riżervazzjonijiet tal-mejda';

  @override
  String get reservationsRequestsTitle => 'Riżervazzjonijiet';

  @override
  String get reservationsTabRequests => 'Talbiet';

  @override
  String get reservationsTabAccepted => 'Aċċettati';

  @override
  String get reservationToday => 'Illum';

  @override
  String reservationCountDrinks(int count) {
    return '$count xorb';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count platti';
  }

  @override
  String reservationCountList(int count) {
    return '$count riżervazzjonijiet';
  }

  @override
  String get reservationsFilters => 'FILTRI';

  @override
  String get reservationLabelTime => 'Ħin:';

  @override
  String get reservationLabelRegion => 'Reġjun:';

  @override
  String get reservationLabelPartySize => 'Numru ta\' nies:';

  @override
  String get preparingTitle => 'Qed jipprepara';

  @override
  String get preparingSubtitle => 'Oġġetti qed jippreparaw';

  @override
  String preparingDishCount(int count) {
    return '$count platti';
  }

  @override
  String get preparingDishCountSuffix => ' platti';

  @override
  String get preparingDrinksCountSuffix => ' xorb';

  @override
  String get preparingMarkAsReady => 'IMMARKA BĦALA LEST';

  @override
  String get preparingMarkAsReadySuccess => 'L-ordni immarkata bħala lesta';

  @override
  String get preparingMarkAsReadyError => 'Falliet l-immarkar';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSubtitle => 'Ibbrawżja l-oġġetti tal-menu';

  @override
  String get menuInstruction =>
      'Immarka meta platt jew xorb ikun disponibbli jew mhux';

  @override
  String get menuSearchHint => 'Fittex platt...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available disponibbli minn $total totali';
  }

  @override
  String get menuAvailableCountMiddle => ' disponibbli minn ';

  @override
  String get drinksListTitle => 'Lista tax-xorb';

  @override
  String get drinksListInstruction =>
      'Immarka meta xorb ikun disponibbli jew mhux';

  @override
  String get drinksAvailableCountSuffix => ' xorb disponibbli';

  @override
  String get menuSearchHintDrinks => 'Fittex xorb...';

  @override
  String get profileTypeWaiter => 'Kelliem';

  @override
  String get profileTypeKitchen => 'Kċina';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Id-dħul falla.';

  @override
  String get authInvalidResponse => 'Rispons invalidu mis-server.';

  @override
  String get filterTitle => 'Filtri';

  @override
  String get filterTableNumber => 'Numru tal-mejda:';

  @override
  String get filterFood => 'Ikel:';

  @override
  String get filterDrinks => 'Xorb:';

  @override
  String get filterBillAmount => 'Ammont tal-kont:';

  @override
  String get filterStatusPending => 'Pendenti ?';

  @override
  String get filterStatusInPreparation => 'Qed jipprepara ⏱';

  @override
  String get filterStatusServed => 'Servut ✔';

  @override
  String get filterStatusRejected => 'Rifjutat ✖';

  @override
  String get filterReset => 'RESETTA L-FILTRI';

  @override
  String get filterApply => 'APPLIKA L-FILTRI';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Data:';

  @override
  String get filterDateFrom => 'Minn:';

  @override
  String get filterDateTo => 'Sa:';

  @override
  String get filterDateToday => 'Illum';

  @override
  String get filterDateYesterday => 'Ilbieraħ';

  @override
  String get filterDateTomorrow => 'Għada';

  @override
  String get filterOrderContent => 'Kontenut tal-ordni:';

  @override
  String get filterOrderContentDrinks => 'Xorb';

  @override
  String get filterOrderContentFood => 'Ikel';

  @override
  String get filterPeopleCount => 'Numru ta\' nies:';

  @override
  String get filterRegion => 'Reġjun:';

  @override
  String get filterRegionIndoors => 'Ġewwa';

  @override
  String get filterRegionGarden => 'Ġnien';

  @override
  String get filterReservationContent => 'Kontenut tar-riżervazzjoni:';

  @override
  String get acceptSheetTitle => 'Ikkompleta l-konferma';

  @override
  String get acceptSheetSelectRegion => 'Agħżel ir-reġjun tar-restoran';

  @override
  String get acceptSheetSelectTable => 'Agħżel in-numru tal-mejda';

  @override
  String get acceptSheetNoteHint =>
      'Żid nota għall-mistieden... (mhux obbligatorju)';

  @override
  String get acceptSheetConfirm => 'IKKONFERMA R-RIŻERVAZZJONI';

  @override
  String get acceptSheetNoTables => 'L-ebda mejda disponibbli.';

  @override
  String get acceptSheetErrorGeneric =>
      'Ma nistax naċċetta r-riżervazzjoni. Erġa\' pprova.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Reġjun $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Riżervazzjoni fi $time';
  }

  @override
  String get confirmedResUser => 'Utent:';

  @override
  String get confirmedResTableNumber => 'Mejda:';

  @override
  String get confirmedResOccasion => 'Okkażjoni:';

  @override
  String get confirmedResOccasionBirthday => 'Għeluq sninek';

  @override
  String get confirmedResOccasionClassic => 'Klassika';

  @override
  String get confirmedResNote => 'Nota:';

  @override
  String get confirmedResMessageLabel => 'Messaġġ:';

  @override
  String get confirmedResMessageConfirmed =>
      'Ir-riżervazzjoni tiegħek hija kkonfermata. Narawk dalwaqt!';

  @override
  String confirmedResMessageConfirmedWithNote(String note) {
    return 'Ir-riżervazzjoni tiegħek hija kkonfermata. Narawk dalwaqt! Nota: $note';
  }

  @override
  String get confirmedResEditButton => 'EDITJA R-RIŻERVAZZJONI';

  @override
  String get confirmedResCancelButton => 'IKKANċELLA R-RIŻERVAZZJONI';

  @override
  String get editResDialogTitle => 'Editjar';

  @override
  String get editResNoteHint =>
      'Daħħal ir-raġunijiet u d-dettalji tal-bidla għall-mistieden... (meħtieġ)';

  @override
  String get editResConfirm => 'IKKONFERMA L-BIDLIET';

  @override
  String get cancelDialogTitle => 'Ikkanċellazzjoni';

  @override
  String get cancelReasonHint =>
      'Daħħal ir-raġuni tal-ikkanċellazzjoni (meħtieġ)';

  @override
  String get rejectDialogTitle => 'Konferma finali';

  @override
  String get rejectReasonHint => 'Daħħal spjegazzjoni (meħtieġ)';

  @override
  String get rejectErrorFallback =>
      'Ma nistax nirrifjuta r-riżervazzjoni. Erġa\' pprova.';

  @override
  String get buttonRejectReservation => 'IRRIFJUTA R-RIŻERVAZZJONI';

  @override
  String get buttonReject => 'IRRIFJUTA';

  @override
  String get buttonAccept => 'AĊĊETTA';

  @override
  String get labelFoodDrink => 'Ikel/Xorb:';

  @override
  String tableSeatCount(int count) {
    return '$count postijiet';
  }

  @override
  String get tableReservationDialogTitle => 'Riżervazzjoni';

  @override
  String get tableReservationNameHint => 'Fl-isem...';

  @override
  String get tableReservationNameRequired => 'Daħħal l-isem';

  @override
  String get tableReservationPartySizeHint => 'Numru ta\' nies';

  @override
  String get tableReservationPartySizeRequired => 'Agħżel in-numru ta\' nies';

  @override
  String get tableReservationDateHint => 'Data';

  @override
  String get tableReservationDateRequired => 'Agħżel id-data';

  @override
  String get tableReservationTimeHint => 'Ħin';

  @override
  String get tableReservationTimeRequired => 'Agħżel iż-żmien';

  @override
  String get tableReservationTableRequired => 'Agħżel il-mejda';

  @override
  String get tableReservationInternalNoteHint => 'Daħħal nota interna...';

  @override
  String get tableReservationCreateButton => 'OĦLOQ RIŻERVAZZJONI';

  @override
  String get tableOrderScreenTitle => 'Ordni Ġdida';

  @override
  String get tableOrderAiBanner =>
      'Meli • Staqsil il-bot AI tagħna għal rakkomandazzjonijiet...';

  @override
  String get billSheetTitle => 'Kont';

  @override
  String get billSheetTotal => 'TOTAL:';

  @override
  String get billSheetEmpty => 'Il-basket huwa vojt';

  @override
  String get billSheetOrderButton => 'ORDNA';

  @override
  String get tableOrderSubmitSuccess => 'L-ordni ntbagħet';

  @override
  String get tableOrderSubmitError => 'Ma stajtx nibgħat l-ordni';

  @override
  String get tableOverviewNoReservations =>
      'L-ebda riżervazzjoni attiva għal din il-mejda';

  @override
  String get tableOverviewNoOrders => 'L-ebda ordni attiva għal din il-mejda';

  @override
  String get tableOverviewMakeOrder => 'AGĦMEL ORDNI';

  @override
  String get tableOrdersFilterTypeAny => 'Kull waħda';

  @override
  String get tableOrdersFilterStatusLabel => 'Status tal-ordni:';

  @override
  String get tableOrdersFilterStatusAny => 'Kull waħda';

  @override
  String get tableOrdersFilterStatusAwaitingConfirmation =>
      'Qed jistenna konferma';

  @override
  String get tableOrdersFilterStatusPending => 'Pendenti';

  @override
  String get tableOrdersFilterStatusConfirmed => 'Ikkonfermat';

  @override
  String get tableOrdersFilterStatusRejected => 'Rifjutat';

  @override
  String get tableOrdersFilterStatusExpired => 'Skada';

  @override
  String get tableOrdersFilterStatusPaid => 'Ħallas';

  @override
  String notificationOrderForTableTitle(String table) {
    return 'Order for table $table';
  }

  @override
  String notificationOrderForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderKitchenForTableTitle(String table) {
    return 'Kitchen Order for table $table';
  }

  @override
  String notificationOrderKitchenForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderBarForTableTitle(String table) {
    return 'Bar Order for table $table';
  }

  @override
  String notificationOrderBarForTableBody(String items) {
    return '$items';
  }

  @override
  String notificationOrderRejectedTitle(String orderNumber) {
    return 'Order $orderNumber rejected';
  }

  @override
  String notificationOrderRejectedBody(String table, String rejectionNote) {
    return 'Table $table. $rejectionNote';
  }

  @override
  String notificationOrderConfirmedTitle(String orderNumber) {
    return 'Order $orderNumber confirmed';
  }

  @override
  String notificationOrderConfirmedBody(String table, String venueName) {
    return 'Table $table at $venueName';
  }

  @override
  String get notificationOrderCompletionTimeTitle => 'Order completion time';

  @override
  String notificationOrderCompletionTimeBody(String time) {
    return 'Estimated completion time: $time';
  }

  @override
  String notificationOrderItemRejectedTitle(String productName) {
    return 'Item Rejected: $productName';
  }

  @override
  String notificationOrderItemRejectedCustomerBody(String productName) {
    return 'We are sorry, but \"$productName\" is currently unavailable. It has been removed from your order bill.';
  }

  @override
  String notificationOrderItemRejectedWaiterTitle(String table) {
    return 'Item Rejected: $table';
  }

  @override
  String notificationOrderItemRejectedWaiterBody(String productName) {
    return '\"$productName\" was rejected and removed from the order.';
  }

  @override
  String notificationOrderItemEtaTitle(String table) {
    return 'ETA Set: $table';
  }

  @override
  String notificationOrderItemEtaBody(String minutes, String productName) {
    return 'Kitchen set $minutes min estimate for $productName';
  }

  @override
  String notificationOrderItemAcceptedTitle(String productName) {
    return 'Item Accepted: $productName';
  }

  @override
  String notificationOrderItemAcceptedBody(String productName) {
    return '\"$productName\" has been accepted and is being prepared.';
  }

  @override
  String get notificationReservationNewRequestTitle =>
      'New Reservation Request';

  @override
  String notificationReservationNewRequestBody(
    String people,
    String time,
    String table,
  ) {
    return '$people guests at $time. Table: $table';
  }

  @override
  String notificationReservationConfirmedTitle(String reservationNumber) {
    return 'Reservation $reservationNumber confirmed';
  }

  @override
  String notificationReservationConfirmedBody(String table, String venueName) {
    return 'Table: $table at $venueName';
  }

  @override
  String notificationReservationRejectedTitle(String reservationNumber) {
    return 'Reservation $reservationNumber rejected';
  }

  @override
  String notificationReservationRejectedBody(String reason) {
    return '$reason';
  }

  @override
  String notificationReservationCancelledTitle(String reservationNumber) {
    return 'Reservation $reservationNumber cancelled';
  }

  @override
  String notificationReservationCancelledBody(String venueName) {
    return '$venueName';
  }

  @override
  String get notificationReservationReminderTitle => 'Reservation Reminder';

  @override
  String get notificationReservationReminderBody =>
      'Your reservation is in 8 hours';

  @override
  String get notificationKitchenStartPreparationTitle =>
      'Start Preparation: Reservation Order';

  @override
  String notificationKitchenStartPreparationBody(
    String reservationNumber,
    String time,
  ) {
    return 'Time to prepare food for Reservation #$reservationNumber. Guests arrive at $time.';
  }

  @override
  String notificationFoodReadyTitle(String table) {
    return 'Food Ready: Table $table';
  }

  @override
  String notificationFoodReadyBody(String items) {
    return '$items are ready to serve.';
  }

  @override
  String notificationDrinksReadyTitle(String table) {
    return 'Drinks Ready: Table $table';
  }

  @override
  String notificationDrinksReadyBody(String items) {
    return '$items are ready at the bar.';
  }
}
