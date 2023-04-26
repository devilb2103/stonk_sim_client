import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stonk_sim_client/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final FilteringTextInputFormatter formatter;
  final Function(String) onChanged;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.maxLines,
      required this.formatter,
      required this.onChanged});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      inputFormatters: [widget.formatter],
      style: const TextStyle(color: textColorLightGrey),
      maxLines: widget.maxLines,
      controller: widget.controller,
      decoration: InputDecoration(
          hintStyle: TextStyle(color: textColorDarkGrey),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black54),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.circular(15),
          ),
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          filled: true,
          fillColor: backgroundColor),
    );
  }
}
