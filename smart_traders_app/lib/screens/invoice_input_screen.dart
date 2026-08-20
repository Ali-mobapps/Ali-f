import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/invoice.dart';
import 'invoice_preview_screen.dart';

class InvoiceInputScreen extends StatefulWidget {
  const InvoiceInputScreen({super.key});

  @override
  State<InvoiceInputScreen> createState() => _InvoiceInputScreenState();
}

class _InvoiceInputScreenState extends State<InvoiceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _serialNoController = TextEditingController();
  final _invoiceNoController = TextEditingController();
  final _dcNoController = TextEditingController();
  final _orderNoController = TextEditingController();
  final _dcNo2Controller = TextEditingController();
  final _clientNameController = TextEditingController();
  final _invoicedToController = TextEditingController(text: 'Same');
  final _addressController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  
  DateTime _selectedDate = DateTime.now();
  final List<InvoiceItem> _items = [];

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(
        productName: '',
        packing: '',
        qty: '',
        bonus: '',
        unitRate: 0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('CREATE INVOICE', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildVIPCard(
                  title: 'BASIC INFORMATION',
                  icon: Icons.info_outline,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildField('SERIAL NO', _serialNoController, Icons.numbers)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildField('INVOICE #', _invoiceNoController, Icons.receipt)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildField('DC NO', _dcNoController, Icons.local_shipping)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDatePicker()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildVIPCard(
                  title: 'CLIENT DETAILS',
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      _buildField('DELIVERED TO', _clientNameController, Icons.business),
                      const SizedBox(height: 16),
                      _buildField('ADDRESS', _addressController, Icons.location_on_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DISPATCH ITEMS', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF1E3A8A))),
                    ElevatedButton.icon(
                      onPressed: _addItem, 
                      icon: const Icon(Icons.add_shopping_cart, size: 18), 
                      label: const Text('ADD'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._items.asMap().entries.map((entry) => _buildItemCard(entry.key, entry.value)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
                  ),
                  child: Column(
                    children: [
                      _summaryRow('GROSS TOTAL', _items.fold(0.0, (sum, i) => sum + i.amount).toStringAsFixed(0)),
                      const Divider(color: Colors.white24, height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() && _items.isNotEmpty) {
                            final invoice = Invoice(
                              serialNo: _serialNoController.text,
                              invoiceNo: _invoiceNoController.text,
                              dcNo: _dcNoController.text,
                              date: _selectedDate,
                              clientName: _clientNameController.text,
                              address: _addressController.text,
                              items: _items,
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePreviewScreen(invoice: invoice)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC41E3A),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text('PREVIEW & GENERATE', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVIPCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey, letterSpacing: 1)),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        labelStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildItemCard(int index, InvoiceItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: _buildSmallField('Product Name', (v) => _updateItem(index, productName: v))),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallField('Packing', (v) => _updateItem(index, packing: v))),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => setState(() => _items.removeAt(index))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildSmallField('Qty', (v) => _updateItem(index, qty: v))),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallField('Rate', (v) => _updateItem(index, unitRate: double.tryParse(v) ?? 0), isNumber: true)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(item.amount.toStringAsFixed(0), style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallField(String label, Function(String) onChanged, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
        const SizedBox(height: 4),
        TextFormField(
          onChanged: onChanged,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(_selectedDate), style: const TextStyle(fontSize: 14)),
            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1E3A8A)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        Text('Rs. $value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
      ],
    );
  }

  void _updateItem(int index, {String? productName, String? packing, String? qty, double? unitRate}) {
    setState(() {
      final old = _items[index];
      _items[index] = InvoiceItem(
        productName: productName ?? old.productName,
        packing: packing ?? old.packing,
        qty: qty ?? old.qty,
        unitRate: unitRate ?? old.unitRate,
      );
    });
  }
}
