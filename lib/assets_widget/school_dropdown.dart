import 'package:flutter/material.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Import the dropdown_button2 package

class SchoolDropdown extends StatefulWidget {
  final String? selectedSchoolId;
  final Function(String?) onChanged;
  final List<School> schools;

  const SchoolDropdown({
    Key? key,
    this.selectedSchoolId,
    required this.onChanged,
    required this.schools,
  }) : super(key: key);

  @override
  _SchoolDropdownState createState() => _SchoolDropdownState();
}

class _SchoolDropdownState extends State<SchoolDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      dropdownStyleData: const DropdownStyleData(maxHeight: 240),
      decoration: InputDecoration(
        labelText: 'Chọn trường học',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: widget.selectedSchoolId,
      onChanged: widget.onChanged,
      items: _buildDropdownMenuItems(),
      isExpanded: true,
      alignment: Alignment.centerLeft,
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem<String>(
        value: null, // Null value for "All"
        child: Text(
          "Tất cả",
          style: const TextStyle(
            overflow: TextOverflow
                .ellipsis, // Automatically add ellipses if text is too long
          ),
        ),
      ),
    ];
    items.addAll(widget.schools.map((School school) {
      return DropdownMenuItem<String>(
        value: school.id,
        child: Text(
          school.name,
          style: const TextStyle(
            overflow: TextOverflow
                .ellipsis, // Automatically add ellipses if text is too long
          ),
        ),
      );
    }).toList());
    return items;
  }
}
