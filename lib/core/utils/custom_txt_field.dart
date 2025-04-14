import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String hinttxt;
  final TextEditingController mycontroller;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hinttxt,
    required this.mycontroller,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: TextSelectionTheme(
        data: const TextSelectionThemeData(selectionColor: Colors.grey),
        child: TextFormField(
          controller: mycontroller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: hinttxt,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 168, 168, 168),
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 172, 172, 172),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 172, 172, 172),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
