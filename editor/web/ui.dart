part of owe;

abstract class UI {
  UI _parent;
  bool _deleted = false;

  UI(this._parent) {}

  html.Element get element;

  UI createUI(dynamic data) {
    if (data is Map) {
      return MapUI(data, this);
    }
    if (data is List) {
      return ListUI(data, this);
    }
    if (data is String) {
      return StringInputUI(data, this);
      // TODO: support dates
    }
    if (data is num) {
      return NumberInputUI(data, this);
    }
    if (data is bool) {
      return BoolInputUI(data, this);
    }
    return EmptyUI(this);
  }

  html.Element header(String name) {
    int i = 0;
    UI ui = _parent;
    while (ui != null) {
      ui = ui._parent;
      i++;
    }
    html.HeadingElement el;
    switch (i) {
      case 1:
        el = html.HeadingElement.h1();
        break;
      case 2:
        el = html.HeadingElement.h2();
        break;
      case 3:
        el = html.HeadingElement.h3();
        break;
      case 4:
        el = html.HeadingElement.h4();
        break;
      case 5:
        el = html.HeadingElement.h5();
        break;
      default:
        el = html.HeadingElement.h6();
        break;
    }
    el.text = name;
    return el;
  }

  html.Element tableRow(List<html.Element> elements) {
    html.Element tr = html.Element.tr();
    elements.forEach((e) => tr.append(html.Element.td()..append(e)));
    return tr;
  }

  html.Element tableHeader(List<String> elements) {
    html.Element tr = html.Element.tr();
    elements.forEach((e) => tr.append(html.Element.th()..text = niceText(e)));
    return tr;
  }

  void triggerCheck() {
    if (_parent == null) {
      return;
    }
    _parent.triggerCheck();
  }

  void clear();

  bool ready();

  void deleted(bool del) {
    _deleted = del;
  }

  String niceText(String text) {
    var sb = new StringBuffer();
    var breaks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.runes;
    var lastWasUp = true;
    var runes = text.runes.toList();
    if (!runes.any((r) => !breaks.contains(r))) {
      return text;
    }
    for (int i = 0; i < text.runes.length; i++) {
      var r = runes[i];
      if (breaks.contains(r)) {
        if (!lastWasUp) {
          sb.write(" ");
        }
        lastWasUp = true;
      } else {
        lastWasUp = false;
      }
      sb.writeCharCode(r);
    }
    return sb.toString().toLowerCase();
  }

  dynamic toDynamic();
}

class EmptyUI extends UI {
  var _element = new html.SpanElement();
  html.Element get element => _element;

  EmptyUI(UI parent) : super(parent) {}

  dynamic toDynamic() {
    return null;
  }

  bool ready() {
    return true;
  }

  void clear() {}
}
