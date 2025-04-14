import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../presentation/screens/onboarding.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Access the session from the snapshot
        final session = snapshot.data?.session;

        if (session != null) {
          // If session exists, the user is logged in
          return const Onboard();
        } else {
          // If session is null, the user is not logged in
          //return SignupWithPhoneScreen();
          return const Onboard();
        }
      },
    );
  }
}
