import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context, listen: false)
        .add(const FetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return Container(
              child: ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  var category = state.categories[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDialog(context, category),
                    ),
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container(); // empty container for unhandled states
        },
      ),
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
