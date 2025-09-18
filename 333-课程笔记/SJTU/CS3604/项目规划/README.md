React/Nextjs来做前端，我觉得国外用的比较多，claude这一类AI比较擅长。pnpm包管理器，prettier做linter。

FastAPI(python)来做后端。uv做包管理器，ruff管理格式。现在就是ORM还没想好用什么。

先用sqlite做数据库，中期替换成postgresql。

github同步代码库，目前考虑前后端分成两个代码库，除非用nextjs做全栈。前期在这个notion平台上共享文档，后期用Github Issues添加/追踪新的功能。Github Actions来PR merge前运行测试。

docker-compose部署。

prometheus 搭配 grafana 做监控+可视化。

locust对后端API进行压力测试。
