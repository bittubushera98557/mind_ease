import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppTextFieldState {
  normal,
  valid,
  error,
}

/// MindEase Custom Input Field
class AppTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final AppTextFieldState state;
  final bool readOnly;
  final FocusNode? focusNode;

  const AppTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.state = AppTextFieldState.normal,
    this.readOnly = false,
    this.focusNode,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  Color _getBorderColor() {
    if (widget.state == AppTextFieldState.error || widget.errorText != null) {
      return AppColors.inputBorderError;
    }
    if (widget.state == AppTextFieldState.valid) {
      return AppColors.inputBorderValid;
    }
    if (_isFocused) {
      return AppColors.inputBorderFocused;
    }
    return AppColors.inputBorder;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _getBorderColor();
    final hasError = widget.state == AppTextFieldState.error || widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTypography.inputLabel,
        ),
        const SizedBox(height: 7),

        // Text Field Container (Fully rounded pill sides)
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: borderColor,
              width: (widget.state == AppTextFieldState.valid || hasError || _isFocused) ? 1.5 : 1.1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.controller == null ? widget.initialValue : null,
            focusNode: _focusNode,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: AppTypography.inputText,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              hintStyle: AppTypography.inputHint,
              contentPadding: EdgeInsets.only(
                left: widget.prefixIcon != null ? 0 : 20,
                right: widget.isPassword || widget.suffixIcon != null ? 0 : 20,
                top: 13,
                bottom: 13,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: false,
              prefixIconConstraints: const BoxConstraints(minWidth: 48, maxHeight: 24),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, right: 10),
                      child: Icon(
                        widget.prefixIcon,
                        size: 19,
                        color: hasError ? AppColors.inputBorderError : AppColors.inputPrefixIcon,
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 48, maxHeight: 24),
              suffixIcon: widget.isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.inputSuffixIcon,
                        ),
                        splashRadius: 18,
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    )
                  : widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: widget.suffixIcon,
                        )
                      : null,
            ),
          ),
        ),

        // Helper or Error text below field
        if (hasError && widget.errorText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              widget.errorText!,
              style: AppTypography.inputError,
            ),
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              widget.helperText!,
              style: AppTypography.inputHelper,
            ),
          ),
        ],
      ],
    );
  }
}
