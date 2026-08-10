import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_entity.dart';
import '../bloc/payment_cubit.dart';
import '../bloc/payment_state.dart';

class PaymentScreen extends StatelessWidget {
  final bool isAdmin;

  const PaymentScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    context.read<PaymentCubit>().fetchPayments();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin
            ? 'Payment Configuration & History'
            : 'Checkout / Payments'),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentLoaded) {
            if (state.payments.isEmpty) {
              return const Center(child: Text('No payment records found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final payment = state.payments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: payment.status == 'Success'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      child: Icon(
                        payment.status == 'Success'
                            ? Icons.check
                            : Icons.hourglass_empty,
                        color: payment.status == 'Success'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    title: Text(
                      payment.itemTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Amount: \$${payment.amount.toStringAsFixed(2)} • ${payment.timestamp.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Chip(
                      label: Text(
                        payment.status,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: payment.status == 'Success'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showCheckoutDialog(context),
              label: const Text('New Checkout'),
              icon: const Icon(Icons.payment),
            )
          : null,
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Simulate Checkout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Item / Service Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0.0;

                if (title.isNotEmpty && amount > 0) {
                  final newPayment = PaymentEntity(
                    id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
                    itemTitle: title,
                    amount: amount,
                    status: 'Success',
                    timestamp: DateTime.now(),
                  );

                  context.read<PaymentCubit>().makePayment(newPayment);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Pay Now'),
            ),
          ],
        );
      },
    );
  }
}
