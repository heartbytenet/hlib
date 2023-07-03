module json

import hlib.optional

struct Null {}

type Value
	= []Value
	| Null
	| bool 
	| f64 
	| map[string]Value
	| string

pub fn (v Value) array() optional.Optional[[]Value] {
	return if v is []Value { optional.some(v) } else { optional.empty[[]Value]() }
}

pub fn (v Value) object() optional.Optional[map[string]Value] {
	return if v is map[string]Value { optional.some(v) } else { optional.empty[map[string]Value]() }
}

pub fn (v Value) is_null() bool {
	return v is Null
}

pub fn (v Value) bool() optional.Optional[bool] {
	return if v is bool { optional.some(v) } else { optional.empty[bool]() }
}

pub fn (v Value) f64() optional.Optional[f64] {
	return if v is f64 { optional.some(v) } else { optional.empty[f64]() }
}

pub fn (v Value) string() optional.Optional[string] {
	return if v is string { optional.some(v) } else { optional.empty[string]() }
}
