// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Accedi per continuare';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'es. utente@esempio.com';

  @override
  String get loginEmailRequired => 'Inserisci email';

  @override
  String get loginEmailInvalid => 'Inserisci un\'email valida';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Inserisci password';

  @override
  String get loginRememberEmail => 'Ricorda email';

  @override
  String get loginButton => 'Accedi';

  @override
  String get loginFailed => 'Accesso fallito. Riprova.';

  @override
  String get loginRoleNotSupported =>
      'Il tuo ruolo non è supportato. Questa app è per camerieri, cuochi e baristi.';

  @override
  String get loginRegisterButton => 'Registrati';

  @override
  String get registerTitle => 'Crea account';

  @override
  String get registerFirstnameLabel => 'Nome';

  @override
  String get registerLastnameLabel => 'Cognome';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordConfirmLabel => 'Conferma password';

  @override
  String get registerPasswordMismatch => 'Le password non coincidono';

  @override
  String get registerFieldRequired => 'Campo obbligatorio';

  @override
  String get registerSubmitButton => 'Registrati';

  @override
  String get registerSuccessTitle => 'Registrazione completata';

  @override
  String registerSuccessMessage(String email) {
    return 'È stato inviato un link di verifica a $email. Apri l\'email e tocca il link per attivare l\'account. Poi potrai accedere all\'app.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric => 'Qualcosa è andato storto. Riprova.';

  @override
  String get registerBackToLogin => 'Torna al login';

  @override
  String get profileTitle => 'Il mio profilo';

  @override
  String get profileLabelName => 'NOME';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'PASSWORD';

  @override
  String get profileChangePassword => 'Modifica';

  @override
  String get profileReservationReminder => 'PROMEMORIA PRENOTAZIONI';

  @override
  String get profileReservationReminderHint =>
      '*Quanto in anticipo ricevi le notifiche per preparare cibo preordinato';

  @override
  String get profileReservationReminderValue => '1 ora prima';

  @override
  String get profileLabelLanguage => 'LINGUA';

  @override
  String get profileLabelCurrency => 'VALUTA';

  @override
  String get profileLanguageValue => 'Italiano';

  @override
  String get profileDrinksList => 'LISTA BEVANDE';

  @override
  String get profileShiftScheduleLabel => 'TURNAZIONE';

  @override
  String get profileShiftScheduleView => 'Vedi';

  @override
  String get shiftScheduleDialogTitle => 'Turnazione';

  @override
  String get shiftScheduleLoadError => 'Impossibile caricare i turni.';

  @override
  String get shiftScheduleEmpty => 'Nessun dato sui turni.';

  @override
  String get shiftScheduleRetry => 'Riprova';

  @override
  String get shiftScheduleSelfLabel => 'Io';

  @override
  String get profileLogout => 'ESCI';

  @override
  String get profileImageDialogTitle => 'Foto profilo';

  @override
  String get profileImageUploadButton => 'CARICA FOTO';

  @override
  String get profileImageMaxSize => '3MB (dimensione massima)';

  @override
  String get profileImageSaveChanges => 'SALVA MODIFICHE';

  @override
  String get logoutDialogTitle => 'Esci';

  @override
  String get logoutDialogMessage => 'Sei sicuro di voler uscire?';

  @override
  String get logoutCancel => 'Annulla';

  @override
  String get logoutConfirm => 'Esci';

  @override
  String get navOrders => 'ORDINI';

  @override
  String get navReady => 'PRONTO';

  @override
  String get navPreparing => 'IN PREPARAZIONE';

  @override
  String get navReservations => 'PRENOTAZIONI';

  @override
  String get navMenu => 'MENÙ';

  @override
  String get navDrinks => 'BEVANDE';

  @override
  String get navZones => 'ZONE';

  @override
  String get tablesReserve => 'PRENOTA';

  @override
  String get tablesOrder => 'ORDINA';

  @override
  String tablesCount(int count) {
    return '$count tavoli';
  }

  @override
  String tableNumber(String number) {
    return 'Tavolo $number';
  }

  @override
  String get tableReservationAt => 'Prenotazione:';

  @override
  String get tableTypeTable => 'Tavolo';

  @override
  String get tableTypeRoom => 'Sala';

  @override
  String get tableTypeSunbed => 'Lettino';

  @override
  String seatingNumberTable(String number) {
    return 'Tavolo $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Sala $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Lettino $number';
  }

  @override
  String get navProfile => 'PROFILO';

  @override
  String get readyTitle => 'Pronto per servire';

  @override
  String get readySubtitle => 'Ordini pronti da servire';

  @override
  String get readyOrdersCountSuffix => ' ordini pronti';

  @override
  String get readyMarkAsServed => 'SEGNALA COME SERVITO';

  @override
  String get readyMarkAsDelivered => 'SEGNALA COME CONSEGNATO';

  @override
  String get readySectionFood => 'CIBO';

  @override
  String get readySectionDrinks => 'BEVANDE';

  @override
  String get readyMarkAsServedSuccess => 'Ordine segnato come servito';

  @override
  String get readyMarkAsServedError => 'Impossibile segnare come servito';

  @override
  String get ordersTitle => 'Ordini';

  @override
  String ordersCount(int count) {
    return '$count ordini';
  }

  @override
  String get ordersCountSuffix => ' ordini';

  @override
  String get ordersTabActive => 'Attivi';

  @override
  String get ordersTabHistory => 'Cronologia';

  @override
  String get ordersFilters => 'FILTRI';

  @override
  String get ordersOrderButton => 'ORDINA';

  @override
  String get ordersFoodLabel => 'Cibo:';

  @override
  String get ordersDrinksLabel => 'Bevande:';

  @override
  String get orderStatusPending => 'IN ATTESA';

  @override
  String get orderStatusInPreparation => 'IN PREPARAZIONE';

  @override
  String get orderStatusServed => 'SERVITO';

  @override
  String get orderStatusRejected => 'RIFIUTATO';

  @override
  String get orderBill => 'Conto:';

  @override
  String orderTableNumber(int number) {
    return 'Tavolo $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Numero piatti: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Numero bevande: $count';
  }

  @override
  String get orderSeeDetails => 'VEDI DETTAGLI';

  @override
  String orderTimeAgoDays(int count) {
    return '$count giorno fa';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}min fa';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count ore fa';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count min fa';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count sec fa';
  }

  @override
  String get orderRejectAll => 'RIFIUTA TUTTO';

  @override
  String get orderAccept => 'ACCETTA';

  @override
  String get orderMarkAsPaid => 'SEGNALA COME PAGATO';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Segnala come pagato';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Sei sicuro di voler eseguire questa azione?';

  @override
  String get dialogYes => 'Sì';

  @override
  String get dialogNo => 'No';

  @override
  String get orderMarkAsPaidError =>
      'Impossibile segnare l\'ordine come pagato';

  @override
  String get orderMarkAsPaidSuccess => 'Ordine segnalato come pagato';

  @override
  String get ordersHistoryEmpty => 'Nessun ordine nella cronologia';

  @override
  String get orderPaidLabel => 'PAGATO';

  @override
  String orderPaidAt(String dateTime) {
    return 'Pagato il $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Elaborazione ordine \"$orderNumber\" completata';
  }

  @override
  String get timeEstimationTitle => 'Stima tempi';

  @override
  String get timeEstimationQuestion =>
      'In quanto tempo sarà pronto questo ordine?';

  @override
  String get timeEstimationSkip => 'SALTA STIMA';

  @override
  String get timeEstimationConfirm => 'CONFERMA TEMPO';

  @override
  String get reservationsTitle => 'Prenotazioni';

  @override
  String get reservationsSubtitle => 'Gestisci prenotazioni tavoli';

  @override
  String get reservationsRequestsTitle => 'Prenotazioni';

  @override
  String get reservationsTabRequests => 'Richieste';

  @override
  String get reservationsTabAccepted => 'Accettate';

  @override
  String get reservationToday => 'Oggi';

  @override
  String reservationCountDrinks(int count) {
    return '$count bevande';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count piatti';
  }

  @override
  String reservationCountList(int count) {
    return '$count prenotazioni';
  }

  @override
  String get reservationsFilters => 'FILTRI';

  @override
  String get reservationLabelTime => 'Ora:';

  @override
  String get reservationLabelRegion => 'Zona:';

  @override
  String get reservationLabelPartySize => 'Persone:';

  @override
  String get preparingTitle => 'In preparazione';

  @override
  String get preparingSubtitle => 'Articoli in preparazione';

  @override
  String preparingDishCount(int count) {
    return '$count piatti';
  }

  @override
  String get preparingDishCountSuffix => ' piatti';

  @override
  String get preparingDrinksCountSuffix => ' bevande';

  @override
  String get preparingMarkAsReady => 'SEGNALA COME PRONTO';

  @override
  String get preparingMarkAsReadySuccess => 'Ordine segnato come pronto';

  @override
  String get preparingMarkAsReadyError => 'Impossibile segnare come pronto';

  @override
  String get menuTitle => 'Menù';

  @override
  String get menuSubtitle => 'Sfoglia voci menù';

  @override
  String get menuInstruction =>
      'Segna quando un piatto o bevanda è disponibile o non disponibile';

  @override
  String get menuSearchHint => 'Cerca piatto...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available disponibili su $total totali';
  }

  @override
  String get menuAvailableCountMiddle => ' disponibili su ';

  @override
  String get drinksListTitle => 'Elenco bevande';

  @override
  String get drinksListInstruction =>
      'Segna quando una bevanda è disponibile o non disponibile';

  @override
  String get drinksAvailableCountSuffix => ' bevande disponibili';

  @override
  String get menuSearchHintDrinks => 'Cerca bevanda...';

  @override
  String get profileTypeWaiter => 'Cameriere';

  @override
  String get profileTypeKitchen => 'Cucina';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Accesso fallito.';

  @override
  String get authInvalidResponse => 'Risposta del server non valida.';

  @override
  String get filterTitle => 'Filtri';

  @override
  String get filterTableNumber => 'Numero tavolo:';

  @override
  String get filterFood => 'Cibo:';

  @override
  String get filterDrinks => 'Bevande:';

  @override
  String get filterBillAmount => 'Importo conto:';

  @override
  String get filterStatusPending => 'In attesa ?';

  @override
  String get filterStatusInPreparation => 'In preparazione ⏱';

  @override
  String get filterStatusServed => 'Servito ✔';

  @override
  String get filterStatusRejected => 'Rifiutato ✖';

  @override
  String get filterReset => 'AZZERA FILTRI';

  @override
  String get filterApply => 'APPLICA FILTRI';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Data:';

  @override
  String get filterDateFrom => 'Da:';

  @override
  String get filterDateTo => 'A:';

  @override
  String get filterDateToday => 'Oggi';

  @override
  String get filterDateYesterday => 'Ieri';

  @override
  String get filterDateTomorrow => 'Domani';

  @override
  String get filterOrderContent => 'Contenuto ordine:';

  @override
  String get filterOrderContentDrinks => 'Bevande';

  @override
  String get filterOrderContentFood => 'Cibo';

  @override
  String get filterPeopleCount => 'Numero di persone:';

  @override
  String get filterRegion => 'Regione:';

  @override
  String get filterRegionIndoors => 'Interno';

  @override
  String get filterRegionGarden => 'Giardino';

  @override
  String get filterReservationContent => 'Contenuto prenotazione:';

  @override
  String get acceptSheetTitle => 'Completa la conferma';

  @override
  String get acceptSheetSelectRegion => 'Seleziona zona ristorante';

  @override
  String get acceptSheetSelectTable => 'Seleziona numero tavolo';

  @override
  String get acceptSheetNoteHint =>
      'Aggiungi nota per l\'ospite... (opzionale)';

  @override
  String get acceptSheetConfirm => 'CONFERMA PRENOTAZIONE';

  @override
  String get acceptSheetNoTables => 'Nessun tavolo disponibile.';

  @override
  String get acceptSheetErrorGeneric =>
      'Impossibile accettare la prenotazione. Riprova.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Zona $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Prenotazione alle $time';
  }

  @override
  String get confirmedResUser => 'Cliente:';

  @override
  String get confirmedResTableNumber => 'Tavolo:';

  @override
  String get confirmedResOccasion => 'Occasione:';

  @override
  String get confirmedResOccasionBirthday => 'Compleanno';

  @override
  String get confirmedResOccasionClassic => 'Classica';

  @override
  String get confirmedResNote => 'Nota:';

  @override
  String get confirmedResEditButton => 'MODIFICA PRENOTAZIONE';

  @override
  String get confirmedResCancelButton => 'ANNULLA PRENOTAZIONE';

  @override
  String get editResDialogTitle => 'Modifica';

  @override
  String get editResNoteHint =>
      'Inserisci motivi e dettagli della modifica per l\'ospite... (campo obbligatorio)';

  @override
  String get editResConfirm => 'CONFERMA MODIFICHE';

  @override
  String get cancelDialogTitle => 'Cancellazione';

  @override
  String get cancelReasonHint =>
      'Inserisci il motivo della cancellazione (obbligatorio)';

  @override
  String get rejectDialogTitle => 'Conferma finale';

  @override
  String get rejectReasonHint => 'Inserisci una spiegazione (obbligatorio)';

  @override
  String get rejectErrorFallback =>
      'Impossibile rifiutare la prenotazione. Riprova.';

  @override
  String get buttonRejectReservation => 'RIFIUTA PRENOTAZIONE';

  @override
  String get buttonReject => 'RIFIUTA';

  @override
  String get buttonAccept => 'ACCETTA';

  @override
  String get labelFoodDrink => 'Cibo/Bevande:';

  @override
  String tableSeatCount(int count) {
    return '$count posti';
  }

  @override
  String get tableReservationDialogTitle => 'Prenotazione';

  @override
  String get tableReservationNameHint => 'A nome di...';

  @override
  String get tableReservationNameRequired => 'Inserisci il nome';

  @override
  String get tableReservationPartySizeHint => 'Numero di persone';

  @override
  String get tableReservationPartySizeRequired => 'Seleziona numero di persone';

  @override
  String get tableReservationDateHint => 'Data';

  @override
  String get tableReservationDateRequired => 'Seleziona data';

  @override
  String get tableReservationTimeHint => 'Ora';

  @override
  String get tableReservationTimeRequired => 'Seleziona ora';

  @override
  String get tableReservationTableRequired => 'Seleziona tavolo';

  @override
  String get tableReservationInternalNoteHint => 'Inserisci nota interna...';

  @override
  String get tableReservationCreateButton => 'CREA PRENOTAZIONE';

  @override
  String get tableOrderScreenTitle => 'Nuovo ordine';

  @override
  String get tableOrderAiBanner =>
      'Meli • Chiedi al nostro bot AI per raccomandazioni...';

  @override
  String get billSheetTitle => 'Conto';

  @override
  String get billSheetTotal => 'TOTALE:';

  @override
  String get billSheetEmpty => 'Il carrello è vuoto';

  @override
  String get billSheetOrderButton => 'ORDINA';

  @override
  String get tableOrderSubmitSuccess => 'Ordine inviato';

  @override
  String get tableOrderSubmitError => 'Impossibile inviare l\'ordine';

  @override
  String get tableOverviewNoReservations =>
      'Nessuna prenotazione attiva per questo tavolo';

  @override
  String get tableOverviewNoOrders => 'Nessun ordine attivo per questo tavolo';

  @override
  String get tableOverviewMakeOrder => 'ORDINA';

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
