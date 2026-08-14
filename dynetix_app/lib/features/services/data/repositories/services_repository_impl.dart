import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<ServiceEntity>> getServices() async {
    final List<dynamic> data = await _supabase.from('services').select().order('title');
    return data.map((json) => ServiceModel.fromJson(json, json['id'].toString())).toList();
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    final model = ServiceModel(
      id: service.id,
      title: service.title,
      description: service.description,
      price: service.price,
      category: service.category,
      type: service.type,
      isActive: service.isActive,
      instructor: service.instructor,
      duration: service.duration,
      level: service.level,
    );
    await _supabase.from('services').insert(model.toJson());
  }

  @override
  Future<void> updateService(ServiceEntity service) async {
    final model = ServiceModel(
      id: service.id,
      title: service.title,
      description: service.description,
      price: service.price,
      category: service.category,
      type: service.type,
      isActive: service.isActive,
      instructor: service.instructor,
      duration: service.duration,
      level: service.level,
    );
    await _supabase.from('services').update(model.toJson()).eq('id', service.id);
  }

  @override
  Future<void> deleteService(String id) async {
    await _supabase.from('services').delete().eq('id', id);
  }

  @override
  Future<void> seedInitialData() async {
    final List<String> services = [
      '3D Modeling', 'Legal Drafting and Global Compliance', 'Full Stack Development with MERN',
      'Cloud Computing', 'Shopify Development and Dropshipping', 'Mobile Game and App Development',
      'UI/UX & Webflow', 'Artificial Intelligence using Python', 'Startup Strategies and Entrepreneurship',
      'Virtual Assistant', 'Data Analytics and Business Intelligence', 'QuickBooks',
      'SEO (Search Engine Optimization)', 'Graphic Design', 'Creative Writing', 'AutoCAD',
      'Digital Literacy', 'Digital Marketing', 'E-Commerce Management', 'Freelancing',
      'Communication and Soft Skills', 'Video Editing, Animation and Vlogging',
      'Affiliate Marketing', 'WordPress'
    ];

    for (var title in services) {
      final id = DateTime.now().millisecondsSinceEpoch.toString() + title.hashCode.toString();
      await addService(ServiceEntity(
        id: id,
        title: title,
        description: 'Elite professional training and solutions by Dynetix.',
        price: 150.0,
        category: 'General',
        type: 'service',
        isActive: true,
      ));
    }
  }
}
