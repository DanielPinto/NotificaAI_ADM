import 'package:flutter/material.dart';

class CustonTextField extends StatefulWidget {
  CustonTextField(
      {super.key,
      required this.onTap,
      required this.controller,
      required this.label,
      required this.icon,
      this.obscureText = false,
      this.minLines,
      this.maxLines = 1});

  Function onTap;
  TextEditingController controller;
  final String label;
  final Icon icon;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  @override
  State<CustonTextField> createState() => _CustonTextFieldState();
}

class _CustonTextFieldState extends State<CustonTextField> {
  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(50),
        elevation: 5.0,
        shadowColor: Colors.grey.shade300,
        child: TextField(
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          onTap: () => widget.onTap,
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: widget.icon,
            label: Text(widget.label),
            hintStyle: TextStyle(color: Colors.amber[600]),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
      );
}
