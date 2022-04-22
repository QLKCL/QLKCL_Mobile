import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlkcl/utils/app_theme.dart';

class Input extends StatefulWidget {
  final String label;
  final String? hint;
  final bool? obscure;
  final bool required;
  final TextInputType type;
  final bool enabled;
  final String? initValue;
  final String? helper;
  final bool showClearButton;
  final TextEditingController? controller;
  final int? maxLength;
  final String? Function(String?)? validatorFunction;
  final void Function(String)? onChangedFunction;
  final void Function(String?)? onSavedFunction;
  final String? error;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final IconData? prefixIcon;
  final EdgeInsets? margin;
  final bool autoValidate;

  const Input({
    Key? key,
    required this.label,
    this.hint,
    this.obscure,
    this.required = false,
    this.type = TextInputType.text,
    this.enabled = true,
    this.initValue,
    this.helper,
    this.showClearButton = true,
    this.controller,
    this.maxLength,
    this.validatorFunction,
    this.onChangedFunction,
    this.onSavedFunction,
    this.error,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.margin,
    this.autoValidate = true,
  }) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _focus = false;
  bool? _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formater = <TextInputFormatter>[];
    if (widget.type == TextInputType.number) {
      formater.add(FilteringTextInputFormatter.singleLineFormatter);
    }
    if (widget.textCapitalization == TextCapitalization.characters) {
      formater.add(UpperCaseTextFormatter());
    } else if (widget.textCapitalization == TextCapitalization.words) {
      formater.add(TitleCaseInputFormatter());
    } else if (widget.textCapitalization == TextCapitalization.sentences) {
      formater.add(CapitalCaseTextFormatter());
    }

    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        autovalidateMode:
            widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
        onTap: () {
          _focus = true;
        },
        obscureText: _obscure ?? false,
        keyboardType: widget.type,
        onSaved: widget.onSavedFunction,
        initialValue: widget.initValue,
        onChanged: (value) {
          widget.onChangedFunction?.call(value);

          if (widget.controller != null && widget.controller!.text != "") {
            setState(() {});
          }
        },
        validator: (value) {
          String? Function(String?)? valid = widget.validatorFunction;
          if (valid == null || valid(value) == null || valid(value) == "") {
            valid = (value) {
              return (widget.required == true && value != null && value.isEmpty)
                  ? "Trường này là bắt buộc"
                  : null;
            };
          }
          return valid(value);
        },
        //  (widget.validatorFunction != null
        //     ? widget.validatorFunction
        //     : (value) {
        //         return (widget.required == true &&
        //                 value != null &&
        //                 value.isEmpty)
        //             ? "Trường này là bắt buộc"
        //             : null;
        //       }),
        enabled: widget.enabled,
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.required ? "${widget.label} *" : widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                )
              : null,
          suffixIcon: _obscure != null
              ? (IconButton(
                  icon: Icon(
                    (_obscure ?? false)
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    _obscure = !_obscure!;
                    setState(() {});
                  },
                ))
              : ((widget.showClearButton &&
                      widget.controller != null &&
                      widget.controller!.text != "" &&
                      _focus == true)
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller!.clear();
                        widget.onChangedFunction?.call("");
                        setState(() {});
                      },
                    )
                  : null),
          helperText: widget.helper,
          errorText: (widget.error != null && widget.error!.isNotEmpty)
              ? widget.error
              : null,
          fillColor: !widget.enabled ? disable : white,
          filled: true, // dont forget this line
        ),

        textCapitalization: widget.textCapitalization,
        inputFormatters: formater, // Only numbers can be entered
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class TitleCaseInputFormatter extends TextInputFormatter {
  String textToTitleCase(String text) {
    if (text.length > 1) {
      return text[0].toUpperCase() + text.substring(1);
      /*or text[0].toUpperCase() + text.substring(1).toLowerCase(), if you want absolute title case*/
    } else if (text.length == 1) {
      return text[0].toUpperCase();
    }

    return '';
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String formattedText =
        newValue.text.split(' ').map(textToTitleCase).toList().join(' ');
    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}

class CapitalCaseTextFormatter extends TextInputFormatter {
  String capitalizeSentence(String text) {
    // Each sentence becomes an array element
    final sentences = text.split('. ');
    // Initialize string as empty string
    var output = '';
    // Loop through each sentence
    for (var x = 0; x < sentences.length; x++) {
      // Trim leading and trailing whitespace
      // var trimmed = sentences[x].trim();
      final trimmed = sentences[x];
      if (trimmed != "") {
        // Capitalize first letter of current sentence
        final capitalized = trimmed[0].toUpperCase() + trimmed.substring(1);
        // Add current sentence to output with a period
        output += capitalized;
        if (x < sentences.length - 1) {
          output += ". ";
        }
      }
    }
    return output;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String formattedText = capitalizeSentence(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}
