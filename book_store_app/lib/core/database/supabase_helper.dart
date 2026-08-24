import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final SupabaseClient _client = Supabase.instance.client;

  // Products
  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _client.from('products').select();
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    await _client.from('products').insert(product);
  }

  Future<void> updateProduct(Map<String, dynamic> product) async {
    await _client.from('products').update(product).eq('id', product['id']);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // Sales
  Future<void> createSale(Map<String, dynamic> sale, List<Map<String, dynamic>> items) async {
    await _client.from('sales').insert(sale);
    await _client.from('sale_items').insert(items);
    
    // Note: Stock reduction logic needs to be handled either by 
    // a PostgreSQL Function (RPC) or individual update calls here.
    for (var item in items) {
      final product = await _client.from('products').select('stock_quantity').eq('id', item['product_id']).single();
      int newStock = (product['stock_quantity'] as int) - (item['quantity'] as int);
      await _client.from('products').update({'stock_quantity': newStock}).eq('id', item['product_id']);
    }
  }

  // Customers
  Future<List<Map<String, dynamic>>> getCustomers() async {
    return await _client.from('customers').select();
  }

  Future<void> insertCustomer(Map<String, dynamic> customer) async {
    await _client.from('customers').insert(customer);
  }
}
