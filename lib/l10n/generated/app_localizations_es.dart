// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

  @override
  String get loginSubtitle => 'Inicia sesión para continuar';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'ej. usuario@ejemplo.com';

  @override
  String get loginEmailRequired => 'Introduce el email';

  @override
  String get loginEmailInvalid => 'Introduce un email válido';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordRequired => 'Introduce la contraseña';

  @override
  String get loginRememberEmail => 'Recordar email';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginFailed => 'Error al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get loginRoleNotSupported =>
      'Tu rol no está soportado. Esta app es para camareros, cocineros y bartenders.';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileLabelName => 'NOMBRE';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'CONTRASEÑA';

  @override
  String get profileChangePassword => 'Cambiar';

  @override
  String get profileReservationReminder => 'RECORDATORIO DE RESERVA';

  @override
  String get profileReservationReminderHint =>
      '*Con cuánta antelación recibes avisos para preparar comida preordenada';

  @override
  String get profileReservationReminderValue => '1 hora antes';

  @override
  String get profileLabelLanguage => 'IDIOMA';

  @override
  String get profileLanguageValue => 'Español';

  @override
  String get profileLogout => 'CERRAR SESIÓN';

  @override
  String get profileImageDialogTitle => 'Foto de perfil';

  @override
  String get profileImageUploadButton => 'SUBIR FOTO';

  @override
  String get profileImageMaxSize => '3 MB (tamaño máximo)';

  @override
  String get profileImageSaveChanges => 'GUARDAR CAMBIOS';

  @override
  String get logoutDialogTitle => 'Cerrar sesión';

  @override
  String get logoutDialogMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get logoutCancel => 'Cancelar';

  @override
  String get logoutConfirm => 'Cerrar sesión';

  @override
  String get navOrders => 'PEDIDOS';

  @override
  String get navReady => 'LISTO';

  @override
  String get navPreparing => 'PREPARANDO';

  @override
  String get navReservations => 'RESERVAS';

  @override
  String get navMenu => 'MENÚ';

  @override
  String get navDrinks => 'BEBIDAS';

  @override
  String get navProfile => 'PERFIL';

  @override
  String get readyTitle => 'Listo para servir';

  @override
  String get readySubtitle => 'Pedidos listos para servir';

  @override
  String get readyOrdersCountSuffix => ' pedidos listos';

  @override
  String get readyMarkAsServed => 'MARCAR COMO SERVIDO';

  @override
  String get readyMarkAsDelivered => 'MARCAR COMO ENTREGADO';

  @override
  String get readySectionFood => 'COMIDA';

  @override
  String get readySectionDrinks => 'BEBIDAS';

  @override
  String get readyMarkAsServedSuccess => 'Pedido marcado como servido';

  @override
  String get readyMarkAsServedError => 'Error al marcar como servido';

  @override
  String get ordersTitle => 'Pedidos';

  @override
  String ordersCount(int count) {
    return '$count pedidos';
  }

  @override
  String get ordersCountSuffix => ' pedidos';

  @override
  String get ordersTabActive => 'Activos';

  @override
  String get ordersTabHistory => 'Historial';

  @override
  String get ordersFilters => 'FILTROS';

  @override
  String get ordersOrderButton => 'PEDIR';

  @override
  String get ordersFoodLabel => 'Comida:';

  @override
  String get ordersDrinksLabel => 'Bebidas:';

  @override
  String get orderStatusPending => 'PENDIENTE';

  @override
  String get orderStatusInPreparation => 'EN PREPARACIÓN';

  @override
  String get orderStatusServed => 'SERVIDO';

  @override
  String get orderStatusRejected => 'RECHAZADO';

  @override
  String get orderBill => 'Cuenta:';

  @override
  String orderTableNumber(int number) {
    return 'Mesa número $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Nº de platos: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Nº de bebidas: $count';
  }

  @override
  String get orderSeeDetails => 'VER DETALLES';

  @override
  String orderTimeAgoDays(int count) {
    return 'hace $count día';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return 'hace ${hours}h ${minutes}min';
  }

  @override
  String orderTimeAgoHours(int count) {
    return 'hace $count h';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return 'hace $count min';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return 'hace $count seg';
  }

  @override
  String get orderRejectAll => 'RECHAZAR TODO';

  @override
  String get orderAccept => 'ACEPTAR';

  @override
  String get orderMarkAsPaid => 'MARCAR COMO PAGADO';

  @override
  String get orderPaidLabel => 'PAGADO';

  @override
  String orderPaidAt(String dateTime) {
    return 'Pagado el $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Procesamiento del pedido \"$orderNumber\" completado';
  }

  @override
  String get timeEstimationTitle => 'Estimación de tiempo';

  @override
  String get timeEstimationQuestion =>
      '¿En cuánto tiempo estará listo este pedido?';

  @override
  String get timeEstimationSkip => 'OMITIR ESTIMACIÓN';

  @override
  String get timeEstimationConfirm => 'CONFIRMAR TIEMPO';

  @override
  String get reservationsTitle => 'Reservas';

  @override
  String get reservationsSubtitle => 'Gestionar reservas de mesas';

  @override
  String get reservationsRequestsTitle => 'Reservas';

  @override
  String get reservationsTabRequests => 'Solicitudes';

  @override
  String get reservationsTabAccepted => 'Aceptadas';

  @override
  String get reservationToday => 'Hoy';

  @override
  String reservationCountDrinks(int count) {
    return '$count bebidas';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count platos';
  }

  @override
  String get preparingTitle => 'Preparando';

  @override
  String get preparingSubtitle => 'Artículos en preparación';

  @override
  String preparingDishCount(int count) {
    return '$count platos';
  }

  @override
  String get preparingDishCountSuffix => ' platos';

  @override
  String get preparingDrinksCountSuffix => ' bebidas';

  @override
  String get preparingMarkAsReady => 'MARCAR COMO LISTO';

  @override
  String get preparingMarkAsReadySuccess => 'Pedido marcado como listo';

  @override
  String get preparingMarkAsReadyError => 'Error al marcar como listo';

  @override
  String get menuTitle => 'Menú';

  @override
  String get menuSubtitle => 'Ver platos del menú';

  @override
  String get menuInstruction =>
      'Marca cuando un plato o bebida esté disponible o no';

  @override
  String get menuSearchHint => 'Buscar plato...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available disponibles de $total en total';
  }

  @override
  String get menuAvailableCountMiddle => ' disponibles de ';

  @override
  String get drinksListTitle => 'Lista de bebidas';

  @override
  String get drinksListInstruction =>
      'Marca cuando una bebida esté disponible o no';

  @override
  String get drinksAvailableCountSuffix => ' bebidas disponibles';

  @override
  String get menuSearchHintDrinks => 'Buscar bebida...';

  @override
  String get profileTypeWaiter => 'Camarero';

  @override
  String get profileTypeKitchen => 'Cocina';

  @override
  String get profileTypeBar => 'Bar';

  @override
  String get authLoginFailed => 'Error al iniciar sesión.';

  @override
  String get authInvalidResponse => 'Respuesta del servidor no válida.';

  @override
  String get filterTitle => 'Filtros';

  @override
  String get filterTableNumber => 'Número de mesa:';

  @override
  String get filterFood => 'Comida:';

  @override
  String get filterDrinks => 'Bebidas:';

  @override
  String get filterBillAmount => 'Importe de la cuenta:';

  @override
  String get filterStatusPending => 'Pendiente ?';

  @override
  String get filterStatusInPreparation => 'En preparación ⏱';

  @override
  String get filterStatusServed => 'Servido ✔';

  @override
  String get filterStatusRejected => 'Rechazado ✖';

  @override
  String get filterReset => 'RESTABLECER FILTROS';

  @override
  String get filterApply => 'APLICAR FILTROS';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Fecha:';

  @override
  String get filterDateFrom => 'Desde:';

  @override
  String get filterDateTo => 'Hasta:';

  @override
  String get filterDateToday => 'Hoy';

  @override
  String get filterOrderContent => 'Contenido del pedido:';

  @override
  String get filterOrderContentDrinks => 'Bebidas';

  @override
  String get filterOrderContentFood => 'Comida';
}
