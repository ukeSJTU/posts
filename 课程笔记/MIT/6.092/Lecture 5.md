Access Control, Class Scope, Packages, Java API

Review

先看下面这段代码：
```java
public class Counter {
    int myCount = 0;
    static int ourCount = 0;

    void increment() {
        myCount++;
        ourCount++;
    }

    public static void main(String[] args) {
        Counter counter1 = new Counter();
        Counter counter2 = new Counter();
        counter1.increment();
        counter1.increment();
        counter2.increment();
        System.out.println("Counter 1: " + counter1.myCount + " " + counter1.ourCount);
        System.out.println("Counter 2: " + counter2.myCount + " " + counter2.ourCount);
    }
}
```

先想想这段代码什么是Fields，什么是Counter类的Methods，然后不运行代码预测代码会输出什么。
```java
int myCount = 0;
static int ourCount = 0;
```

methods:
```java
void increment() {
	myCount++;
	ourCount++;
}
```

答案：
```plaintext
Counter 1: 2 3
Counter 2: 1 3
```

如果你做对了那你可以直接跳转到这一节课要学的内容：Access Control；如果你做的不对，可以看下面一步一步的分析：

注意到class Counter有两个field，一个是static的outCount，另一个是non-static的myCount。确认了这一点让我们按照顺序在大脑里模拟代码的运行：

main是程序的入口，程序从这里开始执行：
```java
Counter counter1 = new Counter();
```

Class Counter里面的ourCount = 0; Object counter1里面的myCount = 0;



---
Access Control




---
Class Scope





---
Packages






---
Java API





---
Assignment