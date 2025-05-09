课程没有任何教程，7 个练习题目的代码在[Github-AP1400-2](https://github.com/courseworks)上。

我感觉每个作业的指引比较少，包括环境设置等等。每一个作业利用GoogleTest来测试，但是也没有介绍如何设置GoogleTest。给的DockerFile似乎默认学习者会使用docker

我觉得值得记录一下每一个作业的考点以及相关操作。

所有的作业应该都有一个`main.cpp`，里面内容大致如下：

```cpp
#include "xxx.h"
#include <gtest/gtest.h>

int main(int argc, char **argv) {
  if (true) // make false to run unit-tests
  {
    // debug section

  } else {
    ::testing::InitGoogleTest(&argc, argv);
    std::cout << "RUNNING TESTS ..." << std::endl;
    int ret{RUN_ALL_TESTS()};
    if (!ret)
      std::cout << "<<<SUCCESS>>>" << std::endl;
    else
      std::cout << "FAILED" << std::endl;
  }
  return 0;
}
```

修改成类似这个样子：

```cpp
#include "xxx.h"
#include <gtest/gtest.h>

int main(int argc, char **argv) {
  bool run_tests = false;

  // 检查命令行参数
  if (argc > 1) {
    std::string arg = argv[1];
    if (arg == "test") {
      run_tests = true;
    }
  }

  if (!run_tests) {
    // debug section

  } else {
    ::testing::InitGoogleTest(&argc, argv);
    std::cout << "RUNNING TESTS ..." << std::endl;
    int ret{RUN_ALL_TESTS()};
    if (!ret)
      std::cout << "<<<SUCCESS>>>" << std::endl;
    else
      std::cout << "FAILED" << std::endl;
  }
  return 0;
}
```

这样就不用在测试前重新编译，

```bash
./main test
```

就可以直接执行测试

## HW3

实现一个二叉搜索树

- lambda function
- 运算符重载
