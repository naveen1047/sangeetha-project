import 'package:bloc/bloc.dart';

class TotalPriceCubit extends Cubit<int> {
  TotalPriceCubit(int state) : super(0);
  int unitPrice = 0;
  int quantity = 0;
  int totalPrice;

  void setPrice(int price) {
    unitPrice = price;
    emit(quantity * unitPrice);
  }

  void setQuantity(int q) {
    print(quantity.toString());

    quantity = q;
    emit(quantity * unitPrice);
  }
}
