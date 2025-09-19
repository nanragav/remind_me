import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              value != null
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
          width: value != null ? 2 : 1,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
            ),
            child: Text(
              hint,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
          ),
          value: value,
          items: items,
          onChanged: onChanged,
          icon: Padding(
            padding: EdgeInsets.only(
              right: ResponsiveHelper.getResponsiveSpacing(context, 16),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color:
                  value != null
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
              size: ResponsiveHelper.getResponsiveIconSize(context, 24),
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 8,
          menuMaxHeight: ResponsiveHelper.isSmallScreen(context) ? 250 : 300,
        ),
      ),
    );
  }
}
