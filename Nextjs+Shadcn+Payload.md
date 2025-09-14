npx create-next-app@latest
剩下的保持默认

ls -al  
total 464
drwxr-xr-x@ 15 uke staff 480 Aug 29 20:28 .
drwx------@ 74 uke staff 2368 Aug 29 20:28 ..
drwxr-xr-x@ 12 uke staff 384 Aug 29 20:28 .git
-rw-r--r--@ 1 uke staff 480 Aug 29 20:28 .gitignore
-rw-r--r--@ 1 uke staff 524 Aug 29 20:28 eslint.config.mjs
-rw-r--r--@ 1 uke staff 262 Aug 29 20:28 next-env.d.ts
-rw-r--r--@ 1 uke staff 133 Aug 29 20:28 next.config.ts
drwxr-xr-x@ 286 uke staff 9152 Aug 29 20:28 node_modules
-rw-r--r--@ 1 uke staff 203001 Aug 29 20:28 package-lock.json
-rw-r--r--@ 1 uke staff 585 Aug 29 20:28 package.json
-rw-r--r--@ 1 uke staff 81 Aug 29 20:28 postcss.config.mjs
drwxr-xr-x@ 7 uke staff 224 Aug 29 20:28 public
-rw-r--r--@ 1 uke staff 1450 Aug 29 20:28 README.md
drwxr-xr-x@ 3 uke staff 96 Aug 29 20:28 src
-rw-r--r--@ 1 uke staff 602 Aug 29 20:28 tsconfig.json

npx shadcn@latest init  
选项都是默认

操作后变成这个样子

git diff src/app/globals.css  
diff --git a/src/app/globals.css b/src/app/globals.css
index a2dc41e..dc98be7 100644
--- a/src/app/globals.css
+++ b/src/app/globals.css
@@ -1,26 +1,122 @@
@import "tailwindcss";
+@import "tw-animate-css";

-:root {

- --background: #ffffff;
- --foreground: #171717;
  -}
  +@custom-variant dark (&:is(.dark \*));

@theme inline {
--color-background: var(--background);
--color-foreground: var(--foreground);
--font-sans: var(--font-geist-sans);
--font-mono: var(--font-geist-mono);

- --color-sidebar-ring: var(--sidebar-ring);
- --color-sidebar-border: var(--sidebar-border);
- --color-sidebar-accent-foreground: var(--sidebar-acc
  ent-foreground);
- --color-sidebar-accent: var(--sidebar-accent);
- --color-sidebar-primary-foreground: var(--sidebar-pr
  imary-foreground);
- --color-sidebar-primary: var(--sidebar-primary);
- --color-sidebar-foreground: var(--sidebar-foreground
  );
- --color-sidebar: var(--sidebar);
- --color-chart-5: var(--chart-5);
- --color-chart-4: var(--chart-4);
- --color-chart-3: var(--chart-3);
- --color-chart-2: var(--chart-2);
- --color-chart-1: var(--chart-1);
- --color-ring: var(--ring);
- --color-input: var(--input);
- --color-border: var(--border);
- --color-destructive: var(--destructive);
- --color-accent-foreground: var(--accent-foreground);
- --color-accent: var(--accent);
- --color-muted-foreground: var(--muted-foreground);
- --color-muted: var(--muted);
- --color-secondary-foreground: var(--secondary-foregr
  ound);
- --color-secondary: var(--secondary);
- --color-primary-foreground: var(--primary-foreground
  );
- --color-primary: var(--primary);
- --color-popover-foreground: var(--popover-foreground
  );
- --color-popover: var(--popover);
- --color-card-foreground: var(--card-foreground);
- --color-card: var(--card);
- --radius-sm: calc(var(--radius) - 4px);
- --radius-md: calc(var(--radius) - 2px);
- --radius-lg: var(--radius);
- --radius-xl: calc(var(--radius) + 4px);
  }

-@media (prefers-color-scheme: dark) {

- :root {
- --background: #0a0a0a;
- --foreground: #ededed;
- }
  +:root {

* --radius: 0.625rem;
* --background: oklch(1 0 0);
* --foreground: oklch(0.145 0 0);
* --card: oklch(1 0 0);
* --card-foreground: oklch(0.145 0 0);
* --popover: oklch(1 0 0);
* --popover-foreground: oklch(0.145 0 0);
* --primary: oklch(0.205 0 0);
* --primary-foreground: oklch(0.985 0 0);
* --secondary: oklch(0.97 0 0);
* --secondary-foreground: oklch(0.205 0 0);
* --muted: oklch(0.97 0 0);
* --muted-foreground: oklch(0.556 0 0);
* --accent: oklch(0.97 0 0);
* --accent-foreground: oklch(0.205 0 0);
* --destructive: oklch(0.577 0.245 27.325);
* --border: oklch(0.922 0 0);
* --input: oklch(0.922 0 0);
* --ring: oklch(0.708 0 0);
* --chart-1: oklch(0.646 0.222 41.116);
* --chart-2: oklch(0.6 0.118 184.704);
* --chart-3: oklch(0.398 0.07 227.392);
* --chart-4: oklch(0.828 0.189 84.429);
* --chart-5: oklch(0.769 0.188 70.08);
* --sidebar: oklch(0.985 0 0);
* --sidebar-foreground: oklch(0.145 0 0);
* --sidebar-primary: oklch(0.205 0 0);
* --sidebar-primary-foreground: oklch(0.985 0 0);
* --sidebar-accent: oklch(0.97 0 0);
* --sidebar-accent-foreground: oklch(0.205 0 0);
* --sidebar-border: oklch(0.922 0 0);
* --sidebar-ring: oklch(0.708 0 0);
  }

-body {

- background: var(--background);
- color: var(--foreground);
- font-family: Arial, Helvetica, sans-serif;
  +.dark {

* --background: oklch(0.145 0 0);
* --foreground: oklch(0.985 0 0);
* --card: oklch(0.205 0 0);
* --card-foreground: oklch(0.985 0 0);
* --popover: oklch(0.205 0 0);
* --popover-foreground: oklch(0.985 0 0);
* --primary: oklch(0.922 0 0);
* --primary-foreground: oklch(0.205 0 0);
* --secondary: oklch(0.269 0 0);
* --secondary-foreground: oklch(0.985 0 0);
* --muted: oklch(0.269 0 0);
* --muted-foreground: oklch(0.708 0 0);
* --accent: oklch(0.269 0 0);
* --accent-foreground: oklch(0.985 0 0);
* --destructive: oklch(0.704 0.191 22.216);
* --border: oklch(1 0 0 / 10%);
* --input: oklch(1 0 0 / 15%);
* --ring: oklch(0.556 0 0);
* --chart-1: oklch(0.488 0.243 264.376);
* --chart-2: oklch(0.696 0.17 162.48);
* --chart-3: oklch(0.769 0.188 70.08);
* --chart-4: oklch(0.627 0.265 303.9);
* --chart-5: oklch(0.645 0.246 16.439);
* --sidebar: oklch(0.205 0 0);
* --sidebar-foreground: oklch(0.985 0 0);
* --sidebar-primary: oklch(0.488 0.243 264.376);
* --sidebar-primary-foreground: oklch(0.985 0 0);
* --sidebar-accent: oklch(0.269 0 0);
* --sidebar-accent-foreground: oklch(0.985 0 0);
* --sidebar-border: oklch(1 0 0 / 10%);
* --sidebar-ring: oklch(0.556 0 0);
  +}
* +@layer base {
* - {
* @apply border-border outline-ring/50;
* }
* body {
* @apply bg-background text-foreground;
* }
  }

---

然后开始添加payload的部分：
官方教程：https://payloadcms.com/docs/getting-started/installation#adding-to-an-existing-app

install the relevant package

pnpm i payload @payloadcms/next @payloadcms/richtext-lexical sharp graphql

以及ad-adapter，TODO：我感觉选择pgsql还是mongodb还是sqlite应该不影响。
pnpm i @payloadcms/db-sqlite

```bash
tree .
.
├── (frontend)
│   ├── favicon.ico
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
└── (payload)
    ├── admin
    │   ├── [[...segments]]
    │   │   ├── not-found.tsx
    │   │   └── page.tsx
    │   └── importMap.js
    ├── api
    │   ├── [...slug]
    │   │   └── route.ts
    │   ├── graphql
    │   │   └── route.ts
    │   └── graphql-playground
    │       └── route.ts
    ├── custom.scss
    └── layout.tsx

9 directories, 12 files
```

https://github.com/payloadcms/payload/blob/main/templates/blank/src/app/(payload)/

反正就是把上面的default默认文件copy过来

相应的记得要调整shadcn的components.json文件：

```
"css": "src/app/(frontend)/globals.css",
```

---

然后教程没有写，但是必须要添加一个`.env`文件：

我推荐添加一个.env.example作为模版来说明要设置哪些环境变量：

touch .env.example:

```txt
DATABASE_URI=mongodb://127.0.0.1/your-database-name
PAYLOAD_SECRET=YOUR_SECRET_HERE
```

然后在需要用到的地方：

```bash
cp .env.example .env
```

然后修改.env

同时记得修改gitignore来记录.env.example文件：

```plaintext
# env files (can opt-in for committing if needed)
.env*

+!.env.example
```

openssl rand -base64 32 来生成随机的secret放入到.env文件中：

也可以用这个在线生成：https://payloadsecret.io/

---

下面这些东西都是不在官方文档里面的
pnpm add cross-env

然后修改package.json里面的：

```json


"build": "next build --turbopack",
    "start": "next start",
    "lint": "eslint"


"scripts": {

"dev": "next dev --turbopack",

"build": "cross-env NODE_OPTIONS=\"--no-deprecation --max-old-space-size=8000\" next build --turbopack",

"start": "cross-env NODE_OPTIONS=--no-deprecation next start",

"lint": "cross-env NODE_OPTIONS=--no-deprecation eslint",

"generate:importmap": "cross-env NODE_OPTIONS=--no-deprecation payload generate:importmap",

"generate:types": "cross-env NODE_OPTIONS=--no-deprecation payload generate:types",

"payload": "cross-env NODE_OPTIONS=--no-deprecation payload"

},



```

---

假如遇到报错如下：

```bash
pnpm build

> portfolio@0.1.0 build /Users/uke/Documents/portfolio
> cross-env NODE_OPTIONS="--no-deprecation --max-old-space-size=8000" next build --turbopack

   ▲ Next.js 15.5.2 (Turbopack)
   - Experiments (use with caution):
     ⨯ reactCompiler

   Creating an optimized production build ...
 ⚠ Webpack is configured while Turbopack is not, which may cause problems.
 ⚠ See instructions if you need to configure Turbopack:
  https://nextjs.org/docs/app/api-reference/next-config-js/turbopack

 ✓ Finished writing to disk in 58ms
 ✓ Compiled successfully in 7.3s
 ✓ Linting and checking validity of types
   Collecting page data  ...Error: could not resolve "@libsql/darwin-arm64" into a module
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83443)
    at Object.module (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83500)
    at moduleContext (.next/server/chunks/[turbopack]_runtime.js:244:28)
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84187)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84204)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
    at getOrInstantiateModuleFromParent (.next/server/chunks/[turbopack]_runtime.js:725:12)
    at Context.esmImport [as i] (.next/server/chunks/[turbopack]_runtime.js:215:20)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:396:10181)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
Error: could not resolve "@libsql/darwin-arm64" into a module
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83443)
    at Object.module (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83500)
    at moduleContext (.next/server/chunks/[turbopack]_runtime.js:244:28)
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84187)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84204)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
    at getOrInstantiateModuleFromParent (.next/server/chunks/[turbopack]_runtime.js:725:12)
    at Context.esmImport [as i] (.next/server/chunks/[turbopack]_runtime.js:215:20)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:396:10181)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
Error: could not resolve "@libsql/darwin-arm64" into a module
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83443)
    at Object.module (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:83500)
    at moduleContext (.next/server/chunks/[turbopack]_runtime.js:244:28)
    at <unknown> (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84187)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:171:84204)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
    at getOrInstantiateModuleFromParent (.next/server/chunks/[turbopack]_runtime.js:725:12)
    at Context.esmImport [as i] (.next/server/chunks/[turbopack]_runtime.js:215:20)
    at __TURBOPACK__module__evaluation__ (.next/server/chunks/[root-of-the-server]__6392aa12._.js:396:10181)
    at instantiateModule (.next/server/chunks/[turbopack]_runtime.js:702:9)
```

建议关闭next build的turbopack参数

---

假如出现报错：

```text
pnpm generate:importmap

> portfolio@0.1.0 generate:importmap /Users/uke/Documents/portfolio
> cross-env NODE_OPTIONS=--no-deprecation payload generate:importmap

/Users/uke/Documents/portfolio/node_modules/.pnpm/undici@7.10.0/node_modules/undici/lib/web/fetch/webidl.js:27
  return new TypeError(`${message.header}: ${message.message}`)
         ^

TypeError: TypeError: Illegal constructor
    at webidl.errors.exception (/Users/uke/Documents/portfolio/node_modules/.pnpm/undici@7.10.0/node_modules/undici/lib/web/fetch/webidl.js:27:10)
    at webidl.illegalConstructor (/Users/uke/Documents/portfolio/node_modules/.pnpm/undici@7.10.0/node_modules/undici/lib/web/fetch/webidl.js:81:23)
    at new CacheStorage (/Users/uke/Documents/portfolio/node_modules/.pnpm/undici@7.10.0/node_modules/undici/lib/web/cache/cachestorage.js:17:14)
    at Object.<anonymous> (/Users/uke/Documents/portfolio/node_modules/.pnpm/undici@7.10.0/node_modules/undici/index.js:144:25)
    at Module._compile (node:internal/modules/cjs/loader:1358:14)
    at Object.transformer [as .js] (file:///Users/uke/Documents/portfolio/node_modules/.pnpm/tsx@4.20.3/node_modules/tsx/dist/register-CFH5oNdT.mjs:3:1009)
    at Module.load (node:internal/modules/cjs/loader:1208:32)
    at Module._load (node:internal/modules/cjs/loader:1024:12)
    at Module.require (node:internal/modules/cjs/loader:1233:19)
    at require (node:internal/modules/helpers:179:18)

Node.js v20.15.0
 ELIFECYCLE  Command failed with exit code 1.
```

应该在`package.json`里面添加：
`"type": "module",`

参考：

https://github.com/payloadcms/payload/issues/13290

https://github.com/payloadcms/payload/pull/12622
