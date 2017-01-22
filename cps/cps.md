# Topics

Callback -> Continuation -> Call With Continuation -> CPS


# Callback

1. `Callback`(回调) 的概念是，把一段可执行代码，作为参数传给其它代码，然后会在某个时候**回来调用**这段代码。如果是回调是立即发生的，叫做**同步回调(`Synchronous Callback`)**，如果是在未来某个时间回调，叫做**异步回调(`Asynchronous Callback`)**。

2. 异步回调很常见也是使用最多的，比如网络请求，文件处理等较耗时的情景异步回调很有用。
https://medium.com/swift-programming/continuation-passing-style-in-swift-e4d825962803#.9vqt39jw9

3. 同步回调呢？好像不常见，有什么用呢？ （同步回调和得到返回值并调用是一样的效果）


4. 程序控制流一直向下，然后在Callee完成动作后，再调用回调 `Callback`, 这时候控制流转移到了 `Callback`。
执行完成后呢？控制流会回到原来的路线吗？


# Continuation

更普遍来看，回调其实就是`延续`(`Continuation`)的一种对象化的实现（作为方法的参数）。

在计算机科学和程序设计中，`延续`是一种对程序控制流程/状态的抽象表现形式。 延续性使程序状态信息具体化，也可以理解为，一个延续性以数据结构的形式表现了程序在运行过程中某一点的计算状态，相应的数据内容可以被编程语言访问，不被运行时环境所隐藏掉。

延续性包含了当前程序的栈（包括当前周期内的所有数据，也就是本地变量），以及当前运行的位置。一个延续的实例可以在将来被用做控制流，被调用时它从所表达的状态开始恢复执行。


# Monad

在函数式语言中，对于纯函数，由于其无副作用性，使得编译器可以优化程序的求值顺序，比如：

`pure1(3) + pure2(10)`

有可能是`pure1(3)`先求值再对`pure2(10)`求值，可有可能反过来，也有可能在多核计算机中并行(Parallel)计算。

如果一定要让`pure1(3)`在`pure2(10)`之前求值呢？
在Haskell中，`Monad` 就可以显式控制求值顺序，比如
```
class Applicative => Monad f where
  >>= :: f a -> (a -> f b) -> f b
```
这是为什么 IO 要用 `Monad` 来实现的原因之一。

Haskell 还有一个东西叫 `Continuation Monad`。这是干什么呢？


---

https://en.wikipedia.org/wiki/Continuation
https://en.wikipedia.org/wiki/Continuation-passing_style
https://en.wikipedia.org/wiki/Callback_(computer_programming)
