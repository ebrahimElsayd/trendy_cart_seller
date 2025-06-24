import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendycart_of_seller/core/comman/entitys/item_model.dart';
import 'package:trendycart_of_seller/core/comman/entitys/categories.dart';
import 'package:trendycart_of_seller/features/products/presentation/riverpod/items_riverpod.dart';
import 'package:trendycart_of_seller/features/products/presentation/riverpod/items_state.dart';
import 'package:trendycart_of_seller/features/products/data/repository/items_repository.dart';
import 'package:trendycart_of_seller/features/dashboard/draft_screen.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _retailPriceController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int _selectedCategoryId = 1;
  List<Categories> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _retailPriceController.dispose();
    _wholesalePriceController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      // Load categories from the items data source
      final itemsNotifier = ref.read(itemsRiverpodProvider.notifier);
      final repository = ref.read(itemsRepositoryProvider);
      final result = await repository.itemsDataSource.getCategories();

      setState(() {
        _categories = result;
        _isLoadingCategories = false;
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories.first.id;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: ${e.toString()}')),
        );
      }
    }
  }

  void _handleAddProduct() {
    if (_formKey.currentState!.validate()) {
      final item = ItemModel(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId,
        imageUrl: _imageUrlController.text.trim(),
        quantity: int.tryParse(_quantityController.text) ?? 0,
        retailPrice: double.tryParse(_retailPriceController.text) ?? 0.0,
        wholesalePrice: double.tryParse(_wholesalePriceController.text) ?? 0.0,
        createdAt: DateTime.now().toIso8601String(),
      );

      ref.read(itemsRiverpodProvider.notifier).addItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsRiverpodProvider);

    // Listen to state changes
    ref.listen<ItemsState>(itemsRiverpodProvider, (previous, next) {
      if (next.status == ItemsStateStatus.itemAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (next.status == ItemsStateStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.errorMessage ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Product',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'Product Information',
                children: [
                  _buildLabel('Product Name *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter product name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter product description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Image URL'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter image URL (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Category & Stock',
                children: [
                  _buildLabel('Category *'),
                  const SizedBox(height: 8),
                  _isLoadingCategories
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _categories.map((category) {
                              return DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 16),
                  _buildLabel('Quantity *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter quantity in stock',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Quantity is required';
                      }
                      final quantity = int.tryParse(value);
                      if (quantity == null || quantity < 0) {
                        return 'Please enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Pricing',
                children: [
                  _buildLabel('Retail Price *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _retailPriceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Retail price is required';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Wholesale Price'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _wholesalePriceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0.00 (optional)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final price = double.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Please enter a valid wholesale price';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          itemsState.status == ItemsStateStatus.addingItem
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DraftsPage(),
                                  ),
                                );
                              },
                      child: Text('Save Draft', style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          itemsState.status == ItemsStateStatus.addingItem
                              ? null
                              : _handleAddProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child:
                          itemsState.status == ItemsStateStatus.addingItem
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Add Product',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
    );
  }
}
