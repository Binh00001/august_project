import 'package:flutter/material.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/feature_page/order_list.dart';
import 'package:flutter_project_august/page/feature_page/product_list.dart';
import 'package:flutter_project_august/page/feature_page/revenue_page.dart';
import 'package:flutter_project_august/page/feature_page/statistic_page.dart';
import 'package:flutter_project_august/page/feature_page/task_page.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:flutter_project_august/assets_widget/navigator_container.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == AppConstants.defaultUser) {
      return const Scaffold(
        body: Center(child: Text("Lỗi khi tải thông tin người dùng")),
      );
    }

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
              if (widget.user.role == 'admin') ...[
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TaskPage(
                                      user: widget.user,
                                    )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FeatureContainer(
                        primaryColor: const Color(0xFFF24E1E),
                        iconColor: const Color(0xFFF24E1E),
                        icon: Icons.attach_money,
                        title: 'Doanh thu',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => RevenuePage()),
                          );
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const StatisticPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                    )),
                  ],
                ),
              ],
              if (widget.user.role == 'staff') ...[
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    TaskPage(user: widget.user)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                        child: SizedBox(
                      width: 10,
                    )),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
