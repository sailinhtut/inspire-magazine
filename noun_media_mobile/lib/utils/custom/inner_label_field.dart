import 'package:flutter/material.dart';

class InnerLabelField extends StatefulWidget {
  final TextEditingController? controller;
  final double? cursorWidth;
  final Color? cursorColor;
  final double? cursorHeight;
  final String? label;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Decoration Function(bool onFocus)? decorationBuilder;
  final String? Function(String? value)? validator;
  final VoidCallback? onFieldSubmitted;
  final void Function()? onTap;
  final void Function(String? value)? onChanged;
  final bool? obsecureText;
  final Widget? invisibleIcon;
  final Widget? visibleIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;

  const InnerLabelField({
    Key? key,
    this.controller,
    this.cursorWidth,
    this.cursorColor,
    this.cursorHeight,
    this.label,
    this.labelStyle,
    this.textStyle,
    this.decorationBuilder,
    this.validator,
    this.onFieldSubmitted,
    this.onTap,
    this.onChanged,
    this.obsecureText,
    this.invisibleIcon,
    this.visibleIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.prefix,
    this.suffix,
    this.maxLength,
  }) : super(key: key);

  @override
  State<InnerLabelField> createState() => _InnerLabelFieldState();
}

class _InnerLabelFieldState extends State<InnerLabelField> {
  final focusNode = FocusNode();
  bool invisibleValue = false;

  @override
  void initState() {
    super.initState();

    invisibleValue = widget.obsecureText ?? false;

    focusNode.addListener(() {
      setState(() {});
    });
  }

  InputDecoration getDecoration() {
    const border = InputBorder.none;
    final visibilityWidget = GestureDetector(
      onTap: () => setState(() => invisibleValue = !invisibleValue),
      child: invisibleValue
          ? widget.invisibleIcon ??
              const Icon(Icons.visibility_off, size: 17, color: Colors.grey)
          : widget.visibleIcon ??
              const Icon(Icons.visibility, size: 17, color: Colors.grey),
    );

    return InputDecoration(
      border: border,
      errorBorder: border,
      focusedBorder: border,
      enabledBorder: border,
      isDense: true,
      contentPadding: const EdgeInsets.only(bottom: 3),
      labelText: widget.label,
      labelStyle: widget.labelStyle,
      suffix: widget.obsecureText != null && widget.obsecureText!
          ? visibilityWidget
          : widget.suffix,
      prefixIcon: widget.prefix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: widget.decorationBuilder?.call(focusNode.hasFocus),
      child: TextFormField(
        focusNode: focusNode,
        controller: widget.controller,
        cursorColor: widget.cursorColor,
        cursorWidth: widget.cursorWidth ?? 2.0,
        cursorHeight: widget.cursorHeight,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        validator: widget.validator,
        decoration: getDecoration(),
        obscureText: invisibleValue,
        maxLength: widget.maxLength,
        buildCounter:
            (context, {int? currentLength, bool? isFocused, maxLength}) => null,
      ),
    );
  }
}
