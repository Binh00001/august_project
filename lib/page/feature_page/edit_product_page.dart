import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project_august/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  XFile? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price);
    _validateImageUrl(widget.product.imageUrl ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _validateImageUrl(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _mediaFile = XFile(imageUrl);
        });
      } else {
        print(
            'Image URL returned status code ${response.statusCode}. Setting image path to null.');
        setState(() {
          _mediaFile = null;
        });
      }
    } catch (e) {
      print('Failed to load image: $e');
      setState(() {
        _mediaFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giá tiền',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_mediaFile != null)
                      Image.file(
                        File(_mediaFile!.path),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[
                            200], // Choose a light grey color for the placeholder
                        child: const Center(
                          child: Text('Chưa có ảnh',
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Chọn ảnh mới'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    child: const Text('Cập nhật sản phẩm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaFile = pickedFile;
      });
    }
  }

  void _updateProduct() {}
}
