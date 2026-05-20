import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_filter_date.dart';

void main() {
  group('ConfirmedReservationsFilters', () {
    test('isEmpty is true when no criteria set', () {
      expect(ConfirmedReservationsFilters().isEmpty, isTrue);
    });

    test('trimmedReservationNumber strips hash and whitespace', () {
      final filters = ConfirmedReservationsFilters(
        reservationNumber: '  #ABC-1  ',
      );
      expect(filters.trimmedReservationNumber, 'ABC-1');
    });

    test('hasCustomDateRange is true when only dateFrom is set', () {
      final filters = ConfirmedReservationsFilters(
        dateFrom: DateTime(2026, 5, 20),
      );
      expect(filters.hasCustomDateRange, isTrue);
    });

    test('apiDateRange uses single day when only dateFrom is set', () {
      final day = DateTime(2026, 5, 20);
      final filters = ConfirmedReservationsFilters(dateFrom: day);
      final range = filters.apiDateRange;

      expect(range.from, CalendarDayBounds.startOfDay(day));
      expect(range.to, CalendarDayBounds.endOfDay(day));
    });

    test('apiDateRange swaps inverted from/to', () {
      final filters = ConfirmedReservationsFilters(
        dateFrom: DateTime(2026, 5, 25),
        dateTo: DateTime(2026, 5, 10),
      );
      final range = filters.apiDateRange;

      expect(range.from.isBefore(range.to) || range.from == range.to, isTrue);
      expect(range.from.day, 10);
      expect(range.to.day, 25);
    });

    test('copyWith clearDateRange removes both dates', () {
      final filters = ConfirmedReservationsFilters(
        dateFrom: DateTime(2026, 5, 1),
        dateTo: DateTime(2026, 5, 31),
      );
      final cleared = filters.copyWith(clearDateRange: true);
      expect(cleared.dateFrom, isNull);
      expect(cleared.dateTo, isNull);
      expect(cleared.isEmpty, isTrue);
    });
  });

  group('formatFilterDateRangeLabel', () {
    test('shows single day when from equals to', () {
      final day = DateTime(2026, 5, 20);
      final filters = ConfirmedReservationsFilters(dateFrom: day, dateTo: day);
      expect(formatFilterDateRangeLabel(filters), '20.05.2026');
    });

    test('shows range when from and to differ', () {
      final filters = ConfirmedReservationsFilters(
        dateFrom: DateTime(2026, 5, 10),
        dateTo: DateTime(2026, 5, 20),
      );
      expect(formatFilterDateRangeLabel(filters), '10.05.2026 - 20.05.2026');
    });
  });
}
