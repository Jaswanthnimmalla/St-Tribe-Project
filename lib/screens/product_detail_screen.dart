// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.thumbnail),
            const SizedBox(height: 16),
            Text(product.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('\$${product.price}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Description:',
                style: Theme.of(context).textTheme.titleMedium),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
