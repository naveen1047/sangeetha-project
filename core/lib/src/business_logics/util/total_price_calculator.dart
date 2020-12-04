import 'package:bloc/bloc.dart';

class TotalPriceCubit extends Cubit<double> {
  TotalPriceCubit(double state) : super(0.0);
  double unitPrice = 0;
  double quantity = 0;
  double totalPrice;

  void setPrice(double price) {
    unitPrice = price;
    totalPrice = quantity * unitPrice;
    emit(totalPrice);
  }

  void setQuantity(double q) {
    print(quantity.toString());

    quantity = q;
    totalPrice = quantity * unitPrice;
    emit(totalPrice);
  }
}
