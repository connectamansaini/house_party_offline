// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heads_up_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeadsUpSetup {

 List<HeadsUpPlayer> get players; HeadsUpConfig get config; List<String> get words;
/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadsUpSetupCopyWith<HeadsUpSetup> get copyWith => _$HeadsUpSetupCopyWithImpl<HeadsUpSetup>(this as HeadsUpSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadsUpSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.words, words));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'HeadsUpSetup(players: $players, config: $config, words: $words)';
}


}

/// @nodoc
abstract mixin class $HeadsUpSetupCopyWith<$Res>  {
  factory $HeadsUpSetupCopyWith(HeadsUpSetup value, $Res Function(HeadsUpSetup) _then) = _$HeadsUpSetupCopyWithImpl;
@useResult
$Res call({
 List<HeadsUpPlayer> players, HeadsUpConfig config, List<String> words
});


$HeadsUpConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$HeadsUpSetupCopyWithImpl<$Res>
    implements $HeadsUpSetupCopyWith<$Res> {
  _$HeadsUpSetupCopyWithImpl(this._self, this._then);

  final HeadsUpSetup _self;
  final $Res Function(HeadsUpSetup) _then;

/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,Object? words = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<HeadsUpPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as HeadsUpConfig,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeadsUpConfigCopyWith<$Res> get config {
  
  return $HeadsUpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [HeadsUpSetup].
extension HeadsUpSetupPatterns on HeadsUpSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadsUpSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadsUpSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadsUpSetup value)  $default,){
final _that = this;
switch (_that) {
case _HeadsUpSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadsUpSetup value)?  $default,){
final _that = this;
switch (_that) {
case _HeadsUpSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HeadsUpPlayer> players,  HeadsUpConfig config,  List<String> words)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadsUpSetup() when $default != null:
return $default(_that.players,_that.config,_that.words);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HeadsUpPlayer> players,  HeadsUpConfig config,  List<String> words)  $default,) {final _that = this;
switch (_that) {
case _HeadsUpSetup():
return $default(_that.players,_that.config,_that.words);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HeadsUpPlayer> players,  HeadsUpConfig config,  List<String> words)?  $default,) {final _that = this;
switch (_that) {
case _HeadsUpSetup() when $default != null:
return $default(_that.players,_that.config,_that.words);case _:
  return null;

}
}

}

/// @nodoc


class _HeadsUpSetup implements HeadsUpSetup {
  const _HeadsUpSetup({required final  List<HeadsUpPlayer> players, required this.config, required final  List<String> words}): _players = players,_words = words;
  

 final  List<HeadsUpPlayer> _players;
@override List<HeadsUpPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  HeadsUpConfig config;
 final  List<String> _words;
@override List<String> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}


/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadsUpSetupCopyWith<_HeadsUpSetup> get copyWith => __$HeadsUpSetupCopyWithImpl<_HeadsUpSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadsUpSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other._words, _words));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config,const DeepCollectionEquality().hash(_words));

@override
String toString() {
  return 'HeadsUpSetup(players: $players, config: $config, words: $words)';
}


}

/// @nodoc
abstract mixin class _$HeadsUpSetupCopyWith<$Res> implements $HeadsUpSetupCopyWith<$Res> {
  factory _$HeadsUpSetupCopyWith(_HeadsUpSetup value, $Res Function(_HeadsUpSetup) _then) = __$HeadsUpSetupCopyWithImpl;
@override @useResult
$Res call({
 List<HeadsUpPlayer> players, HeadsUpConfig config, List<String> words
});


@override $HeadsUpConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$HeadsUpSetupCopyWithImpl<$Res>
    implements _$HeadsUpSetupCopyWith<$Res> {
  __$HeadsUpSetupCopyWithImpl(this._self, this._then);

  final _HeadsUpSetup _self;
  final $Res Function(_HeadsUpSetup) _then;

/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,Object? words = null,}) {
  return _then(_HeadsUpSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<HeadsUpPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as HeadsUpConfig,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of HeadsUpSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeadsUpConfigCopyWith<$Res> get config {
  
  return $HeadsUpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
