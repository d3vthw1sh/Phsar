import '../../core/constants.dart';
import '../models/product.dart';
import 'api_service.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  // Search products with filters
  Future<List<Product>> searchProducts({
    required String query,
    String? category,
    num? minPrice,
    num? maxPrice,
    bool inStock = false,
  }) async {
    try {
      final params = <String, dynamic>{'q': query};

      if (category != null && category != 'All') {
        params['category'] = category;
      }
      if (minPrice != null) {
        params['minPrice'] = minPrice.toInt();
      }
      if (maxPrice != null) {
        params['maxPrice'] = maxPrice.toInt();
      }
      if (inStock) {
        params['inStock'] = 'true';
      }

      final response = await _apiService.dio.get(
        '${ApiConstants.baseUrl}/products/search',
        queryParameters: params,
      );

      List<dynamic> data;
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('products')) {
        data = response.data['products'];
      } else if (response.data is List) {
        data = response.data;
      } else {
        data = [];
      }

      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
