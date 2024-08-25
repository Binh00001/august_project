import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_event.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_state.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_bloc.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_event.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_state.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_bloc.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_event.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_state.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_bloc.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_event.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_state.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_bloc.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_event.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_state.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_event.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController _newOriginController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the Form
  String? _selectedUnit;
  String? _selectedCategory;
  String? _selectedOrigin;
  XFile? _mediaFile;
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, String>> units = [
    {'name': 'Kilogram', 'value': 'kg'},
    {'name': 'Gram', 'value': 'g'},
    {'name': 'Lít', 'value': 'l'},
    {'name': 'Mililít', 'value': 'ml'},
    {'name': 'Mét', 'value': 'm'},
    {'name': 'Centimet', 'value': 'cm'},
    {'name': 'Khay', 'value': 'khay'},
    {'name': 'Chiếc', 'value': 'chiếc'},
    {'name': 'Cái', 'value': 'cái'},
    {'name': 'Ví', 'value': 'ví'},
    {'name': 'Bịch', 'value': 'bịch'},
    {'name': 'Gói', 'value': 'gói'},
    {'name': 'Chai', 'value': 'chai'},
    {'name': 'Hộp', 'value': 'hộp'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    //get category list, get origin list
    super.initState();
    _loadOrigins();
    _loadCategories();
  }

  void _loadOrigins() {
    BlocProvider.of<OriginBloc>(context).add(const FetchOrigins());
  }

  void _loadProducts() {
    BlocProvider.of<ProductBloc>(context).add(
      const FetchProducts(
        page: 1,
        pageSize: 10,
      ),
    );
  }

  void _loadCategories() {
    BlocProvider.of<CategoryBloc>(context).add(const FetchCategories());
  }

  void _setImageFile(XFile? value) {
    setState(() {
      _mediaFile = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo sản phẩm', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _setImageFile(null);
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreateProductBloc, CreateProductState>(
            listener: (context, state) {
              print(state);
              if (state is CreateProductLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              } else if (state is CreateProductSuccess) {
                Navigator.of(context).pop(); // Close loading dialog
                _loadProducts();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thành công'),
                      content: const Text('Sản phẩm đã được tạo thành công.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is CreateProductFailure) {
                Navigator.of(context).pop(); // Close loading dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thất bại'),
                      content: const Text("Thêm sản phẩm mới thất bại"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategoryLoading) {
              } else if (state is CreateCategorySuccess) {
                _loadCategories();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thành công'),
                      content: const Text('Danh mục đã được tạo thành công.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is CreateCategoryFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thất bại'),
                      content: const Text("Thêm danh mục mới thất bại"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          BlocListener<CreateOriginBloc, CreateOriginState>(
            listener: (context, state) {
              if (state is OriginLoading) {
              } else if (state is CreateOriginSuccess) {
                _loadOrigins();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thành công'),
                      content: const Text('Nguồn gốc đã được tạo thành công.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is CreateOriginFailure) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thất bại'),
                      content: const Text("Thêm nguồn gốc mới thất bại"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Assign the GlobalKey to the Form
              child: Column(
                children: [
                  inputProductName(),
                  const SizedBox(height: 16),
                  inputProductPrice(),
                  const SizedBox(height: 16),
                  selectUnit(),
                  const SizedBox(height: 16),
                  buildDropdownCategory(),
                  const SizedBox(height: 16),
                  // buildDropdownOrigin(),
                  // const SizedBox(height: 16),
                  selectAndDisplayImage(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double
                        .infinity, // Sets the button to take the full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Background color
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final name = _nameController.text;
                          final unit = _selectedUnit!;
                          final price = _priceController.text;
                          final categoryId = _selectedCategory!;

                          BlocProvider.of<CreateProductBloc>(context).add(
                            CreateProductRequested(
                                name: name,
                                unit: unit,
                                price: price,
                                categoryId: categoryId,
                                imageFile: _mediaFile),
                          );
                        }
                      },
                      child: const Text('Tạo sản phẩm mới'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row selectAndDisplayImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_mediaFile == null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null && _isValidImage(pickedFile)) {
                _setImageFile(pickedFile);
              } else {
                _showUnsupportedFileTypeDialog();
              }
            },
            icon: const Icon(Icons.attach_file),
            label: const Text('Chọn ảnh'),
          ),
        ],
        if (_mediaFile != null) ...[
          GestureDetector(
            onTap: () async {
              final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null && _isValidImage(pickedFile)) {
                _setImageFile(pickedFile);
              } else {
                _showUnsupportedFileTypeDialog();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Image.file(
                File(_mediaFile!.path), // Safely access _mediaFile path
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool _isValidImage(XFile file) {
    // Kiểm tra MIME type
    final mimeType = lookupMimeType(file.path);
    print('mime của ảnh $mimeType');
    if (mimeType == null || !mimeType.startsWith('image/')) {
      return false;
    }

    // Kiểm tra phần mở rộng tệp
    final String extension = file.path.split('.').last.toLowerCase();
    print('Phần mở rộng tệp: $extension, MIME type: $mimeType');
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

  BlocBuilder<OriginBloc, OriginState> buildDropdownOrigin() {
    return BlocBuilder<OriginBloc, OriginState>(
      builder: (context, state) {
        if (state is OriginLoading) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while loading
        } else if (state is OriginLoaded) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  menuMaxHeight: 240,
                  decoration: const InputDecoration(
                    labelText: 'Nguồn gốc',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedOrigin,
                  items: state.origins
                      .map((origin) => DropdownMenuItem<String>(
                            value: origin.id,
                            child: Text(origin.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOrigin = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn nguồn gốc';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Set background color to grey
                  borderRadius:
                      BorderRadius.circular(8), // Set border radius to 8
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Open dialog to create a new category
                      openCreateNewOriginDialog(context);
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (state is OriginError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Lỗi dữ liệu"),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<OriginBloc>(context)
                      .add(const FetchOrigins());
                },
                child: const Text("Tải lại"),
              ),
            ],
          );
        } else {
          return const Text("Lỗi tải dữ liệu");
        }
      },
    );
  }

  BlocBuilder<CategoryBloc, CategoryState> buildDropdownCategory() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while loading
        } else if (state is CategoryLoaded) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  alignment: Alignment.bottomCenter,
                  menuMaxHeight: 240,
                  decoration: const InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: state.categories
                      .map((cat) => DropdownMenuItem<String>(
                            value: cat.id,
                            child: Text(cat.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn danh mục';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Set background color to grey
                  borderRadius:
                      BorderRadius.circular(8), // Set border radius to 8
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Open dialog to create a new category
                      openCreateNewCategoryDialog(context);
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (state is CategoryError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Lỗi dữ liệu"),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CategoryBloc>(context)
                      .add(const FetchCategories());
                },
                child: const Text("Tải lại"),
              ),
            ],
          );
        } else {
          return const Text("Lỗi tải dữ liệu");
        }
      },
    );
  }

  DropdownButtonFormField<String> selectUnit() {
    return DropdownButtonFormField<String>(
      menuMaxHeight: 240,
      value: _selectedUnit,
      items: units
          .map((unit) => DropdownMenuItem<String>(
                value: unit['value'],
                child: Text(unit['name']!),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedUnit = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Chọn đơn vị',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn đơn vị';
        }
        return null;
      },
    );
  }

  TextFormField inputProductPrice() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Giá tiền',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nội dung bắt buộc nhập';
        }
        return null;
      },
    );
  }

  TextFormField inputProductName() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Tên sản phẩm',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nội dung bắt buộc nhập';
        }
        return null;
      },
    );
  }

  Future<dynamic> openCreateNewOriginDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tạo nguồn gốc mới'),
          content: TextField(
            controller: _newOriginController, // Use the controller here
            decoration: const InputDecoration(
              labelText: 'Tên nguồn gốc',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _newOriginController
                    .clear(); // Clear the controller when canceled
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final originName = _newOriginController.text;

                if (originName.isNotEmpty) {
                  BlocProvider.of<CreateOriginBloc>(context).add(
                    CreateOriginRequested(name: originName),
                  );
                }
                _newOriginController.clear(); // Clear the controller after use
                Navigator.of(context).pop(); // Close dialog after saving
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> openCreateNewCategoryDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tạo danh mục mới'),
          content: TextField(
            controller: _newCategoryController, // Use the controller here
            decoration: const InputDecoration(
              labelText: 'Tên danh mục',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _newCategoryController
                    .clear(); // Clear the controller when canceled
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final categoryName = _newCategoryController.text;

                if (categoryName.isNotEmpty) {
                  BlocProvider.of<CreateCategoryBloc>(context).add(
                    CreateCategoryRequested(name: categoryName),
                  );
                }
                _newCategoryController
                    .clear(); // Clear the controller after use
                Navigator.of(context).pop(); // Close dialog after saving
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }
}
