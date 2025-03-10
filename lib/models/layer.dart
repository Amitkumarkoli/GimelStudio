import 'package:gimelstudio/models/nodegraph.dart';

 enum LayerBlendMode {
  normal,
  darken,
  multiply,
  colorBurn,
  // ...
}

class Layer {
  Layer({
    required this.id,
    required this.index,
    required this.name,
    required this.selected,
    required this.visible,
    required this.locked,
    required this.opacity,
    required this.blend,
    required this.nodegraph,
  });

  final String id;
  int index;
  String name;
  bool selected;
  bool visible;
  bool locked;
  int opacity;
  dynamic blend;
  NodeGraph nodegraph;

  dynamic lastCache = null;
  bool needsEvaluation = true;
  dynamic thumbnail = null;

  void setIndex(int newIndex) {
    index = newIndex;
  }

  void setSelected(bool isSelected) {
    selected = isSelected;
  }

  void setVisibility(bool isVisible) {
    visible = isVisible;
  }

  void setLocked(bool isLocked) {
    locked = isLocked;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'selected': selected,
      'visible': visible,
      'locked': locked,
      'opacity': opacity,
      'blend': blend.name,
      'nodegraph': nodegraph.toJson(),
    };
  }

  Layer.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        index = json['index'] as int,
        name = json['name'] as String,
        selected = json['selected'] as bool,
        visible = json['visible'] as bool,
        locked = json['locked'] as bool,
        opacity = json['opacity'] as int,
        blend = LayerBlendMode.values.byName(json['blend'] as String),
        nodegraph = NodeGraph.fromJson(json['nodegraph'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'Layer{id: $id, index: $index, name: $name, selected: $selected, visible: $visible, locked: $locked, opacity: $opacity, blend: ${blend.name} nodegraph: $nodegraph}';
  }
}
