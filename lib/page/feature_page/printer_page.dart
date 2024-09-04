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
  bool _isLoading = true; // Biến phụ để theo dõi trạng thái đang tải

  String _initialIPAddress = "";
  int _initialPort = 0;
  double _initialScale = 0.0;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _initialIPAddress = prefs.getString('_printerIPAddress') ?? "192.168.1.219";
    _initialPort = prefs.getInt('_printerPort') ?? 9100;
    _initialScale = prefs.getDouble('_printerScale') ?? 1.8;

    _ipAddressController.text = _initialIPAddress;
    _portController.text = _initialPort.toString();
    _scaleController.text = _initialScale.toString();

    setState(() {
      _isLoading = false;
    });
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

  bool _hasChanged = false;

  void checkForChanges() {
    if (_ipAddressController.text != _initialIPAddress ||
        int.parse(_portController.text) != _initialPort ||
        double.parse(_scaleController.text) != _initialScale) {
      if (!_hasChanged) {
        setState(() {
          _hasChanged = true;
        });
      }
    } else {
      if (_hasChanged) {
        setState(() {
          _hasChanged = false;
        });
      }
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildSettingForm(context),
    );
  }

  Padding buildSettingForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ipAddressController,
            decoration: const InputDecoration(labelText: 'Địa chi IP'),
            onChanged: (value) => checkForChanges(),
          ),
          TextField(
            controller: _portController,
            decoration: const InputDecoration(labelText: 'Cổng'),
            onChanged: (value) => checkForChanges(),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _scaleController,
            decoration: const InputDecoration(labelText: 'Tỉ lệ in'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => checkForChanges(),
          ),
          const SizedBox(height: 20),
          if (_hasChanged) // Only show this button if there are changes
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setPrinterIP(_ipAddressController.text);
                  setPrinterPort(int.parse(_portController.text));
                  setPrinterScale(double.parse(_scaleController.text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Cập nhật thành công!'),
                  ));
                  // Reset the _hasChanged after update
                  setState(() {
                    _hasChanged = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Cập nhật cài đặt',
                  style: TextStyle(color: AppColors.onPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
