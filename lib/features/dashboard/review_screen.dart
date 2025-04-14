import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ReviewScreen(),
        );
      },
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final List<Review> reviews = List.generate(
    6,
    (index) => Review(
      name: 'User $index',
      product: 'Gray vintage computer',
      date: 'Apr ${21 - index}',
      comment:
          index % 2 == 0
              ? 'Very good😊'
              : 'This is a very long comment thatrjnfvg should demonstrate how the read more and read less toggle works beautifully when the comment exceeds a specific length 😊',
      avatar: 'assets/images/img.png',
      icon: 'assets/images/img.png',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ListView.separated(
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => Divider(height: 24.h),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ReviewItem(review: review);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Review {
  final String name;
  final String product;
  final String date;
  final String comment;
  final String avatar;
  final String icon;

  Review({
    required this.name,
    required this.product,
    required this.date,
    required this.comment,
    required this.avatar,
    required this.icon,
  });
}

class ReviewItem extends StatefulWidget {
  final Review review;

  const ReviewItem({required this.review});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool isExpanded = false;
  final int charLimit = 80;

  @override
  Widget build(BuildContext context) {
    final comment = widget.review.comment;
    final showToggle = comment.length > charLimit;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            widget.review.avatar,
            width: 40.w,
            height: 40.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/img.png',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.review.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text("rate", style: TextStyle(fontSize: 12.sp)),
                  Spacer(),
                  Text(
                    widget.review.date,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                "On ${widget.review.product}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  children: [
                    TextSpan(
                      text:
                          isExpanded || !showToggle
                              ? comment
                              : comment.substring(0, charLimit) + '...',
                    ),
                    if (showToggle)
                      TextSpan(
                        text: isExpanded ? " Read less" : " Read more",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Image.asset(
          widget.review.icon,
          width: 32.w,
          height: 32.w,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/img.png',
              width: 32.w,
              height: 32.w,
              fit: BoxFit.contain,
            );
          },
        ),
      ],
    );
  }
}
