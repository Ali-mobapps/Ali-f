import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository repository;

  ReviewsCubit(this.repository) : super(ReviewsInitial());

  Future<void> fetchReviews(String serviceId) async {
    emit(ReviewsLoading());
    try {
      final reviews = serviceId == 'all' 
          ? await repository.getReviewsByService('') // Handled in repo
          : await repository.getReviewsByService(serviceId);
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await repository.deleteReview(reviewId);
      fetchReviews('all'); // Refresh for Admin
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> submitReview(ReviewEntity review) async {
    try {
      await repository.submitReview(review);
      fetchReviews(review.serviceId);
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
