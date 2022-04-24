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

  const DateInput({
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () async {
          _focus = true;
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                (widget.controller != null && widget.controller!.text != "")
                    ? DateFormat("dd/MM/yyyy")
                        .parse(widget.controller!.text)
                        .toLocal()
                    : DateTime.now(),
            firstDate: minDate,
            lastDate: maxDate,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            helpText: 'Chọn ngày',
            cancelText: 'Hủy',
            confirmText: 'Chọn',
          );
          if (pickedDate != null) {
            final String formattedDate =
                DateFormat('dd/MM/yyyy').format(pickedDate);
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
          labelText: widget.required ? "${widget.label} *" : widget.label,
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
          fillColor: !widget.enabled ? disable : white,
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

  const DateRangeInput({
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
                ? "${widget.controllerStart!.text} - ${widget.controllerEnd!.text}"
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () async {
          _focus = true;
          final DateTimeRange? pickedDate = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
                start: (widget.controllerStart != null &&
                        widget.controllerStart!.text != "")
                    ? DateFormat("dd/MM/yyyy")
                        .parse(widget.controllerStart!.text)
                        .toLocal()
                    : DateTime.now(),
                end: (widget.controllerEnd != null &&
                        widget.controllerEnd!.text != "")
                    ? DateFormat("dd/MM/yyyy")
                        .parse(widget.controllerEnd!.text)
                        .toLocal()
                    : DateTime.now()),
            firstDate: minDate,
            lastDate: maxDate,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            helpText: 'Chọn ngày',
            cancelText: 'Hủy',
            confirmText: 'Chọn',
          );
          if (pickedDate != null) {
            final String formattedStartDate =
                DateFormat('dd/MM/yyyy').format(pickedDate.start);
            final String formattedEndDate =
                DateFormat('dd/MM/yyyy').format(pickedDate.end);
            setState(() {
              if (widget.controllerStart != null) {
                widget.controllerStart!.text = formattedStartDate;
              }
              if (widget.controllerEnd != null) {
                widget.controllerEnd!.text = formattedEndDate;
              }
              controller.text = "$formattedStartDate - $formattedEndDate";
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
          labelText: widget.required ? "${widget.label} *" : widget.label,
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
          fillColor: !widget.enabled ? disable : white,
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
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool showClearButton;
  final void Function()? onChangedFunction;
  final EdgeInsets? margin;
  final bool autoValidate;
  final String? defaultTime;

  const NewDateInput({
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
    this.autoValidate = true,
    this.defaultTime,
  }) : super(key: key);

  @override
  _NewDateInputState createState() => _NewDateInputState();
}

class _NewDateInputState extends State<NewDateInput> {
  bool _focus = false;
  String newDate = "";
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);
  late TextEditingController showDateController;

  @override
  void initState() {
    super.initState();
    showDateController = TextEditingController(
        text: widget.controller!.text.isNotEmpty
            ? DateFormat("dd/MM/yyyy")
                .format(DateTime.parse(widget.controller!.text).toLocal())
            : "");
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null) {
      minDate = widget.minDate!.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null) {
      maxDate = widget.maxDate!.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        autovalidateMode:
            widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
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
                          widget.controller!.text =
                              DateTime.now().toIso8601String();
                        } else if (newDate != "") {
                          setState(() {
                            widget.controller!.text = newDate;
                          });
                        }
                        showDateController.text = DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(widget.controller!.text)
                                .toLocal());
                        widget.onChangedFunction?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        if (widget.defaultTime != null) {
                          final int hour =
                              int.parse(widget.defaultTime!.split(':').first);
                          final int minute =
                              int.parse(widget.defaultTime!.split(':').last);
                          newDate = (data.value as DateTime)
                              .copyWith(hour: hour, minute: minute)
                              .toIso8601String();
                        } else {
                          newDate = (data.value as DateTime).toIso8601String();
                        }
                      },
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        showTrailingAndLeadingDates: true,
                        dayFormat: 'EEE',
                      ),
                      minDate: minDate,
                      maxDate: maxDate,
                      initialSelectedDate: (widget.controller != null &&
                              widget.controller!.text != "")
                          ? DateTime.parse(widget.controller!.text).toLocal()
                          : DateTime.now(),
                      initialDisplayDate: (widget.controller != null &&
                              widget.controller!.text != "")
                          ? DateTime.parse(widget.controller!.text).toLocal()
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
        controller: showDateController,
        decoration: InputDecoration(
          labelText: widget.required ? "${widget.label} *" : widget.label,
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
          fillColor: !widget.enabled ? disable : white,
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
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool showClearButton;
  final void Function()? onChangedFunction;
  final EdgeInsets? margin;
  final bool autoValidate;
  final String? defaultTime;

  const NewDateRangeInput({
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
    this.autoValidate = true,
    this.defaultTime,
  }) : super(key: key);

  @override
  _NewDateRangeInputState createState() => _NewDateRangeInputState();
}

class _NewDateRangeInputState extends State<NewDateRangeInput> {
  bool _focus = false;
  late TextEditingController showDateController;
  String newStartDate = "";
  String newEndDate = "";
  DateTime minDate = DateTime(1900);
  DateTime maxDate = DateTime(2100);

  @override
  void initState() {
    super.initState();
    showDateController = TextEditingController(
        text: (widget.controllerStart != null &&
                widget.controllerStart!.text != "")
            ? ((widget.controllerEnd != null &&
                    widget.controllerEnd!.text != "")
                ? "${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.controllerStart!.text).toLocal())} - ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.controllerEnd!.text).toLocal())}"
                : DateFormat("dd/MM/yyyy").format(
                    DateTime.parse(widget.controllerStart!.text).toLocal()))
            : "");
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.minDate != null) {
      minDate = widget.minDate!.copyWith(hour: 0, minute: 0);
    }
    if (widget.maxDate != null) {
      maxDate = widget.maxDate!.copyWith(hour: 23, minute: 59);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextFormField(
        autovalidateMode:
            widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
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
                                DateTime.now().toIso8601String();
                          } else if (newStartDate != "") {
                            widget.controllerStart!.text = newStartDate;
                          }
                          if (newEndDate == "" &&
                              widget.controllerEnd != null &&
                              widget.controllerEnd!.text == "") {
                            widget.controllerEnd?.text =
                                DateTime.now().toIso8601String();
                          } else if (newEndDate != "") {
                            widget.controllerEnd!.text = newEndDate;
                          }

                          showDateController.text =
                              '${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.controllerStart!.text).toLocal())} -'
                              ' ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.controllerEnd!.text).toLocal())}';
                        });
                        widget.onChangedFunction?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (data) {
                        if (widget.defaultTime != null) {
                          final int hour =
                              int.parse(widget.defaultTime!.split(':').first);
                          final int minute =
                              int.parse(widget.defaultTime!.split(':').last);
                          newStartDate = (data.value.startDate as DateTime)
                              .copyWith(hour: hour, minute: minute)
                              .toIso8601String();
                          newEndDate = data.value.endDate != null
                              ? (data.value.endDate as DateTime)
                                  .copyWith(hour: hour, minute: minute)
                                  .toIso8601String()
                              : (data.value.startDate as DateTime)
                                  .copyWith(hour: hour, minute: minute)
                                  .toIso8601String();
                        } else {
                          newStartDate = data.value.startDate.toIso8601String();
                          newEndDate = data.value.endDate != null
                              ? data.value.endDate.toIso8601String()
                              : data.value.startDate.toIso8601String();
                        }
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        showTrailingAndLeadingDates: true,
                        dayFormat: 'EEE',
                      ),
                      minDate: minDate,
                      maxDate: maxDate,
                      initialSelectedRange: PickerDateRange(
                          (widget.controllerStart != null &&
                                  widget.controllerStart!.text != "")
                              ? DateTime.parse(widget.controllerStart!.text)
                                  .toLocal()
                              : DateTime.now(),
                          (widget.controllerEnd != null &&
                                  widget.controllerEnd!.text != "")
                              ? DateTime.parse(widget.controllerEnd!.text)
                                  .toLocal()
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
        controller: showDateController,
        decoration: InputDecoration(
          labelText: widget.required ? "${widget.label} *" : widget.label,
          hintText: "dd/mm/yyyy",
          suffixIcon: (widget.showClearButton &&
                  showDateController.text != "" &&
                  _focus == true)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    showDateController.clear();
                    widget.controllerStart!.clear();
                    widget.controllerEnd!.clear();
                    _focus = false;
                    setState(() {});
                  },
                )
              : const Icon(Icons.calendar_today),
          helperText: widget.helper,
          fillColor: !widget.enabled ? disable : white,
          filled: true, // dont forget this line
        ),
      ),
    );
  }
}
