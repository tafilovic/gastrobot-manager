// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'GastroCrew';

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
  String get loginRegisterButton => 'Registrarse';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerFirstnameLabel => 'Nombre';

  @override
  String get registerLastnameLabel => 'Apellido';

  @override
  String get registerEmailLabel => 'Correo electrónico';

  @override
  String get registerPasswordConfirmLabel => 'Confirmar contraseña';

  @override
  String get registerPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerFieldRequired => 'Campo obligatorio';

  @override
  String get registerSubmitButton => 'Registrarse';

  @override
  String get registerSuccessTitle => 'Registro correcto';

  @override
  String registerSuccessMessage(String email) {
    return 'Se ha enviado un enlace de verificación a $email. Abre el correo y pulsa el enlace para activar tu cuenta. Luego podrás iniciar sesión en la app.';
  }

  @override
  String get registerSuccessOk => 'OK';

  @override
  String get registerErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get registerBackToLogin => 'Volver al inicio de sesión';

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
  String get profileDeleteAccount => 'ELIMINAR CUENTA';

  @override
  String get profileDeleteAccountAction => 'Toca para eliminar';

  @override
  String get profileDeleteAccountWarning =>
      'Si eliminas tu perfil, no se podrá restaurar.';

  @override
  String get profileLabelCurrency => 'MONEDA';

  @override
  String get profileLanguageValue => 'Español';

  @override
  String get profileDrinksList => 'LISTA DE BEBIDAS';

  @override
  String get profileShiftScheduleLabel => 'HORARIO DE TURNOS';

  @override
  String get profileShiftScheduleView => 'Ver';

  @override
  String get shiftScheduleDialogTitle => 'Horario de turnos';

  @override
  String get shiftScheduleLoadError => 'No se pudo cargar el horario.';

  @override
  String get shiftScheduleEmpty => 'Sin datos de horario.';

  @override
  String get shiftScheduleRetry => 'Reintentar';

  @override
  String get shiftScheduleSelfLabel => 'Yo';

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
  String get navZones => 'ZONAS';

  @override
  String get tablesReserve => 'RESERVAR';

  @override
  String get tablesOrder => 'PEDIR';

  @override
  String zonesCount(int count) {
    return '$count zonas';
  }

  @override
  String tableNumber(String number) {
    return 'Mesa $number';
  }

  @override
  String get tableReservationAt => 'Reserva:';

  @override
  String get tableTypeTable => 'Mesa';

  @override
  String get tableTypeRoom => 'Sala';

  @override
  String get tableTypeSunbed => 'Tumbona';

  @override
  String seatingNumberTable(String number) {
    return 'Mesa $number';
  }

  @override
  String seatingNumberRoom(String number) {
    return 'Sala $number';
  }

  @override
  String seatingNumberSunbed(String number) {
    return 'Tumbona $number';
  }

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
    return 'Mesa $number';
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
  String get orderMarkAsPaidConfirmTitle => 'Marcar como pagado';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      '¿Seguro que desea realizar esta acción?';

  @override
  String get dialogYes => 'Sí';

  @override
  String get dialogNo => 'No';

  @override
  String get orderMarkAsPaidError => 'No se pudo marcar el pedido como pagado';

  @override
  String get orderMarkAsPaidSuccess => 'Pedido marcado como pagado';

  @override
  String get ordersHistoryEmpty => 'Aún no hay pedidos en el historial';

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
  String reservationCountList(int count) {
    return '$count reservas';
  }

  @override
  String get reservationsFilters => 'FILTROS';

  @override
  String get reservationLabelTime => 'Hora:';

  @override
  String get reservationLabelRegion => 'Zona:';

  @override
  String get reservationLabelPartySize => 'Personas:';

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
  String get filterDateYesterday => 'Ayer';

  @override
  String get filterDateTomorrow => 'Mañana';

  @override
  String get filterOrderContent => 'Contenido del pedido:';

  @override
  String get filterOrderContentDrinks => 'Bebidas';

  @override
  String get filterOrderContentFood => 'Comida';

  @override
  String get filterPeopleCount => 'Número de personas:';

  @override
  String get filterRegion => 'Región:';

  @override
  String get filterRegionIndoors => 'Interior';

  @override
  String get filterRegionGarden => 'Jardín';

  @override
  String get filterReservationContent => 'Contenido de reserva:';

  @override
  String get acceptSheetTitle => 'Completar confirmación';

  @override
  String get acceptSheetSelectRegion => 'Seleccionar zona del restaurante';

  @override
  String get acceptSheetSelectTable => 'Seleccionar número de mesa';

  @override
  String get acceptSheetNoteHint =>
      'Agregar nota para el huésped... (opcional)';

  @override
  String get acceptSheetConfirm => 'CONFIRMAR RESERVA';

  @override
  String get acceptSheetNoTables => 'No hay mesas disponibles.';

  @override
  String get acceptSheetErrorGeneric =>
      'No se puede aceptar la reserva. Inténtalo de nuevo.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Zona $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Reserva a las $time';
  }

  @override
  String get confirmedResUser => 'Cliente:';

  @override
  String get confirmedResTableNumber => 'Mesa:';

  @override
  String get confirmedResOccasion => 'Ocasión:';

  @override
  String get confirmedResOccasionBirthday => 'Cumpleaños';

  @override
  String get confirmedResOccasionClassic => 'Clásica';

  @override
  String get confirmedResNote => 'Nota:';

  @override
  String get confirmedResEditButton => 'EDITAR RESERVA';

  @override
  String get confirmedResCancelButton => 'CANCELAR RESERVA';

  @override
  String get editResDialogTitle => 'Edición';

  @override
  String get editResNoteHint =>
      'Introduce motivos y detalles del cambio para el huésped... (campo obligatorio)';

  @override
  String get editResConfirm => 'CONFIRMAR CAMBIOS';

  @override
  String get cancelDialogTitle => 'Cancelación';

  @override
  String get cancelReasonHint =>
      'Introduce el motivo de la cancelación (obligatorio)';

  @override
  String get rejectDialogTitle => 'Confirmación final';

  @override
  String get rejectReasonHint => 'Introduce una explicación (obligatorio)';

  @override
  String get rejectErrorFallback =>
      'No se puede rechazar la reserva. Inténtalo de nuevo.';

  @override
  String get buttonRejectReservation => 'RECHAZAR RESERVA';

  @override
  String get buttonReject => 'RECHAZAR';

  @override
  String get buttonAccept => 'ACEPTAR';

  @override
  String get labelFoodDrink => 'Comida/Bebida:';

  @override
  String tableSeatCount(int count) {
    return '$count asientos';
  }

  @override
  String get tableReservationDialogTitle => 'Reserva';

  @override
  String get tableReservationNameHint => 'A nombre de...';

  @override
  String get tableReservationNameRequired => 'Introduce el nombre';

  @override
  String get tableReservationPartySizeHint => 'Número de personas';

  @override
  String get tableReservationPartySizeRequired =>
      'Selecciona número de personas';

  @override
  String get tableReservationDateHint => 'Fecha';

  @override
  String get tableReservationDateRequired => 'Selecciona fecha';

  @override
  String get tableReservationTimeHint => 'Hora';

  @override
  String get tableReservationTimeRequired => 'Selecciona hora';

  @override
  String get tableReservationTableRequired => 'Selecciona mesa';

  @override
  String get tableReservationInternalNoteHint => 'Introduce nota interna...';

  @override
  String get tableReservationCreateButton => 'CREAR RESERVA';

  @override
  String get tableOrderScreenTitle => 'Nuevo pedido';

  @override
  String get tableOrderAiBanner =>
      'Meli • Pregunta a nuestro bot de IA por recomendaciones...';

  @override
  String get billSheetTitle => 'Cuenta';

  @override
  String get billSheetTotal => 'TOTAL:';

  @override
  String get billSheetEmpty => 'El carrito está vacío';

  @override
  String get billSheetOrderButton => 'PEDIR';

  @override
  String get tableOrderSubmitSuccess => 'Pedido enviado';

  @override
  String get tableOrderSubmitError => 'No se pudo enviar el pedido';

  @override
  String get tableOverviewNoReservations =>
      'No hay reservas activas para esta mesa';

  @override
  String get tableOverviewNoOrders => 'No hay pedidos activos para esta mesa';

  @override
  String get tableOverviewMakeOrder => 'PEDIR';

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
