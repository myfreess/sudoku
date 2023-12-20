pub fn initValues() -> SquareMap[List[Char]] {
  let digits = cols.to_list()
  SquareMap::new(digits)
}

pub fn solveValues(values : SquareMap[List[Char]]) -> SquareMap[List[Char]] {
  match search(values) {
    None => abort("solve() : cant solve")
    Some(v) => v
  }
}

pub fn ij_assign(values: SquareMap[List[Char]], i : Int, j : Int, val : Int) -> Bool {
  let key = rows[i].to_string() + cols[j].to_string()
  let val = val.to_string()[0]
  assign(values, key, val)
}


pub fn ij_read(values: SquareMap[List[Char]], i : Int, j : Int) -> Int {
  let key = rows[i].to_string() + cols[j].to_string()
  let Cons(digit, Nil) = values[key]
  digit.to_int() - 48
}

fn init {
  // let grid1 = "..5.4...2 ...5.718. 4.71...3. 3..8..6.7 .72.59... 8.4...3.. 29.....1. ...4...56 54..68..."
  // printGrid(solve(grid1))
}
