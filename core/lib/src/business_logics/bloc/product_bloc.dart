import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/models/product.dart';
import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/services/product_service.dart';
import 'package:core/src/services/service_locator.dart';
import 'package:equatable/equatable.dart';

// event
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends ProductEvent {
  final String pname;
  final String pcode;
  final String salaryps;
  final String nosps;
  final String sunit;
  final String pricepersunit;
  final String nospsunit;

  AddProduct({
    this.pname,
    this.pcode,
    this.salaryps,
    this.nosps,
    this.sunit,
    this.pricepersunit,
    this.nospsunit,
  });

  @override
  List<Object> get props => [
        pname,
        pcode,
        salaryps,
        nosps,
        sunit,
        pricepersunit,
        nospsunit,
      ];
}

class EditProduct extends ProductEvent {
  final String pname;
  final String pcode;
  final String salaryps;
  final String nosps;
  final String sunit;
  final String pricepersunit;
  final String nospsunit;

  EditProduct({
    this.pname,
    this.pcode,
    this.salaryps,
    this.nosps,
    this.sunit,
    this.pricepersunit,
    this.nospsunit,
  });

  @override
  List<Object> get props => [
        pname,
        pcode,
        salaryps,
        nosps,
        sunit,
        pricepersunit,
        nospsunit,
      ];
}

class DeleteProduct extends ProductEvent {
  final String pcode;

  DeleteProduct({
    this.pcode,
  });

  @override
  List<Object> get props => [];
}

// state
abstract class ProductState {
  const ProductState();
}

class ProductIdleState extends ProductState {}

class ProductSuccess extends ProductState {
  final bool status;
  final String message;

  ProductSuccess(this.status, this.message);
}

class ProductError extends ProductState {
  final bool status;
  final String message;

  ProductError(this.status, this.message);
}

// bloc
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
      // TODO: handle list of response
      ResponseResults results =
          await _productServices.submitProduct(_product(event));
      for (var result in results.responseResults) {
        if (result.status == true) {
          yield _success(result);
        } else {
          yield _error(result);
        }
      }
    } else {
      yield _nullValueError();
    }
  }

  Stream<ProductState> _mapEditProductToState(EditProduct event) async* {
    if (_isEventAttributeIsNotNull(event)) {
      ResponseResult result =
          await _productServices.editProductByCode(_product(event));
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

  ProductState _success(ResponseResult result) {
    return ProductSuccess(result.status, result.message);
  }

  ProductState _error(ResponseResult result) {
    return ProductError(result.status, result.message);
  }

  ProductState _nullValueError() {
    return ProductError(false, 'please fill required fields');
  }
}
