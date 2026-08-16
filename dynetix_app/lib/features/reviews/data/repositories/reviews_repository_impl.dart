import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../models/review_model.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<ReviewEntity>> getReviewsByService(String serviceId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('reviews')
          .select()
          .eq('service_id', int.parse(serviceId))
          .order('created_at', ascending: false);
          
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> submitReview(ReviewEntity review) async {
    final model = ReviewModel(
      id: review.id,
      orderId: review.orderId,
      serviceId: review.serviceId,
      customerId: review.customerId,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
    );
    
    await _supabase.from('reviews').insert(model.toJson());
  }
}
