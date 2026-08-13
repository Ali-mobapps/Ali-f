import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../bloc/payment_cubit.dart';
import '../bloc/payment_state.dart';

class PaymentScreen extends StatelessWidget {
  final bool isAdmin;

  final List<Map<String, String>> defaultPayments = const [
    {"name": "Easypaisa", "number": "03451495330", "icon": "assets/images/easypaisa.png"},
    {"name": "JazzCash", "number": "03087249533", "icon": "assets/images/jazzcash.png"},
    {"name": "HBL Bank", "number": "16277900607203", "icon": "assets/images/hbl.png"},
    {"name": "NAYAPAY", "number": "03156717093", "icon": "assets/images/nayapay.png"},
    {"name": "SADAPAY", "number": "03156717093", "icon": "assets/images/sadapay.png"},
  ];

  const PaymentScreen({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    context.read<PaymentCubit>().fetchPaymentMethods();

    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: VIPTheme.darkBackground,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Secure Payments', style: TextStyle(color: VIPTheme.primaryGold, fontWeight: FontWeight.bold)),
                  background: Container(color: VIPTheme.darkBackground),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Elite Payment Gateways',
                        style: TextStyle(color: VIPTheme.primaryGold, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Copy the account number and pay via your preferred app.',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _buildPaymentList(context, state),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Note: After successful payment, please share the screenshot with our admin team via chat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentList(BuildContext context, PaymentState state) {
    if (state is PaymentLoading) {
      return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
    } else if (state is PaymentLoaded && state.payments.isNotEmpty) {
      final methods = state.payments.where((m) => m.isActive).toList();
      return Column(
        children: methods.map((m) => _buildPaymentCard(context, m.name, m.accountNumber, null)).toList(),
      );
    }
    
    // Fallback to default payments if no dynamic data
    return Column(
      children: defaultPayments.map((item) => _buildPaymentCard(context, item["name"]!, item["number"]!, item["icon"])).toList(),
    );
  }

  Widget _buildPaymentCard(BuildContext context, String name, String number, String? iconPath) {
    Color methodColor = VIPTheme.primaryGold;
    if (name.toLowerCase().contains('easypaisa')) methodColor = Colors.green;
    if (name.toLowerCase().contains('jazzcash')) methodColor = Colors.red;
    if (name.toLowerCase().contains('hbl')) methodColor = const Color(0xFF006B62);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: methodColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: iconPath != null 
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(iconPath, errorBuilder: (_, __, ___) => Icon(Icons.account_balance, color: methodColor)),
              )
            : Icon(Icons.account_balance, color: methodColor),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text('Dynetix Official', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(number, style: const TextStyle(fontSize: 16, color: VIPTheme.primaryGold, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy_rounded, color: VIPTheme.primaryGold),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: number));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name number copied!'),
                backgroundColor: methodColor.withValues(alpha: 0.8),
              ),
            );
          },
        ),
      ),
    );
  }
}
