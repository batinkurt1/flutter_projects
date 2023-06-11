import "package:flutter/material.dart";


class Car {
String name;
}

void main() {
// these are dart basics. Go to dartpad.dev to run.
int a=5;

double b=5.7;

// num accepts both integer and double types.
num c=100.56;

num d=100;

String name="Bato";

bool flag= false;

print(a);

print(b);

// will print double
print(c.runtimeType);

// will print int
print(d.runtimeType);

print(name);

// converts a to string
print(a.toString());

print(flag);

print(name +" " + c.toString());

// This method is called string interpolation. ${name} can be used in different situations. Search for further information.
// It is like the f-string laterals in python and it can be used to pass in different types of variables into a string. 
// Search for further information. 
print("Hello my name is $name");

print("I am $a years old");

// auto declarator in Dart is var.
var x= "Kıral";

// final variables cannot be redefined but they can be modified.
final y="HOCA";

// const values cannot be redefined, changed or modified in any way.
const z=3;

// this will print out String.
print(x.runtimeType);

print(y.runtimeType);

if(z>=3){
print(z);
}

else if(z==3){
print("this is an elif statement.");
}

else{
  print("this is an else statement.");
}

// look at z; if it's 3 , do that; if it's 4, do that; if it's neither, do that.
switch(z){
case 3:
print("z is three");
break;

case 4:
print("z is four");
break;

default:
print("this is default");
}
// break, continue, pass keywords exist.
for (int x=1;x<=10;x++){
print(x);
}

while(a>=3){
  print(a);
  a--;
}

// there's something as do while loop. It is similar to the while loop but the loop does not evaluate the condition for the first time.
// Search for further information.

var list1=["bato","kudur","agla"];
print(list1);

//syntax is weird but you'll learn.
list1.forEach((element) {
print(element);
 });

// maps are like dictionaries in Python.

var map1={"name":"Bato","age":"19","mow":"m"};
print(map1["name"]);

map1.values.forEach((element) {
  print(element);
});

// map1.keys and map1.values returns a tuple.

//defining a void function with a default parameter.
void printIt(String name, {var age=12}){
print(name+" "+ age);
}

//overriding default parameter.
printIt("Batın",age:21);

// parameter in square bracket means this is optional, but we need to include the ??(null operator) in the code in case of null inputs.
void nulltest([String name]){
  print(name??"null");

}
nulltest();
nulltest("Bato");

int retfunc(String name){
  print(name);
  return 1;
}
int res=retfunc("Bato");
print(res);
 
// oop. classes should be out of the void main function.

}