import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authRemoteDataSourceProvider = Provider.autoDispose<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.watch(supabaseClientProvider)),
);

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  });

  Future<Map<String, dynamic>?> getCurrentUserData(String email);

  Future<void> createUserProfile({required UserModel user});

  Future<void> loginWithEmail({
    required String email,
    required String password,
  });

  Future<void> loginAsGuest();

  Future<void> signOut();

  Future<void> updateUserPhoneNumber({required int phoneNumber, int? userId});

  Future<void> forgetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String name,
    required String password,
  }) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: "https://lockapp.site/redirect_page.html",
      );

      return {'email': email, 'name': name, 'password': password};
    });
  }

  @override
  Future<void> createUserProfile({required UserModel user}) async {
    return executeTryAndCatchForDataLayer(() async {
      final userData = {
        'email': user.email,
        'name': user.name,
        'password': user.password,
      };

      await supabaseClient.from('users').insert(userData);
    });
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserData(String email) async {
    return executeTryAndCatchForDataLayer(() async {
      if (currentUserSession != null) {
        return await supabaseClient
            .from('users')
            .select()
            .eq("email", email)
            // .eq('id', currentUserSession!.user.id)
            .single();
      }
      return null;
    });
  }

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<void> loginAsGuest() async {
    await supabaseClient.auth.signInAnonymously();
  }

  @override
  Future<void> updateUserPhoneNumber({
    required int phoneNumber,
    int? userId,
  }) async {
    await supabaseClient
        .from('users')
        .update({'phone': phoneNumber})
        .eq('id', userId!);
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: 'https://lockapp.site/forget_password.html',
    );
  }
}
