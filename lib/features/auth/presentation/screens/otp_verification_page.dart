import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendycart_of_seller/core/utils/custom_app_bar.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_btn.dart';
import 'package:trendycart_of_seller/features/auth/presentation/riverpod/auth_state.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../riverpod/auth_riverpod.dart';
import '../riverpod/auth_view_model.dart';

class OTPVerificationPage extends ConsumerWidget {
  final String phone;

  const OTPVerificationPage({super.key, required this.phone});

  void verifyOTP(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(authViewModelProvider);
    // if (viewModel.formKey.currentState!.validate()) {
    //   ref.read(authControllerProvider.notifier).verifyOTP(
    //         phone: phone,
    //         otp: viewModel.otpController.text,
    //       );
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null) {
        showSnackBar(context, next.error!);
      } else if (next.isSuccess) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    final viewModel = ref.watch(authViewModelProvider);
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(txt: "", hasArrow: true, hasIcons: false),
              const SizedBox(height: 50),
              Text("Verification Code", style: TextStyles.Inter28SemiBoldBlack),
              const SizedBox(height: 10),
              Text('Enter the code sent to $phone'),
              const SizedBox(height: 40),
              Image.asset(
                "assets/images/forget_pass_img.png",
                height: 166.h,
                width: 225.w,
              ),
              const SizedBox(height: 70),
              TextFormField(
                controller: viewModel.otpController,
                decoration: const InputDecoration(labelText: 'OTP Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (state.isLoading())
                const CircularProgressIndicator()
              else
                CustomTxtBtn(
                  txtstyle: TextStyles.Lato16extraBoldBlack,
                  bgclr: const Color(0xFFF68B3B),
                  btnHeight: 60,
                  btnWidth: 345,
                  btnradious: 14,
                  btnName: "Confirm Code",
                  onPress: () {
                    verifyOTP(context, ref);
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t get OTP? ",
                    style: TextStyles.Lato16regularBlack,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend OTP",
                      style: TextStyles.Poppins14regularBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
