import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cat.dart';

class CatService {
  static const String apiUrl = 'https://api.thecatapi.com/v1/breeds';
  static const String apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  Future<List<Cat>> fetchCats({int page = 0, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$apiUrl?limit=$limit&page=$page'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Cat> cats = data.map((cat) => Cat.fromJson(cat)).toList();
      for (Cat cat in cats) {
        final imageUrl = await fetchCatImage(cat.referenceImageId ?? '');
        cat.imageurl = imageUrl;
      }

      return cats;
    } else {
      throw Exception('Failed to load cats');
    }
  }

  Future<String> fetchCatImage(String catId) async {
    final response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/images/$catId'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data['url'];
      } else {
        return '';
      }
    } else {
      throw Exception('Failed to load cat image');
    }
  }

  Future<List<Cat>> fetchCatName(String catName) async {
    final response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/breeds/search?q=$catName'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Cat> cats = data.map((cat) => Cat.fromJson(cat)).toList();

      for (Cat cat in cats) {
        final imageUrl = await fetchCatImage(cat.referenceImageId ?? '');
        cat.imageurl = imageUrl;
      }

      return cats;
    } else {
      throw Exception('Failed to load cats');
    }
  }
}
