import 'package:flutter/material.dart';

class DraftProduct {
  final String imagePath;
  final String title;
  final String price;
  final String category;
  final String date;
  bool isSelected;

  DraftProduct({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.category,
    required this.date,
    this.isSelected = false,
  });
}

class DraftsPage extends StatefulWidget {
  const DraftsPage({super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  List<DraftProduct> products = [
    DraftProduct(
      imagePath: 'assets/images/img.png',
      title: 'soothing wallpaperme 4',
      price: '\$94.00',
      category: 'Home',
      date: 'Jun 23',
    ),
    DraftProduct(
      imagePath: 'assets/images/img.png',
      title: 'Classic yellow-gray wallpaper',
      price: '\$19.99',
      category: 'Home',
      date: 'Feb 4',
    ),
    DraftProduct(
      imagePath: 'assets/images/img.png',
      title: 'Abstract virtual reality personality',
      price: '\$110.20',
      category: 'Electronics',
      date: 'Nov 30',
    ),
  ];

  bool selectionMode = false;

  void toggleSelection(int index) {
    setState(() {
      products[index].isSelected = !products[index].isSelected;
      selectionMode = products.any((p) => p.isSelected);
    });
  }

  void clearSelection() {
    setState(() {
      for (var p in products) {
        p.isSelected = false;
      }
      selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = products.where((p) => p.isSelected).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drafts', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            if (selectionMode) {
              clearSelection();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search product',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      product.isSelected = true;
                      selectionMode = true;
                    });
                  },
                  onTap: () {
                    if (selectionMode) {
                      toggleSelection(index);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      product.imagePath,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    if (product.isSelected)
                                      Container(
                                        height: 160,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.copy,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (selectionMode)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Checkbox(
                                          value: product.isSelected,
                                          onChanged:
                                              (_) => toggleSelection(index),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.category,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          product.price,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.date,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectionMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$selectedCount product${selectedCount > 1 ? 's' : ''} selected',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Delete'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Publish now'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
