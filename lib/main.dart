import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_bloc.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_bloc.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_bloc.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_bloc.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_bloc.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_bloc.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_bloc.dart';
import 'package:flutter_project_august/blocs/delete_product/delete_product_bloc.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_bloc.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_bloc.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_bloc.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_bloc.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_bloc.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_bloc.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_bloc.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_bloc.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_bloc.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/get_statistic/statistic_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_bloc.dart';
import 'package:flutter_project_august/blocs/update_category/update_category_bloc.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_bloc.dart';
import 'package:flutter_project_august/database/local_database.dart';

import 'package:flutter_project_august/page/login_page/login_screen.dart';
import 'package:flutter_project_august/network/dio.dart';
import 'package:flutter_project_august/page/main_page/main_screen.dart';
import 'package:flutter_project_august/repo/auth_repo.dart';
import 'package:flutter_project_august/repo/category_repo.dart';
import 'package:flutter_project_august/repo/order_repo.dart';
import 'package:flutter_project_august/repo/origin_repo.dart';
import 'package:flutter_project_august/repo/product_repo.dart';
import 'package:flutter_project_august/repo/revenue_repo.dart';
import 'package:flutter_project_august/repo/school_repo.dart';
import 'package:flutter_project_august/repo/statistics_repo.dart';
import 'package:flutter_project_august/repo/user_repo.dart';

import 'package:flutter_project_august/database/share_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio = await DioClient.createDio();
  bool isLoggedIn = await SharedPreferencesHelper.checkUserLoggedIn();
  LocalDatabase localDatabase =
      LocalDatabase.instance; // Access the singleton instance of LocalDatabase

  runApp(MyApp(
    dio: dio,
    localDatabase: localDatabase,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  final LocalDatabase localDatabase;
  final bool isLoggedIn;
  MyApp(
      {super.key,
      required this.dio,
      required this.localDatabase,
      required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (_) => AuthRepositoryImpl(
              dio), // Assuming AuthRepositoryImpl expects a Dio instance
        ),
        RepositoryProvider<SchoolRepo>(
          create: (_) => SchoolRepo(dio: dio, localDatabase: localDatabase),
        ),
        RepositoryProvider<ProductRepo>(
          create: (_) => ProductRepo(dio: dio),
        ),
        RepositoryProvider<OriginRepo>(
          create: (_) => OriginRepo(dio: dio),
        ),
        RepositoryProvider<CategoryRepo>(
          create: (_) => CategoryRepo(dio: dio),
        ),
        RepositoryProvider<UserRepo>(
          create: (_) => UserRepo(dio: dio),
        ),
        RepositoryProvider<OrderRepo>(
          create: (_) => OrderRepo(dio: dio),
        ),
        RepositoryProvider<StatisticsRepo>(
          create: (_) => StatisticsRepo(dio: dio),
        ),
        RepositoryProvider<RevenueRepo>(
          create: (_) => RevenueRepo(dio: dio),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RevenueBloc>(
            create: (context) => RevenueBloc(
              repo: context.read<RevenueRepo>(),
            ),
          ),
          BlocProvider<StatisticBloc>(
            create: (context) => StatisticBloc(
              statisticsRepo: context.read<StatisticsRepo>(),
            ),
          ),
          BlocProvider<SchoolBloc>(
            create: (context) => SchoolBloc(
              schoolRepo: context.read<SchoolRepo>(),
            ),
          ),
          BlocProvider<CreateSchoolBloc>(
            create: (context) => CreateSchoolBloc(
              schoolRepo: context.read<SchoolRepo>(),
            ),
          ),
          BlocProvider<SchoolDeleteBloc>(
            create: (context) => SchoolDeleteBloc(
              schoolRepo: context.read<SchoolRepo>(),
            ),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          BlocProvider<DeleteProductBloc>(
            create: (context) => DeleteProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          BlocProvider<OriginBloc>(
            create: (context) => OriginBloc(
              originRepo: context.read<OriginRepo>(),
            ),
          ),
          BlocProvider<CreateOriginBloc>(
            create: (context) => CreateOriginBloc(
              originRepo: context.read<OriginRepo>(),
            ),
          ),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              categoryRepo: context.read<CategoryRepo>(),
            ),
          ),
          BlocProvider<UpdateCategoryBloc>(
            create: (context) => UpdateCategoryBloc(
              categoryRepo: context.read<CategoryRepo>(),
            ),
          ),
          BlocProvider<CreateCategoryBloc>(
            create: (context) => CreateCategoryBloc(
              categoryRepo: context.read<CategoryRepo>(),
            ),
          ),
          BlocProvider<CreateProductBloc>(
            create: (context) => CreateProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          BlocProvider<UpdateProductBloc>(
            create: (context) => UpdateProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (context) => ChangePasswordBloc(
              repo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<UserDeleteBloc>(
            create: (context) => UserDeleteBloc(
              userRepo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<StaffBloc>(
            create: (context) => StaffBloc(
              userRepo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<CreateUserBloc>(
            create: (context) => CreateUserBloc(
              userRepo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<CreateStaffBloc>(
            create: (context) => CreateStaffBloc(
              userRepo: context.read<UserRepo>(),
            ),
          ),
          BlocProvider<GetOrderBloc>(
            create: (context) => GetOrderBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<DebtBloc>(
            create: (context) => DebtBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<CreateOrderBloc>(
            create: (context) => CreateOrderBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<MarkOrderBloc>(
            create: (context) => MarkOrderBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<AssignStaffBloc>(
            create: (context) => AssignStaffBloc(
              orderRepo: context.read<OrderRepo>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
          BlocProvider<PrintInvoiceImageBloc>(
            create: (context) => PrintInvoiceImageBloc(),
          ),
          BlocProvider<UsbPrintImageBloc>(
            create: (context) => UsbPrintImageBloc(),
          ),
          // Include other BlocProviders if needed
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLoggedIn
              ? const MainPage()
              : const LoginPage(), // Ensure LoginPage is correctly implemented
        ),
      ),
    );
  }
}
