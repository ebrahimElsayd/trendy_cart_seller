// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../core/theme/text_style.dart';
// import '../../../home/presentation/widgets/custom_app_bar.dart';
// import '../../../home/presentation/widgets/custom_txt_btn.dart';
// import '../../../home/presentation/widgets/mainbar.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   final String phone;

//   OtpVerificationScreen({required this.phone});

//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();

//   Future<void> _verifyOtp() async {
//     try {
//       final otp = _otpController.text;

//       if (otp.isEmpty) {
//         throw Exception('Please enter the OTP.');
//       }

//       final response = await Supabase.instance.client.auth.verifyOTP(
//         phone: widget.phone,
//         token: otp,
//         type: OtpType.sms,
//       );

//       if (response.session == null) {
//         throw Exception('OTP failed. Check your phone number');
//       }

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone verified!')));
//       // Navigate to home or another screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainBar()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           //key: viewModel.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CustomAppBar(txt: "", hasArrow: true, hasIcons: false),
//               SizedBox(
//               height: 50,
//             ),
//               Text(
//               "Verification Code",
//               style: TextStyles.Inter28SemiBoldBlack,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//               Text('Enter the code sent to ${widget.phone}'),
//               const SizedBox(height: 40),
//             Image.asset(
//               "assets/images/forget_pass_img.png",
//               height: 166.h,
//               width: 225.w,
//             ),
//               const SizedBox(height: 70),
//               TextFormField(
//                 //controller: viewModel.otpController,
//                 decoration: const InputDecoration(labelText: 'OTP Code'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the OTP';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               if (state.isLoading())
//                 const CircularProgressIndicator()
//               else
//                 CustomTxtBtn(txtstyle: TextStyles.Lato16extraBoldBlack,bgclr: Color(0xFFF68B3B),btnHeight: 60,btnWidth: 345,btnradious: 14,
//                 btnName: "Confirm Code", onPress: (){verifyOTP(context, ref);}),
//                 Row(mainAxisAlignment: MainAxisAlignment.center,
//                   children: [Text("Didn’t get OTP? ",style: TextStyles.Lato16regularBlack,),
//             TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Resend OTP",
//                   style: TextStyles.Poppins14regularBlue,
//                 ),
//               ),
//             ],)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
