# Language Specification of Chinort

## Variable Definition

```rust
def a: int = 1
def b := 2             // Omitted "int"
bind c := 3            // "bind" makes a variable cannot be reassigned
bind sum := a + b + c  // c will be 6
```

## Function Definition and Function Calling

```rust
bind add := fn x: int, y: int {  // Defined a function, named "add"
    ret x + y
}

bind res := add(1, 2)  // res will be 3
bind res := add 1, 2   // Omitted the brackets
```
