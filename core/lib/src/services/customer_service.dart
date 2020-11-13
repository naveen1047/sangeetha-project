import 'package:core/src/business_logics/models/response_result.dart';
import 'package:core/src/business_logics/models/customer.dart';

abstract class CustomerService {
  Future<ResponseResult> submitCustomer(Customer customer);

  Future<ResponseResult> editCustomerByCode(Customer customer);

  Future<ResponseResult> deleteCustomer(Map<String, dynamic> ecode);

  Future<Customers> getAllCustomers();

  Future<Customer> getCustomerByName(String customerName);
}
