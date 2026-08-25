// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mafia_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MafiaPlayer {

 String get id; String get name;
/// Create a copy of MafiaPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MafiaPlayerCopyWith<MafiaPlayer> get copyWith => _$MafiaPlayerCopyWithImpl<MafiaPlayer>(this as MafiaPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MafiaPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MafiaPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MafiaPlayerCopyWith<$Res>  {
  factory $MafiaPlayerCopyWith(MafiaPlayer value, $Res Function(MafiaPlayer) _then) = _$MafiaPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MafiaPlayerCopyWithImpl<$Res>
    implements $MafiaPlayerCopyWith<$Res> {
  _$MafiaPlayerCopyWithImpl(this._self, this._then);

  final MafiaPlayer _self;
  final $Res Function(MafiaPlayer) _then;

/// Create a copy of MafiaPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MafiaPlayer].
extension MafiaPlayerPatterns on MafiaPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MafiaPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MafiaPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MafiaPlayer value)  $default,){
final _that = this;
switch (_that) {
case _MafiaPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MafiaPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _MafiaPlayer() when $default != null:
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
case _MafiaPlayer() when $default != null:
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
case _MafiaPlayer():
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
case _MafiaPlayer() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _MafiaPlayer implements MafiaPlayer {
  const _MafiaPlayer({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of MafiaPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MafiaPlayerCopyWith<_MafiaPlayer> get copyWith => __$MafiaPlayerCopyWithImpl<_MafiaPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MafiaPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MafiaPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MafiaPlayerCopyWith<$Res> implements $MafiaPlayerCopyWith<$Res> {
  factory _$MafiaPlayerCopyWith(_MafiaPlayer value, $Res Function(_MafiaPlayer) _then) = __$MafiaPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$MafiaPlayerCopyWithImpl<$Res>
    implements _$MafiaPlayerCopyWith<$Res> {
  __$MafiaPlayerCopyWithImpl(this._self, this._then);

  final _MafiaPlayer _self;
  final $Res Function(_MafiaPlayer) _then;

/// Create a copy of MafiaPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MafiaPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
