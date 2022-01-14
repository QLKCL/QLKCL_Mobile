import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controller;
  final String? helper;
  final String? maxDate;
  final bool showClearButton;

  DateInput({
    Key? key,
    required this.label,
    this.hint,
    this.required: false,
    this.enabled: true,
    this.helper,
    this.controller,
    this.maxDate,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  bool _focus = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
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
          suffixIcon: (widget.showClearButton &&
                  widget.controller != null &&
                  widget.controller!.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    widget.controller!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : Icon(Icons.calendar_today),
          helperText: widget.helper,
        ),
      ),
    );
  }
}

class DateRangeInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controllerStart;
  final TextEditingController? controllerEnd;
  final String? helper;
  final String? maxDate;
  final bool showClearButton;

  DateRangeInput({
    Key? key,
    required this.label,
    this.hint,
    this.required: false,
    this.enabled: true,
    this.helper,
    this.controllerStart,
    this.controllerEnd,
    this.maxDate,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  _DateRangeInputState createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
  bool _focus = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController(
        text: (widget.controllerStart != null &&
                widget.controllerStart!.text != "")
            ? ((widget.controllerEnd != null &&
                    widget.controllerEnd!.text != "")
                ? widget.controllerStart!.text +
                    " - " +
                    widget.controllerEnd!.text
                : widget.controllerStart!.text)
            : "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
          DateTimeRange? pickedDate = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
                start: (widget.controllerStart != null &&
                        widget.controllerStart!.text != "")
                    ? DateFormat("dd/MM/yyyy")
                        .parse(widget.controllerStart!.text)
                    : DateTime.now(),
                end: (widget.controllerEnd != null &&
                        widget.controllerEnd!.text != "")
                    ? DateFormat("dd/MM/yyyy").parse(widget.controllerEnd!.text)
                    : DateTime.now()),
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
            String formattedStartDate =
                DateFormat('dd/MM/yyyy').format(pickedDate.start);
            String formattedEndDate =
                DateFormat('dd/MM/yyyy').format(pickedDate.end);
            setState(() {
              if (widget.controllerStart != null)
                widget.controllerStart!.text = formattedStartDate;
              if (widget.controllerEnd != null)
                widget.controllerEnd!.text = formattedEndDate;
              controller.text = formattedStartDate + " - " + formattedEndDate;
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
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.required ? widget.label + " \*" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: (widget.showClearButton &&
                  controller.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    widget.controllerStart!.clear();
                    widget.controllerEnd!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : Icon(Icons.calendar_today),
          helperText: widget.helper,
        ),
      ),
    );
  }
}

class NewDateInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controller;
  final String? helper;
  final String? maxDate;
  final bool showClearButton;

  NewDateInput({
    Key? key,
    required this.label,
    this.hint,
    this.required: false,
    this.enabled: true,
    this.helper,
    this.controller,
    this.maxDate,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  _NewDateInputState createState() => _NewDateInputState();
}

class _NewDateInputState extends State<NewDateInput> {
  bool _focus = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    TextButton(
                      child: Text('Hủy'),
                      onPressed: () {
                        widget.controller!.text = "";
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Chọn'),
                      onPressed: () {
                        widget.controller!.text = DateFormat('dd/MM/yyyy')
                            .format(DateTime.now())
                            .toString();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: Container(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        setState(() {
                          widget.controller!.text =
                              DateFormat('dd/MM/yyyy').format(data.value);
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      minDate: DateTime(1900),
                      maxDate: (widget.maxDate != null)
                          ? DateFormat("dd/MM/yyyy").parse(widget.maxDate!)
                          : DateTime(2100),
                      initialSelectedDate: (widget.controller != null &&
                              widget.controller!.text != "")
                          ? DateFormat("dd/MM/yyyy")
                              .parse(widget.controller!.text)
                          : DateTime.now(),
                      initialDisplayDate: (widget.controller != null &&
                              widget.controller!.text != "")
                          ? DateFormat("dd/MM/yyyy")
                              .parse(widget.controller!.text)
                          : DateTime.now(),
                    ),
                  ),
                );
              });
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
          suffixIcon: (widget.showClearButton &&
                  widget.controller != null &&
                  widget.controller!.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    widget.controller!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : Icon(Icons.calendar_today),
          helperText: widget.helper,
        ),
      ),
    );
  }
}

class NewDateRangeInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controllerStart;
  final TextEditingController? controllerEnd;
  final String? helper;
  final String? maxDate;
  final bool showClearButton;

  NewDateRangeInput({
    Key? key,
    required this.label,
    this.hint,
    this.required: false,
    this.enabled: true,
    this.helper,
    this.controllerStart,
    this.controllerEnd,
    this.maxDate,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  _NewDateRangeInputState createState() => _NewDateRangeInputState();
}

class _NewDateRangeInputState extends State<NewDateRangeInput> {
  bool _focus = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController(
        text: (widget.controllerStart != null &&
                widget.controllerStart!.text != "")
            ? ((widget.controllerEnd != null &&
                    widget.controllerEnd!.text != "")
                ? widget.controllerStart!.text +
                    " - " +
                    widget.controllerEnd!.text
                : widget.controllerStart!.text)
            : "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    TextButton(
                      child: Text('Hủy'),
                      onPressed: () {
                        widget.controllerStart!.text = "";
                        widget.controllerEnd!.text = "";
                        controller.text = "";
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Chọn'),
                      onPressed: () {
                        if (widget.controllerStart != null &&
                            widget.controllerStart!.text == "") {
                          widget.controllerStart?.text =
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now())
                                  .toString();
                        }
                        if (widget.controllerEnd != null &&
                            widget.controllerEnd!.text == "") {
                          widget.controllerEnd?.text = DateFormat('dd/MM/yyyy')
                              .format(DateTime.now())
                              .toString();
                        }
                        controller.text = '${widget.controllerStart!.text} -'
                            ' ${widget.controllerEnd!.text}';
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: Container(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        setState(() {
                          widget.controllerStart!.text =
                              DateFormat('dd/MM/yyyy')
                                  .format(data.value.startDate);
                          widget.controllerEnd!.text = DateFormat('dd/MM/yyyy')
                              .format(
                                  data.value.endDate ?? data.value.startDate);
                          controller.text =
                              '${DateFormat('dd/MM/yyyy').format(data.value.startDate)} -'
                              ' ${DateFormat('dd/MM/yyyy').format(data.value.endDate ?? data.value.startDate)}';
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      minDate: DateTime(1900),
                      maxDate: (widget.maxDate != null)
                          ? DateFormat("dd/MM/yyyy").parse(widget.maxDate!)
                          : DateTime(2100),
                      initialSelectedRange: PickerDateRange(
                          (widget.controllerStart != null &&
                                  widget.controllerStart!.text != "")
                              ? DateFormat("dd/MM/yyyy")
                                  .parse(widget.controllerStart!.text)
                              : DateTime.now(),
                          (widget.controllerEnd != null &&
                                  widget.controllerEnd!.text != "")
                              ? DateFormat("dd/MM/yyyy")
                                  .parse(widget.controllerEnd!.text)
                              : DateTime.now()),
                    ),
                  ),
                );
              });
        },
        validator: (value) {
          return (widget.required == true && value != null && value.isEmpty)
              ? "Trường này là bắt buộc"
              : null;
        },
        readOnly: true,
        enabled: widget.enabled,
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.required ? widget.label + " \*" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: (widget.showClearButton &&
                  controller.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    widget.controllerStart!.clear();
                    widget.controllerEnd!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : Icon(Icons.calendar_today),
          helperText: widget.helper,
        ),
      ),
    );
  }
}
