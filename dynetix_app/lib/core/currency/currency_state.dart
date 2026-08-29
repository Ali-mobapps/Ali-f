import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final String code; // 'PKR' or 'USD'
  final double rate; // 1 USD = rate PKR (e.g. 280)
  final String symbol;

  const CurrencyState({required this.code, required this.rate, required this.symbol});

  @override
  List<Object?> get props => [code, rate, symbol];
}
