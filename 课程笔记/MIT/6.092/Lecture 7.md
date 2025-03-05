Banner Image Description: _A refined visual of Java core features: inheritance represented as a family tree or connected class boxes, an exception symbolized by an exclamation mark inside a broken block, and a simple document icon with an arrow denoting file input/output._

---

Inheritance, exceptions, file I/O

Review of Chapter 6

Interfaces? Interfaces!

- It's a contract!
- If you must implement **ALL** the methods
- All fields are `final`, which means that it cannot be changed.

```java
publci interface ICar {
	boolean isCar = true;

	int getNumWheels();
}
```
