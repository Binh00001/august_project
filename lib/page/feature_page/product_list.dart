import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/product_widget.dart';
import 'package:flutter_project_august/blocs/cart/cart_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_event.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_bloc.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_event.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_state.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_event.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_state.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/feature_page/cart_page.dart';
import 'package:flutter_project_august/page/feature_page/create_product.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:input_quantity/input_quantity.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? selectedCategory;
  String? selectedOrigin;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
    // Load user information
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    _user = await SharedPreferencesHelper.getUserInfo();
    setState(() {});
  }

  void _loadProducts() {
    BlocProvider.of<ProductBloc>(context).add(
      FetchProducts(
        page: 1,
        pageSize: 10,
        categoryId: selectedCategory,
        originId: selectedOrigin,
      ),
    );
  }

  void _loadCategories() {
    BlocProvider.of<CategoryBloc>(context).add(const FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sản phẩm'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Column(
        children: [
          categorySelect(),
          gridViewListProduct(),
        ],
      ),
      floatingActionButton: _user?.role == 'admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateProductPage(),
                  ),
                );
              },
              label: const Text(
                'Tạo Sản Phẩm Mới',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.add),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.onSuccess,
              foregroundColor: AppColors.onPrimary,
            )
          : _user?.role == 'user'
              ? FloatingActionButton(
                  onPressed: () {
                    // Handle the cart action
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const CartPage(), // Replace with your cart page
                      ),
                    );
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  child: const Icon(Icons.shopping_cart),
                )
              : null, // If neither admin nor user, no floating action button
// If not admin, no floating action button
    );
  }

  Expanded gridViewListProduct() {
    return Expanded(
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text("Không có dữ liệu"));
            }
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                  8.0, 8.0, 8.0, 160.0), // Add bottom padding
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display 2 products per row
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.75, // Adjust ratio as needed to fit content
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return GestureDetector(
                  onTap: () {
                    if (_user?.role != null) {
                      showProductBottomDialog(product);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Bạn không có quyền thực hiện hành động này.'),
                        ),
                      );
                    }
                  },
                  child: ProductWidget(
                    name: product.name,
                    imageUrl: product.imageUrl,
                    price: double.parse(product.price),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Không có dữ liệu"),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _loadProducts,
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Không có dữ liệu"));
          }
        },
      ),
    );
  }

  Padding categorySelect() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator while loading
                } else if (state is CategoryLoaded) {
                  return DropdownButtonFormField<String>(
                    alignment: Alignment.bottomCenter,
                    menuMaxHeight: 240,
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    items: state.categories
                        .map((cat) => DropdownMenuItem<String>(
                              value: cat.id,
                              child: Text(cat.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        _loadProducts(); // Reload products when origin changes
                      });
                    },
                  );
                } else if (state is CategoryError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Lỗi dữ liệu"),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(const FetchCategories());
                        },
                        child: const Text("Tải lại"),
                      ),
                    ],
                  );
                } else {
                  return const Text("Lỗi tải dữ liệu");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void showProductBottomDialog(Product product) {
    num quantity = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the bottom sheet to adjust for the keyboard
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ), // Adjusts for the keyboard
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.imageUrl != null)
                        Container(
                          width: double.infinity,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: double.infinity,
                                height: 150.0,
                                color: Colors.grey,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 150.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            color: Colors.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      Text(
                        '${product.name} (${product.unit})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Số lượng:',
                            style: TextStyle(fontSize: 16),
                          ),
                          InputQty(
                            maxVal: 999,
                            initVal: quantity,
                            minVal: 1,
                            steps: 1,
                            onQtyChanged: (val) {
                              setState(() {
                                quantity = val;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      // Text(
                      //   'Tổng tiền: $totalPrice',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     color: AppColors.lightRed,
                      //   ),
                      // ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<CartBloc>(context).add(
                              AddProductToCart(
                                  product: product, quantity: quantity));
                          Navigator.of(context).pop(); // Close the bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đã thêm $quantity sản phẩm vào giỏ hàng.'),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Thêm vào giỏ hàng',
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
