part of owe;

class BoolInputUI extends UI {
  bool _startValue;

  var _input = new html.SelectElement()
    ..append(
        new html.OptionElement(data: "FALSE", value: "FALSE", selected: true))
    ..append(
        new html.OptionElement(data: "TRUE", value: "TRUE", selected: false));

  var _ready = new html.CheckboxInputElement()..style.display = "none";

  bool get _value => _input.selectedIndex == 1;

  bool get _modified => _startValue != _value;

  html.Element _element;
  html.Element get element => _element;

  BoolInputUI(this._startValue, UI parent) : super(parent) {
    _input.selectedIndex = this._startValue ? 1 : 0;

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
    if(_input == null) return;

    _input.style
      ..textDecoration = deleted ? "line-through" : "";

    super.deleted(deleted);

    _refresh();
  }

  void clear() {
    _input.selectedIndex = 0;
    _startValue = false;
    _refresh();
  }
}
