part of woe;

class NumberInputUI extends UI {
  num _startValue;

  var _input = new html.NumberInputElement()..step = "0.00000001";

  var _ready = new html.CheckboxInputElement()
    ..style.display = "none"
    ..checked = true;

  String get _startValueString => _startValue.toStringAsFixed(8);

  num get _value => _input.valueAsNumber;

  bool get _modified => _input.value != _startValueString;

  html.Element _element;
  html.Element get element => _element;

  NumberInputUI(this._startValue, UI parent) : super(parent) {
    _input.value = _startValueString;

    _input.onBlur.listen(_onBlur);
    _input.onChange.listen(_onChange);

    _ready.onClick.listen(_onBlur);

    _element = html.SpanElement()
      ..style.whiteSpace = "nowrap"
      ..append(_input)
      ..append(_ready);
      
    _refresh();
  }

  void _onBlur(html.Event e) {
    _refresh();
    triggerCheck();
  }

  void _refresh() {
    if (!_modified || _deleted) {
      _ready.style.display = "none";
      return;
    }

    _ready.style
      ..display = ""
      ..boxShadow = _ready.checked
          ? "0 0 2vw 0 rgba(0, 255, 0, 1)"
          : "0 0 2vw 0 rgba(255, 0, 0, 1)";
  }

  void _onChange(html.Event e) {
    _ready.checked = false;
  }

  dynamic toDynamic() {
    return _value;
  }

  bool ready() {
    return !_modified || _ready.checked;
  }

  void deleted(bool deleted) {
    if (_input == null) return;

    _input.style..textDecoration = deleted ? "line-through" : "";

    super.deleted(deleted);

    _refresh();
  }

  void clear() {
    _input.value = "";
    _startValue = 0;
    _refresh();
  }
}
