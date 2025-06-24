import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/comman/entitys/rating_model.dart';
import '../data_source/ratings_data_source.dart';

final ratingsRepositoryProvider = Provider.autoDispose<RatingsRepository>(
  (ref) => RatingsRepositoryImpl(
    ratingsDataSource: ref.read(ratingsDataSourceProvider),
  ),
);

abstract class RatingsRepository {
  Future<Either<Failure, List<RatingModel>>> getAllRatings();
  Future<Either<Failure, List<RatingModel>>> getRatingsByItemId(String itemId);
  Future<Either<Failure, double>> getAverageRatingByItemId(String itemId);
  Future<Either<Failure, RatingModel>> addRating(RatingModel rating);
  Future<Either<Failure, void>> deleteRating(int ratingId);
}

class RatingsRepositoryImpl implements RatingsRepository {
  final RatingsDataSource ratingsDataSource;

  RatingsRepositoryImpl({required this.ratingsDataSource});

  @override
  Future<Either<Failure, List<RatingModel>>> getAllRatings() async {
    try {
      final ratings = await ratingsDataSource.getAllRatings();
      return Right(ratings);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RatingModel>>> getRatingsByItemId(
    String itemId,
  ) async {
    try {
      final ratings = await ratingsDataSource.getRatingsByItemId(itemId);
      return Right(ratings);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getAverageRatingByItemId(
    String itemId,
  ) async {
    try {
      final average = await ratingsDataSource.getAverageRatingByItemId(itemId);
      return Right(average);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingModel>> addRating(RatingModel rating) async {
    try {
      final newRating = await ratingsDataSource.addRating(rating);
      return Right(newRating);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRating(int ratingId) async {
    try {
      await ratingsDataSource.deleteRating(ratingId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
