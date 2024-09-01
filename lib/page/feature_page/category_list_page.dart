import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_event.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_state.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_bloc.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_event.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_state.dart';
import 'package:flutter_project_august/blocs/update_category/update_category_bloc.dart';
import 'package:flutter_project_august/blocs/update_category/update_category_event.dart';
import 'package:flutter_project_august/blocs/update_category/update_category_state.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final TextEditingController _newCategoryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    BlocProvider.of<CategoryBloc>(context).add(const FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCategoryBloc, CreateCategoryState>(
      listener: (context, state) {
        if (state is CreateCategoryLoading) {
          // Optional: Add loading state handling if needed
        } else if (state is CreateCategorySuccess) {
          _loadCategories(); // Refresh categories
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
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Danh mục sản phẩm'),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Add your logic here for when the button is pressed
                  openCreateNewCategoryDialog(context);
                },
              ),
            ],
          ),
          body: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                if (state.categories.isEmpty) {
                  // If the category list is empty, show only the "Create New Category" button
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () => openCreateNewCategoryDialog(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(4.0), // Rounded corners
                          border: Border.all(color: Colors.grey), // Gray border
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Tạo danh mục mới"),
                                SizedBox(
                                    width:
                                        8), // Add some spacing between text and icon
                                Icon(Icons.add),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // If there are categories, display the list
                  return listCategory(state);
                }
              } else if (state is CategoryError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return Container(); // empty container for unhandled states
            },
          )),
    );
  }

  ListView listCategory(CategoryLoaded state) {
    return ListView.builder(
      itemCount: state.categories.length +
          1, // Increase itemCount by 1 to include the button
      itemBuilder: (context, index) {
        if (index == 0) {
          // Add a button at the start of the list
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: GestureDetector(
              onTap: () => {openCreateNewCategoryDialog(context)},
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0), // Rounded corners
                    border: Border.all(color: Colors.grey), // Gray border
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Tạo danh mục mới"), Icon(Icons.add)],
                      ),
                    ),
                  )),
            ),
          );
        }

        var category = state
            .categories[index - 1]; // Adjust the index to access the categories
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 4.0), // Space between items
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0), // Rounded corners
              border: Border.all(color: Colors.grey), // Gray border
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(category.name),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _showEditDialog(context, category),
                  ),
                ],
              ),
            ),
          ),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Tên danh mục đã được cập nhật thành công.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Category category) {
    final _controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<UpdateCategoryBloc, UpdateCategoryState>(
          listener: (context, state) {
            if (state is UpdateCategorySuccess) {
              BlocProvider.of<CategoryBloc>(context, listen: false)
                  .add(const FetchCategories());
              Navigator.of(context).pop(); // Close the dialog
              _showSuccessDialog(context);
            } else if (state is UpdateCategoryFailure) {
              Navigator.of(context).pop(); // Close the dialog
              _showErrorDialog(context, state.error);
            }
          },
          child: AlertDialog(
            title: const Text('Đổi tên danh mục'),
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Nhập tên mới"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Lưu'),
                onPressed: () {
                  // Logic to update category name
                  // Call your Bloc or repository method here to update the category
                  if (_controller.text != category.name) {
                    BlocProvider.of<UpdateCategoryBloc>(context).add(
                        UpdateCategoryName(
                            newName: _controller.text, id: category.id));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
