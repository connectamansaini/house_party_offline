import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generates a unique id (v4) for domain objects such as players and packs.
String newId() => _uuid.v4();
