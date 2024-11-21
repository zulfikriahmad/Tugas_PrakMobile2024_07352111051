import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Tambahkan ini untuk format Rupiah

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final Map<String, Map<String, dynamic>> cartItems = {
    'Jam Tangan': {'price': 40000.0, 'quantity': 2, 'image': 'assets/images/image2.jpg'},
    'Airpods': {'price': 333000.0, 'quantity': 2, 'image': 'assets/images/image1.jpg'},
    'Hoodie': {'price': 50000.0, 'quantity': 2, 'image': 'assets/images/image3.jpg'},
  };

  double get subtotalPrice {
    double subtotal = 0;
    cartItems.forEach((_, item) {
      subtotal += item['price'] * item['quantity'];
    });
    return subtotal;
  }

  double get discount {
    return subtotalPrice * 0.04; // Diskon 4%
  }

  double get deliveryCharges {
    return 2000.0; // Biaya pengiriman tetap Rp 2000
  }

  double get totalPrice {
    return subtotalPrice - discount + deliveryCharges;
  }

  String formatRupiah(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  void increaseQuantity(String key) {
    setState(() {
      cartItems[key]!['quantity']++;
    });
  }

  void decreaseQuantity(String key) {
    setState(() {
      if (cartItems[key]!['quantity'] > 1) {
        cartItems[key]!['quantity']--;
      }
    });
  }

  void removeItem(String key) {
    setState(() {
      cartItems.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                String key = cartItems.keys.elementAt(index);
                Map<String, dynamic> item = cartItems[key]!;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      item['image'], // Load image from assets
                      width: 50,
                      height: 50,
                    ),
                    title: Text(key),
                    subtitle: Text(formatRupiah(item['price'])), // Menampilkan harga dengan format Rupiah
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => decreaseQuantity(key),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          onPressed: () => increaseQuantity(key),
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () => removeItem(key),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order Summary
                Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Items',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text('${cartItems.length}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(formatRupiah(subtotalPrice)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Discount (4%)',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(formatRupiah(discount)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Charges',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(formatRupiah(deliveryCharges)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatRupiah(totalPrice),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Checkout berhasil dengan total: ${formatRupiah(totalPrice)}'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Checkout - Total: ${formatRupiah(totalPrice)}', // Format Rupiah pada tombol
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Warna teks diubah menjadi putih
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
