import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// cre: https://pub.dev/packages/dropdown_search

class DropdownInput<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final List<T> itemValue;
  final T? selectedItem;
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

  DropdownInput(
      {Key? key,
      required this.label,
      this.hint,
      this.required: false,
      required this.itemValue,
      this.selectedItem,
      this.mode = Mode.MENU,
      this.helper,
      this.showSearchBox = false,
      this.showClearButton = true,
      this.maxHeight,
      this.controller,
      this.enabled = true,
      this.validator,
      this.onChanged,
      this.onSaved,
      this.onFind,
      this.error})
      : super(key: key);

  @override
  State<DropdownInput<T>> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DropdownSearch<T>(
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator,
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? widget.label + " \*" : widget.label,
          helperText: widget.helper,
          contentPadding: EdgeInsets.fromLTRB(12, 4, 0, 4),
          errorText: (widget.validator == null &&
                  widget.error != null &&
                  widget.error!.isNotEmpty)
              ? widget.error
              : null,
        ),
        mode: widget.mode,
        showSelectedItems: !widget.showSearchBox || T == String,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItem: widget.selectedItem,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        enabled: widget.enabled,
        onFind: widget.onFind,
        searchFieldProps: (widget.showSearchBox && widget.controller != null)
            ? TextFieldProps(
                controller: widget.controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller!.clear();
                    },
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class MultiDropdownInput<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final bool required;
  final List<T>? itemValue;
  final List<T> selectedItem;
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

  MultiDropdownInput(
      {Key? key,
      required this.label,
      this.hint,
      this.required: false,
      this.itemValue,
      this.selectedItem = const [],
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
      this.compareFn})
      : super(key: key);

  @override
  State<MultiDropdownInput<T>> createState() => _MultiDropdownInputState<T>();
}

class _MultiDropdownInputState<T> extends State<MultiDropdownInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DropdownSearch<T>.multiSelection(
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator,
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? widget.label + " \*" : widget.label,
          helperText: widget.helper,
          contentPadding: EdgeInsets.fromLTRB(12, 4, 0, 4),
          errorText: (widget.validator == null &&
                  widget.error != null &&
                  widget.error!.isNotEmpty)
              ? widget.error
              : null,
        ),
        mode: widget.mode,
        showSelectedItems: !widget.showSearchBox || T == String,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItems: widget.selectedItem,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        enabled: widget.enabled,
        onFind: widget.onFind,
        compareFn: widget.compareFn,
        popupSelectionWidget: (context, T item, bool isSelected) {
          return isSelected
              ? Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                )
              : Container();
        },
        searchFieldProps: (widget.showSearchBox && widget.controller != null)
            ? TextFieldProps(
                controller: widget.controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller!.clear();
                    },
                  ),
                ),
              )
            : null,
        dropdownBuilder: widget.dropdownBuilder,
      ),
    );
  }
}
