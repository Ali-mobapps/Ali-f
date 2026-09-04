import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../Screen/Widgets/Constant Data/constant.dart';
import 'currency_list.dart';
import 'currency_provider.dart';

class GlobalCurrency extends StatefulWidget {
  const GlobalCurrency({super.key, required this.isDrawer});

  final bool isDrawer;

  @override
  State<GlobalCurrency> createState() => _GlobalCurrencyState();
}

class _GlobalCurrencyState extends State<GlobalCurrency> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrencyProvider>(context, listen: false).getCurrency();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return SizedBox(
      height: 40,
      width: 152,
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        alignment: Alignment.center,
        decoration: kInputDecoration.copyWith(
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: kNutral300, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: kNutral300, width: 1),
          ),
        ),
        isExpanded: true,
        padding: EdgeInsets.zero,
        value: currencyProvider.dropdownCurrencyValue,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: widget.isDrawer ? Colors.white : const Color(0xFF585865),
        ),
        isDense: true,
        items: currencySymbols.keys.map((String items) {
          return DropdownMenuItem<String>(
            value: items,
            child: Text(
              items,
              style: kTextStyle.copyWith(color: widget.isDrawer ? Colors.white : kTitleColor, fontSize: 14.0, overflow: TextOverflow.ellipsis),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) async {
          if (newValue != null && currencySymbols.containsKey(newValue)) {
            String newCurrencySymbol = currencySymbols[newValue]!;
            await currencyProvider.setCurrency(newCurrencySymbol);
            print("Updating currency to: ${currencyProvider.currency}");
            Future.delayed(const Duration(milliseconds: 600)).then((value) => context.go('/dashboard'));
          }
        },
      ),
    );
  }
}
