import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  DropdownInput(
      {Key? key,
      required this.label,
      this.hint,
      this.required: false,
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
      this.popupTitle})
      : super(key: key);

  @override
  State<DropdownInput<T>> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: DropdownSearch<T>(
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: (widget.validator != null
            ? widget.validator
            : (value) {
                return (widget.required == true && value == null)
                    ? "Trường này là bắt buộc"
                    : null;
              }),
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
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
              )
            : null,
        emptyBuilder: (BuildContext context, t) => (Center(
          child: Text('Không có dữ liệu'),
        )),
        popupTitle: (widget.popupTitle != null && widget.popupTitle != "")
            ? Container(
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
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
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
  final List<T> selectedItems;
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

  MultiDropdownInput(
      {Key? key,
      required this.label,
      this.hint,
      this.required: false,
      this.itemValue,
      this.selectedItems = const [],
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
      this.popupTitle})
      : super(key: key);

  @override
  State<MultiDropdownInput<T>> createState() => _MultiDropdownInputState<T>();
}

class _MultiDropdownInputState<T> extends State<MultiDropdownInput<T>> {
  TextEditingController searchController = TextEditingController();
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
        selectedItems: widget.selectedItems,
        itemAsString: widget.itemAsString,
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
        searchFieldProps: widget.showSearchBox
            ? TextFieldProps(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
              )
            : null,
        dropdownBuilder: widget.dropdownBuilder,
        emptyBuilder: (BuildContext context, t) => (Center(
          child: Text('Không có dữ liệu'),
        )),
        popupTitle: (widget.popupTitle != null && widget.popupTitle != "")
            ? Container(
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
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              )
            : null,
      ),
    );
  }
}
