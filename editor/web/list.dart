part of owe;

class ListUI extends UI {
  List _list;
  html.TableRowElement _addRowElement;

  var _columns = new List<String>();
  var _children = new List<RowUI>();

  var _element = new html.TableElement();
  html.Element get element => _element;

  var _addElement = html.SpanElement()
    ..text = "➕"
    ..style.cursor = "pointer";

  ListUI(this._list, UI parent) : super(parent) {
    _list.forEach((i) => _extractColumns(i));
    _columns.add("✎");
    _element.append(tableHeader(_columns));

    _list.forEach((i) => _children.add(new RowUI(i, _columns, this)));
    _children.forEach((ui) => _element.append(ui.element));

    var addRow = List<html.Element>();
    for (int i = 0; i < _columns.length - 1; i++) {
      addRow.add(html.SpanElement());
    }
    addRow.add(_addElement);
    _addRowElement = tableRow(addRow);
    _element.append(_addRowElement);

    _addElement.onClick.listen(_addNewRow);
  }

  void _extractColumns(dynamic item) {
    if (!(item is Map)) {
      _addColumnName("");
      return;
    }

    Map map = item;
    map.forEach((k, v) => _addColumnName(k));
  }

  void _addColumnName(String name) {
    if (_columns.contains(name)) {
      return;
    }
    _columns.add(name);
  }

  void _addNewRow(html.Event e) {
    if (_children.length <= 0) {
      return; // can't do anything here ... TODO
    }
    var newRow = _children.last.clone();
    newRow.clear();
    _children.add(newRow);
    _element.insertBefore(newRow.element, _addRowElement);
    triggerCheck();
  }

  dynamic toDynamic() {
    var res = new List();
    for (int i = 0; i < _children.length; i++) {
      var data = _children[i].toDynamic();
      if (data == null) {
        continue;
      }
      res.add(data);
    }
    return res;
  }

  bool ready() {
    return !_children.any((c) => !c.ready());
  }

  void clear() {
    _children.forEach((c) => c.clear());
  }
}

class RowUI extends UI {
  Map _map;
  List<String> _columns;

  var _children = new Map<String, UI>();

  html.TableRowElement _element;
  html.Element get element => _element;

  var _ready = new html.CheckboxInputElement()..style.display = "none";

  var _deleteElement = html.SpanElement()
    ..text = "🗑"
    ..style.cursor = "pointer";

  RowUI(this._map, this._columns, UI parent) : super(parent) {
    var rowElements = new List<html.Element>();
    for (int i = 0; i < _columns.length - 1; i++) {
      var c = _columns[i];
      if (!_map.containsKey(c)) {
        rowElements.add(new EmptyUI(this).element);
        continue;
      }

      var ui = createUI(_map[c]);
      _children[c] = ui;
      rowElements.add(ui.element);
    }

    _deleteElement.onClick.listen(_deleteRow);
    _ready.onClick.listen(_onBlur);

    var deleteNoWrap = html.SpanElement()
      ..style.whiteSpace = "nowrap"
      ..append(_deleteElement)
      ..append(_ready);

    rowElements.add(deleteNoWrap);

    _element = tableRow(rowElements);
  }

  dynamic toDynamic() {
    if (_deleted) {
      return null;
    }
    var res = new Map();
    _children.forEach((k, v) => res[k] = v.toDynamic());
    return res;
  }

  bool ready() {
    return (_deleted && _ready.checked ) || (!_deleted && !_children.values.any((c) => !c.ready()));
  }

  void _deleteRow(html.Event e) {
    _deleted = !_deleted;

    deleted(_deleted);

    _onBlur(null);
  }

  void deleted(bool deleted) {
    _element.style
      ..textDecoration = deleted ? "line-through" : ""
      ..background = deleted
          ? "repeating-linear-gradient(-55deg,#ccc,#ccc 5px,#fff 5px,#fff 10px)"
          : "";
    _children.forEach((k, v)=>v.deleted(deleted));
    super.deleted(deleted);
  }

  void _onBlur(html.Event e) {
    if (!_deleted) {
      _ready.style.display = "none";
      triggerCheck();
      return;
    }

    _ready.style
      ..display = ""
      ..boxShadow = _ready.checked
          ? "0 0 2vw 0 rgba(0, 255, 0, 1)"
          : "0 0 2vw 0 rgba(255, 0, 0, 1)";

    triggerCheck();
  }

  RowUI clone() {
    var map = new Map();
    _map.forEach((k, v) => map[k] = v);

    var rowUI = new RowUI(map, _columns, _parent);

    return rowUI;
  }

  void clear() {
    _children.forEach((k, v) => v.clear());
  }
}
