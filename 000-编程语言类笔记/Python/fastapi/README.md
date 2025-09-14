fastapi

```bash
pip install "fastapi[standard]"
```

启动命令

```bash
fastapi dev main.py
```

```bash
curl http://127.0.0.1:8000
```

http://127.0.0.1 就是 localhost 吗？

默认提供 /docs（SwaggerUI）和 /redoc （ReDoc）这两个API 文档界面

FastAPI会生成schema OpenAPI的标准：schema等等

---

`@app.get("/")`

Path: or called endpoint/route: last part of the URL starting from the first `/`

Operation: refers to one of the HTTP methods

Can return:

- dict
- list
- singular values as str, int, etc.
- Pydantic models
- many other will be automatically converted to JSON

---

Path Parameters

```python
@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id}
```

> 这里的decorator里面的item_id应该要和参数param的item_id对应

可以添加type annotation，fastapi会自动data validation。这个也会体现在自动生成的docs里面

```python
curl http://127.0.0.1:8000/items/1
{"item_id":1}

curl http://127.0.0.1:8000/items/foo
{"detail":[{"type":"int_parsing","loc":["path","item_id"],"msg":"Input should be a valid integer, unable to parse string as an integer","input":"foo"}]}

curl http://127.0.0.1:8000/items/4.2
{"detail":[{"type":"int_parsing","loc":["path","item_id"],"msg":"Input should be a valid integer, unable to parse string as an integer","input":"4.2"}]}
```

All the data validation 在底层都是 pydantic处理的。

这个path的定义order是比较重要的。假如`/users/me`和`/users/{user_id}`两个，必须要按照顺序。因此也不可以重复定义同样的path decorator

TODO：我感觉有点神奇，为什么不按照最大匹配长度来选择谁来处理。我记得django好像是这样的

Predefined values:

```python
from enum import Enum

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"

@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name == ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}
    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}
    return {"model_name": model_name, "message": "Have some residuals"}
```

```bash
curl http://127.0.0.1:8000/models/alexnet
{"model_name":"alexnet","message":"Deep Learning FTW!"}%

…/Desktop/temp/learn-fastapi                 3.11.11 (learn-fastapi)
❯ curl http://127.0.0.1:8000/models/resnet
{"model_name":"resnet","message":"Have some residuals"}%

…/Desktop/temp/learn-fastapi                 3.11.11 (learn-fastapi)
❯ curl http://127.0.0.1:8000/models/lenet
{"model_name":"lenet","message":"LeCNN all the images"}%

…/Desktop/temp/learn-fastapi                 3.11.11 (learn-fastapi)
❯ curl http://127.0.0.1:8000/models/others
{"detail":[{"type":"enum","loc":["path","model_name"],"msg":"Input should be 'alexnet', 'resnet' or 'lenet'","
```

Path parameters containing paths: 文件路径是api route的一部分
