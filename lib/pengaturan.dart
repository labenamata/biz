import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

Map<String, dynamic> jsonDevice = {'name': "test", 'address': "test"};
BluetoothDevice device = BluetoothDevice.fromJson(jsonDevice);

String namaToko = "Biztro";
String alamat = "Jalan Bima No. 3/8 Dukuh";
String kota = "Salatiga";
String telepon = "0851 0018 1694";
PrinterBluetooth printerBluetooth = PrinterBluetooth(device);
PrinterBluetooth printerBluetooth2 = PrinterBluetooth(device);
String alamatIP = "http://192.168.1.2";

String savedEmail = "";
String savedPass = "";

String kasir = "";
