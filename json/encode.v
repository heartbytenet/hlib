module json

import x.json2
import maps

fn property(key string, value Value) string {
	return json2.encode(key) + ":" + encode(value)
}

pub fn encode(value Value) string {
	return match value {
		[]Value { "[" + value.map(encode).join(",") + "]" }
		Null { "null" }	
		bool { value.str() } 
		f64 { value.str() }
		map[string]Value { "{" + maps.to_array(value, property).join(",") + "}" }
		string { json2.encode(value) }
	}
}
