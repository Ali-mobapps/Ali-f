import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<ServiceEntity>> getServices() async {
    try {
      final List<dynamic> data = await _supabase.from('services').select().order('title');
      return data.map((json) => ServiceModel.fromJson(json, json['id'].toString())).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    try {
      final model = ServiceModel(
        id: service.id,
        title: service.title,
        description: service.description,
        price: service.price,
        category: service.category,
        type: service.type,
        isActive: service.isActive,
      );
      
      final json = model.toJson();
      await _supabase.from('services').insert(json);
    } catch (e) {
      print('Add Service Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateService(ServiceEntity service) async {
    try {
      final model = ServiceModel(
        id: service.id,
        title: service.title,
        description: service.description,
        price: service.price,
        category: service.category,
        type: service.type,
        isActive: service.isActive,
      );
      await _supabase.from('services').update(model.toJson()).eq('id', service.id);
    } catch (e) {
      print('Update Service Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteService(String id) async {
    await _supabase.from('services').delete().eq('id', id);
  }

  @override
  Future<void> seedInitialData() async {
    final List<Map<String, dynamic>> initialItems = [
      {'title': '3D Modeling', 'type': 'service', 'price': 199.99},
      {'title': 'Legal Drafting and Global Compliance', 'type': 'service', 'price': 149.0},
      {'title': 'Full Stack Development with MERN', 'type': 'course', 'price': 299.99},
      {'title': 'Cloud Computing', 'type': 'course', 'price': 249.99},
      {'title': 'Shopify Development and Dropshipping', 'type': 'service', 'price': 179.99},
      {'title': 'Mobile Game and App Development', 'type': 'service', 'price': 349.99},
      {'title': 'UI/UX & Webflow', 'type': 'service', 'price': 129.99},
      {'title': 'Artificial Intelligence using Python', 'type': 'course', 'price': 279.99},
      {'title': 'Startup Strategies and Entrepreneurship', 'type': 'course', 'price': 159.99},
      {'title': 'Virtual Assistant', 'type': 'service', 'price': 89.99},
      {'title': 'Data Analytics and Business Intelligence', 'type': 'course', 'price': 229.99},
      {'title': 'QuickBooks', 'type': 'service', 'price': 99.99},
      {'title': 'SEO (Search Engine Optimization)', 'type': 'service', 'price': 119.99},
      {'title': 'Graphic Design', 'type': 'service', 'price': 79.99},
      {'title': 'Creative Writing', 'type': 'service', 'price': 69.99},
      {'title': 'AutoCAD', 'type': 'service', 'price': 139.99},
      {'title': 'Digital Literacy', 'type': 'course', 'price': 49.99},
      {'title': 'Digital Marketing', 'type': 'service', 'price': 149.99},
      {'title': 'E-Commerce Management', 'type': 'service', 'price': 189.99},
      {'title': 'Freelancing', 'type': 'course', 'price': 59.99},
      {'title': 'Communication and Soft Skills', 'type': 'course', 'price': 79.99},
      {'title': 'Video Editing, Animation and Vlogging', 'type': 'service', 'price': 159.99},
      {'title': 'Affiliate Marketing', 'type': 'service', 'price': 129.99},
      {'title': 'WordPress', 'type': 'service', 'price': 109.99},
    ];

    try {
      for (var item in initialItems) {
        // Use a standard select to check for existence
        final data = await _supabase
            .from('services')
            .select()
            .eq('title', item['title']!);

        if ((data as List).isEmpty) {
          await _supabase.from('services').insert({
            'title': item['title'],
            'description': 'Premium ${item['title']} ${item['type']} by Dynetix Experts.',
            'price': item['price'],
            'category': 'Elite',
            'type': item['type'],
            'is_active': true,
          });
        }
      }
    } catch (e) {
      print('Seeding Error: $e');
      rethrow;
    }
  }
}
