import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/delete_product/delete_product_bloc.dart';
import 'package:flutter_project_august/blocs/delete_product/delete_product_event.dart';
import 'package:flutter_project_august/blocs/delete_product/delete_product_state.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_bloc.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_event.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_state.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project_august/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
  String? previewImageUrl;
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

  //check và đặt giá trị khởi đầu cho ảnh
  Future<void> _validateImageUrl(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          previewImageUrl = imageUrl;
        });
      } else {
        setState(() {
          previewImageUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        previewImageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<DeleteProductBloc, DeleteProductState>(
          listener: (context, state) async {
            if (state is DeleteProductLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            } else if (state is DeleteProductSuccess) {
              Navigator.pop(
                  context); // Dismiss the loading dialog if it's showing
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xóa Sản Phẩm'),
                    content: const Text("Sản phẩm đã được xóa thành công!"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () =>
                            Navigator.of(context).pop(), // Close the dialog
                      ),
                    ],
                  );
                },
              );
              Navigator.pop(context);
            } else if (state is DeleteProductFailure) {
              Navigator.pop(
                  context); // Dismiss the loading dialog if it's showing
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Lỗi Xóa Sản Phẩm'),
                    content: Text("Lỗi khi xóa sản phẩm: ${state.error}"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () =>
                            Navigator.of(context).pop(), // Close the dialog
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocConsumer<UpdateProductBloc, UpdateProductState>(
            listener: (context, state) {
              if (state is UpdateProductLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              } else if (state is UpdateProductSuccess) {
                Navigator.pop(context); // Close the loading dialog if open
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Cập nhật sản phẩm thành công!")),
                );
                Navigator.pop(context);
              } else if (state is UpdateProductFailure) {
                Navigator.pop(context); // Close the loading dialog if open
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Lỗi cập nhật sản phẩm: ${state.error}")),
                );
              }
            },
            builder: (context, state) {
              // Existing builder code
              return buildUI(_formKey, context);
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildUI(
      GlobalKey<FormState> _formKey, BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên sản phẩm',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tên sản phẩm không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá tiền',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Giá tiền không được để trống';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            buildImagePickerRow(context),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.onError,
                    backgroundColor:
                        AppColors.lightRed, // Set the text color to white
                  ),
                  onPressed: () {
                    _showDeleteConfirmationDialog();
                    // Add your delete action or function call here
                  },
                  child: const Text('Xoá sản phẩm'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProduct();
                    }
                  },
                  child: const Text('Cập nhật sản phẩm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cảnh báo'),
          content: const Text(
              'Sản phẩm bị xoá sẽ không thể khôi phục, bạn có muốn tiếp tục?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.error, // White text color
              ),
              child: const Text('Tiếp tục'),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform the delete operation here
                BlocProvider.of<DeleteProductBloc>(context)
                    .add(DeleteProduct(widget.product.id));
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300], // Black text color
              ),
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildImagePickerRow(BuildContext context) {
    return Row(
      children: [
        if (_mediaFile != null) // If there's a selected file, display it
          Image.file(
            File(_mediaFile!.path),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
        else if (previewImageUrl !=
            null) // If no file is selected but there's a valid preview URL
          Image.network(
            previewImageUrl!,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 120,
              height: 120,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Lỗi ảnh', style: TextStyle(color: Colors.black54)),
              ),
            ),
          )
        else // If no file is selected and no valid preview URL, show placeholder
          Container(
            width: 120,
            height: 120,
            color: Colors.grey[200],
            child: const Center(
              child:
                  Text('Chưa có ảnh', style: TextStyle(color: Colors.black54)),
            ),
          ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Chọn ảnh mới'),
        ),
      ],
    );
  }

  //check ảnh được chọn có phù hợp không
  bool _isValidImage(XFile file) {
    // Kiểm tra MIME type
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      return false;
    }

    // Kiểm tra phần mở rộng tệp
    final String extension = file.path.split('.').last.toLowerCase();
    return extension == 'jpg' || extension == 'jpeg' || extension == 'png';
  }

  void _showUnsupportedFileTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsupported File Type'),
          content: const Text('Hãy chọn ảnh có định dạng jpg, jpeg hoặc png'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && _isValidImage(pickedFile)) {
      setState(() {
        _mediaFile = pickedFile;
      });
    } else {
      _showUnsupportedFileTypeDialog();
    }
  }

  void _updateProduct() {
    // Initialize values as null which will represent no change
    String? newName;
    String? newPrice;
    XFile? newImageFile;

    // Check if name has changed
    if (_nameController.text != widget.product.name) {
      newName = _nameController.text;
    }

    // Check if price has changed
    if (_priceController.text != widget.product.price) {
      newPrice = _priceController.text;
    }

    // Check if image has changed; Note: Assuming widget.product.imageUrl is the path to compare with
    if (_mediaFile != null && widget.product.imageUrl != _mediaFile!.path) {
      newImageFile = _mediaFile;
    }

    // If any changes were detected, send the update event to the Bloc
    if (newName != null || newPrice != null || newImageFile != null) {
      BlocProvider.of<UpdateProductBloc>(context).add(
          UpdateProductButtonPressed(
              name: newName,
              price: newPrice,
              productId: widget.product.id,
              imageFile: newImageFile));
    } else {
      // Optionally handle no changes
      print("No changes detected, not updating the product.");
    }
  }
}
