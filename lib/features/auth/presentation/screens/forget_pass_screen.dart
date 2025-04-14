import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendycart_of_seller/core/utils/custom_app_bar.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_btn.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_field.dart';
import 'package:trendycart_of_seller/core/utils/show_snack_bar.dart';

import '../../../../core/theme/text_style.dart';
import '../riverpod/auth_riverpod.dart';
import '../riverpod/auth_state.dart';

class ForgetPassScreen extends ConsumerWidget {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController email = TextEditingController();

    ref.listen(authControllerProvider, (previous, next) {
      if (next.state == AuthState.success) {
        showSnackBar(context, "Password reset link sent to your email");
      }
      if (next.state == AuthState.error) {
        showSnackBar(context, next.error ?? "Something went wrong");
      }
    });

    return Scaffold(
      //appBar:
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(txt: '', hasArrow: true, hasIcons: false),
            SizedBox(height: 70.h),
            Text("Forgot Password", style: TextStyles.Inter28SemiBoldBlack),
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
                child: Text("Email:", style: TextStyles.Lato14extraBoldBlack),
              ),
            ),
            CustomTextField(hinttxt: "Enter Your Email", mycontroller: email),
            const SizedBox(height: 70),
            CustomTxtBtn(
              txtstyle: TextStyles.Lato16extraBoldBlack,
              bgclr: const Color(0xFFF39754),
              btnHeight: 60,
              btnWidth: 345,
              btnradious: 14,
              btnName: "Continue",
              onPress: () {
                if (email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email can't be empty.")),
                  );
                } else if (!email.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email should be valid.")),
                  );
                } else {
                  ref
                      .read(authControllerProvider.notifier)
                      .forgetPassword(email: email.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
