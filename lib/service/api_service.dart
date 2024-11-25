import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.255.186:6000';

  static Future<List<String>> getDistricts(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/districts?city=$city'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['districts']);
    } else {
      throw Exception('Failed to load districts');
    }
  }

  static Future<double> predictPrice({
    required String city,
    required String district,
    required String propertyType,
    required double area,
    required int rooms,
    required int bathrooms,
  }) async {
    final requestData = {
      'city': city,
      'district': district,
      'property_type': propertyType,
      'area': area,
      'rooms': rooms,
      'bathrooms': bathrooms,
    };
    print('Sending Request Data: $requestData');

    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['predicted_price'];
    } else {
      throw Exception('Failed to predict price');
    }
  }
}
