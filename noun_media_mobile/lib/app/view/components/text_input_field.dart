import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspired_blog/utils/functions.dart';

class FindemTextInput extends StatefulWidget {
  const FindemTextInput({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputAction,
    this.maxLines,
    this.decoration,
    this.autofillHints,
    this.obscureInput = false,
    this.suffix,
    this.prefix,
    this.maxLength,
    this.formatters,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final int? maxLines;
  final InputDecoration? decoration;
  final bool obscureInput;
  final Iterable<String>? autofillHints;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLength;
  final List<TextInputFormatter>? formatters;

  @override
  State<FindemTextInput> createState() => _FindemTextInputState();
}

class _FindemTextInputState extends State<FindemTextInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.obscureInput ? 1 : widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.inputAction ?? TextInputAction.next,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureInput ? obscure : false,
      maxLength: widget.maxLength,
      inputFormatters: widget.formatters,
      decoration: widget.decoration ??
          InputDecoration(
              isDense: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: widget.hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.primary)),
              fillColor: Colors.white,
              filled: true,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xff333333),
              ),
              suffixIcon: widget.obscureInput
                  ? GestureDetector(
                      onTap: () => setState(() => obscure = !obscure),
                      child: Icon(
                        obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                        color: Colors.black45,
                      ),
                    )
                  : widget.suffix,
              prefixIcon: widget.prefix),
    );
  }
}
