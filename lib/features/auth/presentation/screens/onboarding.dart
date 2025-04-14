import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_btn.dart';
import 'package:trendycart_of_seller/features/auth/presentation/riverpod/login_riverpod.dart';
import 'package:trendycart_of_seller/features/auth/presentation/screens/signup_screen.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';

List imgs = [
  "assets/images/onboard1.png",
  "assets/images/onboard2.png",
  "assets/images/onboard3.png",
];
List titles = [
  "Welcome!",
  "Irrelevant results again?",
  "And that’s the cherry on top!",
];
List subtitles = [
  "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!",
  "No need to rummage through irrelevant items anymore, we got you covered. we send you relevant items based off of your habits and interests.",
  "No fees, free shipping and amazing customer service. We’ll get you your package within 2 business days no questions asked!",
];

class Onboard extends ConsumerStatefulWidget {
  const Onboard({super.key});

  @override
  ConsumerState<Onboard> createState() => _OnboardState();
}

class _OnboardState extends ConsumerState<Onboard> {
  late PageController _pageController;

  void markAsInstalled() {
    ref.read(appUserRiverpodProvider.notifier).saveInstallationFlag();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appUserRiverpod = ref.read(appUserRiverpodProvider.notifier);

    ref.listen(loginControllerProvider, (previous, next) {
      if (next.isError()) {
        showSnackBar(context, next.error!);
      } else if (next.isLoginAsGuestSuccess()) {
        appUserRiverpod.saveUserData(
          UserModel(name: "Guest", email: "Guest", password: "Guest"),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 19,
              ),
            ),
            onPressed:
                () => {
                  ref.read(loginControllerProvider.notifier).loginAsGuest(),
                },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imgs.length,
                    itemBuilder: (context, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Image.asset(imgs[i], width: 1300, height: 400),
                          const Spacer(),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${titles[i]}',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${subtitles[i]}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(flex: 3),
                          if (i == 0 || i == 1)
                            Row(
                              children: [
                                const Spacer(),
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      (i == 0)
                                          ? const Color.fromARGB(
                                            246,
                                            231,
                                            100,
                                            7,
                                          )
                                          : Colors.blue.shade100,
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      (i == 1)
                                          ? const Color.fromARGB(
                                            246,
                                            231,
                                            100,
                                            7,
                                          )
                                          : Colors.blue.shade100,
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.blue.shade100,
                                ),
                                const Spacer(),
                              ],
                            ),
                          SizedBox(height: 18.h),
                          if (i == 0 || i == 1)
                            CustomTxtBtn(
                              btnName: "Next",
                              onPress: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease,
                                );
                              },
                              bgclr: const Color(0xFFF68B3B),
                              btnradious: 15,
                              btnWidth: 327,
                              btnHeight: 48,
                              txtstyle: TextStyles.Lato16extraBoldBlack,
                            ),
                          if (i == 2)
                            Column(
                              children: [
                                CustomTxtBtn(
                                  btnName: "Sign me up!",
                                  onPress: () {
                                    markAsInstalled();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignupScreen(),
                                      ),
                                    );
                                  },
                                  bgclr: const Color(0xFFF68B3B),
                                  btnradious: 15,
                                  btnWidth: 327,
                                  btnHeight: 48,
                                  txtstyle: TextStyles.Lato16extraBoldBlack,
                                ),
                                SizedBox(height: 10.h),
                                ref.watch(loginControllerProvider).isLoading()
                                    ? CircularProgressIndicator()
                                    : CustomTxtBtn(
                                      btnName: "Ask me later",
                                      onPress: () {
                                        ref
                                            .read(
                                              loginControllerProvider.notifier,
                                            )
                                            .loginAsGuest();
                                      },
                                      bgclr: const Color(0xFFE8E8E8),
                                      btnradious: 15,
                                      btnWidth: 327,
                                      btnHeight: 48,
                                      txtstyle: TextStyles.Lato16boldlightBlack,
                                    ),
                              ],
                            ),
                          SizedBox(height: 20.h),
                        ],
                      );
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
