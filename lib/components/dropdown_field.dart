import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qlkcl/models/key_value.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';

// cre: https://pub.dev/packages/dropdown_search

class DropdownInput<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final List<T>? itemValue;
  final T? selectedItem;
  final String Function(T?)? itemAsString;
  final Mode mode;
  final String? helper;
  final bool showSearchBox;
  final bool showClearButton;
  final double? maxHeight;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final Future<List<T>> Function(String?)? onFind;
  final String? error;
  final bool Function(T?, T?)? compareFn;
  final String? popupTitle;
  final EdgeInsets? margin;
  final Key? widgetKey;

  const DropdownInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.itemValue,
    this.selectedItem,
    this.itemAsString,
    this.mode = Mode.MENU,
    this.helper,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.maxHeight,
    this.controller,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFind,
    this.error,
    this.compareFn,
    this.popupTitle,
    this.margin,
    this.widgetKey,
  }) : super(key: key);

  @override
  State<DropdownInput<T>> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DropdownSearch<T>(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        isFilteredOnline: true,
        key: widget.widgetKey,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator ??
            (value) {
              return (widget.required == true && value == null)
                  ? "Trường này là bắt buộc"
                  : null;
            },
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? "${widget.label} *" : widget.label,
          helperText: widget.helper,
          contentPadding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
          errorText: (widget.validator == null &&
                  widget.error != null &&
                  widget.error!.isNotEmpty)
              ? widget.error
              : null,
          fillColor: !widget.enabled ? disable : white,
          filled: true, // dont forget this line
        ),
        mode: widget.mode,
        showSelectedItems: T == String || widget.compareFn != null,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItem: widget.selectedItem,
        itemAsString: widget.itemAsString,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        enabled: widget.enabled,
        onFind: widget.onFind,
        compareFn: widget.compareFn,
        searchFieldProps: widget.showSearchBox
            ? TextFieldProps(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
              )
            : null,
        emptyBuilder: (BuildContext context, t) => const Center(
          child: Text('Không có dữ liệu'),
        ),
        popupTitle: (widget.popupTitle != null && widget.popupTitle != "")
            ? SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    widget.popupTitle!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            : null,
        popupShape: (widget.popupTitle != null && widget.popupTitle != "")
            ? widget.mode == Mode.BOTTOM_SHEET
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ))
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )
            : null,
        dialogMaxWidth: maxMobileSize,
      ),
    );
  }
}

class MultiDropdownInput<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final List<T>? itemValue;
  final List<T>? selectedItems;
  final Mode mode;
  final String? helper;
  final bool showSearchBox;
  final bool showClearButton;
  final double? maxHeight;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(List<T>?)? validator;
  final void Function(List<T>?)? onChanged;
  final void Function(List<T>?)? onSaved;
  final Future<List<T>> Function(String?)? onFind;
  final bool Function(T?, T?)? compareFn;
  final String? error;
  final Widget Function(BuildContext, List<T>)? dropdownBuilder;
  final String Function(T?)? itemAsString;
  final String? popupTitle;
  final EdgeInsets? margin;
  final Key? widgetKey;

  const MultiDropdownInput({
    Key? key,
    required this.label,
    this.hint,
    this.required = false,
    this.itemValue,
    this.selectedItems,
    this.mode = Mode.MENU,
    this.helper,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.maxHeight,
    this.controller,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFind,
    this.error,
    this.dropdownBuilder,
    this.compareFn,
    this.itemAsString,
    this.popupTitle,
    this.margin,
    this.widgetKey,
  }) : super(key: key);

  @override
  State<MultiDropdownInput<T>> createState() => _MultiDropdownInputState<T>();
}

class _MultiDropdownInputState<T> extends State<MultiDropdownInput<T>> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DropdownSearch<T>.multiSelection(
        // autoValidateMode: AutovalidateMode.onUserInteraction,
        isFilteredOnline: true,
        key: widget.widgetKey,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator ??
            (value) {
              return (widget.required == true &&
                      (value == null || value.isEmpty))
                  ? "Trường này là bắt buộc"
                  : null;
            },
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? "${widget.label} *" : widget.label,
          helperText: widget.helper,
          contentPadding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
          errorText: (widget.validator == null &&
                  widget.error != null &&
                  widget.error!.isNotEmpty)
              ? widget.error
              : null,
          fillColor: !widget.enabled ? disable : white,
          filled: true, // dont forget this line
        ),
        mode: widget.mode,
        showSelectedItems: T == String || widget.compareFn != null,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItems: widget.selectedItems ?? [],
        itemAsString: widget.itemAsString,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        enabled: widget.enabled,
        onFind: widget.onFind,
        compareFn: widget.compareFn,
        popupSelectionWidget: (context, T item, bool isSelected) {
          return isSelected
              ? Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                )
              : Container();
        },
        searchFieldProps: widget.showSearchBox
            ? TextFieldProps(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
              )
            : null,
        dropdownBuilder: widget.dropdownBuilder,
        dropdownBuilderSupportsNullItem: true,
        emptyBuilder: (BuildContext context, t) => const Center(
          child: Text('Không có dữ liệu'),
        ),
        popupTitle: (widget.popupTitle != null && widget.popupTitle != "")
            ? SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    widget.popupTitle!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            : null,
        popupShape: (widget.popupTitle != null && widget.popupTitle != "")
            ? widget.mode == Mode.BOTTOM_SHEET
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ))
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )
            : null,
        dialogMaxWidth: maxMobileSize,
      ),
    );
  }
}

Widget customDropDown(BuildContext context, List<KeyValue?> selectedItems) {
  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).primaryColorLight),
          child: Text(
            e!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }).toList(),
  );
}
