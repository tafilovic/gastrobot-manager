/// Thrown when reservations API fails.
class ReservationsException implements Exception {
  const ReservationsException(this.message);

  final String message;

  @override
  String toString() => message;
}
