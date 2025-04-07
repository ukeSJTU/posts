# Parameters

TODO: 下面的核心意思就是 click 里面，parameters 可以分成 2 种。一个是 options，一个是 arguments。我们后续会分别深入这两个内容，但是本文是从更高的角度来介绍这两个概念。我觉得可能需要和 argparse 比较一下。

Click supports only two types of parameters for scripts (by design): options and arguments.

Options
Are optional.

Recommended to use for everything except subcommands, urls, or files.

Can take a fixed number of arguments. The default is 1. They may be specified multiple times using Multiple Options.

Are fully documented by the help page.

Have automatic prompting for missing input.

Can act as flags (boolean or otherwise).

Can be pulled from environment variables.

Arguments
Are optional with in reason, but not entirely so.

Recommended to use for subcommands, urls, or files.

Can take an arbitrary number of arguments.

Are not fully documented by the help page since they may be too specific to be automatically documented. For more see Documenting Arguments.

Can be pulled from environment variables but only explicitly named ones. For more see Environment Variables.

Parameters (options and arguments) have a name that will be used as the Python argument name when calling the decorated function with values.

In the above example the argument’s name is filename. The name must match the python arg name. To provide a different name for use in help text, see Truncating Help Texts. The option’s names are -t and --times. More names are available for options and are covered in Options.

## Param Type

原生支持：

str / click.STRING:
The default parameter type which indicates unicode strings.

int / click.INT:
A parameter that only accepts integers.

float / click.FLOAT:
A parameter that only accepts floating point values.

bool / click.BOOL:
A parameter that accepts boolean values. This is automatically used for boolean flags. The string values “1”, “true”, “t”, “yes”, “y”, and “on” convert to True. “0”, “false”, “f”, “no”, “n”, and “off” convert to False.

click.UUID:
A parameter that accepts UUID values. This is not automatically guessed but represented as uuid.UUID.

class click.File(mode='r', encoding=None, errors='strict', lazy=None, atomic=False)
Declares a parameter to be a file for reading or writing. The file is automatically closed once the context tears down (after the command finished working).

Files can be opened for reading or writing. The special value - indicates stdin or stdout depending on the mode.

By default, the file is opened for reading text data, but it can also be opened in binary mode or for writing. The encoding parameter can be used to force a specific encoding.

The lazy flag controls if the file should be opened immediately or upon first IO. The default is to be non-lazy for standard input and output streams as well as files opened for reading, lazy otherwise. When opening a file lazily for reading, it is still opened temporarily for validation, but will not be held open until first IO. lazy is mainly useful when opening for writing to avoid creating the file until it is needed.

Files can also be opened atomically in which case all writes go into a separate file in the same folder and upon completion the file will be moved over to the original location. This is useful if a file regularly read by other users is modified.

class click.Path(exists=False, file_okay=True, dir_okay=True, writable=False, readable=True, resolve_path=False, allow_dash=False, path_type=None, executable=False)
The Path type is similar to the File type, but returns the filename instead of an open file. Various checks can be enabled to validate the type of file and permissions.

class click.Choice(choices, case_sensitive=True)
The choice type allows a value to be checked against a fixed set of supported values. All of these values have to be strings.

You should only pass a list or tuple of choices. Other iterables (like generators) may lead to surprising results.

The resulting value will always be one of the originally passed choices regardless of case_sensitive or any ctx.token_normalize_func being specified.

class click.IntRange(min=None, max=None, min_open=False, max_open=False, clamp=False)
Restrict an click.INT value to a range of accepted values. See Range Options.

If min or max are not passed, any value is accepted in that direction. If min_open or max_open are enabled, the corresponding boundary is not included in the range.

If clamp is enabled, a value outside the range is clamped to the boundary instead of failing.

class click.FloatRange(min=None, max=None, min_open=False, max_open=False, clamp=False)
Restrict a click.FLOAT value to a range of accepted values. See Range Options.

If min or max are not passed, any value is accepted in that direction. If min_open or max_open are enabled, the corresponding boundary is not included in the range.

If clamp is enabled, a value outside the range is clamped to the boundary instead of failing. This is not supported if either boundary is marked open.

class click.DateTime(formats=None)
The DateTime type converts date strings into datetime objects.

The format strings which are checked are configurable, but default to some common (non-timezone aware) ISO 8601 formats.

When specifying DateTime formats, you should only pass a list or a tuple. Other iterables, like generators, may lead to surprising results.

The format strings are processed using datetime.strptime, and this consequently defines the format strings which are allowed.

Parsing is tried using each format, in order, and the first format which parses successfully is used.

TODO：上面的调整成表格格式。

### 还可以实现自定义 Types

TODO：有待补充

## 下一步

TODO：后续让我们深入 [[options]] 和 [[arguments]] 的用法。
