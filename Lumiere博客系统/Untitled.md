本系列教程是我针对Lumiere博客系统的一个同步教程，我想要在我开发这个博客系统的过程中同时整理一份学习笔记，这样方便任何人入门相关的技术，并且不局限于最基础的那一部分，而是更深入，如何优化，为什么这么做，以及工程化的各种注意事项。

开始学习前你需要知道：？

技术栈：这里我只写最重要的几个框架或者库，其他的小一点的我会在用到的时候再介绍。

Nextjs，在我开发的时候nextjs已经推出了15.0.3版本，为了保证教程的实时性，我决定采用这个版本，但其实并没有用到很多新特性，你完全可以采用nextjs@14来完成本教程，除非我明确提及版本兼容的问题。在最一开始开发的过程中我们会用Netxjs作为全栈框架并且app router模式，当然我们也启用typescript等等：

```bash
npx create-next-app@15.0.3 ??? TODO 补全选项设置
```

关系型数据库采用 `postgresql`：

TODO: 安装教程

创建数据库：

```shell
createdb lumiere
```

察看数据库：TODO 有待补充内容

```shell
psql

\l
```

ORM层采用`prisma`。

用户验证/登录采用next-auth：值得注意的是，在我写这段文字的时候，next-auth正处于从v4升级成v5的过程中，实际上你也可以从下面的安装命令中看出这一点：

```shell
pnpm install next-auth@beta
```

同样是为了教程能够更长时间有效，我决定采用next-auth v5，如果后续很多api不兼容我会再来更新相关的内容。

ui方面采用`shadcn-ui`

让我们开始吧。

# 用户管理 user-management

如上所述，我们用到了next-auth同时还要在数据库中存储我们的用户数据。

先prisma init

authjs提供以下四种方式来登录：

There are 4 ways to authenticate users with Auth.js:

- [OAuth authentication](https://authjs.dev/getting-started/authentication/oauth) (_Sign in with Google, GitHub, LinkedIn, etc…_)
- [Magic Links](https://authjs.dev/getting-started/authentication/email) (_Email Provider like Forward Email, Resend, Sendgrid, Nodemailer etc…_)
- [Credentials](https://authjs.dev/getting-started/authentication/credentials) (_Username and Password, Integrating with external APIs, etc…_)
- [WebAuthn](https://authjs.dev/getting-started/authentication/webauthn) (_Passkeys, etc…_)

我们的教程会在OAuth里实现3个：github，google，apple；然后用Resend（TODO也许会换一个）实现Magic links，最后实现Credentials（虽然不太安全）。

如果你不清楚这分别是什么：

1. OAuth通过第三方的授权登录，也就是常见用Google账号登录
2. Magic Links提供邮箱，注册后自动发送邮件到邮箱，点击邮件中的链接就完成登录了
3. Credentials就是最常见的邮箱+密码的组合方式
4. WebAuthn： TODO解释passkey是什么

关于OAuth2.0的更多[原理解释](https://juejin.cn/post/7010636081305485319)

注册一个github oauth app：获取相应的id和secret，并新建一个.env.development
