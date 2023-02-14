/// Exception that occurs when there is no empty space in the table users want to reserve.
class FullTable implements Exception {
  const FullTable(String this.message);
  final String? message;
}

/// Exception that occurs when users try to reserve without selecting table.
class NoSelectedTable implements Exception {
  const NoSelectedTable(String this.message);
  final String? message;
}

/// Exception that occurs when there is no reservation that users try to load
class NoSuchReservation implements Exception {
  const NoSuchReservation(String this.message);
  final String? message;
}
