import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:trendycart_of_seller/core/theme/app_pallete.dart';

void openWhatsApp(String phone) async {
  final whatsappUrl = 'https://wa.me/+20$phone';
  try {
    launchUrl(
      Uri.parse(whatsappUrl),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: AppPallete.primaryColor,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: AppPallete.primaryColor,
        preferredControlTintColor: AppPallete.white,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    print(e.toString());
  }
}
