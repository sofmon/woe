part of owe;

class Editor extends UI {

  html.Element _element;
  html.Element get element => _element;

  UI _ui;

  Editor(dynamic data) : super(null) {
    _ui = createUI(data);
    _element = _ui.element;
  }

  void triggerCheck() {
    var res = _ui.toDynamic();
    var json = convert.json.encode(res);
    print(json);
  }

  dynamic toDynamic() {
    var res = _ui.toDynamic();
    var json = convert.json.encode(res);
    print(json);
  }

  void clear() {
    _ui.clear();
  }

}
