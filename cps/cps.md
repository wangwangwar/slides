# Topics

Callback -> Continuation -> Call With Continuation -> CPS

# Callback

`Callback`(回调) 的概念是，把一段可执行代码，作为参数传给其它代码，然后会在某个时候**回来调用**这段代码。如果是回调是立即发生的，叫做**同步回调(`Synchronous Callback`)**，如果是在未来某个时间回调，叫做**异步回调(`Asynchronous Callback`)**。

# 异步回调

异步回调很常见也是使用最多的，比如网络请求，文件处理等较耗时的情景异步回调很有用。
https://medium.com/swift-programming/continuation-passing-style-in-swift-e4d825962803#.9vqt39jw9

# 同步回调

同步回调呢？好像不常见，有什么用呢？

# `Objective-C`中模拟多返回值

在`Objective-C`中，由于缺少`Tuple`这种数据结构，方法无法返回多个值，但是可以用其它方式模拟：

# 指针的指针作为参数

传入`NSError`的指针的指针作为方法参数作为一个返回值，然后方法本身有一个返回值，模拟多返回值的效果：

~~~
NSError *error = nil;
NSData *data = [self getSynchronousData:&error];
if (error != nil) {
    // An error occurred
    return
}
//Continue execeution
~~~

# 用Callback模拟多返回值

~~~
[self getSynchronousData:^ (id data, NSError *error) {
    if (error != nil) {
        // An error occurred
        // 错误之后，控制流怎么由Callback转出去？
    }
}];
~~~

# `Swift`有`Tuple`实现多返回值：

~~~
func getSynchronousData() -> (data:NSData?, error:NSError?) {
    return (NSData(), NSError())
}
let response = getSynchronousData()
if let error = response.error {
    //An error occurred
}
//Continue execeution
~~~


~~程序控制流一直向下，然后在Callee完成动作后，再调用回调 `Callback`, 这时候控制流转移到了 `Callback`。
执行完成后呢？控制流会回到原来的路线吗？~~

# Continuation

更普遍来看，回调其实就是`延续`(`Continuation`)的一种对象化的实现（作为方法的参数）。

在计算机科学和程序设计中，`延续`是一种对程序控制流程/状态的抽象表现形式。 延续性使程序状态信息具体化，也可以理解为，一个延续性以数据结构的形式表现了程序在运行过程中某一点的计算状态，相应的数据内容可以被编程语言访问，不被运行时环境所隐藏掉。

延续性包含了当前程序的栈（包括当前周期内的所有数据，也就是本地变量），以及当前运行的位置。一个延续的实例可以在将来被用做控制流，被调用时它从所表达的状态开始恢复执行。

# Continuation in Haskell

具体来讲，`continuation`是一个表示计算(computation)的剩余部分的函数（procedure)。
举例：

对表达式 `3 * (f() + 8)`, 在对表达式 `f()` 求值后，计算的剩余部分就是对求值结果加 `8`，然后对和乘 `3`。 比如用函数 `current_continuation` 来表示 `f()` 的延续：

~~~
void current_continuation(int result) {
    result += 8;
    result *= 3;
    (continuation of 3 * (f() + 8))(result);
}
~~~

这里把调用的返回值传给了延续。

有一些语言（如 Scheme, SML/NJ, Haskell, Scala) 把延续看作一等公民(first-class citizen)。
比如在 Scheme 中，函数 `call-with-current-continuation` (`call/cc`) 以一个函数为参数，这个函数以当前计算的延续作为参数。

~~~
(call/cc (lambda (current-continuation)
  body))
~~~

在对表达式 `body` 求值过程中， 当前延续绑定到变量 `current-continuation` 上。 如果调用 `current-continuation`, 会立即从 `call/cc` 的调用过程中返回， `call/cc` 会返回调用 `current-continuation` 的参数。如：

~~~
(display
  (call/cc (lambda (cc)
            (display "I got here.\n")
            (cc "This string was passed to the continuation.\n")
            (display "But not here.\n"))))
; 会打印
; I got here.
; This string was passed to the continuation.
~~~

延续强大之处在于，即使 `call/cc` 已经完成了， 延续仍可以被调用。如：

~~~
(let ((start #f))

  (if (not start)
      (call/cc (lambda (cc)
                 (set! start cc))))

  (display "Going to invoke (start)\n")

  (start))
~~~

会不断打印 "Going to invoke (start)"。



# Example

~~~
main = do
    putStrLn "alpha"
    putStrLn "beta"
    putStrLn "gamma"
~~~

# 其实是用了`continuation`的

去掉 `do` 语法糖之后

~~~
main = putStrLn "alpha"
       >>= \_ ->
           putStrLn "beta"
           >>= \_ ->
               putStrLn "gamma"
~~~

每一个表达式，如 `putStrLn "alpha"` 都被绑定到一个 `延续函数`(`continuation function`), 这个函数将显式(explicit)地顺序执行 `main`　。
因此任何语言如果允许顺序执行语句，其实都隐式(implicit)地使用了延续。


# Monad

在函数式语言中，对于纯函数，由于其无副作用性，使得编译器可以优化程序的求值顺序，比如：

`pure1(3) + pure2(10)`

`2*x + 3*y + 1/x + 2/y`

有可能是`pure1(3)`先求值再对`pure2(10)`求值，可有可能反过来，也有可能在多核计算机中并行(Parallel)计算。

如果一定要让`pure1(3)`在`pure2(10)`之前求值呢？

~~~
let val r2x = 2 * x in
 let val r3y = 3 * y in
   let val sum1=r2x + r3y in
     let val r1x = 1 / x in
       let val sum2 = sum1 + r1x in
         let val r2y = 2 / y in
           sum2 + r2y
         end
        …….end
~~~


在Haskell中，`Monad` 就可以显式控制求值顺序，比如

~~~
class Applicative => Monad f where
  >>= :: f a -> (a -> f b) -> f b
~~~

这是为什么 IO 要用 `Monad` 来实现的原因之一。

Haskell 还有一个东西叫 `Continuation Monad`。这是干什么呢？

# 延续用来解决一些问题

Exceptions, time-traveling search, generators, threads, and coroutines

# [SAT-solving][10]

SAT 是布尔可满足性问题 (Boolean satisfiability problem, SATISFIABILITY) 的简称，用来解决给定的布尔方程式，是否存在一组变量赋值，使问题为可满足。比如：对于一个确定的逻辑电路，是否存在一种输入使得输出为真。

~~~
(let ((a (amb (list 1 2 3 4 5 6 7)))
      (b (amb (list 1 2 3 4 5 6 7)))
      (c (amb (list 1 2 3 4 5 6 7))))

      ; We're looking for dimensions of a legal right
      ; triangle using the Pythagorean theorem:
      (assert (= (* c c) (+ (* a a) (* b b))))

      ; And, we want the second side to be the shorter one:
      (assert (< b a))

      ; Print out the answer:
      (display (list a b c))
      (newline))

; print out (4 3 5)
~~~



# 用延续来实现`协程`(`coroutine`)

# 用延续来实现`异常`(`exception`)

---

https://en.wikipedia.org/wiki/Continuation
https://en.wikipedia.org/wiki/Continuation-passing_style
https://en.wikipedia.org/wiki/Callback_(computer_programming)
http://www.cs.uccs.edu/~qyi/UTSA-classes/cs3723/slides/Control.pdf
http://matt.might.net/articles/programming-with-continuations--exceptions-backtracking-search-threads-generators-coroutines/
[10]: https://zh.wikipedia.org/wiki/%E5%B8%83%E5%B0%94%E5%8F%AF%E6%BB%A1%E8%B6%B3%E6%80%A7%E9%97%AE%E9%A2%98
