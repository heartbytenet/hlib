module json

struct LeftBrace {}

struct RightBrace {}

struct LeftBracket {}

struct RightBracket {}

struct Comma {}

struct Colon {}

struct NullLit {}

struct BoolLit {
	value bool
}

struct NumberLit {
	value f64
}

struct StringLit {
	value string
}

type Token 
	= BoolLit
	| Comma
	| Colon
	| NumberLit
	| LeftBrace
	| LeftBracket
	| NullLit
	| RightBrace
	| RightBracket
	| StringLit
