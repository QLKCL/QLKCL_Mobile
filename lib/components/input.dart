import 'package:flutter/material.dart';

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

  Input(
      {Key? key,
      required this.label,
      this.hint,
      this.obscure,
      this.required: false,
      this.type: TextInputType.text,
      this.enabled: true,
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
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _focus = false;
  bool? obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 00),
      child: TextFormField(
        onTap: () {
          _focus = true;
        },
        obscureText: obscure != null ? obscure! : false,
        keyboardType: widget.type,
        onSaved: widget.onSavedFunction,
        initialValue: widget.initValue,
        onChanged: (value) {
          if (widget.onChangedFunction != null)
            widget.onChangedFunction!(value);
          if (widget.controller != null && widget.controller!.text != "")
            setState(() {});
        },
        validator: (widget.validatorFunction != null
            ? widget.validatorFunction
            : (value) {
                return (widget.required == true &&
                        value != null &&
                        value.isEmpty)
                    ? "Trường này là bắt buộc"
                    : null;
              }),
        enabled: widget.enabled,
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
            labelText: widget.required ? widget.label + " \*" : widget.label,
            hintText: widget.hint,
            suffixIcon: obscure != null
                ? (IconButton(
                    icon: Icon(
                      obscure == true ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      obscure = !obscure!;
                      setState(() {});
                    },
                  ))
                : ((widget.showClearButton &&
                        widget.controller != null &&
                        widget.controller!.text != "" &&
                        _focus == true)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          widget.controller!.clear();
                          setState(() {});
                        },
                      )
                    : null),
            helperText: widget.helper,
            errorText: (widget.validatorFunction == null &&
                    widget.error != null &&
                    widget.error!.isNotEmpty)
                ? widget.error
                : null),
        textCapitalization: widget.textCapitalization,
      ),
    );
  }
}
