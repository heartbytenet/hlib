module optional

pub struct Optional[T] {
	value T
	exists bool
}

pub fn some[T](x T) Optional[T] {
	return Optional[T] { value: x, exists: true }
}

pub fn empty[T]() Optional[T] {
	return Optional[T] { exists: false }
}

pub fn (x Optional[T]) is_empty() bool {
	return !x.exists
}

pub fn (x Optional[T]) get() !T {
	return if x.exists { x.value } else { error("optional is empty") }
}

pub fn (x Optional[T]) map[T, U](f fn (T) U) Optional[U] {
	return if x.exists { some(f(x.value)) } else { empty[U]() }
}

pub fn (x Optional[T]) flat_map[T, U](f fn (T) Optional[U]) Optional[U] {
	return if x.exists { f(x.value) } else { empty[U]() }
}
