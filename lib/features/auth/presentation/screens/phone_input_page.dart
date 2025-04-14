import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trendycart_of_seller/features/auth/presentation/riverpod/auth_state.dart';

import '../../../../core/utils/show_snack_bar.dart';
import '../riverpod/auth_riverpod.dart';
import '../riverpod/auth_view_model.dart';
import 'otp_verification_page.dart';

class PhoneInputPage extends ConsumerWidget {
  final bool isSignUp;

  const PhoneInputPage({super.key, this.isSignUp = false});

  // void verifyPhone(BuildContext context, WidgetRef ref) {
  //   final viewModel = ref.read(authViewModelProvider);
  //   if (viewModel.formKey.currentState!.validate()) {
  //     if (isSignUp) {
  //       ref.read(authControllerProvider.notifier).signUpWithPhone(
  //             phone: viewModel.phoneController.text,
  //             name: viewModel.nameController.text,
  //           );
  //     } else {
  //       ref.read(authControllerProvider.notifier).signInWithPhone(
  //             phone: viewModel.phoneController.text,
  //           );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null) {
        showSnackBar(context, next.error!);
      } else if (next.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OTPVerificationPage(
                  phone: ref.read(authViewModelProvider).phoneController.text,
                ),
          ),
        );
      }
    });

    final viewModel = ref.watch(authViewModelProvider);
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isSignUp ? 'Sign Up' : 'Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              if (isSignUp)
                TextFormField(
                  controller: viewModel.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              TextFormField(
                controller: viewModel.phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefix: Text('+'),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (state.isLoading()) const CircularProgressIndicator(),
              // else
              //   ElevatedButton(
              //     onPressed: () => verifyPhone(context, ref),
              //     child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
