import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/src/services/employee_service.dart';
import 'package:core/src/services/product_service.dart';

import '../../../../core.dart';

part 'production_prerequisite_state.dart';

part 'production_prerequisite_event.dart';

class ProductionPrerequisiteBloc
    extends Bloc<ProductionPrerequisiteEvent, ProductionPrerequisiteState> {
  final EmployeeService _viewEmployeeService =
      serviceLocator<EmployeeService>();

  final ProductService _viewProductService = serviceLocator<ProductService>();

  ProductionPrerequisiteBloc() : super(ProductionPrerequisiteLoading());

  Employees _employees;
  List<Employee> _filteredEmployee;

  Products _products;
  List<Product> _filteredProduct;

  @override
  Stream<ProductionPrerequisiteState> mapEventToState(
      ProductionPrerequisiteEvent event) async* {
    if (event is GetProductionPrerequisite) {
      yield* _mapGetProductionPrerequisite();
    }
  }

  Stream<ProductionPrerequisiteState> _mapGetProductionPrerequisite() async* {
    try {
      yield ProductionPrerequisiteLoading();

      if (_employees == null || _products == null) {
        _employees = await _viewEmployeeService.getAllEmployees();
        _filteredEmployee = _employees.employees;
        _filteredEmployee.sort(
            (a, b) => a.ename.toLowerCase().compareTo(b.ename.toLowerCase()));

        _products = await _viewProductService.getAllProducts();
        _filteredProduct = _products.products.toList();
        _filteredProduct.sort(
            (a, b) => a.pname.toLowerCase().compareTo(b.pname.toLowerCase()));
      }
      if (_products.totalResults < 1 || _employees.employees.length < 1) {
        yield ProductionPrerequisiteError(
            "suppler or material is empty, You can't add material purchase");
      } else {
        yield ProductionPrerequisiteLoaded(
            _employees.employees, _products.products);
      }
    } catch (e) {
      yield ProductionPrerequisiteError(e.toString());
    }
  }
}
