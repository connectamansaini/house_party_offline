// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'never_have_i_ever_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NeverHaveIEverPlayer {

 String get id; String get name;
/// Create a copy of NeverHaveIEverPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeverHaveIEverPlayerCopyWith<NeverHaveIEverPlayer> get copyWith => _$NeverHaveIEverPlayerCopyWithImpl<NeverHaveIEverPlayer>(this as NeverHaveIEverPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeverHaveIEverPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'NeverHaveIEverPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $NeverHaveIEverPlayerCopyWith<$Res>  {
  factory $NeverHaveIEverPlayerCopyWith(NeverHaveIEverPlayer value, $Res Function(NeverHaveIEverPlayer) _then) = _$NeverHaveIEverPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$NeverHaveIEverPlayerCopyWithImpl<$Res>
    implements $NeverHaveIEverPlayerCopyWith<$Res> {
  _$NeverHaveIEverPlayerCopyWithImpl(this._self, this._then);

  final NeverHaveIEverPlayer _self;
  final $Res Function(NeverHaveIEverPlayer) _then;

/// Create a copy of NeverHaveIEverPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NeverHaveIEverPlayer].
extension NeverHaveIEverPlayerPatterns on NeverHaveIEverPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeverHaveIEverPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeverHaveIEverPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeverHaveIEverPlayer value)  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeverHaveIEverPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverPlayer() when $default != null:
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
case _NeverHaveIEverPlayer() when $default != null:
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
case _NeverHaveIEverPlayer():
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
case _NeverHaveIEverPlayer() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _NeverHaveIEverPlayer implements NeverHaveIEverPlayer {
  const _NeverHaveIEverPlayer({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of NeverHaveIEverPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeverHaveIEverPlayerCopyWith<_NeverHaveIEverPlayer> get copyWith => __$NeverHaveIEverPlayerCopyWithImpl<_NeverHaveIEverPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeverHaveIEverPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'NeverHaveIEverPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NeverHaveIEverPlayerCopyWith<$Res> implements $NeverHaveIEverPlayerCopyWith<$Res> {
  factory _$NeverHaveIEverPlayerCopyWith(_NeverHaveIEverPlayer value, $Res Function(_NeverHaveIEverPlayer) _then) = __$NeverHaveIEverPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$NeverHaveIEverPlayerCopyWithImpl<$Res>
    implements _$NeverHaveIEverPlayerCopyWith<$Res> {
  __$NeverHaveIEverPlayerCopyWithImpl(this._self, this._then);

  final _NeverHaveIEverPlayer _self;
  final $Res Function(_NeverHaveIEverPlayer) _then;

/// Create a copy of NeverHaveIEverPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_NeverHaveIEverPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
