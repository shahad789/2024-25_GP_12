import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.62:6000';

//get district based on city
  static Future<List<String>> getDistricts(String city) async {
    // Send a GET request to the API endpoint, passing the city as a query parameter.
    final response = await http.get(Uri.parse('$baseUrl/districts?city=$city'));

    // Check if the response status code indicates a successful request.
    if (response.statusCode == 200) {
      // Decode the JSON response body
      final data = json.decode(response.body);
      // Extract the list of districts from the 'districts' key and convert it to a list of strings.
      return List<String>.from(data['districts']);
    } else {
      // If the request fails, throw an exception with an error message.
      throw Exception('Failed to load districts');
    }
  }

//for price valuation
// A static method to predict the price of a property based on input parameters.
  static Future<double> predictPrice({
    required String city,
    required String district,
    required String propertyType,
    required double area,
    required int rooms,
    required int bathrooms,
  }) async {
    // Create a map of the request data with key-value pairs for the input parameters.
    final requestData = {
      'city': city,
      'district': district,
      'property_type': propertyType,
      'area': area,
      'rooms': rooms,
      'bathrooms': bathrooms,
    };
    print('Sending Request Data: $requestData');

    // Send a POST request to the prediction API endpoint with the input data.
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    //logging for debugging purpose
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Decode the JSON response and extract the predicted price.
      final data = json.decode(response.body);
      return data['predicted_price'];
    } else {
      // Throw an exception if the API call fails.
      throw Exception('Failed to predict price');
    }
  }
}
