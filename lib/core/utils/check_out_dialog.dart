import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text_style.dart';

void showCheckoutSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const OrderDetailsScreen(orderId: "")));
          return true;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background text
                Positioned(
                  top: -10.h,
                  left: -6.w,
                  child: Row(
                    children: [
                      Container(
                        height: 25.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'We hope you bright future',
                        style: TextStyles.Blinker14regular.copyWith(
                          color: Colors.grey.withOpacity(0.3),
                          fontSize: 10.h,
                        ),
                      ),
                    ],
                  ),
                ),

                // App Logo in circle

                // Main content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF68B3B).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: const Color(0xFFF68B3B),
                        size: 50.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Order Placed Successfully!',
                      style: TextStyles.Blinker18semiBoldBlack.copyWith(
                        color: const Color(0xFFF68B3B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Thank you for your order. We are preparing it and will contact you within the next few hours.',
                      style: TextStyles.Blinker14regular,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {},
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      //   Navigator.of(context).pop();
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) =>  OrderDetailsScreen(orderId: "")));
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF68B3B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        minimumSize: Size(double.infinity, 45.h),
                      ),
                      child: Text('OK', style: TextStyles.blinker14Boldwhite),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class UserOrdersScreen {}
