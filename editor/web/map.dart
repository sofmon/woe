part of owe;

class MapUI extends UI {
  Map _map;

  html.Element _element;
  html.Element get element => _element;

  Map<String, UI> _children;

  MapUI(this._map, UI parent) : super(parent) {
    _children = Map<String, UI>();
    _element = html.Element.table();
    _map.forEach((k, v) => _createUIs(k, v));
  }

  _createUIs(dynamic k, dynamic v) {
    var ui = createUI(v);
    _children[k] = ui;
    _element.append(
        tableRow(List<html.Element>()..add(_fixedHeader(k))..add(ui.element)));
  }

  dynamic toDynamic() {
    var res = new Map();
    _children.forEach((k, v) => res[k] = v.toDynamic());
    return res;
  }

  bool ready() {
    return !_children.values.any((c)=>!c.ready());
  }

  void clear() {
    _children.forEach((k, v) => v.clear());
  }

  void deleted(bool deleted) {
    _children.values.forEach((c)=>c.deleted(deleted));
    super.deleted(deleted);
  }

  html.SpanElement _fixedHeader(String text) {
    var el = html.SpanElement()
      ..text = niceText(text)
      ..style.display = "block";
    html.document.onScroll.listen((e) => _onScroll(e, el));
    return el;
  }

  void _onScroll(html.Event e, html.SpanElement el) {
    if (el.parent == null) {
      return;
    }
    var offsetTop = _getOffsetTop(el) - html.window.pageYOffset;
    if (offsetTop < 0 &&
        -offsetTop < el.parent.offsetHeight - el.offsetHeight) {
      el.style.transform = "translateY(" + (-offsetTop).toString() + "px)";
    } else {
      el.style.transform = "translateY(0px)";
    }
  }

  int _getOffsetTop(html.Element el) {
    int res = 0;

    while (el != null) {
      res += el.offsetTop;
      el = el.offsetParent;
    }

    return res;
  }
}
