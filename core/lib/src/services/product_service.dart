import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/product.dart';

abstract class ProductService {
  Future<ResponseResults> submitProduct(Product product);

  Future<ResponseResult> editProductByCode(Product product);

  Future<ResponseResult> deleteProduct(Map<String, dynamic> pcode);

  Future<Products> getAllProducts();

  Future<Product> getProductByName(String productName);
}
