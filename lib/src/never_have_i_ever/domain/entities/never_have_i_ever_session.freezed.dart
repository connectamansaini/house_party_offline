// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'never_have_i_ever_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NeverHaveIEverSession {

 List<NeverHaveIEverPlayer> get players; Map<String, int> get lives; List<String> get deck; int get promptIndex;
/// Create a copy of NeverHaveIEverSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeverHaveIEverSessionCopyWith<NeverHaveIEverSession> get copyWith => _$NeverHaveIEverSessionCopyWithImpl<NeverHaveIEverSession>(this as NeverHaveIEverSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeverHaveIEverSession&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.lives, lives)&&const DeepCollectionEquality().equals(other.deck, deck)&&(identical(other.promptIndex, promptIndex) || other.promptIndex == promptIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(lives),const DeepCollectionEquality().hash(deck),promptIndex);

@override
String toString() {
  return 'NeverHaveIEverSession(players: $players, lives: $lives, deck: $deck, promptIndex: $promptIndex)';
}


}

/// @nodoc
abstract mixin class $NeverHaveIEverSessionCopyWith<$Res>  {
  factory $NeverHaveIEverSessionCopyWith(NeverHaveIEverSession value, $Res Function(NeverHaveIEverSession) _then) = _$NeverHaveIEverSessionCopyWithImpl;
@useResult
$Res call({
 List<NeverHaveIEverPlayer> players, Map<String, int> lives, List<String> deck, int promptIndex
});




}
/// @nodoc
class _$NeverHaveIEverSessionCopyWithImpl<$Res>
    implements $NeverHaveIEverSessionCopyWith<$Res> {
  _$NeverHaveIEverSessionCopyWithImpl(this._self, this._then);

  final NeverHaveIEverSession _self;
  final $Res Function(NeverHaveIEverSession) _then;

/// Create a copy of NeverHaveIEverSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? lives = null,Object? deck = null,Object? promptIndex = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<NeverHaveIEverPlayer>,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self.deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,promptIndex: null == promptIndex ? _self.promptIndex : promptIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NeverHaveIEverSession].
extension NeverHaveIEverSessionPatterns on NeverHaveIEverSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeverHaveIEverSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeverHaveIEverSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeverHaveIEverSession value)  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeverHaveIEverSession value)?  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NeverHaveIEverPlayer> players,  Map<String, int> lives,  List<String> deck,  int promptIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeverHaveIEverSession() when $default != null:
return $default(_that.players,_that.lives,_that.deck,_that.promptIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NeverHaveIEverPlayer> players,  Map<String, int> lives,  List<String> deck,  int promptIndex)  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverSession():
return $default(_that.players,_that.lives,_that.deck,_that.promptIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NeverHaveIEverPlayer> players,  Map<String, int> lives,  List<String> deck,  int promptIndex)?  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverSession() when $default != null:
return $default(_that.players,_that.lives,_that.deck,_that.promptIndex);case _:
  return null;

}
}

}

/// @nodoc


class _NeverHaveIEverSession extends NeverHaveIEverSession {
  const _NeverHaveIEverSession({required final  List<NeverHaveIEverPlayer> players, required final  Map<String, int> lives, required final  List<String> deck, required this.promptIndex}): _players = players,_lives = lives,_deck = deck,super._();
  

 final  List<NeverHaveIEverPlayer> _players;
@override List<NeverHaveIEverPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  Map<String, int> _lives;
@override Map<String, int> get lives {
  if (_lives is EqualUnmodifiableMapView) return _lives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_lives);
}

 final  List<String> _deck;
@override List<String> get deck {
  if (_deck is EqualUnmodifiableListView) return _deck;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deck);
}

@override final  int promptIndex;

/// Create a copy of NeverHaveIEverSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeverHaveIEverSessionCopyWith<_NeverHaveIEverSession> get copyWith => __$NeverHaveIEverSessionCopyWithImpl<_NeverHaveIEverSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeverHaveIEverSession&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._lives, _lives)&&const DeepCollectionEquality().equals(other._deck, _deck)&&(identical(other.promptIndex, promptIndex) || other.promptIndex == promptIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_lives),const DeepCollectionEquality().hash(_deck),promptIndex);

@override
String toString() {
  return 'NeverHaveIEverSession(players: $players, lives: $lives, deck: $deck, promptIndex: $promptIndex)';
}


}

/// @nodoc
abstract mixin class _$NeverHaveIEverSessionCopyWith<$Res> implements $NeverHaveIEverSessionCopyWith<$Res> {
  factory _$NeverHaveIEverSessionCopyWith(_NeverHaveIEverSession value, $Res Function(_NeverHaveIEverSession) _then) = __$NeverHaveIEverSessionCopyWithImpl;
@override @useResult
$Res call({
 List<NeverHaveIEverPlayer> players, Map<String, int> lives, List<String> deck, int promptIndex
});




}
/// @nodoc
class __$NeverHaveIEverSessionCopyWithImpl<$Res>
    implements _$NeverHaveIEverSessionCopyWith<$Res> {
  __$NeverHaveIEverSessionCopyWithImpl(this._self, this._then);

  final _NeverHaveIEverSession _self;
  final $Res Function(_NeverHaveIEverSession) _then;

/// Create a copy of NeverHaveIEverSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? lives = null,Object? deck = null,Object? promptIndex = null,}) {
  return _then(_NeverHaveIEverSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<NeverHaveIEverPlayer>,lives: null == lives ? _self._lives : lives // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self._deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,promptIndex: null == promptIndex ? _self.promptIndex : promptIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
