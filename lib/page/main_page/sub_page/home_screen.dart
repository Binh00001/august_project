import 'package:flutter/material.dart';
import 'package:flutter_project_august/page/feature_page/order_list.dart';
import 'package:flutter_project_august/page/feature_page/product_list.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:flutter_project_august/assets_widget/navigator_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      title: 'Danh sách sản phẩm',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ProductListScreen()),
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
                      title: 'Quản lý đơn hàng',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => OrderListPage()),
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
                      title: 'Phân công mua hàng',
                      onTap: () {
                        // Handle tap
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
                  Expanded(
                    child: FeatureContainer(
                      primaryColor: const Color(0xFFF24E1E),
                      iconColor: const Color(0xFFF24E1E),
                      icon: Icons.attach_money,
                      title: 'Doanh thu',
                      onTap: () {
                        // Handle tap
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
                      primaryColor: const Color(0xFF1ABCF3),
                      iconColor: const Color(0xFF1ABCF3),
                      icon: Icons.bar_chart,
                      title: 'Thống kê',
                      onTap: () {
                        // Handle tap
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                      child: SizedBox(
                    width: 10,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
