import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trendycart_of_seller/core/utils/custom_app_bar.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_btn.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_field.dart';
import 'package:trendycart_of_seller/features/auth/presentation/screens/otp_screen.dart';

import '../../../../core/theme/text_style.dart';
import '../../data/_auth_service.dart';

final supabase = Supabase.instance.client;

class SignupWithPhoneScreen extends StatefulWidget {
  const SignupWithPhoneScreen({super.key});

  @override
  State<SignupWithPhoneScreen> createState() => _SignupWithPhoneScreenState();
}

class _SignupWithPhoneScreenState extends State<SignupWithPhoneScreen> {
  final authservice = AuthService();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(txt: '', hasArrow: true, hasIcons: false),
            SizedBox(height: 70.h),
            Text("Phone Number", style: TextStyles.Inter28SemiBoldBlack),
            const SizedBox(height: 40),
            Image.asset(
              "assets/images/forget_pass_img.png",
              height: 166.h,
              width: 225.w,
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Phone Number:",
                  style: TextStyles.Lato14extraBoldBlack,
                ),
              ),
            ),
            CustomTextField(
              hinttxt: "Enter your Phone Number",
              mycontroller: _phoneController,
            ),
            const SizedBox(height: 70),
            CustomTxtBtn(
              txtstyle: TextStyles.Lato16extraBoldBlack,
              bgclr: const Color(0xFFF39754),
              btnHeight: 60,
              btnWidth: 345,
              btnradious: 14,
              btnName: "Continue",
              onPress: () async {
                // Check if phone number is not empty
                if (_phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone Number can't be empty."),
                    ),
                  );
                }
                // Validate phone number length (11 digits in this example)
                else if (_phoneController.text.length != 11) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone Number should be 11 digits."),
                    ),
                  );
                } else {
                  try {
                    // Send OTP to phone number using AuthService
                    await authservice.signInWithPhone(
                      '+2${_phoneController.text}',
                    );

                    // Navigate to OTP screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => OtpScreen(
                              phoneNumber: '+2${_phoneController.text}',
                            ),
                      ),
                    );
                  } catch (e) {
                    // Show error if something went wrong
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => OTPVerificationPage(
//       phone: _phoneController.text,
//     ),
//   ),
// );
