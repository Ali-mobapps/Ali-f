import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../models/service_model.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<ServiceEntity>> getServices() async {
    final List<dynamic> data = await _supabase.from('services').select().order('title');
    return data.map<ServiceEntity>((json) => ServiceModel.fromJson(json, json['id'].toString())).toList();
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    final model = ServiceModel(
      id: service.id,
      title: service.title,
      description: service.description,
      price: service.price,
      isActive: service.isActive,
      category: service.category,
      type: service.type,
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
      isActive: service.isActive,
      category: service.category,
      type: service.type,
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

  Future<void> seedInitialData() async {
    final List<String> items = [
      "3D Modeling", "Legal Drafting and Global Compliance", "Full Stack Development with MERN",
      "Cloud Computing", "Shopify Development and Dropshipping", "Mobile Game and App Development",
      "UI/UX & Webflow", "Artificial Intelligence using Python", "Startup Strategies and Entrepreneurship",
      "Virtual Assistant", "Data Analytics and Business Intelligence", "QuickBooks",
      "SEO (Search Engine Optimization)", "Graphic Design", "Creative Writing", "AutoCAD",
      "Digital Literacy", "Digital Marketing", "E-Commerce Management", "Freelancing",
      "Communication and Soft Skills", "Video Editing, Animation and Vlogging",
      "Affiliate Marketing", "WordPress"
    ];

    for (var title in items) {
      // Add as Service
      await addService(ServiceModel(
        id: 'service_${title.hashCode}_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: "Professional $title services tailored for your needs.",
        price: 150.0,
        isActive: true,
        category: "General",
        type: "service",
      ));

      // Add as Course (Academy)
      await addService(ServiceModel(
        id: 'course_${title.hashCode}_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: "Master $title with our elite academy course.",
        price: 299.0,
        isActive: true,
        category: "Academy",
        type: "course",
        instructor: "Dynetix Expert",
        duration: "3 Months",
        level: "Beginner to Advanced",
      ));
    }
  }
}
