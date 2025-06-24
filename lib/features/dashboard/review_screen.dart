import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../ratings/presentation/riverpod/ratings_riverpod.dart';
import '../ratings/presentation/riverpod/ratings_state.dart';
import '../../core/comman/entitys/rating_model.dart';
import '../../core/comman/widgets/custom_cached_network_image_provider.dart';

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

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    // Load ratings data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratingsRiverpodProvider.notifier).getAllRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingsState = ref.watch(ratingsRiverpodProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "Reviews",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Reviews",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildReviewsList(ratingsState),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsList(RatingsState ratingsState) {
    if (ratingsState.status == RatingsStateStatus.loading) {
      return Container(
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Loading reviews...',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (ratingsState.status == RatingsStateStatus.error) {
      return Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48.w,
                  color: const Color(0xFFFF6B6B),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                ratingsState.errorMessage ?? 'Unable to load reviews',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  ref.read(ratingsRiverpodProvider.notifier).getAllRatings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (ratingsState.ratings.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rate_review_outlined,
                  size: 48.w,
                  color: const Color(0xFF667EEA),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'No reviews yet',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Customer reviews will appear here\nonce they start rating your products',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: ratingsState.ratings.length,
      separatorBuilder:
          (_, __) =>
              Divider(height: 24.h, color: Colors.grey[200], thickness: 1),
      itemBuilder: (context, index) {
        final rating = ratingsState.ratings[index];
        return ReviewItem(rating: rating);
      },
    );
  }
}

class ReviewItem extends StatefulWidget {
  final RatingModel rating;

  const ReviewItem({super.key, required this.rating});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool isExpanded = false;
  final int charLimit = 80;

  @override
  Widget build(BuildContext context) {
    final comment = widget.rating.comment;
    final showToggle = comment.length > charLimit;
    final formattedDate = DateFormat('MMM dd').format(widget.rating.createdAt);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced User Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child:
                  widget.rating.userAvatar != null
                      ? CustomCachedNetworkImageProvider(
                        imageUrl: widget.rating.userAvatar!,
                        width: 42.w,
                        height: 42.w,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[400]!, Colors.purple[400]!],
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 22.w,
                          color: Colors.white,
                        ),
                      ),
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
                      widget.rating.userName ?? 'User ${widget.rating.userId}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Enhanced Star rating display
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.rating.rate.floor()
                              ? Icons.star
                              : index < widget.rating.rate
                              ? Icons.star_half
                              : Icons.star_border,
                          size: 14.w,
                          color: Colors.orange[600],
                        );
                      }),
                    ),
                    const Spacer(),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "On ${widget.rating.itemName ?? 'Product ${widget.rating.itemId}'}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 6.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
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
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
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
          // Enhanced Product Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child:
                  widget.rating.itemImage != null
                      ? CustomCachedNetworkImageProvider(
                        imageUrl: widget.rating.itemImage!,
                        width: 34.w,
                        height: 34.w,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 18.w,
                          color: Colors.grey[600],
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
