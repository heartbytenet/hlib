module json

struct Scanner {
	tokens []Token
mut:
	pos int	
}

fn new_scanner(tokens []Token) Scanner {
	return Scanner { tokens: tokens, pos: 0 }
}

fn (mut scanner Scanner) next() !Token {
	token := scanner.tokens[scanner.pos] or { 
		return error("unexpected end of input") 
	}
	scanner.pos++
	return token
}

fn (mut scanner Scanner) skip() {
	scanner.pos++
}

fn (mut scanner Scanner) peek() !Token {
	return scanner.tokens[scanner.pos] or { 
		return error("unexpected end of input") 
	}
}

fn (mut scanner Scanner) ensure(expected Token) ! {
	token := scanner.next()!
	if token != expected { 
		return error("expected ${expected}, got ${token}") 
	}
}
