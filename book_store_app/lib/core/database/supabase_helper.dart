import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final SupabaseClient _client = Supabase.instance.client;

  // Products / Inventory
  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _client.from('products').select().order('name');
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    await _client.from('products').insert(product);
  }

  Future<void> bulkInsertProducts(List<Map<String, dynamic>> products) async {
    await _client.from('products').insert(products);
  }

  Future<void> updateProduct(Map<String, dynamic> product) async {
    await _client.from('products').update(product).eq('id', product['id']);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // POS / Sales
  Future<void> createSale(Map<String, dynamic> sale, List<Map<String, dynamic>> items) async {
    await _client.from('sales').insert(sale);
    await _client.from('sale_items').insert(items);
  }

  // Customers / Ledger
  Future<List<Map<String, dynamic>>> getCustomers() async {
    return await _client.from('customers').select().order('name');
  }

  Future<Map<String, dynamic>> insertCustomer(Map<String, dynamic> customer) async {
    final response = await _client.from('customers').insert(customer).select().single();
    return response;
  }

  Future<void> updateCustomerBalance(String customerId, double amountChange) async {
    // Fetch current balance
    final customer = await _client.from('customers').select('total_balance').eq('id', customerId).single();
    double currentBalance = (customer['total_balance'] as num?)?.toDouble() ?? 0.0;
    
    // Update with new balance
    await _client.from('customers').update({
      'total_balance': currentBalance + amountChange
    }).eq('id', customerId);
  }

  Future<void> insertLedgerEntry(Map<String, dynamic> entry) async {
    await _client.from('ledger_entries').insert(entry);
    
    // Auto-update running balance on customer profile
    // If type is 'credit', increase balance. If 'payment', decrease balance.
    double change = (entry['amount'] as num).toDouble();
    if (entry['type'] == 'payment') change = -change;
    
    await updateCustomerBalance(entry['customer_id'], change);
  }

  Future<List<Map<String, dynamic>>> getCustomerLedgerWithBills(String customerId) async {
    return await _client.from('ledger_entries')
        .select('*, sales(*, sale_items(*, products(*)))')
        .eq('customer_id', customerId)
        .order('timestamp', ascending: false);
  }

  // Insights / Reports
  Future<List<Map<String, dynamic>>> getSalesWithItems() async {
    return await _client.from('sales')
        .select('*, customers(*), sale_items(*, products(*))')
        .order('timestamp', ascending: false);
  }

  Future<double> getTotalStockValue() async {
    final response = await _client.from('products').select('cost_price, stock_quantity');
    double total = 0;
    for (var item in response) {
      total += ((item['cost_price'] as num?)?.toDouble() ?? 0.0) * ((item['stock_quantity'] as num?)?.toInt() ?? 0);
    }
    return total;
  }

  Future<void> deleteSale(String saleId) async {
    // Note: Due to foreign keys, we need to handle ledger entries linked to this sale
    await _client.from('ledger_entries').delete().eq('sale_id', saleId);
    await _client.from('sale_items').delete().eq('sale_id', saleId);
    await _client.from('sales').delete().eq('id', saleId);
  }
}
