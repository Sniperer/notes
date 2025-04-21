+ 转型语法：有两种旧式转型，和四种新式转型。
```c++
(T)expression
T(expression)
const_cast<T>(expression)
dynamic_cast<T>(expression)
reinterpret_cast<T>(expression)
static_cast<T>(expression)
```
+ const_cast 通常被用来将对象的常量性移除，它也是唯一有次功能的C++-style转型操作符。
+ dynamic_cast 主要用来执行安全向下转型，也就是用来决定某对象是否归属继承体系中的某个类型。它是唯一无法由旧式语法执行的动作，也是唯一可能耗费重大运行成本的转型动作。
+ reinterpret_cast 意图执行低级转型，实际动作(及结果)可能取决于编译器，这也就表示它不可移植，例如将一个pointer to int转型为一个int，这一类转型在低级代码以外很少见，本书只使用一次。
+ static_cast 用来强迫隐式转换，例如将non—const对象转换为const对象，或者将int转化为double等，它也可以用来执行上述多种转换的反向转换，例如将void*指针转为typed指针，将pointer-to-base转为pointer-to-derived，但它无法将const转换为non-const这个只有const-cast才办得到。

+ 新式转换更受欢迎，原因：
  1. 他们很容易在代码中被辨识出来，因而得以简化找出类型系统在哪个地点被破环的过程。
  2. 各转型动作的目标愈窄化，编译器愈可能诊断出错误的运用，举个例子，如果你打算将常量性去掉，除非使用新式转型中的const_cast否则无法通过编译。

+ 任何一个类型转换(不论是通过转型操作而进行的显式转换还是通过编译器完成的隐式转换)往往真的令编译器编译出运行期间执行的码。
```c++
class Base {...};
class Derived: public Base {...};
Derived d;
Base* pd=&d; //隐式的将Derived* 转换为Base*
```

+ 这里我们不过是建立一个base class指针指向一个derived class对象，但有时候上述的两个指针值并不相同，这种情况下会有个偏移量在运行期间被施行于Derived* 指针身上，用以取得正确的Base* 指针值。单一对象可能拥有一个以上的地址，如果使用多重继承，这事几乎一直发生，即使在单一继承中也可能发生。虽然这还有其他意涵，但至少意味着你通常应该避免做出对象在C++中如何如何布局的假设，更不该以此假设为基础执行任何转型动作，例如，将对象地址转型为char* 指针然后在它们身上进行指针算术，几乎总是会导致无定行为。
```c++
class Window{
public:
  virtual void onResize(){...}
}
class SpecialWindow: public Window{
public:
  virtual void onResize(){
    static_cast<Window>(*this*).onResize();
    //进行SpecialWindow专属行为
  }
};
```
+ 这段程序将*this转型为Window，对函数onResize的调用也因此调用了Window::onResize，但onResize传入的this指针所指的是稍早转型动作所建立的一个*this对象之base class成分的副本。这使得对象进入伤残状态，其base class成分的更改没有落实，而derived class成分的更改落实了。
+ 解决的方法是明确函数的调用路径
```c++
class SpecialWindow: public Window{
public:
    virtual void onResize(){
      Window::onResize();
      ...
    }
    ...
};
```
+ dynamic_cast的许多实现版本相当慢，例如至少有一个很普遍的实现版本基于class名称进行字符串比较，如果你在四层深的单继承体系内的某个对象身上执行dynamic_cast，可能会耗用多达四次的strcmp调用，用以比较class名称。深度继承或多重继承的成本更高。
+ 之所以需要dynamic_cast，通常是因为想在一个认定为derived class对象身上执行derived class操作函数，但你的手上却只有一个指向base的pointer或reference，只能依靠他们来处理对象。由两个一般性做法可以避免这个问题：
  1. 使用容器并在其中存储直接指向derived class对象的指针，如此便消除了通过base class接口处理对象的需要，当然，这种做法使你无法在同一个容器内存储指针"指向所有可能值各种Window派生类"，如果真要处理多种窗口类型，可能需要多个容器，他们都必须具备类型安全性。
  2. 在base class内提供virtual函数做你想对各个windows派生类做的事。

+ 如果可以，尽量避免转型，特别是在注重效率的代码中避免dynamic_casts，如果有个设计需要转型动作，试着发展无需转型的替代设计。
+ 如果转型是必要的，试着将它隐藏于某个函数背后，客户随后可以调用该函数，而不需要将转型放进他们自己的代码中。
+ 宁可使用新式转型，不要使用旧式转型，前者很容易辨识出来，而且也比较有着分门别类的职掌。
