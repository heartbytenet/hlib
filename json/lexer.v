module json

import encoding.binary
import encoding.hex
import strconv
import strings

const unescapes = {
	`\\`: `\\`,
	`/`: `/`,
	`"`: `"`,
	`b`: `\b`,
	`t`: `\t`,
	`n`: `\n`,
	`f`: `\f`,
	`r`: `\r`
}

const symbols = {
	`{`: Token(LeftBrace {}),
	`}`: Token(RightBrace {}),
	`[`: Token(LeftBracket {}),
	`]`: Token(RightBracket {}),
	`:`: Token(Colon {}),
	`,`: Token(Comma {})
}

const whitespace = [`\t`, `\n`, `\r`, ` `]

fn lex(source string) ![]Token {
	mut tokens := []Token{}
	mut pos := 0
	for pos < source.len {
		curr := source[pos]
		if curr in whitespace {
			pos++
		} else if token := symbols[curr] {
			pos++
			tokens << token
		} else if curr == `"` {
			pos++
			mut builder := strings.new_builder(32) // TODO: figure out good starting size
			for pos < source.len {
				chr := source[pos]
				pos++
				if chr == `"` { 
					tokens << StringLit { value: builder.str() }
					break 
				} else if chr == `\\` {
					escaped := source[pos]
					pos++
					if value := unescapes[escaped] {
						builder.write_byte(value)
					} else if escaped == `u` {
						bytes := hex.decode(source[pos..pos+4]) or { 
							return error("invalid unicode escape sequence in string literal")
						}
						builder.write_rune(rune(binary.little_endian_u16(bytes)))
						pos += 4
					} else { 
						return error("invalid escape sequence in string literal") 
					}
				} else if chr < 32 {
					return error("unescaped ascii control character in string literal")	
				} else {
					builder.write_byte(chr)
				}
			}
		} else if source[pos..].starts_with("null") { // TODO: improve this performance-wise
			tokens << NullLit {}
			pos += 4
		} else if source[pos..].starts_with("true") { // TODO: improve this performance-wise
			tokens << BoolLit { value: true }
			pos += 4
		} else if source[pos..].starts_with("false") { // TODO: improve this performance-wise
			tokens << BoolLit { value: false }
			pos += 5
		} else { // parse numerical literal
			start := pos
			// optional negative sign
			if curr == `-` { 
				pos++ 
			}
			// integer part
			if source[pos] == `0` {
				pos++
			} else if source[pos].is_digit() {
				pos++
				for source[pos].is_digit() { 
					pos++ 
				}
			} else {
				return error("unexpected character `${rune(source[pos])}`")
			}
			// optional decimal part
			if source[pos] == `.` {
				pos++
				if source[pos].is_digit() {
					pos++
				} else {
					return error("invalid character in decimal part of number literal `${rune(source[pos])}`")
				}
				for source[pos].is_digit() { 
					pos++ 
				}
			}
			// optional exponent part
			if source[pos] in [`e`, `E`] {
				pos++
				if source[pos] in [`-`, `+`] {
					pos++
				}
				if source[pos].is_digit() {
					pos++
				} else {
					return error("invalid character in exponent part of number literal `${rune(source[pos])}`")
				}
				for source[pos].is_digit() {
					pos++
				}
			}
			value := strconv.atof64(source[start..pos])!
			tokens << NumberLit { value: value }
		}
	}
	return tokens
}
