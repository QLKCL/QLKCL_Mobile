import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:qlkcl/helper/function.dart';

class DateInput extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final TextEditingController? controller;
  final String? helper;
  final String? minDate;
  final String? maxDate;
  final bool showClearButton;
  final EdgeInsets? margin;

  DateInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.helper,
    this.controller,
    this.minDate,
    this.maxDate,
    this.showClearButton = false,
    this.margin,
  }) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  bool _focus = false;
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null && widget.minDate != "") {
      minDate = DateFormat("dd/MM/yyyy").parse(widget.minDate!);
      minDate = minDate.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null && widget.maxDate != "") {
      maxDate = DateFormat("dd/MM/yyyy").parse(widget.maxDate!);
      maxDate = maxDate.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        onTap: () async {
          _focus = true;
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                (widget.controller != null && widget.controller!.text != "")
                    ? DateFormat("dd/MM/yyyy").parse(widget.controller!.text)
                    : DateTime.now(),
            firstDate: minDate,
            lastDate: maxDate,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            helpText: 'Chọn ngày',
            cancelText: 'Hủy',
            confirmText: 'Chọn',
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
            setState(() {
              if (widget.controller != null) {
                widget.controller!.text = formattedDate;
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
          hintText: "dd/mm/yyyy",
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
              : const Icon(Icons.calendar_today),
          helperText: widget.helper,
          fillColor:
              !widget.enabled ? CustomColors.disable : CustomColors.white,
          filled: true, // dont forget this line
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
  final String? minDate;
  final String? maxDate;
  final bool showClearButton;
  final EdgeInsets? margin;

  DateRangeInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.helper,
    this.controllerStart,
    this.controllerEnd,
    this.minDate,
    this.maxDate,
    this.showClearButton = false,
    this.margin,
  }) : super(key: key);

  @override
  _DateRangeInputState createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
  bool _focus = false;
  late TextEditingController controller;
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
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
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null && widget.minDate != "") {
      minDate = DateFormat("dd/MM/yyyy").parse(widget.minDate!);
      minDate = minDate.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null && widget.maxDate != "") {
      maxDate = DateFormat("dd/MM/yyyy").parse(widget.maxDate!);
      maxDate = maxDate.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            firstDate: minDate,
            lastDate: maxDate,
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
              if (widget.controllerStart != null) {
                widget.controllerStart!.text = formattedStartDate;
              }
              if (widget.controllerEnd != null) {
                widget.controllerEnd!.text = formattedEndDate;
              }
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
          labelText: widget.required ? widget.label + " *" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: (widget.showClearButton &&
                  controller.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    widget.controllerStart!.clear();
                    widget.controllerEnd!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : const Icon(Icons.calendar_today),
          helperText: widget.helper,
          fillColor:
              !widget.enabled ? CustomColors.disable : CustomColors.white,
          filled: true, // dont forget this line
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
  final String? minDate;
  final String? maxDate;
  final bool showClearButton;
  final void Function()? onChangedFunction;
  final EdgeInsets? margin;

  NewDateInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.helper,
    this.controller,
    this.minDate,
    this.maxDate,
    this.showClearButton = false,
    this.onChangedFunction,
    this.margin,
  }) : super(key: key);

  @override
  _NewDateInputState createState() => _NewDateInputState();
}

class _NewDateInputState extends State<NewDateInput> {
  bool _focus = false;
  String newDate = "";
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null && widget.minDate != "") {
      minDate = DateFormat("dd/MM/yyyy").parse(widget.minDate!);
      minDate = minDate.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null && widget.maxDate != "") {
      maxDate = DateFormat("dd/MM/yyyy").parse(widget.maxDate!);
      maxDate = maxDate.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      child: const Text('Hủy'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Chọn'),
                      onPressed: () {
                        if (newDate == "" && widget.controller!.text == "") {
                          widget.controller!.text = DateFormat('dd/MM/yyyy')
                              .format(DateTime.now())
                              .toString();
                        } else if (newDate != "") {
                          setState(() {
                            widget.controller!.text = newDate;
                          });
                        }
                        if (widget.onChangedFunction != null) {
                          widget.onChangedFunction!();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: Container(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        newDate = DateFormat('dd/MM/yyyy').format(data.value);
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        showTrailingAndLeadingDates: true,
                        dayFormat: 'EEE',
                      ),
                      minDate: minDate,
                      maxDate: maxDate,
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
                      showNavigationArrow: true,
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
          labelText: widget.required ? widget.label + " *" : widget.label,
          hintText: "dd/mm/yyyy",
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
              : const Icon(Icons.calendar_today),
          helperText: widget.helper,
          fillColor:
              !widget.enabled ? CustomColors.disable : CustomColors.white,
          filled: true, // dont forget this line
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
  final String? minDate;
  final String? maxDate;
  final bool showClearButton;
  final void Function()? onChangedFunction;
  final EdgeInsets? margin;

  NewDateRangeInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.helper,
    this.controllerStart,
    this.controllerEnd,
    this.minDate,
    this.maxDate,
    this.showClearButton = false,
    this.onChangedFunction,
    this.margin,
  }) : super(key: key);

  @override
  _NewDateRangeInputState createState() => _NewDateRangeInputState();
}

class _NewDateRangeInputState extends State<NewDateRangeInput> {
  bool _focus = false;
  late TextEditingController controller;
  String newStartDate = "";
  String newEndDate = "";
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
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
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null && widget.minDate != "") {
      minDate = DateFormat("dd/MM/yyyy").parse(widget.minDate!);
      minDate = minDate.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null && widget.maxDate != "") {
      maxDate = DateFormat("dd/MM/yyyy").parse(widget.maxDate!);
      maxDate = maxDate.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      child: const Text('Hủy'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Chọn'),
                      onPressed: () {
                        setState(() {
                          if (newStartDate == "" &&
                              widget.controllerStart != null &&
                              widget.controllerStart!.text == "") {
                            widget.controllerStart?.text =
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                    .toString();
                          } else if (newStartDate != "") {
                            widget.controllerStart!.text = newStartDate;
                          }
                          if (newEndDate == "" &&
                              widget.controllerEnd != null &&
                              widget.controllerEnd!.text == "") {
                            widget.controllerEnd?.text =
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                    .toString();
                          } else if (newEndDate != "") {
                            widget.controllerEnd!.text = newEndDate;
                          }

                          controller.text = '${widget.controllerStart!.text} -'
                              ' ${widget.controllerEnd!.text}';
                        });
                        if (widget.onChangedFunction != null) {
                          widget.onChangedFunction!();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: Container(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        newStartDate = DateFormat('dd/MM/yyyy')
                            .format(data.value.startDate);
                        newEndDate = data.value.endDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(data.value.endDate)
                            : DateFormat('dd/MM/yyyy')
                                .format(data.value.startDate);
                        controller.text =
                            '$newStartDate -                             $newEndDate';
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        showTrailingAndLeadingDates: true,
                        dayFormat: 'EEE',
                      ),
                      minDate: minDate,
                      maxDate: maxDate,
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
                      showNavigationArrow: true,
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
          labelText: widget.required ? widget.label + " *" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: (widget.showClearButton &&
                  controller.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    widget.controllerStart!.clear();
                    widget.controllerEnd!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : const Icon(Icons.calendar_today),
          helperText: widget.helper,
          fillColor:
              !widget.enabled ? CustomColors.disable : CustomColors.white,
          filled: true, // dont forget this line
        ),
      ),
    );
  }
}
