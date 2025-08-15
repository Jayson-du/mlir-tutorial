toy.func @add(%a: i32, %b: i32) -> i32 {
  %e = toy.add %a, %b : i32
  // region {
  //   %y = toy.add %a, %b : i32
  // }
  toy.ret %e : i32
}

toy.func @test(%a: i32, %b: i32) -> i32 {
  %c = toy.call @add(%a, %b) : (i32, i32) -> i32
  %d = toy.add %a, %b : i32
  %f = toy.add %d, %d : i32
  toy.ret %c : i32
}