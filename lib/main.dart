import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_bloc.dart';
import 'package:flutter_project_august/blocs/get_category/get_category_bloc.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/database/local_database.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'package:flutter_project_august/page/login_page/login_screen.dart';
import 'package:flutter_project_august/network/dio.dart';
import 'package:flutter_project_august/repo/auth_repo.dart';
import 'package:flutter_project_august/repo/category_repo.dart';
import 'package:flutter_project_august/repo/origin_repo.dart';
import 'package:flutter_project_august/repo/product_repo.dart';
import 'package:flutter_project_august/repo/school_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio = await DioClient.createDio();

  LocalDatabase localDatabase =
      LocalDatabase.instance; // Access the singleton instance of LocalDatabase

  runApp(MyApp(
    dio: dio,
    localDatabase: localDatabase,
  ));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  final LocalDatabase localDatabase;
  const MyApp({super.key, required this.dio, required this.localDatabase});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (_) => AuthRepositoryImpl(
              dio), // Assuming AuthRepositoryImpl expects a Dio instance
        ),
        RepositoryProvider<SchoolRepo>(
          create: (_) => SchoolRepo(
              dio: dio,
              localDatabase:
                  localDatabase), // Create and provide SchoolRepo with Dio
        ),
        RepositoryProvider<ProductRepo>(
          create: (_) =>
              ProductRepo(dio: dio), // Create and provide SchoolRepo with Dio
        ),
        RepositoryProvider<OriginRepo>(
          create: (_) =>
              OriginRepo(dio: dio), // Create and provide SchoolRepo with Dio
        ),
        RepositoryProvider<CategoryRepo>(
          create: (_) =>
              CategoryRepo(dio: dio), // Create and provide SchoolRepo with Dio
        ),
      ],
      child: MultiBlocProvider(
        providers: [
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
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          BlocProvider<OriginBloc>(
            create: (context) => OriginBloc(
              originRepo: context.read<OriginRepo>(),
            ),
          ),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(
              categoryRepo: context.read<CategoryRepo>(),
            ),
          ),
          BlocProvider<CreateProductBloc>(
            create: (context) => CreateProductBloc(
              productRepo: context.read<ProductRepo>(),
            ),
          ),
          // Include other BlocProviders if needed
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginPage(), // Ensure LoginPage is correctly implemented
        ),
      ),
    );
  }
}
