import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(const CurrencyState(code: 'PKR', rate: 1.0, symbol: 'Rs.'));

  static CurrencyCubit of(BuildContext context, {bool listen = true}) => 
    listen ? context.watch<CurrencyCubit>() : context.read<CurrencyCubit>();

  void switchToUSD() {
    emit(const CurrencyState(code: 'USD', rate: 280.0, symbol: '\$'));
  }

  void switchToPKR() {
    emit(const CurrencyState(code: 'PKR', rate: 1.0, symbol: 'Rs.'));
  }

  void toggleCurrency() {
    if (state.code == 'PKR') {
      switchToUSD();
    } else {
      switchToPKR();
    }
  }

  String formatPrice(double price) {
    if (state.code == 'USD') {
      return '${state.symbol}${(price / state.rate).toStringAsFixed(2)}';
    }
    return '${state.symbol}${price.toStringAsFixed(0)}';
  }
}
