part of owe;

class StringInputUI extends UI {
  String _string;
  String _newValue;

  html.InputElement _input;
  html.CheckboxInputElement _ready;

  html.Element _element;
  html.Element get element => _element;

  StringInputUI(this._string, UI parent) : super(parent) {
    _input = new html.InputElement();
    _input.value = _string;

    _input.onBlur.listen(_onBlur);

    _ready = new html.CheckboxInputElement()
      ..style.display = "none"
      ..onClick.listen(_onBlur);

    _element = html.SpanElement()
      ..style.whiteSpace = "nowrap"
      ..append(_input)
      ..append(_ready);
  }

  void _onBlur(html.Event e) {
    var defaultValue = _input.value == _string;
    var newValue = _newValue != _input.value;

    if (defaultValue) {
      _ready.style.display = "none";
      return;
    }

    if (newValue) {
      _ready.checked = false;
    }

    _ready.style
      ..display = ""
      ..boxShadow = _ready.checked
          ? "0 0 2vw 0 rgba(0, 255, 0, 1)"
          : "0 0 2vw 0 rgba(255, 0, 0, 1)";

    _newValue = _input.value;

    triggerCheck();
  }

  dynamic toDynamic() {
    return _input.value;
  }

  void clear() {
    _input.value = "";
    _string = "";
    _onBlur(null);
  }
}
