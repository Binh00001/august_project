import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the price

class ProductWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double price;

  const ProductWidget({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the price
    final formattedPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          if (imageUrl != null)
            Container(
              width: double.infinity,
              height: 150.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0), // Only top-left corner
                  topRight: Radius.circular(8.0), // Only top-right corner
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0), // Only top-left corner
                  topRight: Radius.circular(8.0), // Only top-right corner
                ), // Clip the image to the border radius
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
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
                  topLeft: Radius.circular(8.0), // Only top-left corner
                  topRight: Radius.circular(8.0), // Only top-right corner
                ), // Add border radius of 8
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          const SizedBox(height: 8.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              formattedPrice,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
