import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in
  Future<AuthResponse> signinWithEmailPass(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  //signup
  Future<AuthResponse> signupWithEmailPass(
    String email,
    String password,
    String name,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // If signup is successful, update the user's profile with the name
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {
          'name': name, // Save the name as part of user metadata
        },
      ),
    );

    // Refresh the session to get the updated user metadata
    await _supabase.auth.refreshSession();

    return response;
  }

  String? getCurrentUserName() {
    final user = _supabase.auth.currentUser;
    return user?.userMetadata?['name']; // Retrieve the name from user metadata
  }

  // Send OTP to the phone number
  Future<void> signInWithPhone(String phoneNumber) async {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
  }

  // Verify OTP and log the user in
  Future<AuthResponse> verifyPhoneOtp(String phoneNumber, String otp) async {
    final response = await _supabase.auth.verifyOTP(
      phone: phoneNumber,
      token: otp,
      type: OtpType.sms, // We're using SMS for OTP
    );
    return response;
  }

  //logout
  Future<void> signout() async {
    await _supabase.auth.signOut();
  }

  //get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}

//////////////////////////
///void logout()async{await authservice.signout();
///context.read(loginStateProvider.notifier).logOut();}
///
///final currentemail = authservice.getCurrentUserEmail();
