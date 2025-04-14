import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: 'ebrahim',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'ebrahim222@gmail.com',
  );
  final TextEditingController locationController = TextEditingController(
    text: 'egypt',
  );

  bool updatesOn = false;
  bool commentsOn = false;
  bool purchasesOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFddd),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48.r,
                backgroundColor: Colors.greenAccent.withOpacity(0.3),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    width: 90.w,
                    height: 90.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 60.sp);
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile information',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              buildLabeledInput('Name', nameController),
              buildLabeledInput('Email', emailController),
              buildLabeledInput('Location', locationController),

              // Bio
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  children: [
                    Text('Bio', style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 4.w),
                    Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_bold, size: 20.sp),
                        SizedBox(width: 12.w),
                        Icon(Icons.format_italic, size: 20.sp),
                        SizedBox(width: 12.w),
                        Icon(Icons.format_underline, size: 20.sp),
                        SizedBox(width: 12.w),
                        Icon(Icons.link, size: 20.sp),
                        SizedBox(width: 12.w),
                        Icon(Icons.format_list_bulleted, size: 20.sp),
                        Spacer(),
                        Icon(Icons.undo, size: 20.sp),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your bio...',
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              buildSwitchTile('Product updates', updatesOn, (value) {
                setState(() => updatesOn = value);
              }),
              Divider(),
              buildSwitchTile('Comments', commentsOn, (value) {
                setState(() => commentsOn = value);
              }),
              Divider(),
              buildSwitchTile('Purchases', purchasesOn, (value) {
                setState(() => purchasesOn = value);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabeledInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 4.w),
              Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 4.w),
              Icon(Icons.info_outline, size: 16.sp, color: Colors.grey),
            ],
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
