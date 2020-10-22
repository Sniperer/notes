+ C++是一个多重范型编程语言，一个同时支持过程形式、面向对象形式、函数形式、泛型形式、元编程形式的语言。
+ C++主演有4个sublanguage：
  1. C。C++以C为基础。
  2. Object-Oriented C++，这部分就是C with Classes诉求的，类的封装，多态，继承等等。
  3. Template C++，泛型编程部分，带来了崭新的贬称范型，元编程TMP，TMP相关规则很少与C++主流编程互相影响。
  4. STL，STL是个template程序库，它对容器，迭代器，算法以及函数对象的规约有极佳的紧密配合与协调。
+ 当你从某个次语言切换到另一个，导致高效编程守则要求你改变策略，不要感到惊讶，例如对内置类型而言，pass-by-value通常比pass-by-reference高效，但当你从C part of C++移往Object-Oriented C++，由于用户自定义构造函数和析构函数的存在，pass-by-reference-to-const往往更好，运用Template C++尤其如此，因为你甚至不知道所处理的对象的类型，然而一旦跨入STL，迭代器和函数对象都是在C指针上塑造出来的，所以对STL的迭代器和函数对象而言，旧式的pass-by-value守则再次适用。
+ C++高效编程守则视状况而变化，取决于你使用C++哪一部分。
