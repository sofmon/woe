part of owe;

class NumberInputUI extends UI {
  num _number;
  String _newValue;

  html.NumberInputElement _input;
  html.CheckboxInputElement _ready;

  html.Element _element;
  html.Element get element => _element;

  String get _string => _number.toStringAsFixed(8);

  NumberInputUI(this._number, UI parent) : super(parent) {
    _input = new html.NumberInputElement()..step = "0.00000001";
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
    return _input.valueAsNumber;
  }

  void clear() {
    _input.value = "";
    _number = 0;
    _onBlur(null);
  }
}
