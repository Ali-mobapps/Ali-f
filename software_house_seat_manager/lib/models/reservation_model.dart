class ReservationModel {
  final String id;
  final String studentId;
  final String seatId;
  final DateTime reservationTime;
  final bool checkedIn;
  final bool cancelled;

  ReservationModel({
    required this.id,
    required this.studentId,
    required this.seatId,
    required this.reservationTime,
    this.checkedIn = false,
    this.cancelled = false,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      studentId: json['student_id'],
      seatId: json['seat_id'],
      reservationTime: DateTime.parse(json['reservation_time']),
      checkedIn: json['checked_in'] ?? false,
      cancelled: json['cancelled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'seat_id': seatId,
      'reservation_time': reservationTime.toIso8601String(),
      'checked_in': checkedIn,
      'cancelled': cancelled,
    };
  }

  bool get isNoShow {
    final now = DateTime.now();
    return !checkedIn && !cancelled && now.isAfter(reservationTime.add(const Duration(minutes: 15)));
  }
}
