import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trendycart_of_seller/core/utils/custom_app_bar.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_btn.dart';
import 'package:trendycart_of_seller/core/utils/custom_txt_field.dart';
import 'package:trendycart_of_seller/core/utils/show_snack_bar.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../riverpods/user_riverpod.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserRiverpodProvider).user!;

    ref.listen(userProvider, (previous, next) {
      if (next.isSuccess()) {
        ref
            .read(appUserRiverpodProvider.notifier)
            .updateUserData(
              user.copyWith(
                name: _nameController.text,
                phone: int.parse(_phoneController.text),
              ),
            );
        showSnackBar(context, "SUCCESS");
      } else if (next.isError()) {
        showSnackBar(context, "ERROR");
      }
    });

    final state = ref.watch(userProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:
              state.isLoading()
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomAppBar(
                        txt: 'Update Profile',
                        hasArrow: true,
                        hasIcons: false,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(0xFFFF9E56),
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hinttxt: "${user.name}",
                        mycontroller: _nameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hinttxt: "${user.phone}",
                        mycontroller: _phoneController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      CustomTxtBtn(
                        btnName: 'Update Profile',
                        btnWidth: 1,
                        btnHeight: 40,
                        btnradious: 20,
                        bgclr: Color(0xFFFF9E56),
                        txtstyle: const TextStyle(color: Colors.white),
                        onPress: () {
                          print(state.isLoading());
                          if (!state.isLoading()) {
                            ref
                                .read(userProvider.notifier)
                                .updateUser(
                                  user.id.toString(),
                                  _nameController.text,
                                  _phoneController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color.fromARGB(99, 83, 85, 85),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../home/presentation/widgets/custom_txt_field.dart';

// class UserInfoScreen extends ConsumerStatefulWidget {
//   const UserInfoScreen({super.key});

//   @override
//   State<UserInfoScreen> createState() => _UserInfoScreenState();
// }

// class _UserInfoScreenState extends State<UserInfoScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

//   }
// }

// return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Profile'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey,
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 16,
//                         backgroundColor: Colors.teal,
//                         child: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                     hinttxt: "Enter your Name",
//                     mycontroller: _nameController,
//                     textInputAction: TextInputAction.next,
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     hinttxt: "Enter your phone",
//                     mycontroller: _phoneController,
//                     textInputAction: TextInputAction.next,
//                   ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   'Update Profile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );\

//    final userId = ref.watch(appUserRiverpodProvider).user!.id!;
