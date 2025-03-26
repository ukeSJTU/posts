> [!note]
> 本文翻译自[How to Read an RFC](https://www.ietf.org/blog/how-read-rfc/)。原文作者是[Mark Nottingham](https://www.ietf.org/blog/author/mark-nottingham/)。

For better or worse, Requests for Comments (RFCs) are how we specify many protocols on the Internet. These documents are alternatively treated as holy texts by developers who parse them for hidden meanings, then shunned as irrelevant because they can’t be understood. This often leads to frustration and – more significantly – interoperability and security issues. However, with some insight into how they’re constructed and published, it’s a bit easier to understand what you’re looking at.

无论是好是坏，意见征求稿（RFC，Requests for Comments）是互联网上许多协议规范的制定方式。开发人员对待这些文档的态度可谓两极：一方面将其视为神圣文本，试图解读其中隐含的意义；另一方面又因其难以理解而弃之不用。这种情况常常导致挫败感，更重要的是，还会引发互操作性和安全性问题。然而，只要了解这些文档的构建和发布方式，理解它们就会变得相对容易一些。

### Here’s my take, informed from my experiences with HTTP and a few [other things](https://datatracker.ietf.org/person/Mark%20Nottingham).

### 以下是一些基于我在HTTP和[其他项目](https://datatracker.ietf.org/person/Mark%20Nottingham)方面的经验的见解。

## Where to start? 从何处着手？

The canonical place to find RFCs is the [RFC Editor Web Site](https://rfc-editor.org/). However, as we’ll see below, some key information is missing there, so most people use [tools.ietf.org](https://tools.ietf.org/).

查找RFC的权威来源是[RFC编辑机构官网](https://rfc-editor.org/)（RFC Editor Web Site）。然而，正如我们将在下文看到的，该网站缺少一些关键信息，因此大多数人会使用[tools.ietf.org](https://tools.ietf.org/)。

Even finding the right RFC can be difficult since there are so many (currently, nearly 9,000!). Obviously you can find them with general Web search engines, and the RFC Editor has an excellent search facility on their site.

由于RFC数量庞大（目前接近9,000份！），找到正确的RFC可能会有些困难。当然，您可以使用通用网络搜索引擎，而且[RFC Editor](https://rfc-editor.org/)也提供了出色的搜索功能。

Another option is [rfc.fyi](https://rfc.fyi/), which I put together to allow searching RFCs by their titles and keywords, and exploration by tags.

另一个选择是[rfc.fyi](https://rfc.fyi/)，这是我创建的网站，允许通过标题和关键词搜索RFC，并可以通过标签进行浏览。

It’s no secret that plain text RFCs are difficult to read bordering on ugly, but things are about to improve; the RFC Editor is wrapping up a [new RFC format](https://www.rfc-editor.org/rse/format-faq/), with much more pleasing presentation and the option for customisation. In the meantime, if you want more usable RFCs, you can use third-party repositories for selected ones; for example, [greenbytes](https://greenbytes.de/tech/webdav/) keeps a list of WebDAV-related RFCs, and the [HTTP Working Group](https://httpwg.org/specs/) maintains a selection of those related to HTTP.

众所周知，纯文本格式的RFC文档阅读起来较为困难，甚至可以说是不够美观，但情况即将改善；RFC编辑机构正在完成[新的RFC格式](https://www.rfc-editor.org/rse/format-faq/)，这将带来更好的展示效果和自定义选项。在此期间，如果您想要更易用的RFC文档，可以使用第三方仓库中的精选文档；例如，[greenbytes](https://greenbytes.de/tech/webdav/)维护着WebDAV相关RFC的列表，而[HTTP工作组](https://httpwg.org/specs/)（HTTP Working Group）则维护着HTTP相关规范的精选集合。

## What kind of RFC is it?

All RFCs have a banner at the top that looks something like this:

所有RFC文档的顶部都有一个类似这样的标题栏：

![RFC Banner](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_3.57.05_PM.original.png)

At the top left, this one says “Internet Engineering Task Force (IETF)”. That indicates that this is a product of the IETF; although it’s not widely known, there are other ways to publish an RFC that don’t require IETF consensus; for example, the [independent stream](https://www.rfc-editor.org/about/independent/).

在左上角，这份文档显示"互联网工程任务组（Internet Engineering Task Force，IETF）"。这表明该文档是IETF的产物；虽然不是众所周知，但还存在其他无需IETF共识的RFC发布方式，例如[独立发布渠道](https://www.rfc-editor.org/about/independent/)（independent stream）。

In fact, there are a number of “streams” that a document can be published on. **Only the IETF stream indicates that the entire IETF has reviewed and has declared consensus on a protocol’s specification**.

实际上，文档可以通过多个"发布渠道"（streams）发布。**只有IETF发布渠道才表明整个IETF已经审查并就协议规范达成共识**。

Older documents (before about RFC5705) say “Network Working Group” there, so you have to dig a bit more to find out whether they represent IETF consensus; look at the “Status of this Memo” section for a start, as well as the [RFC Editor site](https://www.rfc-editor.org/).

较早的文档（大约RFC5705之前）在此处显示"网络工作组"（Network Working Group），因此需要进一步研究才能确定它们是否代表IETF共识；可以从"备忘录状态"（Status of this Memo）部分开始查看，同时参考[RFC编辑机构网站](https://www.rfc-editor.org/)。

Under that is the “Request for Comments” number. **If it says “Internet-Draft” instead, it’s not an RFC**; it’s just a proposal, and *anyone* [can write one](https://datatracker.ietf.org/submit/). Just because something is an Internet-Draft doesn’t mean it’ll ever be adopted by the IETF.

在它下面的是"意见征求稿"（Request for Comments）编号。**如果显示为"互联网草案"（Internet-Draft），则不是RFC**；这仅仅是一个提案，*任何人*都可以[撰写](https://datatracker.ietf.org/submit/)。一个文档是互联网草案并不意味着它一定会被IETF采纳。

**Category** is one of “Standards Track”, “Informational”, “Experimental”, or “Best Current Practice”. The distinctions between these are sometimes fuzzy, but if it’s produced by the IETF (see above), it’s had a reasonable amount of review. However, note that Informational and Experimental are *not* standards, even if there’s IETF consensus to publish.

**类别**（Category）可以是"标准跟踪"（Standards Track）、"信息性"（Informational）、"实验性"（Experimental）或"最佳当前实践"（Best Current Practice）之一。这些类别之间的界限有时并不明确，但如果是由IETF制定的（见上文），就意味着经过了相当程度的审查。但需要注意的是，即使有IETF发布共识，信息性和实验性文档也*不是*标准。

Finally, the **authors** of the document are listed on the right side of the header. Unlike in academia, this is not a comprehensive list of who contributed to the document; often, that’s done near the bottom in an “Acknowledgments” section. In RFCs, this is literally “who wrote the document.” Often, you’ll see “Ed.” appended, which indicates that they were acting as an editor, often because the text was pre-existing (like when an RFC is revised).

最后，文档的**作者**（authors）列在标题栏的右侧。与学术界不同，这并非文档贡献者的完整列表；通常贡献者会在文档底部的"致谢"（Acknowledgments）部分列出。在RFC中，作者一栏严格表示"谁撰写了这份文档"。你经常会看到作者名后附加"Ed."，表示他们担任编辑角色。这通常是因为文本是预先存在的（比如RFC修订时）。

## Is it current? 如何判断RFC的时效性？

RFCs are an archival series of documents; they can’t change, even by one character (see the [diff between RFC7158 and RFC7159](https://tools.ietf.org/rfcdiff?url1=rfc7158&url2=rfc7159) for an example of this taken to the extreme; they got the year wrong ;).

RFC是一个文档存档系列，一旦发布就不能更改，即使是一个字符也不行（例如[RFC7158和RFC7159之间的对比](https://tools.ietf.org/rfcdiff?url1=rfc7158&url2=rfc7159)就展示了这一极端情况，他们错写了年份）。

As a result, it’s important to know that you’re looking at the right document. The header contains a couple of bits of metadata that help here:

因此，确保您查看的是正确文档就变得尤为重要。文档头部包含几个帮助判断的元数据：

- **Obsoletes** lists the RFCs that this document completely replaces; i.e., you should be using this document, not that one. Note that an old version of a protocol isn’t necessarily obsoleted when a newer one comes out; for example, HTTP/2 doesn’t obsolete HTTP/1.1, because it’s still legitimate (and necessary) to implement the older protocol. However, RFC7230 did obsolete RFC2616, because it’s the reference for that protocol.
- **废弃（Obsoletes）**：列出被本文档完全替代的RFC；也就是说，您应该使用本文档而不是被废弃的文档。需要注意的是，当新版本协议发布时，旧版本协议并不一定会被废弃。例如，HTTP/2并没有废弃HTTP/1.1，因为实现旧协议仍然是合法且必要的。但是，RFC7230确实废弃了RFC2616，因为它是该协议的新参考文档。
- **Updates**  lists the RFCs that this document makes substantive changes to; in other words, if you’re reading that other document, you should probably read this one too.
- **更新（Updates）**：列出被本文档实质性修改的RFC；换句话说，如果您正在阅读那些文档，您可能也需要阅读本文档。

Unfortunately, the ASCII text RFCs (e.g., at the RFC Editor site) don’t tell you what documents update or obsolete the document you’re currently looking at. This is why most people use the RFC repository at tools.ietf.org, which puts this information in a [banner like this](https://tools.ietf.org/html/rfc2616):

遗憾的是，ASCII文本格式的RFC（例如RFC编辑机构网站上的）并不会显示哪些文档更新或废弃了当前文档。这就是为什么大多数人使用tools.ietf.org上的RFC仓库，它会在[标题栏中显示这些信息](https://tools.ietf.org/html/rfc2616)：

![RFC Tools view](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_3.59.32_PM.original.png)

Each of the numbers on the tools page is a link, so you can easily find the current document.

tools网站上的每个编号都是可点击的链接，方便您找到当前文档。

**Errata** are corrections and clarifications to the document that aren’t worthy of publishing a new RFC. Sometimes they can have a substantial impact on how the RFC is implemented (for example, if a bug in the spec led to a significant misinterpretation), so they’re worth going through.

**勘误（Errata）** 是对文档的修正和说明，这些修改不足以发布新的RFC。有时勘误会对RFC的实现产生重大影响（例如，规范中的错误导致重大误解），所以值得仔细查看。

For example, here are the [errata for RFC7230](https://www.rfc-editor.org/errata_search.php?rfc=7230). When reading errata, keep their status in mind; many are rejected because someone just misread the spec.

例如，这里是[RFC7230的勘误列表](https://www.rfc-editor.org/errata_search.php?rfc=7230)。在阅读勘误时，请注意它的状态；有许多勘误被拒绝，仅仅是因为有人误读了规范。

## Understanding context 理解RFC文档的上下文

It’s more common than you might think for a developer to look at a statement in an RFC, implement what they see, and do the opposite of what the authors intended.

开发者常常会遇到这样的情况：仅看了RFC中的某个陈述就直接实现，结果与作者的本意完全相反。并且这种情况远比想象中更普遍。

This is because it’s extremely difficult to write a specification in a manner that can’t be misinterpreted when reading it selectively (as is the case with any holy text).

这是因为编写一个完全不会被误解的规范极其困难，特别是当读者选择性地阅读时（就像对待任何权威文本一样）。

As a result, it’s necessary to read not only the directly relevant text but also (at a minimum) anything that it references, whether that’s in the same spec or a different one. In a pinch, reading any potentially related sections will help immensely, if you can’t read the whole document.

因此，不仅需要阅读直接相关的文本，还需要（至少）阅读其引用的所有内容，无论这些引用位于同一规范(spec)还是其他规范中。在时间紧迫的情况下，如果无法阅读整个文档，阅读任何潜在相关的章节也会有很大帮助。

For example, HTTP message headers are [defined](https://httpwg.org/specs/rfc7230.html#http.message) to be separated by CRLF, but if you skip down [here](https://httpwg.org/specs/rfc7230.html#message.robustness), you’ll see that “a recipient MAY recognize a single LF as a line terminator and ignore any preceding CR.” Obvious, right?

举个例子：HTTP消息头被[定义](https://httpwg.org/specs/rfc7230.html#http.message)为必须用CRLF分隔，但如果你继续往下看[这部分](https://httpwg.org/specs/rfc7230.html#message.robustness)，会发现"接收方可以（MAY）将单个LF识别为行终止符，并忽略之前的CR"。这种细节如果不仔细阅读很容易忽略。

It’s also important to keep in mind that many protocols set up [IANA registries](https://www.iana.org/protocols) to manage their extension points; these, not the specifications, are the sources of truth. For example, the canonical list of HTTP methods is in [this registry](https://www.iana.org/assignments/http-methods/http-methods.xhtml), not any of the HTTP specifications.

另外一个重要的点是：许多协议都建立了[IANA注册表](https://www.iana.org/protocols)来管理其扩展点。这些注册表，而不是规范本身，才是权威来源。例如，HTTP方法的标准列表位于[这个注册表](https://www.iana.org/assignments/http-methods/http-methods.xhtml)中，而不是任何HTTP规范文档中。

## Interpreting requirements 解读规范要求

Almost all RFCs have boilerplate that looks something like this near the top:

几乎所有RFC文档(RFCs)的顶部都有类似这样的样板文本：

![RFC boilerplate terms](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.13.35_PM.original.png)

```plaintext
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all capitals, as shown here.

当且仅当这些关键词以全大写形式出现时，它们应按照BCP 14 [RFC2119] [RFC8174]中的定义进行解释：

"MUST"（必须）、"MUST NOT"（禁止）、"REQUIRED"（必需的）、"SHALL"（应当）、"SHALL NOT"（不应当）、"SHOULD"（应该）、"SHOULD NOT"（不应该）、"RECOMMENDED"（推荐）、"NOT RECOMMENDED"（不推荐）、"MAY"（可以）和"OPTIONAL"（可选）。
```

These [RFC2119](https://tools.ietf.org/html/rfc2119) keywords help define interoperability, but they also sometimes confuse developers. It’s very common to see a specification say something like:

这些[RFC2119](https://tools.ietf.org/html/rfc2119)关键词有助于定义互操作性，但有时也会使开发者感到困惑。规范中经常会出现这样的表述：

![FOO must not](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.16.33_PM.original.png)

```plaintext
The Foo message MUST NOT contain a Bar header.

Foo消息禁止包含Bar头部。
```

This requirement is placed upon a protocol artefact, the” Foo message”. If you’re sending one, it’s pretty clear it needs to not contain a Bar header; if you include one, it won’t be a conformant message.

这个要求是针对协议构件(protocol artefact)"Foo消息"而言的。如果你要发送这样的消息，很明显不能包含Bar头部；如果包含了，这个消息就不符合规范。

However, the behaviour of the recipient is much less clear; if you see a Foo message with a Bar header, what do you do?

然而，接收方的行为就不那么明确了；如果收到一个包含Bar头部的Foo消息，应该怎么处理？

Some developers will reject a message that contains it, even though the specification says nothing about doing so. Others will still process the message, but strip the Bar header, or ignore it – even when the spec explicitly says that all headers need to be processed.

一些开发者会拒绝包含该头部的消息，尽管规范并未要求这样做。其他人则会继续处理消息，但会删除或忽略Bar头部——即使规范明确要求处理所有头部。

All of these things can – unintentionally – cause interoperability issues. The correct thing to do is to follow normal processing for the header unless there’s a specific requirement to the contrary.

所有这些行为都可能无意中造成互操作性问题。正确的做法是按照正常流程处理头部，除非有特定要求明确禁止这样做。

That’s because in general, specifications are written so that behaviours are overtly specified; in other words, everything that is not explicitly disallowed is allowed. Therefore, reading too much into specifications can unintentionally cause harm, since you’ll be introducing new behaviours that others will have to work around.

这是因为通常规范的编写原则是明确指定行为；换句话说，任何未被明确禁止的内容都是允许的。因此，过度解读规范可能会无意中造成危害，因为你会引入其他人必须绕过的新行为。

In an ideal world, the specification would be defined in terms of the behaviours of those who handle the message, like this:

在理想情况下，规范应该根据消息处理者的行为来定义，如下所示：

![FOO must not example](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.17.39_PM.original.png)

```plaintext
Senders of the Foo message MUST NOT include a Bar header. Recipients of a Foo message that includes a Bar header MUST ignore the Bar header, but MUST NOT remove it.

Foo消息的发送者禁止包含Bar头部。Foo消息的接收者必须忽略其中包含的Bar头部，但禁止删除该头部。
```

Absent that, it’s best to look for more general advice about error handling elsewhere in the specification (e.g., HTTP’s [Conformance and Error Handling](https://httpwg.org/specs/rfc7230.html#conformance) section).

如果没有这样的明确说明，最好在规范的其他部分寻找更一般的错误处理建议（例如，HTTP规范中的[一致性和错误处理](https://httpwg.org/specs/rfc7230.html#conformance)章节）。

Also, keep in mind the *target* of requirements; most specifications have a highly developed set of terms that they use to distinguish between different roles in the protocol.

同时，要注意要求的适用对象；大多数规范都有一套完善的术语体系，用于区分协议中的不同角色。

For example, HTTP has [proxies](https://httpwg.org/specs/rfc7230.html#intermediaries), which are a kind of intermediary, which implement both a client and a server (but not a User-Agent or an origin server); they need to pay attention to requirements targeted at all of those roles.

例如，HTTP有代理(proxies)，这是一种中间件(intermediary)，同时实现了客户端和服务器的功能（但不是用户代理或源服务器）；它们需要注意针对所有这些角色的要求。

Likewise, HTTP distinguishes between “generating” a message and merely “forwarding” it in some requirements, depending on the specific situation. Paying attention to this kind of specific terminology can save you a lot of guesswork.

同样，HTTP在某些要求中区分"生成"消息和仅仅"转发"消息，具体取决于特定情况。注意这类特定术语可以帮助你避免很多猜测工作。

## SHOULD SHOULD（应该）

Yep, SHOULD deserves its own section. This wishy-washy term plagues many RFCs, despite efforts to eradicate it. RFC2119 describes it as:

尽管已经有努力试图消除它，"SHOULD"这个含糊的术语仍然困扰着许多RFC文档。RFC2119对其描述如下：

![RECOMMENDED](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.19.00_PM.original.png)

```plaintext
SHOULD This word, or the adjective "RECOMMENDED", mean that there may exist valid reasons in particular circumstancces to ignore a particular item, but the full implication must be understood and carefully weighed before choosing a different course.

SHOULD（应该）这个词，或形容词"RECOMMENDED"（推荐），表示在特定情况下可能存在忽略某个特定项目的正当理由，但在选择不同做法之前，必须充分理解并仔细权衡其全部含义。
```

In practice, authors often use SHOULD and SHOULD NOT to mean “We’d like you to do this, but we know we can’t always require it.”

实际上，作者们经常使用SHOULD和SHOULD NOT来表达"我们希望你这样做，但我们知道不能总是强制要求"这样的意思。

For example, in the [overview of HTTP methods](https://httpwg.org/specs/rfc7231.html#method.overview), we see:

例如，在[HTTP方法概述](https://httpwg.org/specs/rfc7231.html#method.overview)中，我们看到：

![Should example 1](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.11.30_PM.original.png)

```plaintext
When a request method is received that is unrecognized or not implemented by an origin server, the origin server SHOULD respond with the 501 (Not Implemented) status code. When a request method is received that is known by an origin server but not allowed for the target resource, the origin server SHOULD respond with the 405 (Method Not Allowed) status code.

当源服务器收到无法识别或未实现的请求方法时，应该响应501（未实现）状态码。当源服务器收到已知但目标资源不允许使用的请求方法时，应该响应405（方法不允许）状态码。
```

These SHOULDs are not MUSTs because the server might reasonably decide to take another action; if the request is from a client that is believed to be an attacker, it might drop the connection, or if HTTP authentication is required for the resource, it might enforce that with a 401 (Not Authenticated) before getting to the 405.

这些"SHOULD"之所以不是"MUST"，是因为服务器可能会合理地决定采取其他行动；如果请求来自被认为是攻击者的客户端，服务器可能会直接断开连接，或者如果资源需要HTTP认证，服务器可能会在返回405之前先用401（未认证）来执行认证。

SHOULD *doesn’t* mean that the server is free to ignore a requirement because it doesn’t feel like honouring it.

SHOULD并*不*意味着服务器可以因为不愿意遵守某个要求就随意忽略它。

Sometimes, we [see](https://httpwg.org/specs/rfc7231.html#multipart.types) a SHOULD that follows this form:

有时，我们会[看到](https://httpwg.org/specs/rfc7231.html#multipart.types)这样形式的SHOULD：

![Should example 2](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.07.21_PM.original.png)

```plaintext
A sender that generates a message containing a payload body SHOULD generate a Content-Type header field in that message unless the intended media type of the enclosed representation is unknown to the sender.

生成包含负载主体的消息的发送者应该在该消息中生成Content-Type头部字段，除非发送者不知道所包含表示的预期媒体类型。
```

Notice the “unless” – it’s specifying the “particular circumstances” that the SHOULD allows. Arguably this could be specified as a MUST, since the unless clause would still apply, but this style of specification is somewhat common.

注意这里的"除非"——它明确指出了SHOULD允许的"特定情况"。可以说这本可以被规定为MUST，因为"除非"条款仍然适用，但这种规范写法在某种程度上比较常见。

## Reading examples 阅读示例

Another very common pitfall is to skim the specification for examples, and implement what they do.

另一个常见的陷阱是仅浏览规范说明书(specification)中的示例，并基于这些示例进行实现。

Unfortunately, examples typically get the least amount of attention from authors, since they need to be updated with each change to the protocol.

遗憾的是，示例通常得到作者最少的关注，因为它们需要随着协议的每次变更而更新。

As a result, they’re very often the least reliable parts of the spec. Yes, the authors should absolutely double-check the examples before publication, but errors do slip through.

因此，示例往往是规范说明书中最不可靠的部分。诚然，作者在发布前应当仔细检查示例，但错误仍可能出现。

Also, even a perfect example might not be intended to illustrate the aspect of the protocol you’re looking for; they’re often truncated for brevity, or shown after an decoding step takes place.

此外，即使是完美的示例也可能并非用于说明您所关注的协议特性；它们通常为了简洁而被截断，或者展示的是解码步骤之后的结果。

Even though it takes more time, it’s better to read the actual text; examples are not the specification.

尽管需要更多时间，但阅读实际的说明文本更为可靠；示例并不等同于规范说明书本身。

## On ABNF 关于ABNF

[Augmented BNF](https://tools.ietf.org/html/rfc5234) is often used to define protocol artefacts. For example:

[增强型巴科斯范式](https://tools.ietf.org/html/rfc5234)(Augmented BNF)常用于定义协议构件。例如：

![Augmented BNF](https://www.ietf.org/media/images/Screen_Shot_2018-09-06_at_4.02.37_PM.original.png)

```plaintext
FooHeader = 1#foo
foo       = 1*9DIGIT [ ";" "bar" ]
```

Once you get used to it, ABNF offers an easy-to-understand sketch of what protocol elements should look like.

一旦熟悉后，ABNF能够简明地展示协议元素应有的结构。

However, ABNF is “aspirational” - it identifies an ideal form for a message, and those messages that you generate really need to match it. It doesn’t specify what to do with received messages that fail to match it. In fact, many specifications fail to say what the relationship of ABNF is to processing requirements *at all*.

然而，ABNF是"理想化的"——它定义了消息的理想形式，您生成的消息确实需要符合这种形式。但它并未指定如何处理不符合规范的接收消息。事实上，许多规范说明书*完全没有*说明ABNF与处理要求之间的关系。

Most protocols will fail badly if you try to enforce their ABNF strictly, but sometimes it matters. In the example above, whitespace isn’t allowed around the semicolon, but you can bet that some people will put it there, and some implementations will accept it.

如果严格执行ABNF规则，大多数协议都会出现严重故障，但在某些情况下这确实很重要。在上述示例中，分号周围不允许有空格，但可以预见某些开发者会在那里添加空格，而某些实现也会接受这种情况。

So, make sure you read the text around the ABNF for additional requirements or context, and realise that absent a direct requirement, you may have to adjust parsing to be more accepting of input than the ABNF implies.

因此，请务必阅读ABNF周边的说明文本以了解额外要求或上下文，并认识到在没有明确要求的情况下，可能需要调整解析器，使其比ABNF所蕴含的更能接受各种输入。

Some specifications are starting to acknowledge the aspirational nature of ABNF and specifying explicit parsing algorithms that incorporate error handling. When specified, these should be followed exactly, to ensure interoperability.

一些规范说明书开始认可ABNF的理想化特性，并开始明确指定包含错误处理的解析算法。当这些算法被明确指定时，应当严格遵循，以确保互操作性。

## Security considerations 安全性考虑

Ever since [RFC3552](https://tools.ietf.org/html/rfc3552), the RFC boilerplate has included a “Security Considerations” section.

自[RFC3552](https://tools.ietf.org/html/rfc3552)以来，RFC模板中都包含了"安全性考虑"章节。

As a result, it’s rare for an RFC to be published without a substantial section on security; the review process does not allow a draft to just say “There are no security considerations for this protocol”.

因此，RFC很少会在没有实质性安全章节的情况下发布；审查过程不允许草案仅简单声明"本协议没有安全性考虑"。

So, it pays to read and make sure you understand the Security Considerations section, whether you’re implementing or deploying the protocol; if you don’t, it’s very likely that something will bite you down the road.

无论是实现还是部署协议，都有必要仔细阅读并理解安全性考虑章节；如果忽视这一点，很可能在未来遇到问题。

Following its references (if any) is also a good idea. If there aren’t any, try looking up some of the terms used to get an appreciation of the issues being discussed.

建议同时参考其引用文献（如果有的话）。如果没有引用文献，可以查找文中使用的相关术语，以更好地理解所讨论的问题。

## Finding out more 获取更多信息

If an RFC doesn’t answer your question, or you’re not sure about the intent of its text, the best thing to do is to find the most relevant [Working Group](https://datatracker.ietf.org/wg/) and ask a question on their mailing list. If there isn’t an active working group covering the topic in question, try the mailing list for the appropriate [area](https://ietf.org/topics/areas/).

如果RFC文档未能解答您的疑问，或者您对文本的含义不太确定，最好的办法是找到最相关的[工作组](https://datatracker.ietf.org/wg/)并在他们的邮件列表中提问。如果没有活跃的工作组负责相关主题，可以尝试在相应[领域](https://ietf.org/topics/areas/)的邮件列表中提问。

Filing an errata is usually not the first step you should take – talk to someone first.

提交勘误通常不应该是您的第一步选择 - 最好先与相关人员沟通交流。

Many Working Groups are now using Github for managing their specifications; if you have a question about an active specification, go ahead and file an issue. If it’s already an RFC, it’s usually best to use the mailing list unless you find directions to the contrary.

目前许多工作组正在使用Github管理他们的规范说明书。如果您对某个正在制定中的规范有疑问，可以直接提交issue。如果涉及已发布的RFC，除非有特别说明，否则最好使用邮件列表进行交流。

I’m sure there’s more to write about how to read RFCs, and some will dispute what I’ve written here, but this is how I think about them. I hope it was useful.

关于如何阅读RFC还有很多可以讨论的内容，也可能有人会对本文的观点持有不同意见，但这是我个人的理解方式。希望这些内容对您有所帮助。

#### This post originally appeared on [mnot's blog](https://www.mnot.net/blog/2018/07/31/read_rfc). It is reposted here with permission.

#### 本文最初发表于[mnot的博客](https://www.mnot.net/blog/2018/07/31/read_rfc)，经授权转载。
