# C++ Language Reference Comparison

```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello C++" << endl;
    return 0;
}
```

## 1. 基础语法结构

### 1.1 程序入口

```cpp
// 和C语言一样，在C++中，你的程序会从main()开始执行，
// 该函数的返回值应当为int型，这个返回值会作为程序的退出状态值。
// 不过，大多数的编译器（gcc，clang等）也接受 void main() 的函数原型。
// （参见 http://en.wikipedia.org/wiki/Exit_status 来获取更多信息）
int main(int argc, char** argv)
{
    // 和C语言一样，命令行参数通过argc和argv传递。
    // argc代表命令行参数的数量，
    // 而argv是一个包含“C语言风格字符串”（char *）的数组，
    // 其中每个字符串代表一个命令行参数的内容，
    // 首个命令行参数是调用该程序时所使用的名称。
    // 如果你不关心命令行参数的值，argc和argv可以被忽略。
    // 此时，你可以用int main()作为函数原型。

    // 退出状态值为0时，表示程序执行成功
    return 0;
}
```

### 1.2 代码组织

**头文件包含:**

```cpp
// C++也可以使用C语言的标准头文件，
// 但是需要加上前缀“c”并去掉末尾的“.h”。
#include <cstdio>
#include <iostream> // 引入包含输入/输出流的头文件

int main()
{
    printf("Hello, world!\n"); // From <cstdio>
    std::cout << "Hello from iostream!\n"; // From <iostream>
    return 0;
}
```

**命名空间:**

```cpp
///////////
// 命名空间
///////////

// 命名空间为变量、函数和其他声明提供了分离的的作用域。
// 命名空间可以嵌套使用。

namespace First {
    namespace Nested {
        void foo()
        {
            printf("This is First::Nested::foo\n");
        }
    } // 结束嵌套的命名空间Nested
} // 结束命名空间First

namespace Second {
    void foo()
    {
        printf("This is Second::foo\n"); // Corrected missing semicolon
    }
}

void foo()
{
    printf("This is global foo\n");
}

int main()
{
    // 如果没有特别指定，就从“Second”中取得所需的内容。
    using namespace Second; // 输入输出流等标准库内容也在std命名空间中

    foo(); // 显示“This is Second::foo”
    First::Nested::foo(); // 显示“This is First::Nested::foo”
    ::foo(); // 显示“This is global foo”

    std::cout << "Accessing std members directly.\n"; // Without 'using namespace std;'
}
```

## 2. 变量与类型系统

### 2.1 变量声明

(变量声明在示例代码中随处可见，例如 `int myInt;`, `string myString = "Hello";`)

### 2.2 基本数据类型

**字符类型:**

```cpp
// 在C++中，字符字面量的大小是一个字节。
sizeof('c') == 1; // true in C++

// 在C语言中，字符字面量的大小与int相同。
// sizeof('c') == sizeof(int); // true in C
```

### 2.3 复合类型

**字符串:**

```cpp
/////////
// 字符串
/////////

// C++中的字符串是对象，它们有很多成员函数
#include <string>
#include <iostream> // For cout

// using namespace std; // 字符串也在std命名空间（标准库）中。 Avoid in headers.

int main() {
    std::string myString = "Hello";
    std::string myOtherString = " World";

    // + 可以用于连接字符串。
    std::cout << myString + myOtherString << std::endl; // "Hello World"

    std::cout << myString + " You" << std::endl; // "Hello You"

    // C++中的字符串是可变的，具有“值语义”。
    myString.append(" Dog");
    std::cout << myString << std::endl; // "Hello Dog"
    return 0;
}
```

**引用:**

```cpp
/////////////
// 引用
/////////////
#include <string>
#include <iostream>

// 除了支持C语言中的指针类型以外，C++还提供了_引用_。
// 引用是一种特殊的指针类型，一旦被定义就不能重新赋值，并且不能被设置为空值。
// 使用引用时的语法与原变量相同：
// 也就是说，对引用类型进行解引用时，不需要使用*；
// 赋值时也不需要用&来取地址。

int main() {
    using namespace std;

    string foo = "I am foo";
    string bar = "I am bar";


    string& fooRef = foo; // 建立了一个对foo的引用。
    fooRef += ". Hi!"; // 通过引用来修改foo的值
    cout << fooRef << endl; // "I am foo. Hi!"
    cout << foo << endl;    // Also "I am foo. Hi!"

    // 这句话的并不会改变fooRef的指向，其效果与“foo = bar”相同。
    // 也就是说，在执行这条语句之后，foo == "I am bar"。
    fooRef = bar;
    cout << fooRef << endl; // "I am bar"
    cout << foo << endl;    // Also "I am bar"

    const string& barRef = bar; // 建立指向bar的常量引用。
    // 和C语言中一样，（指针和引用）声明为常量时，对应的值不能被修改。
    // barRef += ". Hi!"; // 这是错误的，不能修改一个常量引用的值。
    cout << barRef << endl; // "I am bar"

    return 0;
}
```

### 2.4 类型系统

**空指针:**

```cpp
// 在C++中，用nullptr代替C语言中的NULL
int* ip = nullptr;
```

**与 C 的区别:**

```cpp
// C++的函数原型与函数定义是严格匹配的
void func(); // 这个函数不能接受任何参数

// 而在C语言中
// void func(); // 这个函数能接受任意数量的参数
```

## 3. 控制流程

### 3.1 条件分支

(例如 `if (fh == nullptr)` in RAII example)

### 3.2 循环结构

(Not explicitly shown in provided examples)

### 3.3 流程控制

(例如 `return`, `throw`, `goto failure;` in RAII example)

## 4. 函数与闭包

### 4.1 函数定义

**函数重载:**

```cpp
///////////
// 函数重载
///////////
#include <cstdio> // For printf

// C++支持函数重载，你可以定义一组名称相同而参数不同的函数。

void print(char const* myString)
{
    printf("String %s\n", myString);
}

void print(int myInt)
{
    printf("My int is %d\n", myInt); // Corrected format specifier and added newline
}

int main()
{
    print("Hello"); // 解析为 void print(const char*)
    print(15); // 解析为 void print(int)
    return 0;
}
```

**默认参数:**

```cpp
///////////////////
// 函数参数的默认值
///////////////////
#include <iostream>

// 你可以为函数的参数指定默认值，
// 它们将会在调用者没有提供相应参数时被使用。

void doSomethingWithInts(int a = 1, int b = 4)
{
    // 对两个参数进行一些操作
    std::cout << "a: " << a << ", b: " << b << std::endl;
}

int main()
{
    doSomethingWithInts();      // a = 1,  b = 4
    doSomethingWithInts(20);    // a = 20, b = 4
    doSomethingWithInts(20, 5); // a = 20, b = 5
    return 0;
}

// 默认参数必须放在所有的常规参数之后。

// void invalidDeclaration(int a = 1, int b) // 这是错误的！
// {
// }
```

### 4.2 闭包特性

(C++ Lambdas provide closure-like behavior, but not explicitly shown in the provided text)

## 5. 面向对象

### 5.1 类与对象

```cpp
///////////////////
// 类与面向对象编程
///////////////////

// 有关类的第一个示例
#include <iostream>
#include <string> // Include string header

// 声明一个类。
// 类通常在头文件（.h或.hpp）中声明。
class Dog {
    // 成员变量和成员函数默认情况下是私有（private）的。
    std::string name;
    int weight;

// 在这个标签之后，所有声明都是公有（public）的，
// 直到重新指定“private:”（私有继承）或“protected:”（保护继承）为止
public:

    // 默认的构造器
    Dog();

    // 这里是成员函数声明的一个例子。
    // 可以注意到，我们在此处使用了std::string，而不是using namespace std
    // 语句using namespace绝不应当出现在头文件当中。
    void setName(const std::string& dogsName);

    void setWeight(int dogsWeight);

    // 如果一个函数不对对象的状态进行修改，
    // 应当在声明中加上const。
    // 这样，你就可以对一个以常量方式引用的对象执行该操作。
    // 同时可以注意到，当父类的成员函数需要被子类重写时，
    // 父类中的函数必须被显式声明为_虚函数（virtual）_。
    // 考虑到性能方面的因素，函数默认情况下不会被声明为虚函数。
    virtual void print() const;

    // 函数也可以在class body内部定义。
    // 这样定义的函数会自动成为内联函数。
    void bark() const { std::cout << name << " barks!\n"; }

    // 除了构造器以外，C++还提供了析构器。
    // 当一个对象被删除或者脱离其定义域时，它的析构函数会被调用。
    // 这使得RAII这样的强大范式（参见下文）成为可能。
    // 为了衍生出子类来，基类的析构函数必须定义为虚函数。
    virtual ~Dog();

}; // 在类的定义之后，要加一个分号

// 类的成员函数通常在.cpp文件中实现。
Dog::Dog() : name("Unnamed"), weight(0) // Initialize members
{
    std::cout << "A dog has been constructed\n";
}

// 对象（例如字符串）应当以引用的形式传递，
// 对于不需要修改的对象，最好使用常量引用。
void Dog::setName(const std::string& dogsName)
{
    name = dogsName;
}

void Dog::setWeight(int dogsWeight)
{
    weight = dogsWeight;
}

// 虚函数的virtual关键字只需要在声明时使用，不需要在定义时重复
void Dog::print() const
{
    std::cout << "Dog is " << name << " and weighs " << weight << "kg\n";
}

Dog::~Dog()
{
    std::cout << "Goodbye " << name << "\n";
}

// 继承：

// 这个类继承了Dog类中的公有（public）和保护（protected）对象
class OwnedDog : public Dog {
private: // private members should come first usually
    std::string owner;

public: // public interface
    // Constructor for OwnedDog might be needed
    OwnedDog() : Dog() {} // Call base class constructor

    void setOwner(const std::string& dogsOwner);

    // 重写OwnedDogs类的print方法。
    // 如果你不熟悉子类多态的话，可以参考这个页面中的概述：
    // http://zh.wikipedia.org/wiki/%E5%AD%90%E7%B1%BB%E5%9E%8B

    // override关键字是可选的，但推荐使用，它确保你所重写的是基类中的方法。
    void print() const override;

    // Destructor for OwnedDog
    ~OwnedDog() override {
        std::cout << "OwnedDog destructor called for owner " << owner << std::endl;
    }
};

// 与此同时，在对应的.cpp文件里：

void OwnedDog::setOwner(const std::string& dogsOwner)
{
    owner = dogsOwner;
}

void OwnedDog::print() const
{
    Dog::print(); // 调用基类Dog中的print方法
    // "Dog is <name> and weights <weight>"

    std::cout << "Dog is owned by " << owner << "\n";
    // "Dog is owned by <owner>"
}


int main() {
    Dog myDog; // 此时显示“A dog has been constructed”
    myDog.setName("Barkley");
    myDog.setWeight(10);
    myDog.print(); // 显示“Dog is Barkley and weighs 10 kg”
    myDog.bark();

    std::cout << "--- Now OwnedDog ---\n";
    OwnedDog myOwnedDog;
    myOwnedDog.setName("Buddy");
    myOwnedDog.setWeight(15);
    myOwnedDog.setOwner("Alice");
    myOwnedDog.print(); // Calls OwnedDog's print
    myOwnedDog.bark();

    std::cout << "--- Polymorphism ---" << std::endl;
    Dog* dogPtr = &myOwnedDog; // Pointer to base class
    dogPtr->print(); // Calls OwnedDog::print() due to virtual function

    std::cout << "--- End of main ---" << std::endl;
    return 0;
} // Destructors called: ~OwnedDog, then ~Dog for myOwnedDog; ~Dog for myDog
  // Output order: Goodbye Buddy, OwnedDog destructor, Goodbye Barkley
```

**运算符重载与初始化列表:**

```cpp
/////////////////////
// 初始化与运算符重载
/////////////////////

#include <iostream>
// using namespace std; // Avoid global using namespace

class Point {
public:
    // 可以以这样的方式为成员变量设置默认值 (C++11 onwards)。
    double x = 0;
    double y = 0;

    // 定义一个默认的构造器。
    // 除了将Point初始化为(0, 0)以外，这个函数什么都不做。
    Point() { }; // Default constructor

    // 下面使用的语法称为初始化列表，
    // 这是初始化类中成员变量的正确方式。
    Point (double a, double b) :
        x(a),
        y(b)
    { /* 除了初始化成员变量外，什么都不做 */ }

    // 重载 + 运算符
    // Returns a new Point object by value
    Point operator+(const Point& rhs) const;

    // 重载 += 运算符
    // Returns a reference to the modified object (*this)
    Point& operator+=(const Point& rhs);

    // 增加 - 和 -= 运算符也是有意义的，但这里不再赘述。
};

Point Point::operator+(const Point& rhs) const
{
    // 创建一个新的点，
    // 其横纵坐标分别为这个点与另一点在对应方向上的坐标之和。
    return Point(x + rhs.x, y + rhs.y);
}

Point& Point::operator+=(const Point& rhs)
{
    x += rhs.x;
    y += rhs.y;
    return *this; // Return a reference to the current object
}

int main () {
    Point up (0,1);
    Point right (1,0);
    // 这里使用了Point类型的运算符“+”
    // 调用up（Point类型）的“+”方法，并以right作为函数的参数
    Point result = up + right; // Calls up.operator+(right)
    // 显示“Result is upright (1,1)”
    std::cout << "Result is upright (" << result.x << ',' << result.y << ")\n";

    result += up; // Calls result.operator+=(up)
    std::cout << "After += up: (" << result.x << ',' << result.y << ")\n"; // (1, 2)

    return 0;
}
```

### 5.2 访问控制

- `private`: 成员只能被类的成员函数访问（默认）。
- `public`: 成员可以被任何代码访问。
- `protected`: 成员可以被类的成员函数以及派生类的成员函数访问。

(See `Dog` class example above for `private` and `public`)

## 6. 错误处理

### 6.1 处理机制

```cpp
///////////
// 异常处理
///////////

#include <iostream>
#include <stdexcept> // For standard exceptions like std::runtime_error

// 标准库中提供了一些基本的异常类型
// （参见http://en.cppreference.com/w/cpp/error/exception）
// 但是，其他任何类型也可以作为一个异常被拋出

void mightThrow(bool shouldThrow) {
    if (shouldThrow) {
        // 不要用 _new_关键字在堆上为异常分配空间。
        // The exception object is typically copied.
        throw std::runtime_error("A problem occurred");
    } else {
        std::cout << "Did not throw." << std::endl;
    }
}

int main() {
    // 在_try_代码块中拋出的异常可以被随后的_catch_捕获。
    try {
        mightThrow(true); // This will throw
        std::cout << "This line won't be reached if throw happens." << std::endl;
    }
    // 如果拋出的异常是一个对象，可以用常量引用来捕获它
    catch (const std::runtime_error& ex) // Catch specific standard exceptions
    {
      std::cout << "Caught runtime_error: " << ex.what() << std::endl;
    }
    catch (const std::exception& ex) // Catch other standard exceptions
    {
      std::cout << "Caught std::exception: " << ex.what() << std::endl;
    }
    // 捕获尚未被_catch_处理的所有其他类型错误 (including non-standard types)
    catch (...)
    {
        std::cout << "Unknown exception caught" << std::endl;
        // throw; // 重新拋出异常 - uncomment to rethrow
    }

    std::cout << "Trying again without throwing..." << std::endl;
    try {
        mightThrow(false);
    } catch (...) {
        std::cout << "This shouldn't be caught." << std::endl;
    }

    return 0;
}
```

### 6.2 错误传播

- 异常会沿着调用栈向上传播，直到被匹配的 `catch` 块捕获。
- 可以在 `catch` 块中使用 `throw;` 来重新抛出当前捕获的异常。
- RAII 模式（见 9.1）有助于确保在异常传播过程中资源被正确释放。

## 7. 并发模型

### 7.1 线程与协程

(C++11 及以后版本通过 `<thread>`, `<mutex>`, `<condition_variable>`, `<future>`, `<atomic>` 等头文件提供了标准库级别的线程支持。协程在 C++20 中引入。)

### 7.2 同步机制

(例如 `std::mutex`, `std::lock_guard`, `std::unique_lock`, `std::atomic`)

## 8. 元编程

### 8.1 反射与内省

(C++ 本身不直接支持像 Java 或 Python 那样的运行时反射。可以通过 RTTI（Run-Time Type Information，`typeid`, `dynamic_cast`）获得有限的运行时类型信息，但这通常不被认为是完整的反射。)

### 8.2 宏系统

(C++ 继承了 C 的预处理器宏系统 `#define`, `#ifdef` 等。模板元编程（Template Metaprogramming, TMP）是 C++ 特有的编译期元编程技术。)

## 9. 内存管理

### 9.1 管理策略

**RAII (Resource Allocation Is Initialization):**

```cpp
///////
// RAII
///////
#include <cstdio>   // For C-style file operations (fopen, fclose)
#include <fstream>  // For C++ file streams (ifstream)
#include <string>
#include <stdexcept> // For exceptions
#include <iostream>

// Dummy functions for demonstration
void doSomethingWithTheFile(FILE* fh) { if (!fh) throw std::runtime_error("Invalid C file handle"); /* ... */ }
void doSomethingElseWithIt(FILE* fh) { if (!fh) throw std::runtime_error("Invalid C file handle"); /* ... */ }
void doSomethingWithTheFile(std::ifstream& fh) { if (!fh.is_open()) throw std::runtime_error("Invalid C++ file stream"); /* ... */ }
void doSomethingElseWithIt(std::ifstream& fh) { if (!fh.is_open()) throw std::runtime_error("Invalid C++ file stream"); /* ... */ }


// RAII指的是“资源获取就是初始化”（Resource Allocation Is Initialization），
// 它被视作C++中最强大的编程范式之一。
// 简单说来，它指的是，用构造函数来获取一个对象的资源，
// 相应的，借助析构函数来释放对象的资源。

// 为了理解这一范式的用处，让我们考虑某个函数使用文件句柄时的情况：

// --- C-style without RAII (Error Prone) ---
void doSomethingWithAFile_C_Manual(const char* filename)
{
    // 首先，让我们假设一切都会顺利进行。
    FILE* fh = fopen(filename, "r"); // 以只读模式打开文件
    if (fh == nullptr) {
        std::cerr << "Error opening file (C Manual): " << filename << std::endl;
        return; // Or throw
    }

    try {
        doSomethingWithTheFile(fh);
        doSomethingElseWithIt(fh);
    } catch (const std::exception& e) {
        std::cerr << "Exception during file processing (C Manual): " << e.what() << std::endl;
        fclose(fh); // MUST close here on error
        throw; // Re-throw
    } catch (...) {
        std::cerr << "Unknown exception during file processing (C Manual)" << std::endl;
        fclose(fh); // MUST close here on error
        throw; // Re-throw
    }

    fclose(fh); // MUST close here on success
    std::cout << "Successfully processed file (C Manual): " << filename << std::endl;
}


// --- C++ style with RAII ---
void doSomethingWithAFile_CPP_RAII(const std::string& filename)
{
    // ifstream是输入文件流（input file stream）的简称
    std::ifstream fh(filename); // 打开一个文件 (Constructor acquires resource)
    if (!fh.is_open()) { // Check if opening succeeded
        throw std::runtime_error("Could not open the file (C++ RAII): " + filename);
    }

    // 对文件进行一些操作
    // If exceptions occur here, fh's destructor is still called during stack unwinding
    doSomethingWithTheFile(fh);
    doSomethingElseWithIt(fh);

    std::cout << "Successfully processed file (C++ RAII): " << filename << std::endl;

} // 文件fh离开作用域，其析构器被自动调用，关闭文件句柄

// 与上面几种方式相比，这种方式有着_明显_的优势：
// 1. 无论发生了什么情况，资源（此例当中是文件句柄）都会被正确关闭。
//    只要你正确使用了析构器，就_不会_因为忘记关闭句柄，造成资源的泄漏。
// 2. 可以注意到，通过这种方式写出来的代码十分简洁。
//    析构器会在后台关闭文件句柄，不再需要你来操心这些琐事。
// 3. 这种方式的代码具有异常安全性。
//    无论在函数中的何处拋出异常，都不会阻碍对文件资源的释放。

// 地道的C++代码应当把RAII的使用扩展到各种类型的资源上，包括：
// - 用unique_ptr和shared_ptr管理的内存 (Smart Pointers)
// - 各种数据容器，例如标准库中的链表、向量（容量自动扩展的数组）、散列表等；
//   当它们脱离作用域时，析构器会自动释放其中储存的内容。
// - 用lock_guard和unique_lock实现的互斥 (Concurrency)

int main() {
    // Create a dummy file for testing
    const char* testfile = "test_raii.txt";
    std::ofstream outfile(testfile);
    outfile << "Hello RAII" << std::endl;
    outfile.close();

    try {
        std::cout << "--- Testing C Manual Style ---" << std::endl;
        doSomethingWithAFile_C_Manual(testfile);
    } catch(const std::exception& e) {
        std::cerr << "Caught exception from C Manual style: " << e.what() << std::endl;
    }

    try {
        std::cout << "\n--- Testing C++ RAII Style ---" << std::endl;
        doSomethingWithAFile_CPP_RAII(testfile);
    } catch(const std::exception& e) {
        std::cerr << "Caught exception from C++ RAII style: " << e.what() << std::endl;
    }

    // Clean up dummy file
    remove(testfile);

    return 0;
}
```

**智能指针:**

- `std::unique_ptr`: 独占所有权的智能指针，确保资源在其生命周期结束时被释放。不支持拷贝，但支持移动。
- `std::shared_ptr`: 共享所有权的智能指针，使用引用计数来管理资源生命周期。当最后一个 `shared_ptr` 被销毁时，资源被释放。
- `std::weak_ptr`: 不增加引用计数的观察者指针，用于打破 `shared_ptr` 的循环引用。

### 9.2 优化技术

- **内联函数 (`inline`)**: 建议编译器将函数体直接插入调用处，减少函数调用开销。在类定义内部实现的成员函数默认为内联。
- **移动语义 (Move Semantics, C++11)**: 通过 `std::move` 和右值引用 (`&&`) 实现资源的高效转移，避免不必要的拷贝。
- **编译器优化**: 现代 C++ 编译器（如 GCC, Clang, MSVC）提供多种优化选项（`-O1`, `-O2`, `-O3`, `-Os`）来进行代码优化。

## 10. 生态系统

### 10.1 包管理

(C++ 没有官方统一的包管理器，但存在多个流行的第三方工具):

- **Conan**: 跨平台，去中心化。
- **vcpkg**: Microsoft 开发，易于集成 Visual Studio。
- **xmake**: 基于 Lua 的构建工具，也包含包管理功能。
- 系统包管理器 (apt, yum, brew, pacman) 也常用于安装 C++ 库。

### 10.2 构建系统

- **CMake**: 事实上的标准，跨平台构建系统生成器。
- **Make**: 经典的构建工具，通常与 `Makefile` 配合使用。
- **xmake**: 如上所述，集构建与包管理于一体。
- **Bazel**: Google 开发的构建系统，支持多种语言。
- IDE 内建构建系统 (Visual Studio, Xcode)。

## 11. 模块系统

### 11.1 模块化支持

- **C++20 模块 (Modules)**: 旨在取代传统的基于 `#include` 的头文件系统，提供更好的封装性、更快的编译速度和更清晰的依赖关系。

  ```cpp
  // Example (Conceptual - requires C++20 compiler support)
  // math.cppm
  export module math;
  export int add(int a, int b) { return a + b; }

  // main.cpp
  import math;
  #include <iostream>
  int main() {
      std::cout << add(2, 3) << std::endl;
      return 0;
  }
  ```

## 12. 标准库能力

### 12.1 核心功能覆盖

C++ 标准库 (STL - Standard Template Library) 提供了广泛的功能：

- **容器**: `vector`, `list`, `deque`, `set`, `map`, `unordered_set`, `unordered_map`, `stack`, `queue`, `array`, `string`.
- **算法**: `sort`, `find`, `copy`, `transform`, `accumulate`, `for_each`, 等等 (`<algorithm>`, `<numeric>`)。
- **迭代器**: 用于遍历容器元素的通用接口。
- **输入/输出流**: `<iostream>`, `<fstream>`, `<sstream>`.
- **智能指针**: `<memory>` (`unique_ptr`, `shared_ptr`, `weak_ptr`).
- **并发支持**: `<thread>`, `<mutex>`, `<future>`, `<atomic>`.
- **正则表达式**: `<regex>`.
- **文件系统**: `<filesystem>` (C++17).
- **数值计算**: `<cmath>`, `<complex>`, `<random>`.
- **异常处理**: `<exception>`, `<stdexcept>`.
- **时间日期**: `<chrono>`.
- **函数对象与 Lambda**: `<functional>`.

```cpp
////////////
// 输入/输出
////////////

// C++使用“流”来输入输出。<<是流的插入运算符，>>是流提取运算符。
// cin、cout、和cerr分别代表
// stdin（标准输入）、stdout（标准输出）和stderr（标准错误）。

#include <iostream> // 引入包含输入/输出流的头文件

// using namespace std; // 输入输出流在std命名空间（也就是标准库）中。

int main()
{
   int myInt;

   // 在标准输出（终端/显示器）中显示
   std::cout << "Enter your favorite number:\n";
   // 从标准输入（键盘）获得一个值
   std::cin >> myInt;

   // cout也提供了格式化功能
   std::cout << "Your favorite number is " << myInt << "\n";
   // 显示“Your favorite number is <myInt>”

   std::cerr << "Used for error messages\n"; // cerr usually unbuffered
   return 0;
}
```

## 13. 开发工具链

### 13.1 调试与诊断

- **调试器**: GDB (GNU Debugger), LLDB, Visual Studio Debugger, WinDbg.
- **内存检测**: Valgrind, AddressSanitizer (ASan), MemorySanitizer (MSan).
- **线程检测**: ThreadSanitizer (TSan).
- **性能分析 (Profiling)**: gprof, perf, VTune Profiler, Instruments (Xcode).
- **静态分析**: Clang Static Analyzer, Cppcheck, PVS-Studio.
- **代码覆盖率**: gcov, lcov, Clang Source-based Code Coverage.

## 14. 跨语言互操作

### 14.1 外部接口

- **C ABI**: C++ 代码通常可以导出符合 C 语言应用程序二进制接口 (ABI) 的函数 (`extern "C"`)，使其能够被 C 和其他支持 C ABI 的语言调用。

  ```cpp
  // my_cpp_lib.h
  #ifdef __cplusplus
  extern "C" {
  #endif

  int add_numbers(int a, int b);

  #ifdef __cplusplus
  }
  #endif

  // my_cpp_lib.cpp
  #include "my_cpp_lib.h"
  int add_numbers(int a, int b) {
      return a + b; // C++ implementation
  }
  ```

- **绑定生成器**: 工具如 SWIG, pybind11 (for Python), nbind (for Node.js) 可以自动生成 C++ 代码与其他语言（如 Python, Java, JavaScript）之间的绑定。
- **COM (Component Object Model)**: 在 Windows 平台上，C++ 可以用于创建和使用 COM 对象。

## 15. 安全机制

### 15.1 安全特性

- **类型安全**: C++ 是静态类型语言，编译时进行类型检查，有助于捕捉类型错误。但指针和强制类型转换 (`static_cast`, `reinterpret_cast`, C-style casts) 可能破坏类型安全。
- **内存安全**: C++ 本身不保证内存安全（可能出现缓冲区溢出、悬垂指针等）。RAII 和智能指针有助于提高内存安全性。标准库容器（如 `std::vector::at()`) 提供边界检查访问。
- **常量正确性 (`const`)**: 强制区分可变和不可变数据，提高代码可靠性。
- **访问控制**: `private`, `protected`, `public` 控制对类成员的访问。
- **异常处理**: 提供结构化的错误处理机制。

## 16. 社区与趋势

- **ISO C++ 标准委员会**: 负责 C++ 语言标准的演进 (C++11, C++14, C++17, C++20, C++23, ...)。
- **活跃社区**: CppCon, Meeting C++, ACCU 等会议；在线论坛如 Stack Overflow, Reddit (r/cpp)；众多开源项目。
- **当前趋势**: 现代化 C++ (利用 C++11 及以后版本的新特性)、性能优化、安全性改进、模块化、更好的工具链支持。
