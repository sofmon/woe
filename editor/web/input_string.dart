part of owe;

const TEXTAREA_LENGHT_THRESHOLD = 100;
const SOME_RANDOM_TEXT = '55f07dd6-87d3-48ba-9fe1-2f45a1ffbea1';

class StringInputUI extends UI {
  String _startValue;

  html.InputElement _inputElement;
  html.TextAreaElement _textareaElement;

  html.Element get _activeElement => _isTextArea?_textareaElement:_inputElement;

  var _isTextArea = false;
  String get _value => _isTextArea
      ? (_textareaElement != null ? _textareaElement.value : "")
      : (_inputElement != null ? _inputElement.value : "");

  bool get _modified => _value != _startValue;

  var _ready = new html.CheckboxInputElement()..style.display = "none";

  html.Element _element;
  html.Element get element => _element;

  StringInputUI(this._startValue, UI parent) : super(parent) {
    _isTextArea = _startValue.contains("\n") ||
        _startValue.length > TEXTAREA_LENGHT_THRESHOLD;

    _element = html.SpanElement()
      ..style.whiteSpace = "nowrap"
      ..append(_ready);
    _ready.onClick.listen(_onBlur);

    if (_isTextArea) {
      _switchToTextarea();
      _textareaElement.value = _startValue;
    } else {
      _switchToInput();
      _inputElement.value = _startValue;
    }

    _refresh();
  }

  void _switchToTextarea() {
    if (_inputElement != null) {
      _inputElement.remove();
    }
    var value = _value;
    _textareaElement = new html.TextAreaElement();
    _textareaElement.value = value;
    _element.insertBefore(_textareaElement, _ready);
    _textareaElement.onBlur.listen(_onBlur);
    _textareaElement.onChange.listen(_onChange);
    _isTextArea = true;
    _textareaElement.focus();
  }

  void _switchToInput() {
    if (_textareaElement != null) {
      _textareaElement.remove();
    }
    var value = _value;
    _inputElement = new html.InputElement();
    _inputElement.value = value;
    _element.insertBefore(_inputElement, _ready);
    _inputElement.onBlur.listen(_onBlur);
    _inputElement.onChange.listen(_onChange);
    _inputElement.onKeyDown
        .where((k) => k.keyCode == html.KeyCode.ENTER)
        .listen((ke) => _switchToTextarea());
    _inputElement.onDoubleClick.listen((e) => _switchToTextarea());
    _isTextArea = false;
    _inputElement.focus();
  }

  void _onChange(html.Event e) {
    _ready.checked = false;
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

  dynamic toDynamic() {
    return _value;
  }

  bool ready() {
    return !_modified || _ready.checked;
  }

  void deleted(bool deleted) {
    if(_activeElement == null) return;

    _activeElement.style
      ..textDecoration = deleted ? "line-through" : "";

    super.deleted(deleted);

    _refresh();
  }

  void clear() {
    if (_inputElement != null) {
      _inputElement.value = "";
    }
    if (_textareaElement != null) {
      _textareaElement.value = "";
    }
    _startValue = SOME_RANDOM_TEXT;
    _refresh();
  }
}
