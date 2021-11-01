import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String label;
  final String? hint;
  final bool obscure;
  final bool required;
  final TextInputType type;
  final bool enabled;
  final String? initValue;

  Input(
      {Key? key,
      required this.label,
      this.hint,
      this.obscure: false,
      this.required: false,
      this.type: TextInputType.text,
      this.enabled: true,
      this.initValue})
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
        // onSaved: (newValue) => password = newValue,
        initialValue: widget.initValue,
        onChanged: (value) {
          // if (value.isNotEmpty) {
          //   removeError(error: kPassNullError);
          // } else if (value.length >= 8) {
          //   removeError(error: kShortPassError);
          // }
          return null;
        },
        validator: (value) {
          // if (value!.isEmpty) {
          //   addError(error: kPassNullError);
          //   return "";
          // } else if (value.length < 8) {
          //   addError(error: kShortPassError);
          //   return "";
          // }
          return null;
        },
        enabled: widget.enabled,
        decoration: InputDecoration(
          labelText: widget.required ? widget.label + " \*" : widget.label,
          hintText: widget.hint,
        ),
        
      ),
    );
  }
}
