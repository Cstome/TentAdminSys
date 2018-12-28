# Tent Admin System

## 概述

Tent Admin System 基础后台管理系统采用前后端完全分离的形式，由前端 [Tent Admin](https://github.com/Cstome/tent-admin) 及后端 [Tent API System](https://github.com/Cstome/tentsys) 组成。

查看 [Demo](http://tent.demo.tentpay.com/admin/) 用户名：demo 密码：demo

### 前端  Tent Admin

[Tent Admin](https://github.com/Cstome/tent-admin) 使用Vue全栈（Vue，Vuex，Vue-router）作为MVVM基本框架，UI基于 [AdminLTE](https://github.com/almasaeed2010/AdminLTE) 3（由于直接引入 AdminLTE 3 的css，因此也直接包含了Bootstrap 4），[Element UI](https://element.eleme.io/) 作为组件库，[axios](https://github.com/axios/axios) 作为请求库，同时还引入了 [fontawesome](https://fontawesome.com/) 5 以及 [animate.css](https://github.com/daneden/animate.css).

AdminLTE 是一个优秀的前端后台框架，TentAdmin 可以看做是 AdminLTE 基于 Vue 的实现，前端开发者可以直接将 AdminLTE 的 HTML 结构在 TentAdmin 中得以应用。TentAdmin 使用 element ui 作为前端组件库，但仅建议使用复杂组件，像button之类的HTML自带标签，建议使用原生HTML写法并用class去定义样式。

TentAdmin 实现了以下页面：

- 登录页
- NavBar 导航栏
- 侧边菜单（编辑，授权）
- 个人Profile
- 用户列表
- 用户组列表
- 后端API授权（需Tent API System后端支持）
- 通用列表页（分页，搜索）
- TentAdmin 支持响应式

### 后端 Tent API System

TentAPI 是一套基于 ThinkPHP 开发的 RESTful 风格的 API 基础系统。

系统实现了以下功能：

- RESTful 风格 API 实现
- 使用access token 鉴权
- 基于用户组的权限控制（GBAC）
- 快速创建资源管理器
- API 附加调试信息

## 如何部署

TentAdmin 与 Tent API System 可以分别独立运作，但 TentAdmin 暂不自带 mock API， 因此最简单的方法就是同时部署  Tent API System 作为 TentAdmin 的后台支持。

当然，也可以参照 *[API 文档](TentSYS_API_DOC.md)*，并将 TentAdmin 对接到自己的API后端系统。

### Tent API System 后端

#### 系统要求

- PHP >= 5.6.0
- PHP Composer installed
- PDO PHP Extension
- MBstring PHP Extension
- MySQL >= 5.6

#### 部署流程

1. 将 [tentsys.sql](tentsys.sql) 导入到数据库；

2. Clone  [Tent API System](https://github.com/Cstome/tentsys) & Install Dependencies

   ```sh
   # clone project
   $ git clone https://github.com/Cstome/tentsys.git
   
   # install dependencies
   $ cd tentsys/
   $ composer install
   ```

3. 配置数据库连接

   将 `tentsys/config/api/database.php` 中的数据库配置信息改成实际连接信息。

4. 启动项目

   使用PHP自带HTTP服务器并指定 `./public/` 为根目录：

   ```sh
   $ php -S 0.0.0.0:80 -t ./public
   ```

此时访问 `127.0.0.1` 返回JSON：

```json
{
	"name": "TentSYS",
	"version": "3.0.2",
	"desc": "Powerful REST API system."
}
```

说明 Tent API System 后台已部署完成。

### TentAdmin 前端

#### 部署流程

1. Clone & Install Dependencies

   ```sh
   # clone project
   $ git clone https://github.com/Cstome/tent-admin.git
   
   # install dependencies
   $ npm install
   
   # serve with hot reload at localhost:2122
   $ npm run dev
   ```

2. 此时访问 `localhost:2122` 即可使用 TentAdmin.

### 注意事项

1. TentAdmin 在开发环境中已经配置了 API 代理，将所有`localhost:2122/api` 代理到 `localhost/api` （即Tent API System 后端），如果相关地址有所改动，请按需修改。在生产环境中，api访问指向前端路径的 /api/ 下，即 `{host}/api/` ，此处也可以按实际情况修改。
2. TentAdmin 默认开启HTML 5 History 方法的路由，且默认根地址为 `{host}/admin`.

### 生产环境部署

**后端** - 配置HTTP服务器将 `public` 文件夹设置为根目录，并配置URL的伪静态访问，可参考 ThinkPHP 文档：[URL访问](https://www.kancloud.cn/manual/thinkphp5_1/353955)

**前端** - 执行 `npm run build` 后将打包后的文件放到 `{tentsys}/public/admin` 是最简单的方法，如果修改了 `assetsPublicPath` 则路径需要对应修改。由于默认开启了 history 模式的 router，因此需参考 [HTML5 History 模式](https://router.vuejs.org/zh/guide/essentials/history-mode.html) 进行伪静态设置。

## 待完成

### 后端

- Oauth模块 - 该模块只完成了简单的基于密码生成的token的功能(Password Credentials Grant)，未严格遵照 Oauth 2.0 标准。

### 前端

- 用户头像上传功能
- 右上角通知，消息功能未完善
- 二次开发文档待完善
- 路由鉴权（目前仅实现了侧边菜单授权，但可以直接访问对应未授权链接）

## FAQ

1. 部署后登录时弹出错误提示？

一般是因为后端系统配置问题，凡是出现保存可在开发者工具查看返回结果。

## Reference

[TentAdmin API Document](TentSYS_DEV_DOC-zh-cn.md)

[Tent API System 二次开发文档](https://github.com/Cstome/TentAdminSys/blob/master/TentSYS_DEV_DOC.md) (英文)

## License

MIT