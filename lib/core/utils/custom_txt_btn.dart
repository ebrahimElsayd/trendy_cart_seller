import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendycart_of_seller/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:trendycart_of_seller/features/auth/presentation/riverpod/auth_state.dart';

class CustomTxtBtn extends ConsumerWidget {
  final String btnName;
  final Function onPress;
  final Color bgclr;
  final double btnradious;
  final double btnWidth;
  final double btnHeight;

  final TextStyle txtstyle;

  const CustomTxtBtn({
    super.key,
    required this.btnName,
    required this.onPress,
    required this.bgclr,
    required this.btnradious,
    required this.btnWidth,
    required this.btnHeight,
    required this.txtstyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        width: btnWidth.w,
        height: btnHeight.h,
        decoration: BoxDecoration(
          color: bgclr,
          borderRadius: BorderRadius.circular(btnradious.r),
        ),
        child: Center(
          child:
              ref.watch(authControllerProvider).state == AuthState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(btnName, style: txtstyle),
        ),
      ),
    );
  }
}

// return TextButton(
//                               onPressed: onPress,
//                               style: TextButton.styleFrom(
//                                 backgroundColor:
//                                     bgclr,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(btnradious.r),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: btnWidth.w, vertical: btnHeight.h),
//                               ),
//                               child: Text(
//                                 btnName,
//                                 style: TextStyles.Lato16extraBoldBlack,
//                               ),
//                             );
