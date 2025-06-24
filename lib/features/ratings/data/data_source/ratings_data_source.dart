import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/comman/entitys/rating_model.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final ratingsDataSourceProvider = Provider.autoDispose<RatingsDataSource>(
  (ref) =>
      RatingsDataSourceImpl(supabaseClient: ref.read(supabaseClientProvider)),
);

abstract class RatingsDataSource {
  Future<List<RatingModel>> getAllRatings();
  Future<List<RatingModel>> getRatingsByItemId(String itemId);
  Future<double> getAverageRatingByItemId(String itemId);
  Future<RatingModel> addRating(RatingModel rating);
  Future<void> deleteRating(int ratingId);
}

class RatingsDataSourceImpl implements RatingsDataSource {
  final SupabaseClient supabaseClient;

  RatingsDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<RatingModel>> getAllRatings() async {
    return executeTryAndCatchForDataLayer(() async {
      print('🔍 Debug: Fetching all ratings from database...');

      // First, let's just get the basic ratings data without joins
      final response = await supabaseClient
          .from('ratings')
          .select('*')
          .order('created_at', ascending: false);

      print('🔍 Debug: Raw ratings response: $response');
      print('🔍 Debug: Response type: ${response.runtimeType}');
      print('🔍 Debug: Response length: ${response.length}');

      if (response.isEmpty) {
        print('🔍 Debug: No ratings found in database');
        return [];
      }

      final ratings =
          (response as List<dynamic>).map((rating) {
            final Map<String, dynamic> ratingMap = Map<String, dynamic>.from(
              rating,
            );
            print('🔍 Debug: Processing rating: $ratingMap');

            // For now, we'll use the basic data without user/item details
            // We can add separate queries for user/item info later if needed
            return RatingModel.fromMap(ratingMap);
          }).toList();

      print('🔍 Debug: Processed ${ratings.length} ratings');
      return ratings;
    });
  }

  @override
  Future<List<RatingModel>> getRatingsByItemId(String itemId) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('ratings')
          .select('*')
          .eq('item_id', itemId)
          .order('created_at', ascending: false);

      final ratings =
          (response as List<dynamic>).map((rating) {
            final Map<String, dynamic> ratingMap = Map<String, dynamic>.from(
              rating,
            );
            return RatingModel.fromMap(ratingMap);
          }).toList();

      return ratings;
    });
  }

  @override
  Future<double> getAverageRatingByItemId(String itemId) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('ratings')
          .select('rate')
          .eq('item_id', itemId);

      if (response.isEmpty) return 0.0;

      final rates =
          (response as List<dynamic>)
              .map((rating) => (rating['rate'] as num).toDouble())
              .toList();

      final average = rates.reduce((a, b) => a + b) / rates.length;
      return double.parse(average.toStringAsFixed(1));
    });
  }

  @override
  Future<RatingModel> addRating(RatingModel rating) async {
    return executeTryAndCatchForDataLayer(() async {
      final response =
          await supabaseClient
              .from('ratings')
              .insert(rating.toMap())
              .select()
              .single();

      return RatingModel.fromMap(response);
    });
  }

  @override
  Future<void> deleteRating(int ratingId) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('ratings').delete().eq('id', ratingId);
    });
  }
}
