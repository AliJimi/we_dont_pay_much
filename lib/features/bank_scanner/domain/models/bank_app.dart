// we_dont_pay_much/features/bank_scanner/domain/models/bank_app.dart

import 'dart:typed_data';


class BankApp {
  BankApp({required this.name, required this.packageName, this.icon});
  final Uint8List? icon;
  final String name;
  final String packageName;
}
