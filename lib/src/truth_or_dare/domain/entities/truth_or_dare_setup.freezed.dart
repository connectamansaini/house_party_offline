// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truth_or_dare_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TruthOrDareSetup {

 List<TruthOrDarePlayer> get players; TruthOrDareConfig get config;/// The host's own prompts to shuffle in — already filtered by the
/// config's include flag, so the game just deals what it's given.
 List<String> get customTruths; List<String> get customDares;
/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruthOrDareSetupCopyWith<TruthOrDareSetup> get copyWith => _$TruthOrDareSetupCopyWithImpl<TruthOrDareSetup>(this as TruthOrDareSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruthOrDareSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.customTruths, customTruths)&&const DeepCollectionEquality().equals(other.customDares, customDares));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config,const DeepCollectionEquality().hash(customTruths),const DeepCollectionEquality().hash(customDares));

@override
String toString() {
  return 'TruthOrDareSetup(players: $players, config: $config, customTruths: $customTruths, customDares: $customDares)';
}


}

/// @nodoc
abstract mixin class $TruthOrDareSetupCopyWith<$Res>  {
  factory $TruthOrDareSetupCopyWith(TruthOrDareSetup value, $Res Function(TruthOrDareSetup) _then) = _$TruthOrDareSetupCopyWithImpl;
@useResult
$Res call({
 List<TruthOrDarePlayer> players, TruthOrDareConfig config, List<String> customTruths, List<String> customDares
});


$TruthOrDareConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$TruthOrDareSetupCopyWithImpl<$Res>
    implements $TruthOrDareSetupCopyWith<$Res> {
  _$TruthOrDareSetupCopyWithImpl(this._self, this._then);

  final TruthOrDareSetup _self;
  final $Res Function(TruthOrDareSetup) _then;

/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,Object? customTruths = null,Object? customDares = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<TruthOrDarePlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as TruthOrDareConfig,customTruths: null == customTruths ? _self.customTruths : customTruths // ignore: cast_nullable_to_non_nullable
as List<String>,customDares: null == customDares ? _self.customDares : customDares // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TruthOrDareConfigCopyWith<$Res> get config {
  
  return $TruthOrDareConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [TruthOrDareSetup].
extension TruthOrDareSetupPatterns on TruthOrDareSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruthOrDareSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruthOrDareSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruthOrDareSetup value)  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruthOrDareSetup value)?  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TruthOrDarePlayer> players,  TruthOrDareConfig config,  List<String> customTruths,  List<String> customDares)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruthOrDareSetup() when $default != null:
return $default(_that.players,_that.config,_that.customTruths,_that.customDares);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TruthOrDarePlayer> players,  TruthOrDareConfig config,  List<String> customTruths,  List<String> customDares)  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareSetup():
return $default(_that.players,_that.config,_that.customTruths,_that.customDares);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TruthOrDarePlayer> players,  TruthOrDareConfig config,  List<String> customTruths,  List<String> customDares)?  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareSetup() when $default != null:
return $default(_that.players,_that.config,_that.customTruths,_that.customDares);case _:
  return null;

}
}

}

/// @nodoc


class _TruthOrDareSetup implements TruthOrDareSetup {
  const _TruthOrDareSetup({required final  List<TruthOrDarePlayer> players, required this.config, final  List<String> customTruths = const <String>[], final  List<String> customDares = const <String>[]}): _players = players,_customTruths = customTruths,_customDares = customDares;
  

 final  List<TruthOrDarePlayer> _players;
@override List<TruthOrDarePlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  TruthOrDareConfig config;
/// The host's own prompts to shuffle in — already filtered by the
/// config's include flag, so the game just deals what it's given.
 final  List<String> _customTruths;
/// The host's own prompts to shuffle in — already filtered by the
/// config's include flag, so the game just deals what it's given.
@override@JsonKey() List<String> get customTruths {
  if (_customTruths is EqualUnmodifiableListView) return _customTruths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customTruths);
}

 final  List<String> _customDares;
@override@JsonKey() List<String> get customDares {
  if (_customDares is EqualUnmodifiableListView) return _customDares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customDares);
}


/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruthOrDareSetupCopyWith<_TruthOrDareSetup> get copyWith => __$TruthOrDareSetupCopyWithImpl<_TruthOrDareSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruthOrDareSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other._customTruths, _customTruths)&&const DeepCollectionEquality().equals(other._customDares, _customDares));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config,const DeepCollectionEquality().hash(_customTruths),const DeepCollectionEquality().hash(_customDares));

@override
String toString() {
  return 'TruthOrDareSetup(players: $players, config: $config, customTruths: $customTruths, customDares: $customDares)';
}


}

/// @nodoc
abstract mixin class _$TruthOrDareSetupCopyWith<$Res> implements $TruthOrDareSetupCopyWith<$Res> {
  factory _$TruthOrDareSetupCopyWith(_TruthOrDareSetup value, $Res Function(_TruthOrDareSetup) _then) = __$TruthOrDareSetupCopyWithImpl;
@override @useResult
$Res call({
 List<TruthOrDarePlayer> players, TruthOrDareConfig config, List<String> customTruths, List<String> customDares
});


@override $TruthOrDareConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$TruthOrDareSetupCopyWithImpl<$Res>
    implements _$TruthOrDareSetupCopyWith<$Res> {
  __$TruthOrDareSetupCopyWithImpl(this._self, this._then);

  final _TruthOrDareSetup _self;
  final $Res Function(_TruthOrDareSetup) _then;

/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,Object? customTruths = null,Object? customDares = null,}) {
  return _then(_TruthOrDareSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<TruthOrDarePlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as TruthOrDareConfig,customTruths: null == customTruths ? _self._customTruths : customTruths // ignore: cast_nullable_to_non_nullable
as List<String>,customDares: null == customDares ? _self._customDares : customDares // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of TruthOrDareSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TruthOrDareConfigCopyWith<$Res> get config {
  
  return $TruthOrDareConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
