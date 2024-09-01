import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdown extends StatefulWidget {
  final List<dynamic> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String labelText;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      dropdownStyleData: const DropdownStyleData(maxHeight: 240),
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      value: widget.selectedValue,
      onChanged: widget.onChanged,
      isExpanded: true, // Makes the dropdown button fill its parent's width
      alignment:
          Alignment.centerLeft, // Aligns the selected item text to the left
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item.id,
          child: Text(item.name),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return widget.items.map((item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: const TextStyle(
                overflow: TextOverflow
                    .ellipsis, // Automatically add ellipses if text is too long
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
