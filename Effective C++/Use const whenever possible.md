```c++
char greating[]="hello";
char *p=greeting; //non-const pointer,non-const data
const char *p=greeting; //non-const pointer, const data
char* const p=greeting;//const pointer, non-const data
const char* const p=greeting;//const pointer, const data
void f1(const Widget* pw);//the same with Widget const
void f2(Widget const* pw);
std::vector<int> vec;
const std::vector<int>::iterator iter=vec.begin();//迭代器是对象, const 对象
*iter=10;
//++iter;
std::vector<int>::const_iterator cIter=vec.begin();//const_iterator 迭代器所指之物为const
//*cIter=10;
++cIter;
```
+ 令函数返回一个常量值，往往可以降低因客户端错误而造成的意外，而又不至于放弃安全性和高效性。
```c++
class Rational { ... };
const Rational operator* (const Rational& lhs, const Rational& rhs);
(a*b)=c;//如果判等写错，这会造成莫名其妙的错误。
```

+ 将const实施于成员函数的目的，是为了确认该成员函数可作用于const对象身上。基于两个理由：
  1. 他们使class接口比较容易理解，得知哪个函数可以改动对象内容而哪个函数不行。
  2. 他们使操作const对象称为可能，这对编写高效代码是个关键，改善C++程序效率的一个根本办法是以pass-by-reference-to-const方式传递对象，而此技术可行的前提是，我们有const成员函数可用来处理取得的const对象。
+ 两个成员函数，如果指示常量与否的不同，是可以被重载的。
```c++
class TextBlock{
  public:
    const char& operator[](std::size_t position) const{
      //operator[] for const 对象
      return text[position];
    }
    char& operator[](std::size_t position){
      //operator[] for non-const 对象
      return text[position];
    }
  private:
    std::string text;
};
```
+ 如果函数的返回类型是个内置类型（不是引用类型），那么改动函数返回值从来就不合法。纵使合法，C++以by value返回对象这一事实意味着被改动的是副本，而不是其自身。
+ 请思考成员函数是const这意味着什么？对编译器来说，这意味着bitwise const，也就是说，const成员函数不可以更改对象内任何non-static成员变量。但，对一些情况下，希望const函数是logical const的，一个const函数可以修改它所处理的对象内的某些bits，但只有在客户端侦测不出的情况下才得如此。

```c++
class CTextBlock{
public:
    std::size_t length() const;
private:
    char* pText;
    std::size_t textLength;
    bool lengthIsValid;
};
std::size_t CTextBlock::length() const{
    if(!lengthIsValid){
      //const 函数直接修改非静态成员变量，是不被允许的
      textLength=std::strlen(pText);
      lengthIsValid=true;
    }
    return textLength;
}
class CTextBlock{
public:
  std::size_t length() const;
private:
  char *pText;
  mutable std::size_t textLength;
  mutable bool lengthIsValid;
};
std::size_t CTextBlock::length() const{
    if(!lengthIsValid){
      //mutable 表示成员变量可能总被更改，即使在const成员函数内
      textLength=std::strlen(pText);
      lengthIsValid=true;
    }
    return textLength;
}
```
+ mutable 不能解决所有问题，无论如何做，const函数都要重复一遍non-const函数的功能，真正需要做的是实现operator[]的机能一次并使用两次，也就是说，应该令其中一个调用另一个。着促使我们将常量性转移 casting away constness

```c++
class TextBlock{
public:
  const char& operator[](std::size_t position) const{
    return text[position];
  }
  char& operator[](std::size_t position){
    return const_cast<char&>(static_cast<const TextBlock&>(*this\*)[position]);
  }
}
```
+ 这份代码有两个转型动作，我们打算让non-const operator[]调用其const兄弟，但non-const operator[]内部若只是单纯调用operator[]，会递归调用自己。为了避免无穷递归，我们必须明确指出调用的是const operator[]，但C++缺乏直接的语法可以那么做，因此将*this从其原始类型TextBlock& 转型为const TextBlock&。我们使用转型操作为它加上const，所以我们这里有两次转型，第一次用来为*this添加const，第二次则是从const operator[]的返回值中移除const。
