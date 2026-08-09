enum SeatStatus { available, occupied, selected, maintenance }

class SeatModel {
  final String id;
  final String row;
  final int number;
  final SeatStatus status;

  SeatModel({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });

  String get label => '$row$number';

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'],
      row: json['row'],
      number: json['number'],
      status: SeatStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => SeatStatus.available),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row': row,
      'number': number,
      'status': status.name,
    };
  }

  SeatModel copyWith({SeatStatus? status}) {
    return SeatModel(
      id: id,
      row: row,
      number: number,
      status: status ?? this.status,
    );
  }
}
