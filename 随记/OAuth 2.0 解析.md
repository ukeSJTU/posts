RFC 6749 取代替换了 OAuth1.0标准 RFC5849。

The OAuth 2.0 authorization framework enables a third-party
application to obtain limited access to an HTTP service, either on
behalf of a resource owner by orchestrating an approval interaction
between the resource owner and the HTTP service, or by allowing the
third-party application to obtain access on its own behalf. This
specification replaces and obsoletes the OAuth 1.0 protocol described
in [RFC 5849](https://datatracker.ietf.org/doc/html/rfc5849).

TODO：什么是 RFC？

# 1. Introduction

先分析了传统的C-S验证模型中的会带来的各种问题：

- 第三方应用程序需要存储资源拥有者的凭据，很多情况下是明文存储的密码；
- server 必须要支持密码验证方式，但是密码很多情况下有安全隐患；
- 第三方应用程序权限过大，资源拥有者很难限制它可以访问的范围；
- 资源拥有者无法撤销给单独的某个第三方程序，除非修改第三方密码，但这会导致撤销所有的授权；
- 任何第三方应用程序的泄露都会导致最终用户的密码以及受该密码保护的所有数据的泄露。

OAuth2.0 提出的解决办法是在Client和Resource owner之间加一层验证层authentication layer来分隔它们俩。C如果想要访问资源（这个资源由resource owner控制，由resource server托管），需要获得一个访问令牌（access token），这个令牌是要经资源所有者批准后，授权服务器将访问令牌颁发给第三方客户端的。TODO 上面的文本需要调整表述，尤其是一些英文单词调整格式，统一比表述。

在RFC中，有这样的一个例子：

最终用户（资源所有者）可以授予打印服务（客户端）访问存储在照片共享服务（资源服务器）中的受保护照片的权限，而无需与打印服务共享其用户名和密码。相反，她直接使用照片共享服务（授权服务器）信任的服务器进行身份验证，该服务器将颁发打印服务特定于授权的凭据（访问令牌）。

OAuth2.0 的设计是用于HTTP（RFC2616）。OAuth2.0 并不兼容 OAuth1.0（RFC5849）。TODO：补充RFC文件的官方链接。

TODO：读到这里的读者很有可能不理解这些名词（Resource Owner， Client）具体什么意思，应当添加适当的提示，表明将会在下面的1.1节进行定义与解释。

## 1.1 Roles

OAuth2.0 中有下面四个关键的角色：

- Resource Owner 资源所有者：能够授予对受保护资源的访问权限的实体。当资源所有者是个人时，它被称为最终用户end-user。
- Resource Server 资源服务器：托管受保护资源的服务器，能够使用访问令牌接受和响应受保护资源请求。
- Client 客户端：代表资源所有者及其授权发出受保护资源请求的应用程序。TODO 下面这句话的表述有点费解，可以完善一下：术语“客户端”并不意味着任何特定的实现特征（例如，应用程序是否在服务器、桌面或其他设备上执行）。
- Authorization Server 授权服务器：成功验证资源所有者并获得授权后向客户端颁发访问令牌的服务器。

> 注意：Authorization Server 和 Resource Server可以是不同的服务器也有可能就是同一台服务器。单个授权服务器可以发出多个资源服务器接受的访问令牌。

TODO：我觉得这些名词概念有一点抽象，可以更加具体的一个例子，我还没有完全确定这个例子是不是正确的。我现在想到的是：用户A访问一个网站W，网站W提供Github的OAuth登陆方式，登陆后网站W上自动显示用户A的Github账户名以及头像作为A在网站W上的账户名和头像。那么在这个过程中：网站W就是Client，用户A就是Resource Owner（end-user），Resouce Server和Authorization Server在这里都是Github提供的服务器，至于是否是同一台物理机器我们并不关心。如果这个例子合适的话后续我们都应该用这个例子来辅助解释。如果不合适的话进行修改，不要忘了后面的文章内容也需要调整。

## 1.2 Protocol Flow

下面直接复制了RFC里面的ascii图像：

```plaintext
     +--------+                               +---------------+
     |        |--(A)- Authorization Request ->|   Resource    |
     |        |                               |     Owner     |
     |        |<-(B)-- Authorization Grant ---|               |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(C)-- Authorization Grant -->| Authorization |
     | Client |                               |     Server    |
     |        |<-(D)----- Access Token -------|               |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(E)----- Access Token ------>|    Resource   |
     |        |                               |     Server    |
     |        |<-(F)--- Protected Resource ---|               |
     +--------+                               +---------------+

                     Figure 1: Abstract Protocol Flow
```

简单来说，OAuth的验证流程如下：TODO 下面这个ABCD的格式有待调整

- A. Client客户端会向Resource Owner资源拥有者请求授权。用户A点击网页W上的登录sign-in按钮，页面跳转到一个Github页面，现实的内容大致是用户A的Github账号信息以及询问是否同意授权某某信息内容给网页W。
- B. Client客户端接收授权Authorization Grant。OAuth总共有四种授予类型（TODO 补充到后面具体授予类型内容的链接），具体类型取决于客户端用于请求授权的方法以及授权服务器支持的类型。用户A在刚刚弹出的页面上点击“授予权限”的按钮，Github根据设置的授予类型向网页W表明用户A已经授权（TODO不太确定是不是这样）。
- C. Client客户端通过与Authorization Server授权服务器进行身份验证并提供授权授予Authorization Grant来请求访问令牌Access Token。网页W利用刚刚步骤B中获得的授权，向Github的授权服务器发送验证并获得访问令牌。
- D. 授权服务器对客户端进行身份验证并验证授权授予，如果有效，则发出访问令牌。Github返回一个access token给网页W
- E. 客户端从资源服务器请求受保护的资源，并通过提供访问令牌进行身份验证。网页W利用token向github请求用户A的用户名和头像。
- F.  资源服务器验证访问令牌，如果有效，则为请求提供服务。github的资源服务器验证token有效性。如果有效就返回用户A的用户名和头像，至此网页W就可以显示A的用户名和头像了。

TODO： 上面的格式有待调整。Authorization Grant的翻译有待商榷。

## 1.3 Authorization Grant

Grant就是一个 (Credential) 凭据，表明用户A已经授权客户端网页W可以获得访问令牌access token来访问受保护的资源（用户A在github上面的用户名和头像）。本RFC规定了四种grant类型：authorization code，implicit，resource owner password credentials 和 client credential，以及定义额外grant类型拓展机制。

TODO 这里四种grant类型的翻译需要和后面保持一致，目前参考了阮一峰的教程：授权码，隐藏式，密码式和客户端凭证。

下面小章节是概括性的解释每种 grant 方式，更进一步的、详细的解释需要看第四章。TODO 补充链接。

TODO：也许可以用表格的形式横向对比四种方式。

### 1.3.1 Authorization Code

### 1.3.2 Implicit

### 1.3.3 Resource Owner Password Credentials

### 1.3.4 Client Credentials

## 1.4 Access Token

Access Token访问令牌是用来访问受保护资源的凭据。它本质上就是一个字符串，表明了访问的范围以及持续时间等等信息，由资源所有者授予，并由资源服务器和授权服务器强制执行。TODO：修改表述。

根据资源服务器安全要求，访问令牌可以具有不同的格式、结构和使用方法（例如，加密属性）。访问令牌属性和用于访问受保护资源的方法超出了本规范的范围，并由相关规范（如[RFC6750]）定义。TODO：补充链接

## 1.5 Refresh Token

刷新令牌是用于获取访问令牌的凭据。刷新令牌由授权服务器颁发给客户端，用于在当前访问令牌无效或过期时获取新的访问令牌。具体内容请参考RFC原文。由授权服务器决定是否发布刷新令牌是可选的。如果授权服务器发出刷新令牌，则在发出访问令牌时会包括该令牌（即图1中的步骤（D））。TODO：修改表述以及必要的链接。

```plaintext
  +--------+                                           +---------------+
  |        |--(A)------- Authorization Grant --------->|               |
  |        |                                           |               |
  |        |<-(B)----------- Access Token -------------|               |
  |        |               & Refresh Token             |               |
  |        |                                           |               |
  |        |                            +----------+   |               |
  |        |--(C)---- Access Token ---->|          |   |               |
  |        |                            |          |   |               |
  |        |<-(D)- Protected Resource --| Resource |   | Authorization |
  | Client |                            |  Server  |   |     Server    |
  |        |--(E)---- Access Token ---->|          |   |               |
  |        |                            |          |   |               |
  |        |<-(F)- Invalid Token Error -|          |   |               |
  |        |                            +----------+   |               |
  |        |                                           |               |
  |        |--(G)----------- Refresh Token ----------->|               |
  |        |                                           |               |
  |        |<-(H)----------- Access Token -------------|               |
  +--------+           & Optional Refresh Token        +---------------+

               Figure 2: Refreshing an Expired Access Token
```

在1.2节的基础上多了G、H这两个步骤：

客户端向授权服务器发送Refresh Token，如果验证成功，授权服务器会返回新的Access Token已经新的（可选的）Refresh Token。

TODO: 下面的1.6-1.9我认为都不是很重要，故省略。

## 1.6 TLS Version

## 1.7 HTTP Redirections

## 1.8 Interoperability

## 1.9 Notational Conventions

# 2. Client Registration

# 4. Obtaining Authorization

客户端在申请Access Token之前，必须要先获得的resource owner的授权，也就是authorization grant。我们前面（TODO：补充到 1.3 节的链接）。

## 4.1 Authorization Code Grant
