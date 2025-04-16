# Markup Languages

Markup languages are not programming languages. This refers to formats like TOML, YAML, and JSON that are used for data serialization and configuration.

## ToC

### YAML

笔记：

[[1-syntax|基础语法]]  
[[2-examples|示例]]  
[[3-gotchas|常见错误]]  
[[4-usecases|使用案例]]  
[[5-tools|常用工具]]

额外资源：

- [YAML Official Website](https://yaml.org/)
- [YAML Specification](https://yaml.org/spec/)
- [YAML Validator](https://www.yamllint.com/)

### JSON

笔记：

[[json-1-syntax|基础语法]]  
[[json-2-examples|示例]]  
[[json-3-gotchas|常见错误]]  
[[json-4-usecases|使用案例]]

额外资源：

- [JSON Official Website](https://www.json.org/)
- [JSON Schema](https://json-schema.org/)

### TOML

笔记：

[[toml-1-syntax|基础语法]]  
[[toml-2-examples|示例]]  
[[toml-3-comparison|与其他格式比较]]

额外资源：

- [TOML Official Website](https://toml.io/)
- [TOML GitHub Repository](https://github.com/toml-lang/toml)

## 比较

| 特性          | YAML                 | JSON               | TOML                          |
| ------------- | -------------------- | ------------------ | ----------------------------- |
| 可读性        | 高                   | 中                 | 高                            |
| 复杂度        | 高                   | 低                 | 中                            |
| 注释支持      | ✅                   | ❌                 | ✅                            |
| 数据类型      | 丰富                 | 基本               | 丰富                          |
| 常见用途      | 配置文件，数据序列化 | API 通信，数据存储 | 配置文件                      |
| 流行框架/工具 | Kubernetes, Ansible  | REST APIs, MongoDB | Cargo (Rust), Poetry (Python) |
