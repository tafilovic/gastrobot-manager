// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

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
  String get profileLanguageValue => 'Italiano';

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
    return 'Tavolo numero $number';
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
  String get filterOrderContent => 'Contenuto ordine:';

  @override
  String get filterOrderContentDrinks => 'Bevande';

  @override
  String get filterOrderContentFood => 'Cibo';
}
