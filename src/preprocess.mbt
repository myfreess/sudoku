///|
fn eliminate(
  values : Grid[@immut/sorted_set.T[Char]],
  key : String,
  val : Char
) -> Bool {
  if not(values[key].contains(val)) {
    return true
  }
  values[key] = values[key].remove(val)
  // 如果key对应的可能性只剩下一种，则从key的邻近位置中消除此可能性
  match values[key].size() {
    1 => {
      let val = values[key].min()
      let mut res = true
      for key in peers[key] {
        res = res && eliminate(values, key, val)
      }
      if not(res) {
        return res
      }
    }
    0 => return false
    _ => ()
  }
  // 如果key所在的unit中只剩下一个方块可容纳val, 则把val赋值给该方块
  let unit = units[key]
  let places = unit.filter(fn(sq) { values[sq].contains(val) })
  match places.size() {
    1 => {
      let key = places.min()
      return assign(values, key, val)
    }
    0 => return false
    _ => return true
  }
}

///|
fn assign(
  values : Grid[@immut/sorted_set.T[Char]],
  key : String,
  val : Char
) -> Bool {
  let other_values = values[key].remove(val)
  let mut result = true
  for val in other_values {
    result = result && eliminate(values, key, val)
  }
  return result
}

///|
fn Grid::parse(s : String) -> Grid[@immut/sorted_set.T[Char]] {
  let digits = @immut/sorted_set.from_array(cols.to_array())
  let values = Grid::new(digits)
  let chars = s
    .iter()
    .filter(fn(ch) { ch is ('0'..='9') || ch == '.' })
    .collect()
  let pairs = squares.to_array().zip(chars)
  for p in pairs {
    let (square, digit) = p
    if digit is ('1'..='9') {
      if not(assign(values, square, digit)) {
        // println("parseGrid(): found contradiction")
        abort("parseGrid(): found contradiction")
      }
    }
  }
  return values
}

///|
fn Grid::format(self : Grid[@immut/sorted_set.T[Char]]) -> String {
  let rep = Array::make(81, "")
  let mut i = 0
  let mut maxWidth = 0
  while i < 81 {
    rep[i] = self._[i].fold(init="", fn(acc, ch) { acc + ch.to_string() })
    maxWidth = @math.maximum(rep[i].length(), maxWidth)
    i = i + 1
  }
  let buf = StringBuilder::new(size_hint=1000)
  i = 0
  while i < 81 {
    buf.write_string(" ")
    buf.write_string(rep[i])
    buf.write_string(String::make(maxWidth - rep[i].length(), ' '))
    if (i + 1) % 27 == 0 && i + 1 != 81 {
      buf.write_string("\n")
      buf.write_string(String::make(maxWidth * 3 + 6, '-'))
      buf.write_string("+")
      buf.write_string(String::make(maxWidth * 3 + 6, '-'))
      buf.write_string("+")
      buf.write_string(String::make(maxWidth * 3 + 6, '-'))
      buf.write_string("\n")
    } else if (i + 1) % 9 == 0 {
      buf.write_string("\n")
    } else if (i + 1) % 3 == 0 {
      buf.write_string(" |")
    } else {
      buf.write_string(" ")
    }
    i = i + 1
  }
  buf.to_string()
}

///|
test {
  inspect(
    Grid::parse(grid1).format(),
    content=
      #| 4        1679     12679   | 139      2369     269     | 8        1239     5      
      #| 26789    3        1256789 | 14589    24569    245689  | 12679    1249     124679 
      #| 2689     15689    125689  | 7        234569   245689  | 12369    12349    123469 
      #|---------------------------+---------------------------+---------------------------
      #| 3789     2        15789   | 3459     34579    4579    | 13579    6        13789  
      #| 3679     15679    15679   | 359      8        25679   | 4        12359    12379  
      #| 36789    4        56789   | 359      1        25679   | 23579    23589    23789  
      #|---------------------------+---------------------------+---------------------------
      #| 289      89       289     | 6        459      3       | 1259     7        12489  
      #| 5        6789     3       | 2        479      1       | 69       489      4689   
      #| 1        6789     4       | 589      579      5789    | 23569    23589    23689  
      #|
    ,
  )
  inspect(
    Grid::parse(grid2).format(),
    content=
      #| 4  8  3 | 9  2  1 | 6  5  7
      #| 9  6  7 | 3  4  5 | 8  2  1
      #| 2  5  1 | 8  7  6 | 4  9  3
      #|---------+---------+---------
      #| 5  4  8 | 1  3  2 | 9  7  6
      #| 7  2  9 | 5  6  4 | 1  3  8
      #| 1  3  6 | 7  9  8 | 2  4  5
      #|---------+---------+---------
      #| 3  7  2 | 6  8  9 | 5  1  4
      #| 8  1  4 | 2  5  3 | 7  6  9
      #| 6  9  5 | 4  1  7 | 3  8  2
      #|
    ,
  )
}
