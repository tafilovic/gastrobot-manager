// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'GastroBot Manager';

  @override
  String get loginSubtitle => 'Войдите, чтобы продолжить';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'напр. user@example.com';

  @override
  String get loginEmailRequired => 'Введите email';

  @override
  String get loginEmailInvalid => 'Введите корректный email';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginPasswordRequired => 'Введите пароль';

  @override
  String get loginRememberEmail => 'Запомнить email';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginFailed => 'Ошибка входа. Попробуйте снова.';

  @override
  String get loginRoleNotSupported =>
      'Ваша роль не поддерживается. Это приложение для официантов, поваров и барменов.';

  @override
  String get profileTitle => 'Мой профиль';

  @override
  String get profileLabelName => 'ИМЯ';

  @override
  String get profileLabelEmail => 'EMAIL';

  @override
  String get profileLabelPassword => 'ПАРОЛЬ';

  @override
  String get profileChangePassword => 'Изменить';

  @override
  String get profileReservationReminder => 'НАПОМИНАНИЕ О БРОНИРОВАНИИ';

  @override
  String get profileReservationReminderHint =>
      '*За сколько вы получаете уведомления о подготовке предзаказа';

  @override
  String get profileReservationReminderValue => 'За 1 час';

  @override
  String get profileLabelLanguage => 'ЯЗЫК';

  @override
  String get profileLanguageValue => 'Русский';

  @override
  String get profileDrinksList => 'СПИСОК НАПИТКОВ';

  @override
  String get profileLogout => 'ВЫЙТИ';

  @override
  String get profileImageDialogTitle => 'Фото профиля';

  @override
  String get profileImageUploadButton => 'ЗАГРУЗИТЬ ФОТО';

  @override
  String get profileImageMaxSize => '3 МБ (максимальный размер)';

  @override
  String get profileImageSaveChanges => 'СОХРАНИТЬ';

  @override
  String get logoutDialogTitle => 'Выход';

  @override
  String get logoutDialogMessage => 'Вы уверены, что хотите выйти?';

  @override
  String get logoutCancel => 'Отмена';

  @override
  String get logoutConfirm => 'Выйти';

  @override
  String get navOrders => 'ЗАКАЗЫ';

  @override
  String get navReady => 'ГОТОВО';

  @override
  String get navPreparing => 'В ПОДГОТОВКЕ';

  @override
  String get navReservations => 'БРОНИРОВАНИЯ';

  @override
  String get navMenu => 'МЕНЮ';

  @override
  String get navDrinks => 'НАПИТКИ';

  @override
  String get navTables => 'СТОЛЫ';

  @override
  String get tablesReserve => 'ЗАБРОНИРОВАТЬ';

  @override
  String get tablesOrder => '+ ЗАКАЗАТЬ';

  @override
  String tablesCount(int count) {
    return '$count столов';
  }

  @override
  String tableNumber(String number) {
    return 'Стол №$number';
  }

  @override
  String get tableReservationAt => 'Бронирование:';

  @override
  String get tableTypeTable => 'Стол';

  @override
  String get tableTypeRoom => 'В помещении';

  @override
  String get tableTypeSunbed => 'Шезлонг';

  @override
  String get navProfile => 'ПРОФИЛЬ';

  @override
  String get readyTitle => 'Готово к подаче';

  @override
  String get readySubtitle => 'Заказы готовы к подаче';

  @override
  String get readyOrdersCountSuffix => ' готовых заказов';

  @override
  String get readyMarkAsServed => 'ОТМЕТИТЬ ПОДАННЫМ';

  @override
  String get readyMarkAsDelivered => 'ОТМЕТИТЬ ДОСТАВЛЕННЫМ';

  @override
  String get readySectionFood => 'ЕДА';

  @override
  String get readySectionDrinks => 'НАПИТКИ';

  @override
  String get readyMarkAsServedSuccess => 'Заказ отмечен как поданный';

  @override
  String get readyMarkAsServedError => 'Не удалось отметить как поданный';

  @override
  String get ordersTitle => 'Заказы';

  @override
  String ordersCount(int count) {
    return '$count заказов';
  }

  @override
  String get ordersCountSuffix => ' заказов';

  @override
  String get ordersTabActive => 'Активные';

  @override
  String get ordersTabHistory => 'История';

  @override
  String get ordersFilters => 'ФИЛЬТРЫ';

  @override
  String get ordersOrderButton => 'ЗАКАЗАТЬ';

  @override
  String get ordersFoodLabel => 'Еда:';

  @override
  String get ordersDrinksLabel => 'Напитки:';

  @override
  String get orderStatusPending => 'ОЖИДАЕТ';

  @override
  String get orderStatusInPreparation => 'В ПОДГОТОВКЕ';

  @override
  String get orderStatusServed => 'ПОДАН';

  @override
  String get orderStatusRejected => 'ОТКЛОНЁН';

  @override
  String get orderBill => 'Счёт:';

  @override
  String orderTableNumber(int number) {
    return 'Стол № $number';
  }

  @override
  String orderDishCount(int count) {
    return 'Количество блюд: $count';
  }

  @override
  String orderDrinksCount(int count) {
    return 'Количество напитков: $count';
  }

  @override
  String get orderSeeDetails => 'ПОДРОБНЕЕ';

  @override
  String orderTimeAgoDays(int count) {
    return '$count дн. назад';
  }

  @override
  String orderTimeAgoHoursMinutes(int hours, int minutes) {
    return '$hoursч $minutesмин назад';
  }

  @override
  String orderTimeAgoHours(int count) {
    return '$count ч назад';
  }

  @override
  String orderTimeAgoMinutes(int count) {
    return '$count мин назад';
  }

  @override
  String orderTimeAgoSeconds(int count) {
    return '$count сек назад';
  }

  @override
  String get orderRejectAll => 'ОТКЛОНИТЬ ВСЁ';

  @override
  String get orderAccept => 'ПРИНЯТЬ';

  @override
  String get orderMarkAsPaid => 'ОТМЕТИТЬ ОПЛАЧЕННЫМ';

  @override
  String get orderMarkAsPaidConfirmTitle => 'Отметить оплаченным';

  @override
  String get orderMarkAsPaidConfirmMessage =>
      'Вы уверены, что хотите выполнить это действие?';

  @override
  String get dialogYes => 'Да';

  @override
  String get dialogNo => 'Нет';

  @override
  String get orderMarkAsPaidError => 'Не удалось отметить заказ оплаченным';

  @override
  String get orderMarkAsPaidSuccess => 'Заказ отмечен как оплаченный';

  @override
  String get ordersHistoryEmpty => 'В истории пока нет заказов';

  @override
  String get orderPaidLabel => 'ОПЛАЧЕНО';

  @override
  String orderPaidAt(String dateTime) {
    return 'Оплачено $dateTime';
  }

  @override
  String orderProcessingComplete(String orderNumber) {
    return 'Обработка заказа \"$orderNumber\" завершена';
  }

  @override
  String get timeEstimationTitle => 'Оценка времени';

  @override
  String get timeEstimationQuestion => 'Через сколько будет готов этот заказ?';

  @override
  String get timeEstimationSkip => 'ПРОПУСТИТЬ ОЦЕНКУ';

  @override
  String get timeEstimationConfirm => 'ПОДТВЕРДИТЬ ВРЕМЯ';

  @override
  String get reservationsTitle => 'Бронирования';

  @override
  String get reservationsSubtitle => 'Управление бронированием столов';

  @override
  String get reservationsRequestsTitle => 'Бронирования';

  @override
  String get reservationsTabRequests => 'Запросы';

  @override
  String get reservationsTabAccepted => 'Принятые';

  @override
  String get reservationToday => 'Сегодня';

  @override
  String reservationCountDrinks(int count) {
    return '$count напитков';
  }

  @override
  String reservationCountDishes(int count) {
    return '$count блюд';
  }

  @override
  String reservationCountList(int count) {
    return '$count бронирований';
  }

  @override
  String get reservationLabelTime => 'Время:';

  @override
  String get reservationLabelRegion => 'Зона:';

  @override
  String get reservationLabelPartySize => 'Гостей:';

  @override
  String get preparingTitle => 'В подготовке';

  @override
  String get preparingSubtitle => 'Позиции в подготовке';

  @override
  String preparingDishCount(int count) {
    return '$count блюд';
  }

  @override
  String get preparingDishCountSuffix => ' блюд';

  @override
  String get preparingDrinksCountSuffix => ' напитков';

  @override
  String get preparingMarkAsReady => 'ОТМЕТИТЬ ГОТОВЫМ';

  @override
  String get preparingMarkAsReadySuccess => 'Заказ отмечен как готовый';

  @override
  String get preparingMarkAsReadyError => 'Не удалось отметить как готовый';

  @override
  String get menuTitle => 'Меню';

  @override
  String get menuSubtitle => 'Просмотр позиций меню';

  @override
  String get menuInstruction =>
      'Отмечайте, когда блюдо или напиток доступен или недоступен';

  @override
  String get menuSearchHint => 'Поиск блюда...';

  @override
  String menuAvailableCount(int available, int total) {
    return '$available доступно из $total';
  }

  @override
  String get menuAvailableCountMiddle => ' доступно из ';

  @override
  String get drinksListTitle => 'Список напитков';

  @override
  String get drinksListInstruction =>
      'Отмечайте, когда напиток доступен или недоступен';

  @override
  String get drinksAvailableCountSuffix => ' доступных напитков';

  @override
  String get menuSearchHintDrinks => 'Поиск напитка...';

  @override
  String get profileTypeWaiter => 'Официант';

  @override
  String get profileTypeKitchen => 'Кухня';

  @override
  String get profileTypeBar => 'Бар';

  @override
  String get authLoginFailed => 'Ошибка входа.';

  @override
  String get authInvalidResponse => 'Некорректный ответ сервера.';

  @override
  String get filterTitle => 'Фильтры';

  @override
  String get filterTableNumber => 'Номер стола:';

  @override
  String get filterFood => 'Еда:';

  @override
  String get filterDrinks => 'Напитки:';

  @override
  String get filterBillAmount => 'Сумма счёта:';

  @override
  String get filterStatusPending => 'Ожидает ?';

  @override
  String get filterStatusInPreparation => 'В подготовке ⏱';

  @override
  String get filterStatusServed => 'Подан ✔';

  @override
  String get filterStatusRejected => 'Отклонён ✖';

  @override
  String get filterReset => 'СБРОСИТЬ ФИЛЬТРЫ';

  @override
  String get filterApply => 'ПРИМЕНИТЬ';

  @override
  String filterBillRSD(String min, String max) {
    return '$min - $max RSD';
  }

  @override
  String get filterDate => 'Дата:';

  @override
  String get filterDateFrom => 'С:';

  @override
  String get filterDateTo => 'По:';

  @override
  String get filterDateToday => 'Сегодня';

  @override
  String get filterOrderContent => 'Содержимое заказа:';

  @override
  String get filterOrderContentDrinks => 'Напитки';

  @override
  String get filterOrderContentFood => 'Еда';

  @override
  String get acceptSheetTitle => 'Завершить подтверждение';

  @override
  String get acceptSheetSelectRegion => 'Выберите зону ресторана';

  @override
  String get acceptSheetSelectTable => 'Выберите номер стола';

  @override
  String get acceptSheetNoteHint =>
      'Добавить заметку для гостя... (необязательно)';

  @override
  String get acceptSheetConfirm => 'ПОДТВЕРДИТЬ БРОНИРОВАНИЕ';

  @override
  String get acceptSheetNoTables => 'Нет доступных столов.';

  @override
  String get acceptSheetErrorGeneric =>
      'Невозможно принять бронирование. Попробуйте ещё раз.';

  @override
  String acceptSheetRegionLabel(int number) {
    return 'Зона $number';
  }

  @override
  String acceptSheetReservationAt(String time) {
    return 'Бронирование в $time';
  }
}
