import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustompassTxtField extends StatelessWidget {
  final String hinttxt;
  final TextEditingController mycontroller;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const CustompassTxtField({
    super.key,
    required this.hinttxt,
    required this.mycontroller,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
    required this.obscureText,
    required this.onToggleVisibility,
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
          obscureText: obscureText,
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
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ),
    );
  }
}
