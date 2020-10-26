1.先来介绍它的第一条也是最重要的一条：隐藏。（static函数，static变量均可）
当同时编译多个文件时，所有未加static前缀的全局变量和函数都具有全局可见性。
2.static的第二个作用是保持变量内容的持久。（static变量中的记忆功能和全局生存期）存储在静态数据区的变量会在程序刚开始运行时就完成初始化，也是唯一的一次初始化。共有两种变量存储在静态存储区：全局变量和static变量，只不过和全局变量比起来，static可以控制变量的可见范围，说到底static还是用来隐藏的。
3.static的第三个作用是默认初始化为0（static变量）
4.static的第四个作用：C++中的类成员声明static（有些地方与以上作用重叠）

 在类中声明static变量或者函数时，初始化时使用作用域运算符来标明它所属类，因此，静态数据成员是类的成员，而不是对象的成员，这样就出现以下作用：

(1)类的静态成员函数是属于整个类而非类的对象，所以它没有this指针，这就导致 了它仅能访问类的静态数据和静态成员函数。      

(2)不能将静态成员函数定义为虚函数。      

(3)由于静态成员声明于类中，操作于其外，所以对其取地址操作，就多少有些特殊 ，变量地址是指向其数据类型的指针 ，函数地址类型是一个“nonmember函数指针”。

(4)由于静态成员函数没有this指针，所以就差不多等同于nonmember函数，结果就 产生了一个意想不到的好处：成为一个callback函数，使得我们得以将C++和C-based X W indow系统结合，同时也成功的应用于线程函数身上。 （这条没遇见过）  

(5)static并没有增加程序的时空开销，相反她还缩短了子类对父类静态成员的访问 时间，节省了子类的内存空间。      

(6)静态数据成员在<定义或说明>时前面加关键字static。      

(7)静态数据成员是静态存储的，所以必须对它进行初始化。 （程序员手动初始化，否则编译时一般不会报错，但是在Link时会报错误）

(8)静态成员初始化与一般数据成员初始化不同:

初始化在类体外进行，而前面不加static，以免与一般静态变量或对象相混淆；
初始化时不加该成员的访问权限控制符private，public等；        
初始化时使用作用域运算符来标明它所属类；
           所以我们得出静态数据成员初始化的格式：
<数据类型><类名>::<静态数据成员名>=<值>

(9)为了防止父类的影响，可以在子类定义一个与父类相同的静态变量，以屏蔽父类的影响。这里有一点需要注意：我们说静态成员为父类和子类共享，但我们有重复定义了静态成员，这会不会引起错误呢？不会，我们的编译器采用了一种绝妙的手法：name-mangling 用以生成唯一的标志。