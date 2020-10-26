+ 宁可以编译器替换预处理器。当你使用#define ASPECT 1.63，你所使用的名称可能从未进入记号表，解决之道是以一个常量替换上述的宏 const double AspectRatio = 1.653;作为一个语言常量，AspectRatio肯定会被编译器看到，进入记号表内。
+ 此外，对浮点常量，使用常量可能比使用#define导致较小量的码，因为预处理器盲目地将宏名称ASPECT_RATIO替换为1.653可能导致目标码出现多份1.653，若改用常量AspectRatio绝不会出现相同情况。(上一个原因比较重要，这里是说，浮点数在预编译的时候被替换，增加了代码体积，可能导致函数体积过大，对于古老的编译器不能通过，但现代编译器可以过)。
+ ISO 禁止在类内初始化非const的静态成员。允许初始化普通变量和常量成员。

| 数据成员类型 | normal | const | static | static const int | static const |
| --- | --- | --- | --- | --- | --- |
|类内直接初始化|可以|可以|不可以|可以|不可以|
|先声明再通过初始化列表赋初值|可以|可以|不可以|不可以|不可以|
|先声明再在构造函数体里赋初值|可以|不可以|不可以|不可以|不可以|
|先声明再在类外赋初值|不可以|不可以|可以|可以|不可以|

```c++
class GamePlayer{
private:
  static const int NumTurns=5; //NumTurns的声明式
  int scores[NumTurns];
};
const int GamePlayer::NumTurns;//NumTurns的定义式
```
+ 对于class专属常量且为static且为int类型，当编译器不要求，且不需要取变量地址时，可以只声明而不定义，可以理解为宏替换。
+ 我们无法利用#define 创建一个class专属常量，因为#define不重视作用域，一旦宏被定义，它就在其后的编译过程中有效，除非#undef，这意味着#define不能定义class专属变量，且不能提供任何封装性，没有所谓private #define。
+ the enum hack，一个属于枚举类型的数值可权充int被使用。基于数个理由enum hack值得我们认识：
  1. 第一，enum hack的行为某些方面比较像#define 而不是const，例如取一个const的地址是合法的，但取一个enum的地址不合法，而取一个#define的地址通常也不合法。如果你不想让别人获得一个pointer或reference指向你的某个整数常量，enum可以帮助实现这个约束。
  2. 第二，实用主义，许多代码用了它，所以你必须认识它。事实上enum back是元编程的基础技术。
+ 宏一向和运算符优先级纠缠，例如：
```c++
#define CALL_WITH_MAX(a,b) f((a)>(b)?(a):(b))
int a=5,b=0;
CALL_WITH_MAX(++a,b); //a=7
CALL_WITH_MAX(++a,b+10); //a=6
template<typename T>
inline void CALL_WITH_MAX(const T& a, const T& b){
    f(a>b?a:b);
}
```
+ 有了const、enum和inlines，我们对预处理的需求降低了，但并非完全消除，#include仍然是必需品，而#ifdef/#ifndef也继续扮演着控制编译的重要角色，目前还不到预处理器全面引退的时候，但应该明确的给予它更长的假期。
+ 对于单纯常量，最好以const对象或enum替换#define
+ 对于形似函数的宏，最好改用inline函数替换#define
