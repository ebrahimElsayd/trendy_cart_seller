import '../../../../core/comman/entitys/rating_model.dart';

enum RatingsStateStatus {
  initial,
  loading,
  loaded,
  error,
  adding,
  added,
  deleting,
  deleted,
}

class RatingsState {
  final List<RatingModel> ratings;
  final RatingsStateStatus status;
  final String? errorMessage;
  final double? averageRating;

  const RatingsState({
    this.ratings = const [],
    this.status = RatingsStateStatus.initial,
    this.errorMessage,
    this.averageRating,
  });

  RatingsState copyWith({
    List<RatingModel>? ratings,
    RatingsStateStatus? status,
    String? errorMessage,
    double? averageRating,
  }) {
    return RatingsState(
      ratings: ratings ?? this.ratings,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  @override
  String toString() {
    return 'RatingsState(ratings: ${ratings.length}, status: $status, errorMessage: $errorMessage, averageRating: $averageRating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RatingsState &&
        other.ratings == ratings &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.averageRating == averageRating;
  }

  @override
  int get hashCode {
    return ratings.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        averageRating.hashCode;
  }
}
