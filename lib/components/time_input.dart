import 'package:flutter/material.dart';
import 'package:qlkcl/utils/app_theme.dart';

class TimeInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controller;
  final String? helper;
  final String? maxDate;
  final bool showClearButton;
  final void Function()? onChangedFunction;
  final EdgeInsets? margin;

  TimeInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.helper,
    this.controller,
    this.maxDate,
    this.showClearButton = false,
    this.onChangedFunction,
    this.margin,
  }) : super(key: key);

  @override
  _TimeInputState createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  bool _focus = false;
  String hour = "00";
  String minute = "00";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null && widget.controller!.text != "") {
      hour = widget.controller!.text.split(':').first;
      minute = widget.controller!.text.split(':').last;
    }
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: (widget.controller != null &&
                    widget.controller!.text != "")
                ? TimeOfDay(hour: int.parse(hour), minute: int.parse(minute))
                : TimeOfDay.now(),
            builder: (context, childWidget) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      // Using 24-Hour format
                      alwaysUse24HourFormat: true),
                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                  child: childWidget!);
            },
            helpText: 'Chọn thời gian',
            cancelText: 'Hủy',
            confirmText: 'Chọn',
          );
          if (pickedTime != null) {
            setState(() {
              if (widget.controller != null) {
                widget.controller!.text =
                    '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
              }
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
          labelText: widget.required ? widget.label + " *" : widget.label,
          hintText: "HH:mm",
          suffixIcon: (widget.showClearButton &&
                  widget.controller != null &&
                  widget.controller!.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : const Icon(Icons.access_time),
          helperText: widget.helper,
          fillColor:
              !widget.enabled ? CustomColors.disable : CustomColors.white,
          filled: true, // dont forget this line
        ),
      ),
    );
  }
}
