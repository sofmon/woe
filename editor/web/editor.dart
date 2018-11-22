part of owe;

class Editor extends UI {
  html.Element _element;
  html.Element get element => _element;

  UI _ui;

  html.Node _parentElement;

  Editor(this._parentElement) : super(null) {
    _load();
  }

  void triggerCheck() {
    if (ready()) {
      _save();
    }
  }

  dynamic toDynamic() {
    return _ui.toDynamic();
  }

  bool ready() {
    return _ui.ready();
  }

  void clear() {
    _ui.clear();
  }

  void _load() {
    html.HttpRequest.getString("./owe.json").then((String responseText) {
      dynamic data = convert.json.decode(responseText);
      _ui = createUI(data);
      _parentElement.append(_ui.element);
    });
  }

  void _save() {
    var res = toDynamic();
    var json = convert.json.encode(res);
    html.HttpRequest.request("./owe.json", method: "PUT", sendData: json)
        .then((html.HttpRequest req) {
          // TODO: process error
        });
  }
}
