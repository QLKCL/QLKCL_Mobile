import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controller;
  final String? helper;
  final String? maxDate;

  DateInput({
    Key? key,
    required this.label,
    this.hint,
    this.required: false,
    this.enabled: true,
    this.helper,
    this.controller,
    this.maxDate,
  }) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                (widget.controller != null && widget.controller!.text != "")
                    ? DateFormat("dd/MM/yyyy").parse(widget.controller!.text)
                    : DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: (widget.maxDate != null)
                ? DateFormat("dd/MM/yyyy").parse(widget.maxDate!)
                : DateTime(2100),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            helpText: 'Chọn ngày',
            cancelText: 'Hủy',
            confirmText: 'Chọn',
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
            setState(() {
              if (widget.controller != null)
                widget.controller!.text = formattedDate;
            });
          }
        },
        validator: (value) {
          return (widget.required == true && value != null && value.isEmpty)
              ? "Trường này là bắt buộc"
              : null;
        },
        readOnly: true,
        enabled: widget.enabled,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.required ? widget.label + " \*" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: Icon(Icons.calendar_today),
          helperText: widget.helper,
        ),
      ),
    );
  }
}
