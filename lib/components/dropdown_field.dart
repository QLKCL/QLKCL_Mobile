import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final String label;
  final String hint;
  final bool required;
  final List<String> itemValue;
  
  DropdownInput(
    {Key? key,
      required this.label,
      required this.hint,
      this.required: false,
      required this.itemValue })
      : super(key: key);
  

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  @override
  Widget build(BuildContext context) {
    var _valueSelected;
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DropdownButtonFormField(
         decoration: InputDecoration(labelText: widget.label, hintText: widget.hint),
         value: _valueSelected ?? widget.itemValue[0],
         items: widget.itemValue.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text('$item'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _valueSelected = value)),
      );
      
  }
}
