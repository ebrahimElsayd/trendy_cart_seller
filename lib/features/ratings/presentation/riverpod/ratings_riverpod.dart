import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/ratings_repository.dart';
import '../../../../core/comman/entitys/rating_model.dart';
import 'ratings_state.dart';

final ratingsRiverpodProvider =
    StateNotifierProvider.autoDispose<RatingsRiverpod, RatingsState>(
      (ref) => RatingsRiverpod(
        ratingsRepository: ref.read(ratingsRepositoryProvider),
      ),
    );

class RatingsRiverpod extends StateNotifier<RatingsState> {
  final RatingsRepository ratingsRepository;

  RatingsRiverpod({required this.ratingsRepository})
    : super(const RatingsState());

  Future<void> getAllRatings() async {
    state = state.copyWith(status: RatingsStateStatus.loading);

    print('🔍 Debug: Starting to fetch ratings...');

    final result = await ratingsRepository.getAllRatings();

    result.fold(
      (failure) {
        print('🔍 Debug: Error fetching ratings: ${failure.message}');
        state = state.copyWith(
          status: RatingsStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (ratings) {
        print('🔍 Debug: Successfully fetched ${ratings.length} ratings');
        state = state.copyWith(
          status: RatingsStateStatus.loaded,
          ratings: ratings,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> getRatingsByItemId(String itemId) async {
    state = state.copyWith(status: RatingsStateStatus.loading);

    final result = await ratingsRepository.getRatingsByItemId(itemId);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: RatingsStateStatus.error,
            errorMessage: failure.message,
          ),
      (ratings) =>
          state = state.copyWith(
            status: RatingsStateStatus.loaded,
            ratings: ratings,
            errorMessage: null,
          ),
    );
  }

  Future<void> getAverageRating(String itemId) async {
    final result = await ratingsRepository.getAverageRatingByItemId(itemId);

    result.fold(
      (failure) => null, // Don't change state for average rating errors
      (average) => state = state.copyWith(averageRating: average),
    );
  }

  Future<void> addRating(RatingModel rating) async {
    state = state.copyWith(status: RatingsStateStatus.adding);

    final result = await ratingsRepository.addRating(rating);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: RatingsStateStatus.error,
            errorMessage: failure.message,
          ),
      (newRating) {
        final updatedRatings = [newRating, ...state.ratings];
        state = state.copyWith(
          status: RatingsStateStatus.added,
          ratings: updatedRatings,
          errorMessage: null,
        );

        // Refresh all ratings to get updated data
        getAllRatings();
      },
    );
  }

  Future<void> deleteRating(int ratingId) async {
    state = state.copyWith(status: RatingsStateStatus.deleting);

    final result = await ratingsRepository.deleteRating(ratingId);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: RatingsStateStatus.error,
            errorMessage: failure.message,
          ),
      (_) {
        final updatedRatings =
            state.ratings.where((rating) => rating.id != ratingId).toList();
        state = state.copyWith(
          status: RatingsStateStatus.deleted,
          ratings: updatedRatings,
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(
      status: RatingsStateStatus.loaded,
      errorMessage: null,
    );
  }
}
