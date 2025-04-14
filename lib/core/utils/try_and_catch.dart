import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trendycart_of_seller/core/erorr/failure.dart';

import 'netowrk_exception.dart';

// Define a utility function to handle exceptions and return an Either type
Future<Either<Failure, T>> executeTryAndCatchForRepository<T>(
  Future<T> Function() action,
) async {
  try {
    final result = await action();
    return right(result);
  } on FormatException catch (e) {
    return left(Failure('Error parsing data: ${e.message}'));
  } on NoInternetException catch (e) {
    return left(Failure(e.message));
  } on StorageException catch (e) {
    return left(Failure(e.message));
  } on PostgrestException catch (e) {
    return left(Failure(e.message));
  } on AuthException catch (e) {
    return left(Failure(e.message));
  } on TypeError catch (e) {
    return left(
      Failure(
        'Type error: ${e.toString()}. This might be due to incorrect data structure.',
      ),
    );
  } on NoSuchMethodError catch (e) {
    return left(
      Failure(
        'Method not found: ${e.toString()}. This might be due to missing fields in the data.',
      ),
    );
  } catch (e) {
    print('Caught exception: ${e.hashCode} - ${e.toString()}');
    if (e is TimeoutException) {
      return left(Failure('Operation timed out: ${e.message}'));
    } else if (e is SocketException) {
      return left(Failure('Network error: ${e.message}'));
    } else {
      return left(Failure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

Future<T> executeTryAndCatchForDataLayer<T>(Future<T> Function() action) async {
  try {
    var check = await Connectivity().checkConnectivity();

    if (check.contains(ConnectivityResult.mobile) ||
        check.contains(ConnectivityResult.wifi)) {
      return await action();
    } else {
      throw NoInternetException();
    }
  } on AuthException catch (e) {
    throw AuthException(e.message);
  } on PostgrestException catch (e) {
    throw PostgrestException(message: e.message);
  } on TimeoutException catch (e) {
    throw Exception('Operation timed out: ${e.message}');
  } on SocketException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on StorageException catch (e) {
    throw Exception('Storage error: ${e.message}');
  } on FormatException catch (e) {
    throw FormatException('Error parsing data: ${e.message}');
  } catch (e) {
    throw Exception('An unexpected error occurred: ${e.toString()}');
  }
}
