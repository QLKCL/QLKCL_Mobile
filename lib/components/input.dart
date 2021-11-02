import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String label;
  final String? hint;
  final bool obscure;
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

  Input(
      {Key? key,
      required this.label,
      this.hint,
      this.obscure: false,
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
      this.onSavedFunction})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  final List<String?> errors = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextFormField(
        obscureText: widget.obscure,
        keyboardType: widget.type,
        onSaved: widget.onSavedFunction,
        initialValue: widget.controller == null ? widget.initValue : null,
        onChanged: widget.onChangedFunction,
        validator: widget.validatorFunction,
        enabled: widget.enabled,
        controller: widget.controller,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
            labelText: widget.required ? widget.label + " \*" : widget.label,
            hintText: widget.hint,
            suffixIcon: (widget.showClearButton && widget.controller != null)
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller!.clear();
                    },
                  )
                : null,
            helperText: widget.helper,
            errorText: errors.isEmpty ? null : "error"),
      ),
    );
  }
}
