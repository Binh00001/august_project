import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_event.dart';
import 'package:flutter_project_august/blocs/cart/cart_state.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_bloc.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_event.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_state.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderBloc, CreateOrderState>(
      listener: (context, state) {
        if (state is CreateOrderSuccess) {
          // Optionally, clear the cart after creating the order
          BlocProvider.of<CartBloc>(context).add(ClearCart());

          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green), // Success icon
                    SizedBox(width: 8), // Add spacing between icon and title
                    Text('Thành công'), // Title of the dialog
                  ],
                ),
                content: const Text(
                    'Đơn hàng đã được tạo thành công!'), // Success message
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Đóng'),
                  ),
                ],
              );
            },
          );
        } else if (state is CreateOrderFailure) {
          // Show error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red), // Error icon
                    SizedBox(width: 8), // Add spacing between icon and title
                    Text('Lỗi'), // Title of the dialog
                  ],
                ),
                content: Text('Lỗi: ${state.error}'), // Error message
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Đóng'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Giỏ Hàng',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                // Trigger clear cart action
                BlocProvider.of<CartBloc>(context).add(ClearCart());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartUpdated && state.products.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products.keys.elementAt(index);
                        final quantity = state.products[product] ?? 0;
                        final price = num.parse(product.price) * quantity;
                        final formattedPrice =
                            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                .format(price);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                product.imageUrl ?? "",
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Số lượng: $quantity ${product.unit}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      formattedPrice,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Trigger remove product from cart action
                                  BlocProvider.of<CartBloc>(context).add(
                                      RemoveProductFromCart(product: product));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is CartUpdated && state.products.isEmpty) {
                    return const Center(
                      child: Text('Giỏ hàng của bạn đang trống.'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final cartState = BlocProvider.of<CartBloc>(context).state;

                  if (cartState is CartUpdated &&
                      cartState.products.isNotEmpty) {
                    final products = createOrderList(cartState.products);
                    final totalAmount = cartState.products.entries
                        .map(
                            (entry) => num.parse(entry.key.price) * entry.value)
                        .reduce((value, element) => value + element);

                    // Dispatch the CreateOrder event with the products and totalAmount
                    BlocProvider.of<CreateOrderBloc>(context).add(
                      CreateOrder(products: products, totalAmount: totalAmount),
                    );
                  } else {
                    // Show a message if the cart is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Giỏ hàng của bạn đang trống.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Tạo Đơn Hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> createOrderList(Map<Product, num> products) {
    return products.entries.map((entry) {
      final product = entry.key;
      final quantity = entry.value;
      final price = num.parse(product.price) * quantity;

      return {
        'productId': product.id, // id of the product
        'quantity': quantity, // quantity of the product
        'price': price, // calculated price based on the quantity
      };
    }).toList();
  }
}
