import 'package:flutter/material.dart';
import 'package:trendycart_of_seller/core/theme/text_style.dart';

class CustomTxtBtnSize extends StatefulWidget {
  final String str;

  const CustomTxtBtnSize({super.key, required this.str});

  @override
  _CustomTxtBtnState createState() => _CustomTxtBtnState();
}

class _CustomTxtBtnState extends State<CustomTxtBtnSize> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 35,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _isPressed = !_isPressed;
            });
            print(widget.str);
          },
          style: TextButton.styleFrom(
            backgroundColor:
                _isPressed ? Colors.grey.shade400 : Colors.transparent,
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: Text(widget.str, style: TextStyles.Raleway14mediuBlack),
        ),
      ),
    );
  }
}
