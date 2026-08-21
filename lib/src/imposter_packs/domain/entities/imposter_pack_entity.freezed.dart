// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imposter_pack_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImposterPackEntity {

 String get id; String get name; String get category; List<String> get words; bool get isCustom;
/// Create a copy of ImposterPackEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImposterPackEntityCopyWith<ImposterPackEntity> get copyWith => _$ImposterPackEntityCopyWithImpl<ImposterPackEntity>(this as ImposterPackEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImposterPackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.words, words)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,const DeepCollectionEquality().hash(words),isCustom);

@override
String toString() {
  return 'ImposterPackEntity(id: $id, name: $name, category: $category, words: $words, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $ImposterPackEntityCopyWith<$Res>  {
  factory $ImposterPackEntityCopyWith(ImposterPackEntity value, $Res Function(ImposterPackEntity) _then) = _$ImposterPackEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, List<String> words, bool isCustom
});




}
/// @nodoc
class _$ImposterPackEntityCopyWithImpl<$Res>
    implements $ImposterPackEntityCopyWith<$Res> {
  _$ImposterPackEntityCopyWithImpl(this._self, this._then);

  final ImposterPackEntity _self;
  final $Res Function(ImposterPackEntity) _then;

/// Create a copy of ImposterPackEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? words = null,Object? isCustom = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<String>,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImposterPackEntity].
extension ImposterPackEntityPatterns on ImposterPackEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImposterPackEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImposterPackEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImposterPackEntity value)  $default,){
final _that = this;
switch (_that) {
case _ImposterPackEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImposterPackEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ImposterPackEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  List<String> words,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImposterPackEntity() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.words,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  List<String> words,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _ImposterPackEntity():
return $default(_that.id,_that.name,_that.category,_that.words,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  List<String> words,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _ImposterPackEntity() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.words,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc


class _ImposterPackEntity implements ImposterPackEntity {
  const _ImposterPackEntity({this.id = '', this.name = '', this.category = '', final  List<String> words = const <String>[], this.isCustom = false}): _words = words;
  

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String category;
 final  List<String> _words;
@override@JsonKey() List<String> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}

@override@JsonKey() final  bool isCustom;

/// Create a copy of ImposterPackEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImposterPackEntityCopyWith<_ImposterPackEntity> get copyWith => __$ImposterPackEntityCopyWithImpl<_ImposterPackEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImposterPackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._words, _words)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,const DeepCollectionEquality().hash(_words),isCustom);

@override
String toString() {
  return 'ImposterPackEntity(id: $id, name: $name, category: $category, words: $words, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$ImposterPackEntityCopyWith<$Res> implements $ImposterPackEntityCopyWith<$Res> {
  factory _$ImposterPackEntityCopyWith(_ImposterPackEntity value, $Res Function(_ImposterPackEntity) _then) = __$ImposterPackEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, List<String> words, bool isCustom
});




}
/// @nodoc
class __$ImposterPackEntityCopyWithImpl<$Res>
    implements _$ImposterPackEntityCopyWith<$Res> {
  __$ImposterPackEntityCopyWithImpl(this._self, this._then);

  final _ImposterPackEntity _self;
  final $Res Function(_ImposterPackEntity) _then;

/// Create a copy of ImposterPackEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? words = null,Object? isCustom = null,}) {
  return _then(_ImposterPackEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<String>,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
