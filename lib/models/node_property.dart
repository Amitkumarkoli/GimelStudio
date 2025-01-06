import 'package:gimelstudio/models/node_base.dart';

/// Base class for all properties.
///
/// A Property is the representation of a single point of
/// data that can changed either be evaluation of an input
/// or by the change of the value directly by the user.
abstract class Property {
  Property({
    required this.id,
    required this.idname,
    required this.dataType,
    required this.value,
    required this.isExposed,
  });

  /// A unique id.
  String id;

  /// The string by which this property will be referenced.
  /// This should be unique per node type.
  final String idname;

  /// The data type of this property.
  final Type dataType;

  /// The current value of the property, which is
  /// used if ``connection`` is null.
  dynamic value;

  /// Whether this property is exposed in the node graph.
  bool isExposed;

  /// The connected node to evaluate the value from.
  /// If this is null, then value is used during evaluation.
  /// (NodeBase object, name of the connected node's Output)
  // TODO: for the purposes of converting to json and back, NodeBase should be the id of the node.
  (NodeBase, String)? connection;

  void setValue(Object newValue) {
    if (dataType == int) {
      assert(newValue is int); // TODO: remove after testing
    }
    value = newValue;
  }

  void setConnection((NodeBase, String) newConnection) {
    connection = newConnection;
  }

  Map<String, dynamic> toJson() {
    return {
      // TODO
      'id': id,
      'idname': idname,
      'dataType': dataType.toString(),
      'value': value,
      'connection': connection,
    };
  }

  // TODO
  // Property.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       idname = json['idname'],
  //       dataType = json['dataType'],
  //       value = json['value'],
  //       connection = json['connection'];

  @override
  String toString() {
    return 'id: $id, idname: $idname, dataType: $dataType, value: $value, isExposed: $isExposed, connection: $connection';
  }
}

/// Integer input.
class IntegerProperty extends Property {
  IntegerProperty({
    required super.id,
    required super.idname,
    required super.dataType,
    required super.value,
    required super.isExposed,
  }) : assert(value is int);
}
