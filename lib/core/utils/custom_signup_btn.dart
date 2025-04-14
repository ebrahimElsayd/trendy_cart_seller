import 'package:flutter/material.dart';
import 'package:trendycart_of_seller/features/auth/presentation/screens/signup_screen.dart';

import '../../../../core/theme/text_style.dart';

class CustomSignupBtn extends StatelessWidget {
  const CustomSignupBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("New to Ecommerce?", style: TextStyles.Lato16regularBlack),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupScreen(),
                // builder: (context) => SignupScreen(),
              ),
            );
          },
          child: Text("Sign up", style: TextStyles.Lato16extraBoldBlack),
        ),
      ],
    );
  }
}
