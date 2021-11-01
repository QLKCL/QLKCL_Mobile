import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// cre: https://pub.dev/packages/dropdown_search

class DropdownInput<T> extends StatefulWidget {
  final String label;
  final String hint;
  final bool required;
  final List<T> itemValue;
  final T? selectedItem;
  final Mode mode;
  final String? helper;
  final bool showSearchBox;
  final bool showClearButton;
  final double? maxHeight;
  final TextEditingController? controller;

  DropdownInput(
      {Key? key,
      required this.label,
      required this.hint,
      this.required: false,
      required this.itemValue,
      this.selectedItem,
      this.mode = Mode.MENU,
      this.helper,
      this.showSearchBox = false,
      this.showClearButton = true,
      this.maxHeight,
      this.controller})
      : super(key: key);

  @override
  State<DropdownInput<T>> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DropdownSearch<T>(
        // validator: (v) => v == null ? "required field" : null,
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? widget.label + " \*" : widget.label,
          helperText: widget.helper,
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        ),
        mode: widget.mode,
        showSelectedItems: !widget.showSearchBox || T == String,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItem: widget.selectedItem,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        // onFind: (filter) => getData(filter),
        searchFieldProps: widget.controller != null
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
  final String hint;
  final bool required;
  final List<T> itemValue;
  final List<T> selectedItem;
  final Mode mode;
  final String? helper;
  final bool showSearchBox;
  final bool showClearButton;
  final double? maxHeight;

  MultiDropdownInput(
      {Key? key,
      required this.label,
      required this.hint,
      this.required: false,
      required this.itemValue,
      this.selectedItem = const [],
      this.mode = Mode.MENU,
      this.helper,
      this.showSearchBox = false,
      this.showClearButton = false,
      this.maxHeight})
      : super(key: key);

  @override
  State<MultiDropdownInput<T>> createState() => _MultiDropdownInputState<T>();
}

class _MultiDropdownInputState<T> extends State<MultiDropdownInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DropdownSearch<T>.multiSelection(
        // validator: (List<String>? v) {
        //   return v == null || v.isEmpty ? "required field" : null;
        // },
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.required ? widget.label + " \*" : widget.label,
          helperText: widget.helper,
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        ),
        mode: widget.mode,
        showSelectedItems: !widget.showSearchBox || T == String,
        showClearButton: widget.showClearButton,
        items: widget.itemValue,
        selectedItems: widget.selectedItem,
        showSearchBox: widget.showSearchBox,
        maxHeight: widget.maxHeight,
        // onFind: (filter) => getData(filter),
        popupSelectionWidget: (cnt, T item, bool isSelected) {
          return isSelected
              ? Icon(
                  Icons.check,
                  color: Colors.blue,
                )
              : Container();
        },
      ),
    );
  }
}
