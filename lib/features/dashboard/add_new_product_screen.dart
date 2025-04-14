import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendycart_of_seller/features/dashboard/draft_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const AddProductScreen(),
    );
  }
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Product',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBDBDBD),
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Name & description',
                children: [
                  _buildLabel('Product title'),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Input your text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.format_bold, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.format_italic, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.format_underline, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.emoji_emotions_outlined, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.link, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.format_list_bulleted, size: 18),
                              SizedBox(width: 12),
                              Icon(Icons.format_align_left, size: 18),
                              Spacer(),
                              Icon(Icons.arrow_back_ios_new, size: 18),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        const TextField(
                          maxLines: 6,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Images & CTA',
                children: [
                  _buildLabel('Cover images'),
                  const SizedBox(height: 8),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_upload_outlined, size: 32),
                          Text(
                            'Click or drop image',
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Category'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: 'Purchase now',
                    items: const [
                      DropdownMenuItem(
                        value: 'Purchase now',
                        child: Text('Purchase now'),
                      ),
                      DropdownMenuItem(
                        value: 'Pre-order',
                        child: Text('Pre-order'),
                      ),
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCard(
                title: 'Price',
                children: [
                  _buildLabel('Amount'),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Discount amount'),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Last saved Oct 4, 2021 - 23:32',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DraftsPage()),
                        );
                      },
                      child: Text('Save Draft', style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'Publish now',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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
