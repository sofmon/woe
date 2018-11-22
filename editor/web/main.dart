library owe;

import 'dart:html' as html;
import 'dart:convert' as convert;

part 'ui.dart';
part 'editor.dart';
part 'map.dart';
part 'list.dart';
part 'input_string.dart';
part 'input_number.dart';
part 'input_bool.dart';

void main() {
  new Editor(html.document.body);
}