import '../entities/review_entity.dart';

abstract class ReviewsRepository {
  Future<List<ReviewEntity>> getReviewsByService(String serviceId);
  Future<void> submitReview(ReviewEntity review);
  Future<void> deleteReview(String reviewId);
}
