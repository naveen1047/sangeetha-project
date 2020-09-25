import 'dart:math';
import 'package:bloc/bloc.dart';

class RandomCodeCubit extends Cubit<String> {
  RandomCodeCubit(String state) : super('');

  void generate(String sname) => emit(_convertToCode(sname));

  String _convertToCode(String text) {
    if (text == '' || text == null) return '';
    text = text
        .replaceAll("_", "")
        .split(new RegExp(r"[\s-]"))
        .map((word) => word.length > 1 ? word[0] : word)
        .map((letter) => letter.toUpperCase())
        .where((item) => item.contains(new RegExp(r"[A-Z]")))
        .reduce((result, item) => result + item);
    text += Random().nextInt(99).toString();
    text += Random().nextInt(9).toString();
    text += String.fromCharCode((Random().nextInt(26) + 65));
    return text;
  }
}
