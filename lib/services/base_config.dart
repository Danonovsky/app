import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

headers(jwt) =>
    {"Content-Type": "application/json", "Authorization": "Bearer $jwt"};
const api = 'http://192.168.1.6:5000/api';
