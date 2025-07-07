import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspired_blog_panel/utils/functions.dart';
import 'package:intl/intl.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    super.key,
    this.initValues,
    this.controller,
    this.validate,
    this.useObsecure = false,
    this.hint,
    this.inputAction = TextInputAction.next,
    this.autoFills,
    this.onSubmitted,
    this.onChanged,
    this.inputType,
    this.prefix,
    this.maxLines,
    this.enabled,
    this.inputFormatters,
  });

  final String? initValues;
  final TextEditingController? controller;
  final String? Function(String? value)? validate;
  final bool? useObsecure;
  final String? hint;
  final TextInputAction? inputAction;
  final Iterable<String>? autoFills;
  final Function(String? value)? onSubmitted;
  final Function(String? value)? onChanged;
  final TextInputType? inputType;
  final Widget? prefix;
  final int? maxLines;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TextInputWidget> createState() => TextInputWidgetState();
}

class TextInputWidgetState extends State<TextInputWidget> {
  bool invisiblePassword = false;

  @override
  void initState() {
    super.initState();
    invisiblePassword = widget.useObsecure ?? false;
  }

  InputDecoration _getDecoration({String? hintText}) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
        ));

    final visibleWidget = GestureDetector(
      onTap: () {
        setState(() {
          invisiblePassword = !invisiblePassword;
        });
      },
      child: Icon(invisiblePassword ? Icons.visibility_off : Icons.visibility),
    );

    return InputDecoration(
      filled: true,
      fillColor: const Color(0xfff1f1f1),
      enabledBorder: border,
      border: border,
      isDense: true,
      contentPadding: const EdgeInsets.all(10),
      suffixIcon: (widget.useObsecure ?? false)
          ? visibleWidget
          : const SizedBox.shrink(),
      hintText: hintText,
      prefixIcon: widget.prefix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      initialValue: widget.initValues,
      cursorColor: context.primary,
      cursorWidth: 1.2,
      obscureText: invisiblePassword,
      controller: widget.controller,
      autofillHints: widget.autoFills,
      textInputAction: widget.inputAction,
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      keyboardType: widget.inputType,
      decoration: _getDecoration(hintText: widget.hint),
      validator: widget.validate,
      enabled: widget.enabled,
      maxLines: widget.useObsecure! ? 1 : widget.maxLines,
      style:
          (widget.enabled ?? true) ? null : const TextStyle(color: Colors.grey),
      inputFormatters: widget.inputFormatters,
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters from the input value
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the cleaned input as an integer
    int intValue = int.tryParse(newText) ?? 0;

    // Format the integer as currency using NumberFormat
    String formattedValue = _formatter.format(intValue);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
