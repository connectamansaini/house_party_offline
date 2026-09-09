// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heads_up_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeadsUpPlayer {

 String get id; String get name;
/// Create a copy of HeadsUpPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadsUpPlayerCopyWith<HeadsUpPlayer> get copyWith => _$HeadsUpPlayerCopyWithImpl<HeadsUpPlayer>(this as HeadsUpPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadsUpPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'HeadsUpPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $HeadsUpPlayerCopyWith<$Res>  {
  factory $HeadsUpPlayerCopyWith(HeadsUpPlayer value, $Res Function(HeadsUpPlayer) _then) = _$HeadsUpPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$HeadsUpPlayerCopyWithImpl<$Res>
    implements $HeadsUpPlayerCopyWith<$Res> {
  _$HeadsUpPlayerCopyWithImpl(this._self, this._then);

  final HeadsUpPlayer _self;
  final $Res Function(HeadsUpPlayer) _then;

/// Create a copy of HeadsUpPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadsUpPlayer].
extension HeadsUpPlayerPatterns on HeadsUpPlayer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadsUpPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadsUpPlayer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadsUpPlayer value)  $default,){
final _that = this;
switch (_that) {
case _HeadsUpPlayer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadsUpPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _HeadsUpPlayer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadsUpPlayer() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _HeadsUpPlayer():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _HeadsUpPlayer() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _HeadsUpPlayer implements HeadsUpPlayer {
  const _HeadsUpPlayer({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of HeadsUpPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadsUpPlayerCopyWith<_HeadsUpPlayer> get copyWith => __$HeadsUpPlayerCopyWithImpl<_HeadsUpPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadsUpPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'HeadsUpPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$HeadsUpPlayerCopyWith<$Res> implements $HeadsUpPlayerCopyWith<$Res> {
  factory _$HeadsUpPlayerCopyWith(_HeadsUpPlayer value, $Res Function(_HeadsUpPlayer) _then) = __$HeadsUpPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$HeadsUpPlayerCopyWithImpl<$Res>
    implements _$HeadsUpPlayerCopyWith<$Res> {
  __$HeadsUpPlayerCopyWithImpl(this._self, this._then);

  final _HeadsUpPlayer _self;
  final $Res Function(_HeadsUpPlayer) _then;

/// Create a copy of HeadsUpPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_HeadsUpPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
