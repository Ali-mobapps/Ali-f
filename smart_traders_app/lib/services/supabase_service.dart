import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invoice.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> saveInvoice(Invoice invoice) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final invoiceData = invoice.toMap();
    invoiceData['user_id'] = user.id;

    final response = await supabase
        .from('invoices')
        .insert(invoiceData)
        .select()
        .single();

    final invoiceId = response['id'];

    final itemsData = invoice.items.map((item) => item.toMap(invoiceId)).toList();
    await supabase.from('invoice_items').insert(itemsData);
  }

  Future<List<Map<String, dynamic>>> fetchInvoices() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];
    
    return await supabase
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  }

  Future<void> deleteInvoice(String id) async {
    await supabase.from('invoices').delete().eq('id', id);
  }
}
