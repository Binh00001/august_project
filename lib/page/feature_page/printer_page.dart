import 'package:flutter/material.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSettingsPage extends StatefulWidget {
  @override
  _PrinterSettingsPageState createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  final _ipAddressController = TextEditingController();
  final _portController = TextEditingController();
  final _scaleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ipAddressController.text =
        prefs.getString('_printerIPAddress') ?? "192.168.1.219";
    _portController.text = (prefs.getInt('_printerPort') ?? 9100).toString();
    _scaleController.text =
        (prefs.getDouble('_printerScale') ?? 1.8).toString();
  }

  Future<void> setPrinterIP(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_printerIPAddress', newIP);
  }

  Future<void> setPrinterPort(int newPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('_printerPort', newPort);
  }

  Future<void> setPrinterScale(double newScale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('_printerScale', newScale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt máy in'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ipAddressController,
              decoration: const InputDecoration(labelText: 'Địa chi IP'),
            ),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(labelText: 'Cổng'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _scaleController,
              decoration: const InputDecoration(labelText: 'Tỉ lệ in'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Dismiss the keyboard by removing focus from any focused element
                  FocusScope.of(context).unfocus();

                  setPrinterIP(_ipAddressController.text);
                  setPrinterPort(int.parse(_portController.text));
                  setPrinterScale(double.parse(_scaleController.text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Cập nhật thành công!'),
                  ));
                },
                child: const Text('Cập nhật cài đặt'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
