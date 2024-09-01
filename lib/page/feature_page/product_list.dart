import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/category_dropdown.dart';
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
import 'package:flutter_project_august/page/feature_page/edit_product_page.dart';
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
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<Product> _products = []; // List to store loaded products
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
    _loadUserInfo();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadUserInfo() async {
    _user = await SharedPreferencesHelper.getUserInfo();
    setState(() {});
  }

  void _loadProducts({int page = 1}) {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    BlocProvider.of<ProductBloc>(context).add(
      FetchProducts(
        page: page,
        pageSize: 10,
        categoryId: selectedCategory,
        originId: selectedOrigin,
      ),
    );
  }

  void _loadCategories() {
    BlocProvider.of<CategoryBloc>(context).add(const FetchCategories());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (_isLoading || !_hasMore) return;
    _currentPage++;
    _loadProducts(page: _currentPage);
  }

  void _resetProducts() {
    setState(() {
      _products.clear(); // Clear the current products list
      _currentPage = 1; // Reset the current page
      _hasMore = true; // Reset the flag for more products
    });
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateProductPage(),
                  ),
                );
                _resetProducts();

                // _loadProducts();
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  child: const Icon(Icons.shopping_cart),
                )
              : null,
    );
  }

  Expanded gridViewListProduct() {
    return Expanded(
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoaded) {
            setState(() {
              _isLoading = false;
              if (state.products.isEmpty) {
                _hasMore = false;
              } else {
                _products
                    .addAll(state.products); // Add new products to the list
              }
            });
          } else if (state is ProductError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Error loading products: ${state.message}")),
            );
          }
        },
        child: _products.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, 160.0), // Add bottom padding
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display 2 products per row
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio:
                      0.7, // Adjust ratio as needed to fit content
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () async {
                      if (_user?.role == "user") {
                        showProductBottomDialog(product);
                      }

                      if (_user?.role == "admin") {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProductPage(product: product),
                          ),
                        );
                        _resetProducts();
                      }
                    },
                    child: ProductWidget(
                      name: product.name,
                      imageUrl: product.imageUrl,
                      price: double.parse(product.price),
                    ),
                  );
                },
              ),
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
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  return CustomDropdown(
                    items: state.categories,
                    selectedValue: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        // Additional logic
                        _resetProducts();
                      });
                    },
                    labelText: 'Danh mục',
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
                                  'Đã thêm $quantity ${product.name} vào giỏ hàng.'),
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
