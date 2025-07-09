import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSearchWidget<T> extends StatelessWidget {
  final T? value;
  final String title;
  final Icon prefixIcon;
  final List<T> dropdownItemList;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  const DropdownSearchWidget({
    super.key,
    required this.value,
    required this.dropdownItemList,
    required this.onChanged,
    this.validator,
    required this.title,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      selectedItem: value,
      popupProps: PopupProps.bottomSheet(
        itemBuilder: (context, item, isDisabled, isSelected) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    leading: prefixIcon,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text(
                      item as String,
                      style: AppTextStyles.body3(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainBlack,
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          );
        },
        title: Container(
          decoration: BoxDecoration(
            color: AppColors.mainLightBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: AppTextStyles.heading3(
              fontWeight: FontWeight.w600,
              color: AppColors.mainWhite.withValues(alpha: 0.85),
            ),
          ),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.mainBlack, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.mainRed, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.mainRed, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.mainGrey, width: 1.5),
          ),
        ),
      ),
      validator: validator,
      items: (filter, loadProps) {
        return dropdownItemList;
      },
      onChanged: onChanged,
    );
  }
}
