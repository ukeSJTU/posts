这里对应了官方的 Tutorial 页面：https://textual.textualize.io/tutorial/

官方还提供了一系列的视频教程帮助理解：[videos](https://www.youtube.com/playlist?list=PLHhDR_Q5Me1MxO4LmfzMNNQyKfwa275Qe)

We're going to build a stopwatch application. This application should show a list of stopwatches with buttons to start, stop, and reset the stopwatches. We also want the user to be able to add and remove stopwatches as required.

textual 本身自带 type hints。示例代码也使用了 type hints。我们可以使用 mypy 来检查代码的类型。但是可以自行决定自己的项目中要不要用 type hints

## The App class

The first step in building a Textual app is to import and extend the App class. Here's a basic app class we will use as a starting point for the stopwatch app.

```python
from textual.app import App, ComposeResult
from textual.widgets import Footer, Header


class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Header()
        yield Footer()

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )


if __name__ == "__main__":
    app = StopwatchApp()
    app.run()
```

### closer look at the App class

Break down the code above

```python
from textual.app import App, ComposeResult
from textual.widgets import Footer, Header
```

The first line imports App class, which is the base class for all Textual apps. The second line imports two builtin widgets: Footer which shows a bar at the bottom of the screen with bound keys, and Header which shows a title at the top of the screen. Widgets are re-usable components responsible for managing a part of the screen.

```python
class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Header()
        yield Footer()

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )
```

The App class is where most of the logic of Textual apps is written. It is responsible for loading configuration, setting up widgets, handling keys, and more.

BINDINGS is a list of tuples that maps (or binds) keys to actions in your app. The first value in the tuple is the key; the second value is the name of the action; the final value is a short description. We have a single binding which maps the D key on to the "toggle_dark" action. See [key bindings](https://textual.textualize.io/guide/input/#bindings) in the guide for details.

compose() is where we construct a user interface with widgets. The compose() method may return a list of widgets, but it is generally easier to yield them (making this method a generator). In the example code we yield an instance of each of the widget classes we imported, i.e. Header() and Footer().

action*toggle_dark() defines an action method. Actions are methods beginning with action* followed by the name of the action. The BINDINGS list above tells Textual to run this action when the user hits the D key. See actions in the guide for details.

```python
if __name__ == "__main__":
    app = StopwatchApp()
    app.run()
```

The final three lines create an instance of the app and calls the [run()](https://textual.textualize.io/api/app/#textual.app.App.run) method which puts your terminal into application mode and runs the app until you exit with Ctrl+Q. This happens within a **name** == "**main**" block so we could run the app with python stopwatch01.py or import it as part of a larger project.

## Designing a UI with widgets

Textual has a large number of [builtin widgets](https://textual.textualize.io/widget_gallery/). For our app we will need new widgets, which we can create by extending and combining the builtin widgets.

### Custom widgets

We need a Stopwatch widget composed of the following child widgets:

A "Start" button
A "Stop" button
A "Reset" button
A time display
Let's add those to the app. Just a skeleton for now, we will add the rest of the features as we go.

```python
from textual.app import App, ComposeResult
from textual.containers import HorizontalGroup, VerticalScroll
from textual.widgets import Button, Digits, Footer, Header


class TimeDisplay(Digits):
    """A widget to display elapsed time."""


class Stopwatch(HorizontalGroup):
    """A stopwatch widget."""

    def compose(self) -> ComposeResult:
        """Create child widgets of a stopwatch."""
        yield Button("Start", id="start", variant="success")
        yield Button("Stop", id="stop", variant="error")
        yield Button("Reset", id="reset")
        yield TimeDisplay("00:00:00.00")


class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Header()
        yield Footer()
        yield VerticalScroll(Stopwatch(), Stopwatch(), Stopwatch())

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )


if __name__ == "__main__":
    app = StopwatchApp()
    app.run()
```

We've imported two new widgets in this code: Button for the buttons and Digits for the time display.

we've imported HorizontalGroup and VerticalScroll from textual.containers (as the name of the module suggests, containers are widgets which contain other widgets). We will use these container widgets to define the general layout of our interface.

> If you are building custom widgets of your own, be sure to see guide on [coordinating widgets](https://textual.textualize.io/guide/widgets/#coordinating-widgets).

#### The buttons

TODO：这个可以留到 Widgets 部分一起讲解

### Composing the widgets

The new line in StopwatchApp.compose() yields a single VerticalScroll which will scroll if the contents don't quite fit. This widget also takes care of key bindings required for scrolling, like Up, Down, Page Down, Page Up, Home, End, etc.

When widgets contain other widgets (like VerticalScroll) they will typically accept their child widgets as positional arguments. So the line yield VerticalScroll(Stopwatch(), Stopwatch(), Stopwatch()) creates a VerticalScroll containing three Stopwatch widgets.

### The unstyled app

我们需要给 widgets 添加 styles 才能让 App 看起来更像我们想要的样子。

## Writing Textual CSS

Every widget has a styles object with a number of attributes that impact how the widget will appear. For example, set white text and a blue background for a widget:

```python
self.styles.background = "blue"
self.styles.color = "white"
```

更推荐用 CSS files 来给 widgets 设置样式。

CSS makes it easy to iterate on the design of your app and enables [live-editing](https://textual.textualize.io/guide/devtools/#live-editing)

```python
from textual.app import App, ComposeResult
from textual.containers import HorizontalGroup, VerticalScroll
from textual.widgets import Button, Digits, Footer, Header


class TimeDisplay(Digits):
    """A widget to display elapsed time."""


class Stopwatch(HorizontalGroup):
    """A stopwatch widget."""

    def compose(self) -> ComposeResult:
        """Create child widgets of a stopwatch."""
        yield Button("Start", id="start", variant="success")
        yield Button("Stop", id="stop", variant="error")
        yield Button("Reset", id="reset")
        yield TimeDisplay("00:00:00.00")


class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    CSS_PATH = "stopwatch03.tcss"
    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Create child widgets for the app."""
        yield Header()
        yield Footer()
        yield VerticalScroll(Stopwatch(), Stopwatch(), Stopwatch())

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )


if __name__ == "__main__":
    app = StopwatchApp()
    app.run()
```

Adding the CSS_PATH class variable tells Textual to load the following file when the app starts:

```css
Stopwatch {
  background: $boost;
  height: 5;
  margin: 1;
  min-width: 50;
  padding: 1;
}

TimeDisplay {
  text-align: center;
  color: $foreground-muted;
  height: 3;
}

Button {
  width: 16;
}

#start {
  dock: left;
}

#stop {
  dock: left;
  display: none;
}

#reset {
  dock: right;
}
```

### CSS basics

CSS files contain a number of declaration blocks. Here's the first such block from stopwatch03.tcss again:

```css
Stopwatch {
  background: $boost;
  height: 5;
  margin: 1;
  min-width: 50;
  padding: 1;
}
```

The first line tells Textual that the styles should apply to the Stopwatch widget. The lines between the curly brackets contain the styles themselves.

Here's how this CSS code changes how the Stopwatch widget is displayed.

- background: $boost sets the background color to $boost. The $ prefix picks a pre-defined color from the builtin theme. There are other ways to specify colors such as "blue" or rgb(20,46,210).
- height: 5 sets the height of our widget to 5 lines of text.
- margin: 1 sets a margin of 1 cell around the Stopwatch widget to create a little space between widgets in the list.
- min-width: 50 sets the minimum width of our widget to 50 cells.
- padding: 1 sets a padding of 1 cell around the child widgets.

TODO: 原本的官网上的 tutorial 还解释了剩下的 Textual CSS 的作用，我觉得这个部分可以放到后续专门介绍 tcss 的内容。

The TimeDisplay block aligns text to the center (text-align:), sets its color (color:), and sets its height (height:) to 3 lines.

The Button block sets the width (width:) of buttons to 16 cells (character widths).

The last 3 blocks have a slightly different format. When the declaration begins with a # then the styles will be applied to widgets with a matching "id" attribute. We've set an ID on the Button widgets we yielded in compose. For instance the first button has id="start" which matches #start in the CSS.

The buttons have a dock style which aligns the widget to a given edge. The start and stop buttons are docked to the left edge, while the reset button is docked to the right edge.

You may have noticed that the stop button (#stop in the CSS) has display: none;. This tells Textual to not show the button. We do this because we don't want to display the stop button when the timer is not running. Similarly, we don't want to show the start button when the timer is running. We will cover how to manage such dynamic user interfaces in the next section.

### Dynamic CSS

We want our Stopwatch widget to have two states: a default state with a Start and Reset button; and a started state with a Stop button.

We can accomplish this with a CSS class. Not to be confused with a Python class, a CSS class is like a tag you can add to a widget to modify its styles. A widget may have any number of CSS classes, which may be added and removed to change its appearance.

```css
.started {
  background: $success-muted;
  color: $text;
}

.started TimeDisplay {
  color: $foreground;
}

.started #start {
  display: none;
}

.started #stop {
  display: block;
}

.started #reset {
  visibility: hidden;
}
```

These new rules are prefixed with .started. The . indicates that .started refers to a CSS class called "started". The new styles will be applied only to widgets that have this CSS class.

Some of the new styles have more than one selector separated by a space. The space indicates that the rule should match the second selector if it is a child of the first.

The .started selector matches any widget with a "started" CSS class. While #start matches a widget with an ID of "start". Combining the two selectors with a space (.started #start) creates a new selector that will match the start button only if it is also inside a container with a CSS class of "started".

TODO: 上面的这两段的意思也就是说：这个选择器可以同时有很多个，用空格分割，并且按照从左往右的顺序，`.started #start`就会先找有`started`这个 class 的，然后再看组件的 id 是不是 start

### Manipulating classes

Modifying a widget's CSS classes is a convenient way to update visuals without introducing a lot of messy display related code.

The following code will start or stop the stopwatches in response to clicking a button:

```python
...

class Stopwatch(HorizontalGroup):
    """A stopwatch widget."""

    def on_button_pressed(self, event: Button.Pressed) -> None:
        """Event handler called when a button is pressed."""
        if event.button.id == "start":
            self.add_class("started")
        elif event.button.id == "stop":
            self.remove_class("started")

...

```

The on*button_pressed method is an event handler. Event handlers are methods called by Textual in response to an event such as a key press, mouse click, etc. Event handlers begin with on* followed by the name of the event they will handle. Hence on_button_pressed will handle the button pressed event.

TODO: 上面这个的核心在于`on_`开头的 methods 是 Textual 会自动调用的，后面跟着事件的名字。比如这里的`on_button_pressed`就是处理 button 被按下的事件。这个方法会在按钮被按下时被 Textual 自动调用。

See the guide on [message handlers](https://textual.textualize.io/guide/events/#message-handlers) for the details on how to write event handlers.

TODO: 我在想知道这个 event handle 是向下传递的还是向上传递的。比如说我在一个 container 里面有很多个 button，这个时候点击其中一个 button，是否会触发这个 container 的 event handler？还是说只会触发这个 button 的 event handler？

## Reactive attributes

It is possible: you can call refresh() to display new data. However, Textual prefers to do this automatically via reactive attributes.

Reactive attributes work like any other attribute, such as those you might set in an `__init__` method, but allow Textual to detect when you assign to them, in addition to some other [superpowers](https://textual.textualize.io/guide/reactivity/).

To add a reactive attribute, import [reactive](https://textual.textualize.io/api/reactive/#textual.reactive.reactive) and create an instance in your class scope.

Let's add reactives to our stopwatch to calculate and display the elapsed time.

```python
from time import monotonic

from textual.app import App, ComposeResult
from textual.containers import HorizontalGroup, VerticalScroll
from textual.reactive import reactive
from textual.widgets import Button, Digits, Footer, Header


class TimeDisplay(Digits):
    """A widget to display elapsed time."""

    start_time = reactive(monotonic)
    time = reactive(0.0)

    def on_mount(self) -> None:
        """Event handler called when widget is added to the app."""
        self.set_interval(1 / 60, self.update_time)

    def update_time(self) -> None:
        """Method to update the time to the current time."""
        self.time = monotonic() - self.start_time

    def watch_time(self, time: float) -> None:
        """Called when the time attribute changes."""
        minutes, seconds = divmod(time, 60)
        hours, minutes = divmod(minutes, 60)
        self.update(f"{hours:02,.0f}:{minutes:02.0f}:{seconds:05.2f}")


class Stopwatch(HorizontalGroup):
    """A stopwatch widget."""
    ...

    def compose(self) -> ComposeResult:
        """Create child widgets of a stopwatch."""
        ...
        yield TimeDisplay()

...

```

We have added two reactive attributes to the TimeDisplay widget: start_time will contain the time the stopwatch was started (in seconds), and time will contain the time to be displayed in the Stopwatch widget.

Both attributes will be available on `self` as if you had assigned them in `__init__`. If you write to either of these attributes the widget will update automatically.

The first argument to reactive may be a default value for the attribute or a callable that returns a default value. We set the default for start_time to the monotonic function which will be called to initialize the attribute with the current time when the TimeDisplay is added to the app. The time attribute has a simple float as the default, so self.time will be initialized to 0.

The on_mount method is an event handler called when the widget is first added to the application (or mounted in Textual terminology). In this method we call [set_interval()](https://textual.textualize.io/api/message_pump/#textual.message_pump.MessagePump.set_interval) to create a timer which calls self.update_time sixty times a second. This update_time method calculates the time elapsed since the widget started and assigns it to self.time — which brings us to one of Reactive's super-powers.

TODO:上面这里第一次提到了`on_mount`方法，作用是在 widget 被添加到 app 的时候调用。这个方法可以用来做一些初始化的工作，比如说设置定时器，或者设置 styles 等等。

TODO:上面还提到了`set_interval()`这个方法。后续仔细研究。

If you implement a method that begins with `watch_` followed by the name of a reactive attribute, then the method will be called when the attribute is modified. Such methods are known as _watch methods_.

Because watch_time watches the time attribute, when we update self.time 60 times a second we also implicitly call watch_time which converts the elapsed time to a string and updates the widget with a call to self.update. Because this happens automatically, we don't need to pass in an initial argument to TimeDisplay.

如果运行上面的代码，会发现当 App 启动，所有的秒表都开始计时。我们按照下面这样修改：

### Wiring buttons

We need to be able to start, stop, and reset each stopwatch independently. We can do this by adding a few more methods to the `TimeDisplay` class.

```python
from time import monotonic

from textual.app import App, ComposeResult
from textual.containers import HorizontalGroup, VerticalScroll
from textual.reactive import reactive
from textual.widgets import Button, Digits, Footer, Header


class TimeDisplay(Digits):
    """A widget to display elapsed time."""

    start_time = reactive(monotonic)
    time = reactive(0.0)
    total = reactive(0.0)

    def on_mount(self) -> None:
        """Event handler called when widget is added to the app."""
        self.update_timer = self.set_interval(1 / 60, self.update_time, pause=True)

    def update_time(self) -> None:
        """Method to update time to current."""
        self.time = self.total + (monotonic() - self.start_time)

    def watch_time(self, time: float) -> None:
        """Called when the time attribute changes."""
        minutes, seconds = divmod(time, 60)
        hours, minutes = divmod(minutes, 60)
        self.update(f"{hours:02,.0f}:{minutes:02.0f}:{seconds:05.2f}")

    def start(self) -> None:
        """Method to start (or resume) time updating."""
        self.start_time = monotonic()
        self.update_timer.resume()

    def stop(self) -> None:
        """Method to stop the time display updating."""
        self.update_timer.pause()
        self.total += monotonic() - self.start_time
        self.time = self.total

    def reset(self) -> None:
        """Method to reset the time display to zero."""
        self.total = 0
        self.time = 0


class Stopwatch(HorizontalGroup):
    """A stopwatch widget."""

    def on_button_pressed(self, event: Button.Pressed) -> None:
        """Event handler called when a button is pressed."""
        button_id = event.button.id
        time_display = self.query_one(TimeDisplay)
        if button_id == "start":
            time_display.start()
            self.add_class("started")
        elif button_id == "stop":
            time_display.stop()
            self.remove_class("started")
        elif button_id == "reset":
            time_display.reset()

    def compose(self) -> ComposeResult:
        """Create child widgets of a stopwatch."""
        yield Button("Start", id="start", variant="success")
        yield Button("Stop", id="stop", variant="error")
        yield Button("Reset", id="reset")
        yield TimeDisplay()


class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    CSS_PATH = "stopwatch04.tcss"
    BINDINGS = [("d", "toggle_dark", "Toggle dark mode")]

    def compose(self) -> ComposeResult:
        """Called to add widgets to the app."""
        yield Header()
        yield Footer()
        yield VerticalScroll(Stopwatch(), Stopwatch(), Stopwatch())

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )


if __name__ == "__main__":
    app = StopwatchApp()
    app.run()
```

Here's a summary of the changes made to TimeDisplay.

- We've added a total reactive attribute to store the total time elapsed between clicking the start and stop buttons.
- The call to `set_interval` has grown a `pause=True` argument which starts the timer in pause mode (when a timer is paused it won't run until resume() is called). This is because we don't want the time to update until the user hits the start button.
- The update_time method now adds total to the current time to account for the time between any previous clicks of the start and stop buttons.
- We've stored the result of set_interval which returns a Timer object. We will use this to resume the timer when we start the Stopwatch.
- We've added start(), stop(), and reset() methods.

TODO：上面提到一点，set_interval 可以传入一个 pause 参数，来决定是否在创建的时候就开始计时。这个可以在后续的内容中再详细介绍一下。

In addition, the on_button_pressed method on Stopwatch has grown some code to manage the time display when the user clicks a button. Let's look at that in detail:

```python
    def on_button_pressed(self, event: Button.Pressed) -> None:
        """Event handler called when a button is pressed."""
        button_id = event.button.id
        time_display = self.query_one(TimeDisplay)
        if button_id == "start":
            time_display.start()
            self.add_class("started")
        elif button_id == "stop":
            time_display.stop()
            self.remove_class("started")
        elif button_id == "reset":
            time_display.reset()
```

This code supplies missing features and makes our app useful. We've made the following changes.

- The first line retrieves id attribute of the button that was pressed. We can use this to decide what to do in response.
- The second line calls [`query_one`](https://textual.textualize.io/api/dom_node/#textual.dom.DOMNode.query_one) to get a reference to the `TimeDisplay` widget.
- We call the method on `TimeDisplay` that matches the pressed button.
- We add the "started" class when the Stopwatch is started (self.add_class("started")), and remove it (self.remove_class("started")) when it is stopped. This will update the Stopwatch visuals via CSS.

## Dynamic widgets

The Stopwatch app creates widgets when it starts via the compose method. We will also need to create new widgets while the app is running, and remove widgets we no longer need. We can do this by calling mount() to add a widget, and remove() to remove a widget.

```python
class StopwatchApp(App):
    """A Textual app to manage stopwatches."""

    CSS_PATH = "stopwatch.tcss"

    BINDINGS = [
        ("d", "toggle_dark", "Toggle dark mode"),
        ("a", "add_stopwatch", "Add"),
        ("r", "remove_stopwatch", "Remove"),
    ]

    def compose(self) -> ComposeResult:
        """Called to add widgets to the app."""
        yield Header()
        yield Footer()
        yield VerticalScroll(Stopwatch(), Stopwatch(), Stopwatch(), id="timers")

    def action_add_stopwatch(self) -> None:
        """An action to add a timer."""
        new_stopwatch = Stopwatch()
        self.query_one("#timers").mount(new_stopwatch)
        new_stopwatch.scroll_visible()

    def action_remove_stopwatch(self) -> None:
        """Called to remove a timer."""
        timers = self.query("Stopwatch")
        if timers:
            timers.last().remove()

    def action_toggle_dark(self) -> None:
        """An action to toggle dark mode."""
        self.theme = (
            "textual-dark" if self.theme == "textual-light" else "textual-light"
        )
```

Here's a summary of the changes:

The VerticalScroll object in StopWatchApp grew a "timers" ID.
Added action_add_stopwatch to add a new stopwatch.
Added action_remove_stopwatch to remove a stopwatch.
Added keybindings for the actions.
The action_add_stopwatch method creates and mounts a new stopwatch. Note the call to query_one() with a CSS selector of "#timers" which gets the timer's container via its ID. Once mounted, the new Stopwatch will appear in the terminal. That last line in action_add_stopwatch calls scroll_visible() which will scroll the container to make the new Stopwatch visible (if required).

The action_remove_stopwatch function calls query() with a CSS selector of "Stopwatch" which gets all the Stopwatch widgets. If there are stopwatches then the action calls last() to get the last stopwatch, and remove() to remove it.
