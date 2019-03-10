

a = 1;
function foo() {
  console.log(a);
}
foo();
// 1


a = 1;
function foo() {
  console.log(a);
}
foo();function bar() {
  var a = 3;
  foo();
}
var a = 2;
bar();
// 1
// 2

a = 1;
function foo() {
  console.log(a);
}
foo();function bar() {
  var a = 3;
  foo();
}
var a = 2;
bar();
foo();
// 1
// 2
// 2

