String generateDate({DateTime selectedDate}) {
  String day, month;
  int year;

  if (selectedDate != null) {
    day =
        selectedDate.day < 10 ? '0${selectedDate.day}' : '${selectedDate.day}';
    month = selectedDate.month < 10
        ? '0${selectedDate.month}'
        : '${selectedDate.month}';
    year = selectedDate.year;
    return '$day-$month-$year';
  } else {
    day = DateTime.now().day < 10
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    month = DateTime.now().month < 10
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    year = DateTime.now().year;
    return '$day-$month-$year';
  }
}
