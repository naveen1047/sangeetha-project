String generateDate() {
  String day = DateTime.now().day < 10
      ? '0${DateTime.now().day}'
      : '${DateTime.now().day}';
  String month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : '${DateTime.now().month}';
  int year = DateTime.now().year;
  return '$day-$month-$year';
}
