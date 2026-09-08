// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'most_likely_to_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MostLikelyToPlayer {

 String get id; String get name;
/// Create a copy of MostLikelyToPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MostLikelyToPlayerCopyWith<MostLikelyToPlayer> get copyWith => _$MostLikelyToPlayerCopyWithImpl<MostLikelyToPlayer>(this as MostLikelyToPlayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MostLikelyToPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MostLikelyToPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MostLikelyToPlayerCopyWith<$Res>  {
  factory $MostLikelyToPlayerCopyWith(MostLikelyToPlayer value, $Res Function(MostLikelyToPlayer) _then) = _$MostLikelyToPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MostLikelyToPlayerCopyWithImpl<$Res>
    implements $MostLikelyToPlayerCopyWith<$Res> {
  _$MostLikelyToPlayerCopyWithImpl(this._self, this._then);

  final MostLikelyToPlayer _self;
  final $Res Function(MostLikelyToPlayer) _then;

/// Create a copy of MostLikelyToPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MostLikelyToPlayer].
extension MostLikelyToPlayerPatterns on MostLikelyToPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MostLikelyToPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MostLikelyToPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MostLikelyToPlayer value)  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MostLikelyToPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToPlayer() when $default != null:
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
case _MostLikelyToPlayer() when $default != null:
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
case _MostLikelyToPlayer():
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
case _MostLikelyToPlayer() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _MostLikelyToPlayer implements MostLikelyToPlayer {
  const _MostLikelyToPlayer({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of MostLikelyToPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MostLikelyToPlayerCopyWith<_MostLikelyToPlayer> get copyWith => __$MostLikelyToPlayerCopyWithImpl<_MostLikelyToPlayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MostLikelyToPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MostLikelyToPlayer(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MostLikelyToPlayerCopyWith<$Res> implements $MostLikelyToPlayerCopyWith<$Res> {
  factory _$MostLikelyToPlayerCopyWith(_MostLikelyToPlayer value, $Res Function(_MostLikelyToPlayer) _then) = __$MostLikelyToPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$MostLikelyToPlayerCopyWithImpl<$Res>
    implements _$MostLikelyToPlayerCopyWith<$Res> {
  __$MostLikelyToPlayerCopyWithImpl(this._self, this._then);

  final _MostLikelyToPlayer _self;
  final $Res Function(_MostLikelyToPlayer) _then;

/// Create a copy of MostLikelyToPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MostLikelyToPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
