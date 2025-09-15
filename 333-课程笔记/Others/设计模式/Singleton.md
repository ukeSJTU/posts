---
aliases:
  - singleton
  - 单例
creation date: 2025-09-15
tags:
  - "#creational"
---

> [!abstract] 一句话核心
> 确保一个类只有一个实例，并提供一个全局访问点来获取这个唯一的实例。

---

## 1. 意图 / 要解决的问题 (The "Why")

> [!question] 这个模式解决了什么痛点？
> 对于某些管理共享资源或全局状态的对象，假如不正确处理，我们可能会遇到两个核心痛点：**资源浪费**和**状态不一致**。

假设这样一个场景，我们需要一个应用程序配置类`AppConfig`，它负责从json或者yaml等等配置文件中读取配置信息，例如数据库地址、API密钥、主题颜色等等。

```plaintext
class AppConfig:
	String db_url;

	public AppConfig():
		// Read from the config
		// and set fields accordingly
		// db_url = ...
```

程序的不同部分可能都需要创建各自的实例，比如说：

`EmailService`模块创建了一个实例，`AppConfig config1 = new AppConfig();`
然后`ApiService`模块也创建了一个实例，`AppConfig config2 = new AppConfig();`

资源浪费：`config1`和`config2`都回去读取硬盘上的同一个配置文件，并且各自在内存中存储一份配置数据。这造成了不必要的I/O开销和内存占用。尤其是数据库连接池、线程池这类重量级资源，多个实例代价很高。

状态不一致：假如AppConfig里面的配置可以在运行时被修改，很有可能一个模块通过类似`config1.setFieldXXX(xxx)`的方式修改了数值而另一个模块持有`config2`并且不知道修改。

因此，需要一个机制来**强制**`AppConfig`这类管理共享资源或全局状态的对象，在整个应用的生命周期中，**有且仅有一个实例**。

---

## 2. 解决方案 / 核心思想 (The "What")

> [!tip] 它是如何解决上述问题的？
> 通过**控制类的实例化过程**来强制实现“唯一实例”的目标。核心思想建立在以下两个基本原则之上：**构造函数私有化**和**提供了一个全局静态访问方法**。

1. **构造函数私有化(Private Constructor):** 为了防止外部代码通过类似`new`这样的关键字随意创建类的实例，我们必须将构造函数声明为`private`也就是只有类本身可以调用它。
2. **提供一个全局静态访问方法(Public Static Access Method):** 类必须提供一个公开的、静态的方法，作为外界获取其唯一实例的**唯一通道**，这个方法通常叫做`getInstance()`。方法内部负责检查实例是否存在：如果已经创建则直接返回；如果尚未创建，先创建实例，然后再返回。

---

## 3. 结构与角色 (The "Structure")

> [!note] 模式的蓝图

### UML 类图

在这里嵌入UML图。你可以使用 PlantUML 插件、Mermaid 插件，或者直接粘贴图片。

```mermaid
classDiagram
    direction LR

    class Client

    class Singleton {
        -Singleton instance$
        -Singleton()
        +getInstance(): Singleton$
    }

    note for Singleton {
      "if (instance == null) {
        // Note: if you're creating an app with
        // multithreading support, you should
        // place a thread lock here.
        instance = new Singleton()
      }
      return instance"
    }

    Client --> Singleton : uses
    Singleton -- Singleton : instance

```

### 参与角色

Singleton模式的结构非常简单，可以说只有一个核心角色。

- **`单例 (Singleton)`**
  - **职责**:
    1. **持有自身的静态实例**：在内部维护一个对自身实例的静态引用。
    2. **保证构造函数私有**：防止其他对象直接使用 `new` 关键字来创建它的实例。
    3. **提供全局访问点**：提供一个公共的静态方法（通常是 `getInstance()`），让客户端可以获取到这个唯一的实例。这个方法负责处理实例的创建（仅在第一次调用时）和返回。

---

## 4. 代码示例 (The "How")

> [!example] Talk is cheap. Show me the code.

继续沿用 `AppConfig` 例子，看看如何将其改造为Singleton模式。

### Before: 重构前的代码

这是未使用模式前的代码，任何地方都可以随意创建 `AppConfig` 的实例，导致了之前提到的资源浪费和状态不一致问题。

```java
// 问题说明：
// 1. 构造函数是 public 的，允许外部自由创建实例。
// 2. 每次 `new AppConfig()` 都会执行一次（可能很昂贵的）文件读取操作。
// 3. config1 和 config2 是两个不同的对象，修改其中一个不会影响另一个。
public class AppConfig {
    private String databaseUrl;
    private String apiKey;

    // 每次创建实例都会读取配置文件
    public AppConfig() {
        System.out.println("Reading configuration from file...");
        // 模拟读取配置文件的耗时操作
        this.databaseUrl = "jdbc:mysql://localhost:3306/prod";
        this.apiKey = "default_api_key_from_file";
    }

    public void displayConfig() {
        System.out.println("DB URL: " + databaseUrl + ", API Key: " + apiKey);
    }

    // Getter and Setter ...
}

// 客户端代码
public class Client {
    public static void main(String[] args) {
        System.out.println("--- Client creating first config ---");
        AppConfig config1 = new AppConfig();
        config1.displayConfig();

        System.out.println("\n--- Client creating second config ---");
        AppConfig config2 = new AppConfig();
        config2.displayConfig();

        System.out.println("\nAre config1 and config2 the same instance? " + (config1 == config2));
    }
}
```

运行结果：

```plaintext
--- Client creating first config ---
Reading configuration from file...
DB URL: jdbc:mysql://localhost:3306/prod, API Key: default_api_key_from_file

--- Client creating second config ---
Reading configuration from file...
DB URL: jdbc:mysql://localhost:3306/prod, API Key: default_api_key_from_file

Are config1 and config2 the same instance? false
```

### After: 应用模式后的代码

现在，我们应用Singleton模式来重构 `AppConfig`。这里展示的是最经典的**懒汉式（Lazy Initialization）**实现。

```java
// Singleton: 单例类本身
public class AppConfig {

    // 1. 持有自身的私有静态实例。
    // 使用 volatile 关键字确保多线程环境下的可见性和有序性。
    private static volatile AppConfig instance;

    private String databaseUrl;
    private String apiKey;

    // 2. 构造函数私有化，防止外部直接 new。
    private AppConfig() {
        System.out.println("Reading configuration from file... (This should happen only once)");
        // 模拟读取配置文件的耗时操作
        this.databaseUrl = "jdbc:mysql://localhost:3306/prod";
        this.apiKey = "unique_api_key_from_singleton";
    }

    // 3. 提供全局静态访问方法。
    // 使用双重检查锁定（Double-Checked Locking）来保证线程安全和性能。
    public static AppConfig getInstance() {
        // 第一次检查：如果实例已存在，直接返回，避免不必要的同步开销。
        if (instance == null) {
            // 同步块，确保只有一个线程可以进入创建实例的代码区。
            synchronized (AppConfig.class) {
                // 第二次检查：防止多个线程同时通过第一次检查后重复创建实例。
                if (instance == null) {
                    instance = new AppConfig();
                }
            }
        }
        return instance;
    }

    public void displayConfig() {
        System.out.println("DB URL: " + databaseUrl + ", API Key: " + apiKey);
    }

    // Getter and Setter ...
}


// 客户端代码
public class Client {
    public static void main(String[] args) {
        System.out.println("--- Client getting first config ---");
        AppConfig config1 = AppConfig.getInstance();
        config1.displayConfig();

        System.out.println("\n--- Client getting second config ---");
        AppConfig config2 = AppConfig.getInstance();
        config2.displayConfig();

        System.out.println("\nAre config1 and config2 the same instance? " + (config1 == config2));
    }
}
```

运行结果：

```plaintext
--- Client getting first config ---
Reading configuration from file... (This should happen only once)
DB URL: jdbc:mysql://localhost:3306/prod, API Key: unique_api_key_from_singleton

--- Client getting second config ---
DB URL: jdbc:mysql://localhost:3306/prod, API Key: unique_api_key_from_singleton

Are config1 and config2 the same instance? true
```

可以看到，配置文件只被读取了一次，并且两次获取到的都是同一个实例。

---

## 5. 优缺点 (Pros & Cons)

> [!todo] 权衡利弊

### 优点 (Pros)

- **确保唯一实例**: 严格控制实例数量，保证一个类在任何情况下都只有一个实例，有效防止了前面提到的状态不一致问题。
- **全局访问点**: 提供一个全局唯一的访问点，方便程序中任何位置的代码共享和访问这个实例。
- **资源节约**: 对于数据库连接池、线程池、日志对象、配置文件对象等重量级资源，只创建一次实例可以显著节约内存和计算资源。
- **延迟初始化 (Lazy Initialization)**: 像上面的代码示例一样，可以在首次被请求时才创建实例，避免了在程序启动时就进行不必要的初始化，从而加快启动速度。

### 缺点 (Cons)

- **违反单一职责原则 (Single Responsibility Principle)**: Singleton类既要负责其核心的业务逻辑（如管理配置），又要负责保证自己是唯一的。这两个职责被耦合在了一起。
  > **单一职责原则 (Single Responsibility Principle, SRP)** 指出：一个类应该只有一个引起它变化的原因。
  > Singleton模式违反了这一点，因为它承担了两个完全不相关的职责：1. **业务职责**：类本身要完成的业务逻辑。例如，`AppConfig`的职责是“管理和提供配置信息”；`DatabaseConnectionPool`的职责是“管理和分配数据库连接”。2. **生命周期管理职责**：保证自己只有一个实例。这包括私有化构造函数、提供静态实例变量和`getInstance()`方法等逻辑。
- **对测试不友好**: 因为Singleton模式引入了全局状态，使得单元测试变得困难。依赖于Singleton的类很难被独立测试，因为无法轻易地用一个模拟（Mock）对象来替换这个全局唯一的实例。
- **对继承不友好**: 由于构造函数是私有的，所以Singleton类通常不能被继承。
- **可能被滥用**: 开发者可能会滥用Singleton来代替全局变量，导致代码各部分之间产生不必要的强耦合，使得代码结构不清晰、难以维护。

**问题一：代码耦合度高，可维护性差**

想象一下，你的`AppConfig`类一开始是用简单的懒汉式实现的。后来，项目引入了多线程，你需要将`getInstance()`方法修改为线程安全的版本（比如使用双重检查锁定）。

在这个过程中，你**修改`AppConfig`类的原因，和“配置管理”这个业务逻辑毫无关系**，而是因为它的“生命周期管理”逻辑需要变更。

这意味着，业务逻辑和生命周期管理逻辑被紧紧地**耦合**在了一个类里。未来任何一个职责的变更需求，都可能需要修改同一个文件，增加了引入错误的风险，也让代码的意图变得不那么清晰。一个类承担了太多不相干的角色，变得越来越臃肿和难以理解。

**问题二：灵活性差**

如果有一天，你希望在某些特殊情况下（比如测试）能拥有`AppConfig`的多个实例，或者希望这个实例的创建方式能被替换（比如从读取文件变为从网络获取），Singleton模式会给你带来巨大的阻碍。因为创建逻辑被硬编码（hard-coded）在`getInstance`静态方法里，外部完全无法干预或替换它。

### 2. 对测试不友好是怎么体现的？

这是Singleton模式最致命的缺点之一，因为它引入了**全局状态 (Global State)**，而全局状态是单元测试的噩梦。

我们用一个Python的例子来生动地展示这个问题。

**场景**: 我们有一个 `EventLogger` 类，负责记录系统事件。我们希望它是一个单例，因为我们希望所有日志都写入同一个地方。然后，我们有一个 `UserManager` 类，在用户注册时需要调用 `EventLogger` 来记录事件。

#### 第1步：使用Singleton模式的代码（不方便测试）

Python

```
# event_logger.py (Singleton)
class EventLogger:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            print("Creating new EventLogger instance...")
            cls._instance = super(EventLogger, cls).__new__(cls)
            cls._instance.events = []
        return cls._instance

    def log(self, event: str):
        self.events.append(event)
        print(f"Logged: {event}")

# user_manager.py
from event_logger import EventLogger

class UserManager:
    def register_user(self, username: str):
        # 紧密耦合：直接调用全局的Singleton实例
        logger = EventLogger()
        logger.log(f"User '{username}' registered.")
        # ... 其他注册逻辑 ...
        return True
```

#### 第2步：尝试为 `UserManager` 编写单元测试

我们想测试 `UserManager.register_user` 方法是否正确调用了日志记录器。

Python

```
# test_user_manager.py
import unittest
from user_manager import UserManager
from event_logger import EventLogger

class TestUserManager(unittest.TestCase):
    def test_register_user_should_log_event(self):
        """
        测试：当一个用户被注册时，应该记录一个事件。
        """
        # 问题1：我们无法阻止 EventLogger 的真实实例被创建。
        # 控制台会打印 "Creating new EventLogger instance..."
        manager = UserManager()
        manager.register_user("Alice")

        # 问题2：如何验证 log 方法被调用了？
        # 我们被迫要去获取全局的单例实例，并检查它的内部状态。
        # 这让我们的测试依赖于 EventLogger 的具体实现。
        logger_instance = EventLogger()
        self.assertIn("User 'Alice' registered.", logger_instance.events)

    def test_another_feature(self):
        # 问题3：测试之间互相影响！
        # 上一个测试向全局的 logger_instance.events 添加了数据。
        # 如果我们不手动清理，这个测试就会受到污染。
        logger_instance = EventLogger()
        print(f"Events before this test: {logger_instance.events}") # 输出: ['User \'Alice\' registered.']
        # 这会导致测试结果不稳定，依赖于测试的执行顺序。
```

**总结一下测试的痛点：**

1. **无法隔离 (Isolation)**：`UserManager` 的测试无法与 `EventLogger` 的真实逻辑隔离开。我们的测试现在依赖于网络、文件系统或`EventLogger`所做的任何I/O操作，这使得测试变慢且不稳定。我们只想测试`UserManager`的逻辑，不想测试`EventLogger`。
2. **难以模拟 (Mocking)**：我们无法轻易地用一个“模拟对象”（Mock Object）来替换`EventLogger`。比如，我们想测试当`log`方法抛出异常时，`register_user`是否能优雅地处理？用Singleton就很难做到，因为`UserManager`内部硬编码了对`EventLogger()`的调用。
3. **状态泄露**：由于实例是全局共享的，一个测试用例对Singleton实例状态的修改会“泄露”到下一个测试用例，导致测试之间相互依赖和污染。这违反了单元测试独立性的基本原则。

#### 第3步：重构代码以提高可测试性（使用依赖注入）

现在，我们放弃Singleton模式，转而使用**依赖注入 (Dependency Injection)**。核心思想是：一个类不应该自己创建它所依赖的对象，而应该通过外部（比如构造函数）将依赖传递进来。

Python

```
# event_logger_refactored.py (不再是Singleton)
class EventLogger:
    def __init__(self):
        self.events = []
        print("Creating new EventLogger instance...")

    def log(self, event: str):
        self.events.append(event)
        print(f"Logged: {event}")


# user_manager_refactored.py
class UserManager:
    # 依赖通过构造函数被“注入”
    def __init__(self, logger: EventLogger):
        self._logger = logger

    def register_user(self, username: str):
        # 使用注入的依赖，而不是全局实例
        self._logger.log(f"User '{username}' registered.")
        # ... 其他注册逻辑 ...
        return True
```

#### 第4步：为重构后的代码编写一个干净的单元测试

现在测试变得非常简单、干净和可靠。

Python

```
# test_user_manager_refactored.py
import unittest
from unittest.mock import Mock # Python内置的模拟库
from user_manager_refactored import UserManager
from event_logger_refactored import EventLogger

class TestUserManagerRefactored(unittest.TestCase):
    def test_register_user_should_log_event(self):
        # 1. 准备：创建一个模拟的 logger 对象
        # 它不是一个真实的 EventLogger，只是一个“假”对象
        mock_logger = Mock(spec=EventLogger)

        # 2. 执行：将模拟对象“注入”到我们要测试的类中
        manager = UserManager(logger=mock_logger)
        manager.register_user("Bob")

        # 3. 断言：验证我们的模拟对象是否被如期调用
        # 我们可以精确地检查 log 方法是否被以正确的参数调用了一次
        # 这个过程完全不涉及真实的 EventLogger 类，测试非常快且独立。
        mock_logger.log.assert_called_once_with("User 'Bob' registered.")

    def test_another_feature(self):
        # 这个测试完全不会受到上一个测试的影响，因为每次都创建新的模拟对象。
        pass
```

通过这个对比，你可以清晰地看到，Singleton模式通过全局访问点（`EventLogger()`）创建了**紧耦合**，而依赖注入则实现了**松耦合**，使得单元测试变得轻而易举。

在应用程序的顶层，你仍然可以只创建一个`EventLogger`实例，然后把它传递给所有需要它的地方，从而达到“事实上的单例”效果，同时又保留了代码的灵活性和可测试性。这正是现代依赖注入框架（如Spring, Guice, FastAPI's Depends）所推崇的方式。

---

## 6. 适用场景 (Applicability)

> [!check] 我应该在什么时候使用它？
>
> - 当系统中某个组件必须依赖一个唯一的实例来管理共享资源时。
> - 当需要一个比全局变量更好的方式来管理全局状态时。

---

## 7. 现实世界中的应用 (Real-World Examples)

> [!bug] 这个模式在哪些知名项目中被使用过？
>
> - 等发现的时候补充

---

## 8. 相关模式 (Related Patterns)

> [!link] 与其他模式的联系和区别
>
> - **[[另一个设计模式]]**: 与该模式的关系是...（例如，经常一起使用，或者结构相似但意图不同）。
> - **[[又一个设计模式]]**: 与该模式的区别在于...（帮助你辨析易混淆的模式）。

TODO：- A [Facade](https://refactoring.guru/design-patterns/facade) class can often be transformed into a [Singleton](https://refactoring.guru/design-patterns/singleton) since a single facade object is sufficient in most cases.

TODO：- [Flyweight](https://refactoring.guru/design-patterns/flyweight) would resemble [Singleton](https://refactoring.guru/design-patterns/singleton) if you somehow managed to reduce all shared states of the objects to just one flyweight object. But there are two fundamental differences between these patterns:

    1. There should be only one Singleton instance, whereas a _Flyweight_ class can have multiple instances with different intrinsic states.
    2. The _Singleton_ object can be mutable. Flyweight objects are immutable.

TODO：- [Abstract Factories](https://refactoring.guru/design-patterns/abstract-factory), [Builders](https://refactoring.guru/design-patterns/builder) and [Prototypes](https://refactoring.guru/design-patterns/prototype) can all be implemented as [Singletons](https://refactoring.guru/design-patterns/singleton).

TODO：图解设计模式书本中提到相关的设计模式：AbstractFactory，Builder，Facade，Prototype模式在多数情况下只会生成一个实例。

## 9. 练习题

### 习题5-1

非Singleton模式的`TicketMaker`类：

```java
public class TicketMaker {
	private int ticket = 1000;
	public int getNextTicketNumber() {
		return ticket++;
	}
}
```

修改成Singleton模式确保只能生成一个该类的实例。

```java
public class TicketMaker {
	private static int ticket = 1000;
	public static int getNextTicketNumber() {
		return ticket++;
	}
}
```

### 习题5-2

编写`Triple`类，最多生成3个Triple类的实例，编号分别为0, 1, 2且可以通过getInstance(int id)来获取该编号对应的实例。

```java
public class Triple {
	private Triple() {
	}

	public Triple getInstance(int id) {

	}
}
```

### 习题5-3

下面的代码为什么不是严格的SIngleton模式？

```java
public class Singleton {
	private static Singleton singleton = null;
	private Singleton() {
		System.out.println("生成了一个实例。")；
	}

	public static Singleton getInstance() {
		if (singleton == null) {
			singleton = new Singleton();
		}
		return singleton;
	}
}
```

因为多线程问题。
