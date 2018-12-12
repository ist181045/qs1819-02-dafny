# 2nd Software Specification Project - 2018/2019
## Question 1
> Note that in the `FileSystemState` and the `FileStream` classes, all of the
> functions say they read `this`. Why is this important?

`reads this` means that the functions depend on the instance of the class,
meaning the instance is readable by the function, or that the function has
access to the instance's contents since it is now in the function's reading
frame. This is important so the function can only access information about the
specific object and not every instance's invariants.

---
## Question 2
> Note that it isn't possible to create new `FileSystemState` objects. What
> would problems might arise if this were possible?

Similar to the `OkState` and `HostConstants` classes, this class is used for
verification purposes only, not having a native implementation counterpart. If
we could instantiate it, and we proceeded to do it, an error during compilation
time would be raised.

---
## Question 3
> Semantically, what does it mean if you add preconditions (`requires`) to the
> `Main` method?

It means that we're imposing restrictions on the environment the program will be
running on. In other words, it conditions the execution of the program according
to a given set of restrictions, including file system state, command line
argument count and content, or a mixture of both, essentially controlling the
program's "inputs".