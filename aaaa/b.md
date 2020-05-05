NUMBER         → DIGIT+ ( "." DIGIT+ )? ;
STRING         → '"' <any char except '"'>* '"' ;
IDENTIFIER     → ALPHA ( ALPHA | DIGIT )* ;
ALPHA          → 'a' ... 'z' | 'A' ... 'Z' | '_' ;
DIGIT          → '0' ... '9' ;

reaches the end
runs out of characters
lookahead
truthy|falsey
RuntimeError
statements vs. expressions |> statement expressions
Some parser writers prefix a method name with “finish” if it is called after some of its corresponding grammar rule has already been consumed. In a big complex parser, this helps maintainers keep track of what state the token stream is in when a method is called. For Lox’s little parser, I didn’t bother.

a = 3;   // OK.
(a) = 3; // Error.

Scope and environments are close cousins.
block scope

comparison

It’s like the earlier arguments rule, except that each parameter is an identifier, not an expression. That’s a lot of new syntax for the parser to chew through, but the resulting AST node isn’t too bad:

var a = "outer";
{
  var a = a;
}

对变量最基本的操作，是对它的“绑定”（binding）和“取值”（evaluate）。

var a = "outer";
{
  var a = a;
}
var temp = a; // Run the initializer.
var a;        // Declare the variable.
a = temp;     // Initialize it.

var a; // Define the variable.
a = a; // Run the initializer.

return "at top level";??????

class DevonshireCream {
  serveOn() {
    return "Scones";
  }
}

print DevonshireCream; // Prints "DevonshireCream".

class Bagel {}
Bagel();

class Bagel {}
var bagel = Bagel();
print bagel; // Prints "Bagel instance".

someObject.someProperty = value;


var m = object.method;
m(argument);


class Box {}

fun notMethod(argument) {
  print "called function with " + argument;
}

var box = Box();
box.function = notMethod;
box.function("argument");

breakfast(omelette.filledWith(cheese), sausage);

var eggs = omelette.filledWith(cheese);
breakfast(eggs, sausage);


fun callback(a, b, c) {
  object.method(a, b, c);
}

takeCallback(callback);


takeCallback(object.method);
class Person {
  sayName() {
    print this.name;
  }
}

var jane = Person();
jane.name = "Jane";

var method = jane.sayName;
method(); // ?

class Person {
  sayName() {
    print this.name;
  }
}

var jane = Person();
jane.name = "Jane";

var bill = Person();
bill.name = "Bill";

bill.sayName = jane.sayName;
bill.sayName(); // ?


class Bacon {
  eat() {
    print "Crunch crunch crunch!";
  }
}

Bacon().eat(); // Prints "Crunch crunch crunch!".

class Egotist {
  speak() {
    print this;
  }
}

var method = Egotist().speak;
method();

class Cake {
  taste() {
    var adjective = "delicious";
    print "The " + this.flavor + " cake is " + adjective + "!";
  }
}

var cake = Cake();
cake.flavor = "German chocolate";
cake.taste(); // Prints "The German chocolate cake is delicious!".


class Thing {
  getCallback() {
    fun localFunction() {
      print this;
    }

    return localFunction;
  }
}

var callback = Thing().getCallback();
callback();

print this;
fun notAMethod() {
  print this;
}


class Foo {
  init() {
    print this;
  }
}

var foo = Foo();
print foo.init();



class Foo {
  init() {
    return "something else";
  }
}


class Foo {
  init() {
    return;
  }
}


class Math {
  class square(n) {
    return n * n;
  }
}

print Math.square(3); // Prints "9".


class Circle {
  init(radius) {
    this.radius = radius;
  }

  area {
    return 3.141592653 * this.radius * this.radius;
  }
}

var circle = Circle(4);
print circle.area; // Prints roughly "50.2655".
