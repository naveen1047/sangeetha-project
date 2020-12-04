import 'package:bloc/bloc.dart';
import 'package:core/src/business_logics/util/generate_date.dart';

class DatePickerCubit extends Cubit<String> {
  DatePickerCubit(String state) : super(generateDate());

  void selectDate(DateTime dateTime) =>
      emit(generateDate(selectedDate: dateTime));
}
