import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductIdleState());

  final ProductService _productServices = serviceLocator<ProductService>();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is AddProduct) {
      yield* _mapAddProductToState(event);
    } else if (event is EditProduct) {
      yield* _mapEditProductToState(event);
    } else if (event is DeleteProduct) {
      yield* _mapDeleteProductToState(event);
    }
  }

  Stream<ProductState> _mapAddProductToState(AddProduct event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      await Future.delayed(Duration(seconds: 2));
      // TODO: handle list of response
      ResponseResults results =
          await _productServices.submitProduct(_product(event));

      yield* _listOfResults(results);
    } else {
      yield _nullValueError();
    }
  }

  Stream<ProductState> _mapEditProductToState(EditProduct event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      yield _loading();
      ResponseResult result =
          await _productServices.editProductByCode(_product(event));
      await Future.delayed(Duration(seconds: 2));

      if (result.status == true) {
        yield _success(result);
      } else {
        yield _error(result);
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<ProductState> _mapDeleteProductToState(DeleteProduct event) async* {
    Map<String, String> pcode = {'pcode': event.pcode};
    ResponseResult result = await _productServices.deleteProduct(pcode);
    if (result.status == true) {
      yield _success(result);
    } else {
      yield _error(result);
    }
  }

  bool _isEventAttributeIsNotNull(var event) {
    if (event.nosps != '' &&
        event.pcode != '' &&
        event.pname != '' &&
        event.salaryps != '' &&
        event.sunit != '' &&
        event.nospsunit != '' &&
        event.pricepersunit != '') {
      return true;
    }
    return false;
  }

  Product _product(var event) {
    return Product(
      pname: event.pname,
      pcode: event.pcode,
      salaryps: event.salaryps,
      nosps: event.nosps,
      sunit: event.sunit,
      nospsunit: event.nospsunit,
      pricepersunit: event.pricepersunit,
    );
  }

  ProductState _success(ResponseResult result, {String size}) {
    return size != null
        ? ProductSuccess(result.status, size + result.message)
        : ProductSuccess(result.status, result.message);
  }

  Stream<ProductState> _listOfResults(ResponseResults results) async* {
    for (int i = 0; i < results.totalResults; i++) {
      final String size = "(${i + 1}/${results.totalResults}) ";
      if (i != 0) {
        await Future.delayed(Duration(seconds: 2));
      }
      if (results.responseResults[i].status == true) {
        yield _success(results.responseResults[i], size: size);
      } else {
        yield _error(results.responseResults[i], size: size);
      }
    }
  }

  ProductState _error(ResponseResult result, {String size}) {
    return size != null
        ? ProductError(result.status, size + result.message)
        : ProductError(result.status, result.message);
  }

  ProductState _nullValueError() {
    return ProductError(false, 'please fill required fields');
  }

  ProductState _loading() {
    return ProductLoading(true, 'Uploading..');
  }
}
