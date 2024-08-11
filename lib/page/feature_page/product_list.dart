import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/product_widget.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_bloc.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_event.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_state.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_event.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_state.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? selectedCategory;
  String? selectedOrigin;

  @override
  void initState() {
    // TODO: implement initState
    //get category list, get origin list
    super.initState();
    _loadProducts();
    _loadOrigins();
  }

  void _loadProducts() {
    BlocProvider.of<ProductBloc>(context).add(
      FetchProducts(
          page: 1,
          pageSize: 10,
          categoryId: selectedCategory,
          originId: selectedOrigin),
    );
  }

  void _loadOrigins() {
    BlocProvider.of<OriginBloc>(context).add(const FetchOrigins());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Sản phẩm'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 240,
                      decoration: const InputDecoration(
                        labelText: 'Danh mục',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      items: [
                        'Category 1',
                        'Category 2',
                        'Category 3',
                      ]
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          // _loadProducts(); // Reload products when category changes
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: BlocBuilder<OriginBloc, OriginState>(
                      builder: (context, state) {
                        if (state is OriginLoading) {
                          return const Center(
                              child:
                                  CircularProgressIndicator()); // Show loading indicator while loading
                        } else if (state is OriginLoaded) {
                          return DropdownButtonFormField<String>(
                            menuMaxHeight: 240,
                            decoration: const InputDecoration(
                              labelText: 'Nguồn gốc',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedOrigin,
                            items: state.origins
                                .map((origin) => DropdownMenuItem<String>(
                                      value: origin.id,
                                      child: Text(origin.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOrigin = value;
                                _loadProducts(); // Reload products when origin changes
                              });
                            },
                          );
                        } else if (state is OriginError) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Failed to load origins"),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<OriginBloc>(context)
                                      .add(const FetchOrigins());
                                },
                                child: const Text("Retry"),
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
            ),
            Expanded(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Display 2 products per row
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio:
                            0.75, // Adjust ratio as needed to fit content
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductWidget(
                          name: product['name'],
                          imageUrl: product['image_url'],
                          price: double.parse(product['price']),
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {},
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
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
