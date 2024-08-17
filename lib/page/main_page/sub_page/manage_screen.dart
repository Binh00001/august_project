import 'package:flutter/material.dart';
import 'package:flutter_project_august/assets_widget/navigator_container.dart';
import 'package:flutter_project_august/page/feature_page/school_manage.dart';
import 'package:flutter_project_august/page/feature_page/staff_manage.dart';
import 'package:flutter_project_august/page/feature_page/user_manage.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FeatureContainer(
                    primaryColor: const Color(0xFFF24E1E),
                    iconColor: const Color(0xFFF24E1E),
                    icon: Icons.list,
                    title: 'Trường học',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SchoolManageScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FeatureContainer(
                    primaryColor: const Color(0xFF5E72E4),
                    iconColor: const Color(0xFF5E72E4),
                    icon: Icons.shopping_cart,
                    title: 'Khách hàng',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => UserManagePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FeatureContainer(
                    primaryColor: const Color(0xFFA259FF),
                    iconColor: const Color(0xFFA259FF),
                    icon: Icons.assignment_ind,
                    title: 'Nhân viên',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => StaffManagePage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                    child: SizedBox(
                  width: 10,
                ))
                // Expanded(
                //   child: FeatureContainer(
                //     primaryColor: const Color(0xFF0ACF83),
                //     iconColor: const Color(0xFF0ACF83),
                //     icon: Icons.source,
                //     title: 'Nguồn gốc sản phẩm',
                //     onTap: () {
                //       // Handle tap
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
