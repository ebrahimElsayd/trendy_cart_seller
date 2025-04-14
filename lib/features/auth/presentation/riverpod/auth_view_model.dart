import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel {
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final TextEditingController otpController;
  final GlobalKey<FormState> formKey;

  AuthViewModel()
    : phoneController = TextEditingController(),
      nameController = TextEditingController(),
      otpController = TextEditingController(),
      formKey = GlobalKey<FormState>();

  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    otpController.dispose();
  }
}

final authViewModelProvider = Provider.autoDispose<AuthViewModel>((ref) {
  final viewModel = AuthViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
