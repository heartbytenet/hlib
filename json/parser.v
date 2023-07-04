module json

fn (mut scanner Scanner) parse() !Value {
	token := scanner.next()!
	return match token {
		LeftBrace { 
			mut object := map[string]Value{}
			key := scanner.next()!	
			match key {
				RightBrace { return object }
				StringLit { 
					scanner.ensure(Colon {})!
					object[key.value] = scanner.parse()!
				}
				else { return error("unexpected token in object ${key}") }
			}
			for {
				comma := scanner.next()!
				match comma {
					RightBrace { break }
					Comma {
						key_ := scanner.next()!		
						if key_ is StringLit {
							scanner.ensure(Colon {})!
							object[key_.value] = scanner.parse()!
						} else {
							return error("unexpected token in object ${key_}")
						}
					}
					else { return error("unexpected token in object ${comma}") }
				}
			}
			object
		}
		LeftBracket {
			mut array := []Value{}
			peek := scanner.peek()!
			if peek is RightBracket {
				scanner.skip()
				return array
			}
			array << scanner.parse()!
			for { 
				comma := scanner.next()!
				match comma {
					Comma {
						array << scanner.parse()!
					}
					RightBracket { break }
					else { 
						return error("unexpected token in array ${comma}")
					}
				}
			}
			array
		}
		BoolLit { token.value }
		NullLit { Null {} }
		NumberLit { token.value }
		StringLit { token.value }	
		else { error("unexpected token ${token}") }
	}
}

pub fn decode(source string) !Value {
	tokens := lex(source)!
	mut scanner := new_scanner(tokens)
	return scanner.parse()!
}
