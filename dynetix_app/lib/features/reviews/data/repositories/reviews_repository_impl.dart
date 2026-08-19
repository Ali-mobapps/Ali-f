import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../models/review_model.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<ReviewEntity>> getReviewsByService(String serviceId) async {
    try {
      var query = _supabase.from('reviews').select();
      
      // If serviceId is provided and not 'all', filter; otherwise get all (for Admin)
      if (serviceId.isNotEmpty && serviceId != 'all') {
        query = query.eq('service_id', serviceId); // Fix: Removed int.parse
      }
          
      final List<dynamic> data = await query.order('created_at', ascending: false);
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

  @override
  Future<void> deleteReview(String reviewId) async {
    await _supabase.from('reviews').delete().eq('id', reviewId);
  }
}
