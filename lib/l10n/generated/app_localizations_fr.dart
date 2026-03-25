// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

  @override
  String get loginSubtitle => 'Connectez-vous pour continuer';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'ex. utilisateur@exemple.com';

  @override
  String get loginEmailRequired => 'Saisissez l\'e-mail';

  @override
  String get loginEmailInvalid => 'Saisissez un e-mail valide';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordRequired => 'Saisissez le mot de passe';

  @override
  String get loginRememberEmail => 'Mémoriser l\'e-mail';

  @override
  String get loginButton => 'Connexion';

  @override
  String get loginFailed => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get loginRoleNotSupported =>
      'Votre rôle n\'est pas pris en charge. Cette application est destinée aux serveurs, cuisiniers et barmans.';

  @override
  String get loginRegisterButton => 'S\'inscrire';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerFirstnameLabel => 'Prénom';

  @override
  String get registerLastnameLabel => 'Nom';

  @override
  String get registerEmailLabel => 'E-mail';

  @override
  String get registerPasswordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get registerPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get registerFieldRequired => 'Champ obligatoire';

  @override
  String get registerSubmitButton => 'S\'inscrire';

  @override
  String get registerSuccessTitle => 'Inscription réussie';

  @override
  String registerSuccessMessage(String email) {
    return 'Un lien de vérification a été envoyé à $email. Ouvrez votre messagerie et cliquez sur le lien pour activer votre compte. Vous pourrez ensuite vous connecter à l\'application.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric => 'Une erreur s\'est produite. Réessayez.';

  @override
  String get registerBackToLogin => 'Retour à la connexion';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileLabelName => 'NOM';

  @override
  String get profileLabelEmail => 'E-MAIL';

  @override
  String get profileLabelPassword => 'MOT DE PASSE';

  @override
  String get profileChangePassword => 'Modifier';

  @override
  String get profileReservationReminder => 'RAPPEL DE RÉSERVATION';

  @override
  String get profileReservationReminderHint =>
      '*À quel moment vous recevez les notifications pour préparer les plats commandés à l\'avance';

  @override
  String get profileReservationReminderValue => '1 h à l\'avance';

  @override
  String get profileLabelLanguage => 'LANGUE';

  @override
  String get profileLabelCurrency => 'DEVISE';

  @override
  String get profileLanguageValue => 'Français';

  @override
  String get profileDrinksList => 'LISTE DES BOISSONS';

  @override
  String get profileShiftScheduleLabel => 'PLANNING DES SHIFTS';

  @override
  String get profileShiftScheduleView => 'Voir';

  @override
  String get shiftScheduleDialogTitle => 'Planning des shifts';

  @override
  String get shiftScheduleLoadError => 'Impossible de charger le planning.';

  @override
  String get shiftScheduleEmpty => 'Aucune donnée de planning.';

  @override
  String get shiftScheduleRetry => 'Réessayer';

  @override
  String get shiftScheduleSelfLabel => 'Moi';

  @override
  String get profileLogout => 'DÉCONNEXION';

  @override
  String get profileImageDialogTitle => 'Photo de profil';

  @override
  String get profileImageUploadButton => 'TÉLÉVERSER UNE PHOTO';

  @override
  String get profileImageMaxSize => '3 Mo (taille maximale de l\'image)';

  @override
  String get profileImageSaveChanges => 'ENREGISTRER LES MODIFICATIONS';

  @override
  String get logoutDialogTitle => 'Déconnexion';

  @override
  String get logoutDialogMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get logoutCancel => 'Annuler';

  @override
  String get logoutConfirm => 'Se déconnecter';

  @override
  String get navOrders => 'COMMANDES';

  @override
  String get navReady => 'PRÊT';

  @override
  String get navPreparing => 'EN PRÉPARATION';

  @override
  String get navReservations => 'RÉSERVATIONS';

  @override
  String get navMenu => 'MENU';

  @override
  String get navDrinks => 'BOISSONS';

  @override
  String get navZones => 'ZONES';

  @override
  String get tablesReserve => 'RÉSERVER';

  @override
  String get tablesOrder => 'COMMANDER';

  @override
  String zonesCount(int count) {
    return '$count zones';
  }

  @override
  String tableNumber(String number) {
    return 'Table $number';
  }

  @override
  String get tableReservationAt => 'Réservation :';

  @override
  String get tableTypeTable => 'Table';

  @override
  String get tableTypeRoom => 'Salle';

  @override
  String get tableTypeSunbed => 'Transat';

  @override
  String seatingNumberTable(String number) {
    return 'Table $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Salle $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Transat $number';
  }

  @override
  String get navProfile => 'PROFIL';

  @override
  String get readyTitle => 'Prêt au service';

  @override
  String get readySubtitle => 'Commandes prêtes à être servies';

  @override
  String get readyOrdersCountSuffix => ' commandes prêtes';

  @override
  String get readyMarkAsServed => 'MARQUER COMME SERVI';

  @override
  String get readyMarkAsDelivered => 'MARQUER COMME LIVRÉ';

  @override
  String get readySectionFood => 'PLATS';

  @override
  String get readySectionDrinks => 'BOISSONS';

  @override
  String get readyMarkAsServedSuccess => 'Commande marquée comme servie';

  @override
  String get readyMarkAsServedError => 'Échec du marquage';

  @override
  String get ordersTitle => 'Commandes';

  @override
  String ordersCount(int count) {
    return '$count commandes';
  }

  @override
  String get ordersCountSuffix => ' commandes';

  @override
  String get ordersTabActive => 'Actives';

  @override
  String get ordersTabHistory => 'Historique';

  @override
  String get ordersFilters => 'FILTRES';

  @override
  String get ordersOrderButton => 'COMMANDER';

  @override
  String get ordersFoodLabel => 'Plats :';

  @override
  String get ordersDrinksLabel => 'Boissons :';

  @override
  String get orderStatusPending => 'EN ATTENTE';

  @override
  String get orderStatusInPreparation => 'EN PRÉPARATION';

  @override
  String get orderStatusServed => 'SERVI';

  @override
  String get orderStatusRejected => 'REFUSÉ';

  @override
  String get orderBill => 'Addition :';

  @override
  String orderTableNumber(int number) {
    return 'Table $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Nombre de plats : $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Nombre de boissons : $count';
  }

  @override
  String get orderSeeDetails => 'VOIR LES DÉTAILS';

  @override
  String orderTimeAgoDays(int count) {
    return 'il y a $count jour';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'il y a $hours h $minutes min';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'il y a $count h';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'il y a $count s';
  }

  @override
  String get orderRejectAll => 'TOUT REFUSER';

  @override
  String get orderAccept => 'ACCEPTER';

  @override
  String get orderMarkAsPaid => 'MARQUER COMME PAYÉ';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Marquer comme payé';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Voulez-vous vraiment effectuer cette action ?';

  @override
  String get dialogYes => 'Oui';

  @override
  String get dialogNo => 'Non';

  @override
  String get orderMarkAsPaidError =>
      'Impossible de marquer la commande comme payée';

  @override
  String get orderMarkAsPaidSuccess => 'Commande marquée comme payée';

  @override
  String get ordersHistoryEmpty => 'Aucune commande dans l\'historique';

  @override
  String get orderPaidLabel => 'PAYÉ';

  @override
  String orderPaidAt(String dateTime) {
    return 'Payé le $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Traitement de la commande « $orderNumber » terminé';
  }

  @override
  String get timeEstimationTitle => 'Estimation du temps';

  @override
  String get timeEstimationQuestion =>
      'Dans combien de temps cette commande sera-t-elle prête ?';

  @override
  String get timeEstimationSkip => 'IGNORER L\'ESTIMATION';

  @override
  String get timeEstimationConfirm => 'CONFIRMER L\'HEURE';

  @override
  String get reservationsTitle => 'Réservations';

  @override
  String get reservationsSubtitle => 'Gérer les réservations de tables';

  @override
  String get reservationsRequestsTitle => 'Réservations';

  @override
  String get reservationsTabRequests => 'Demandes';

  @override
  String get reservationsTabAccepted => 'Acceptées';

  @override
  String get reservationToday => 'Aujourd\'hui';

  @override
  String reservationCountDrinks(int count) {
    return '$count boissons';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count plats';
  }

  @override
  String reservationCountList(int count) {
    return '$count réservations';
  }

  @override
  String get reservationsFilters => 'FILTRES';

  @override
  String get reservationLabelTime => 'Heure :';

  @override
  String get reservationLabelRegion => 'Zone :';

  @override
  String get reservationLabelPartySize => 'Nombre de personnes :';

  @override
  String get preparingTitle => 'En préparation';

  @override
  String get preparingSubtitle => 'Articles en préparation';

  @override
  String preparingDishCount(int count) {
    return '$count plats';
  }

  @override
  String get preparingDishCountSuffix => ' plats';

  @override
  String get preparingDrinksCountSuffix => ' boissons';

  @override
  String get preparingMarkAsReady => 'MARQUER COMME PRÊT';

  @override
  String get preparingMarkAsReadySuccess => 'Commande marquée comme prête';

  @override
  String get preparingMarkAsReadyError => 'Échec du marquage';

  @override
  String get menuTitle => 'Carte';

  @override
  String get menuSubtitle => 'Parcourir les plats';

  @override
  String get menuInstruction =>
      'Indiquez si un plat ou une boisson est disponible ou non';

  @override
  String get menuSearchHint => 'Rechercher un plat...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available disponibles sur $total au total';
  }

  @override
  String get menuAvailableCountMiddle => ' disponibles sur ';

  @override
  String get drinksListTitle => 'Liste des boissons';

  @override
  String get drinksListInstruction =>
      'Indiquez si une boisson est disponible ou non';

  @override
  String get drinksAvailableCountSuffix => ' boissons disponibles';

  @override
  String get menuSearchHintDrinks => 'Rechercher une boisson...';

  @override
  String get profileTypeWaiter => 'Serveur';

  @override
  String get profileTypeKitchen => 'Cuisine';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Échec de la connexion.';

  @override
  String get authInvalidResponse => 'Réponse du serveur invalide.';

  @override
  String get filterTitle => 'Filtres';

  @override
  String get filterTableNumber => 'Numéro de table :';

  @override
  String get filterFood => 'Plats :';

  @override
  String get filterDrinks => 'Boissons :';

  @override
  String get filterBillAmount => 'Montant de l\'addition :';

  @override
  String get filterStatusPending => 'En attente ?';

  @override
  String get filterStatusInPreparation => 'En préparation ⏱';

  @override
  String get filterStatusServed => 'Servi ✔';

  @override
  String get filterStatusRejected => 'Refusé ✖';

  @override
  String get filterReset => 'RÉINITIALISER LES FILTRES';

  @override
  String get filterApply => 'APPLIQUER LES FILTRES';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Date :';

  @override
  String get filterDateFrom => 'Du :';

  @override
  String get filterDateTo => 'Au :';

  @override
  String get filterDateToday => 'Aujourd\'hui';

  @override
  String get filterDateYesterday => 'Hier';

  @override
  String get filterDateTomorrow => 'Demain';

  @override
  String get filterOrderContent => 'Contenu de la commande :';

  @override
  String get filterOrderContentDrinks => 'Boissons';

  @override
  String get filterOrderContentFood => 'Plats';

  @override
  String get filterPeopleCount => 'Nombre de personnes :';

  @override
  String get filterRegion => 'Zone :';

  @override
  String get filterRegionIndoors => 'Intérieur';

  @override
  String get filterRegionGarden => 'Terrasse / jardin';

  @override
  String get filterReservationContent => 'Contenu de la réservation :';

  @override
  String get acceptSheetTitle => 'Finaliser la confirmation';

  @override
  String get acceptSheetSelectRegion => 'Choisir la zone du restaurant';

  @override
  String get acceptSheetSelectTable => 'Choisir le numéro de table';

  @override
  String get acceptSheetNoteHint => 'Note pour l\'invité... (facultatif)';

  @override
  String get acceptSheetConfirm => 'CONFIRMER LA RÉSERVATION';

  @override
  String get acceptSheetNoTables => 'Aucune table disponible.';

  @override
  String get acceptSheetErrorGeneric =>
      'Impossible d\'accepter la réservation. Veuillez réessayer.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Zone $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Réservation à $time';
  }

  @override
  String get confirmedResUser => 'Client :';

  @override
  String get confirmedResTableNumber => 'Table :';

  @override
  String get confirmedResOccasion => 'Occasion :';

  @override
  String get confirmedResOccasionBirthday => 'Anniversaire';

  @override
  String get confirmedResOccasionClassic => 'Classique';

  @override
  String get confirmedResNote => 'Note :';

  @override
  String get confirmedResEditButton => 'MODIFIER LA RÉSERVATION';

  @override
  String get confirmedResCancelButton => 'ANNULER LA RÉSERVATION';

  @override
  String get editResDialogTitle => 'Modification';

  @override
  String get editResNoteHint =>
      'Indiquez les raisons et détails du changement pour l\'invité... (obligatoire)';

  @override
  String get editResConfirm => 'CONFIRMER LES MODIFICATIONS';

  @override
  String get cancelDialogTitle => 'Annulation';

  @override
  String get cancelReasonHint =>
      'Indiquez le motif d\'annulation (obligatoire)';

  @override
  String get rejectDialogTitle => 'Confirmation finale';

  @override
  String get rejectReasonHint => 'Indiquez une explication (obligatoire)';

  @override
  String get rejectErrorFallback =>
      'Impossible de refuser la réservation. Veuillez réessayer.';

  @override
  String get buttonRejectReservation => 'REFUSER LA RÉSERVATION';

  @override
  String get buttonReject => 'REFUSER';

  @override
  String get buttonAccept => 'ACCEPTER';

  @override
  String get labelFoodDrink => 'Plat / boisson :';

  @override
  String tableSeatCount(int count) {
    return '$count places';
  }

  @override
  String get tableReservationDialogTitle => 'Réservation';

  @override
  String get tableReservationNameHint => 'Au nom de...';

  @override
  String get tableReservationNameRequired => 'Saisissez le nom';

  @override
  String get tableReservationPartySizeHint => 'Nombre de personnes';

  @override
  String get tableReservationPartySizeRequired =>
      'Sélectionnez le nombre de personnes';

  @override
  String get tableReservationDateHint => 'Date';

  @override
  String get tableReservationDateRequired => 'Sélectionnez la date';

  @override
  String get tableReservationTimeHint => 'Heure';

  @override
  String get tableReservationTimeRequired => 'Sélectionnez l\'heure';

  @override
  String get tableReservationTableRequired => 'Sélectionnez la table';

  @override
  String get tableReservationInternalNoteHint => 'Note interne...';

  @override
  String get tableReservationCreateButton => 'CRÉER LA RÉSERVATION';

  @override
  String get tableOrderScreenTitle => 'Nouvelle commande';

  @override
  String get tableOrderAiBanner =>
      'Meli • Demandez des recommandations à notre bot IA...';

  @override
  String get billSheetTitle => 'Addition';

  @override
  String get billSheetTotal => 'TOTAL :';

  @override
  String get billSheetEmpty => 'Le panier est vide';

  @override
  String get billSheetOrderButton => 'COMMANDER';

  @override
  String get tableOrderSubmitSuccess => 'Commande envoyée';

  @override
  String get tableOrderSubmitError => 'Impossible d\'envoyer la commande';

  @override
  String get tableOverviewNoReservations =>
      'Aucune réservation active pour cette table';

  @override
  String get tableOverviewNoOrders => 'Aucune commande active pour cette table';

  @override
  String get tableOverviewMakeOrder => 'COMMANDER';

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
