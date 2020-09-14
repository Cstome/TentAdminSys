# Tent API System v3 Developments Document



## 项目描述

一个基于 ThinkPHP 的 RESTful API 系统，目前包含以下特性：

- 用户管理（用户，用户组）

- API 鉴权
- RESTful 资源映射
- 附加调试信息



## 框架及依赖

ThinkPHP v5.1.27 (LTS)



## 如何启用

```sh
# After cloned the project:

# Install dependencies
$ composer install

# Quick start PHP build-in http server and specific ./public/ as document root directory.
$ php -S 0.0.0.0:80 -t ./public/
```



## 目录结构

~~~
www  WEB部署目录（或者子目录）
├─application                     应用目录 （可修改，模块功能主要在该目录开发）
│  ├─common                       公共模块目录（可以更改）
│  ├─api                          API 模块目录
│  │  ├─common.php                模块函数文件
│  │  ├─controller                API控制器，以目录作版本控制
│  │  │  ├─v2                     v2 版本API（deprecate）
│  │  │  └─v3                     v3 版本API
│  │  │    ├─Api.php              v3 版本API基类，所有API继承该类
│  │  │    ├─oauth                Oauth认证模块
│  │  │    │  ├─Auth.php          API权限认证模块
│  │  │    │  └─Token.php         Access Token 生成与验证模块
│  │  │    └─module               API模块目录，不同模块分目录存放，目录名称使用小写加下划线
│  │  │       └─controller.php    API资源控制器，以PascalCase命名
│  │  └─model                     模型目录，所有模型存放在该目录下，模型直接继承 `think\Model` 
└─ ...                            其他目录同ThinkPHP一致
~~~

> 目录及文件命名规范遵照ThinkPHP的规范。



## URL访问及路由

在 `{root}/route/route.php`  h中已经定义了全局路由规则：

```php
Route::resource('api/:version/:module/:controller','api/:version.:module.:controller');
```

通过 `GET` 或 `POST` 方法请求 `{host}/api/v3/module/controller` 或通过 `PUT` or `DELETE` 方法请求`{host}/api/v3/module/controller/:id` .

### 不同的请求对应资源控制器的方法

| Request Method | Route Rule          | Related method in controller |
| -------------- | ------------------- | ---------------------------- |
| GET            | controller          | index                        |
| GET            | controller/create   | create                       |
| POST           | controller          | save                         |
| GET            | controller/:id      | read                         |
| GET            | controller/:id/edit | edit                         |
| PUT            | controller/:id      | update                       |
| DELETE         | controller/:id      | delete                       |

TentSYS 直接使用了 ThinkPHP 的 [资源控制器](https://www.kancloud.cn/manual/thinkphp5_1/353984) ，可查阅文档了解更多。



## 数据库

Tent API 系统规定每个数据表包含以下字段：

- `id` 
- `status` 0: 停用, 1: 正常, -1: 已删除
- `create_time` int unixtimetamp
- `update_time` int unixtimetamp

Example:

```sql
CREATE TABLE `admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `some_field` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```



## 控制器

所以的API控制器都继承 `app\api\controller\v3\Api` 类，只需简单的几行代码，即可定义一个接口完整的CRUD功能。

```php
<?php
namespace app\api\controller\v3\admin;

use app\api\controller\v3\Api;
use app\api\model\AdminUser as MainModel; //定义主模型

class User extends Api
{
    function initialize()
    {
        $this->Auth(); //开启鉴权
        $this->bindModel(new MainModel()); //创建主模型实例并绑定为主模型
    }

    public function index()
    {
        return $this->getList(); //获取列表
    }

    public function read($id)
    {
        return $this->getItem(['id' => $id]); //获取单条信息
    }

    public function save()
    {
        $post = input('post.');
        return $this->createItem($post); //保存新信息
    }

    public function update($id)
    {
        $data = input('put.');
        return $this->updateItem(['id' => $id], $data); //更新条目
    }

    public function delete($id)
    {
        return $this->deleteItem(['id' => $id]); //删除条目
    }
}
```

### API 权限认证

API 基础类 `app\api\controller\v3\Api`  已经包含了 `Auth` 认证类`app\api\controller\v3\oauth\Auth` . API 默认不校验权限，需通过调用 `$this->auth()` 来检查API权限并返回用户信息。

 `$this->auth()`可以在任意需要鉴权的方法中调用：

```php
public function index()
{
    $this->Auth();
    return $this->responseData($this->Auth()->getUserInfo()); //鉴权后返回用户信息
}
```

如果所有的方法都需要鉴权，可以在 `initialize` 方法中调用：

```php
function initialize()
{
    $this->Auth();
}
```

 `$this->auth()` 返回一个 `Auth` 类的实例，鉴权成功后可通过以下方法获取用户信息：

```php
$this->Auth()->getUserInfo(); //Array return
```

当鉴权失败（Access Token不存在或失效）系统将返回 `401` 错误：

```json
{
    "errMsg": "Unauthorized, login required."
}
```

鉴权过程将自动检查API授权情况，如果您只是想获取用户信息，可以通过重写属性关闭授权检查：

```php
<?php
namespace app\api\controller\v3\admin;
use app\api\controller\v3\Api;
class User extends Api
{
    protected $checkAccessControl = false; //Disable access control checking.
}
```

但用户没有该API的访问权限时，系统将返回 `403` 错误：

```json
{
    "errMsg": "Unauthorized operation."
}
```

### Defined Main Model (Deprecated) （该方法已废弃）

> This method has deprecated.
>
> The model of ThinkPHP 5.1 return an instance of each chain operation([链式操作](https://www.kancloud.cn/manual/thinkphp5_1/354005)), the method above was unavailable, using `bindModel` replace.

```php
<?php
namespace app\api\controller\v3\admin;
use app\api\controller\v3\Api;
use app\api\model\AdminGroup as MainModel; //Require a MainModel

class Group extends Api
{
    function initialize()
    {
        $this->model = new MainModel(); //Defined a MainModel
    }

    public function index()
    {
        //Case in ThinkPHP 5
        $this->model->where('status', 1); //Operate MainModel
        //Case in ThinkPHP 5.1
        $this->model = $this->model->where('status', 1);
        
        return $this->getList();
    }
    
    //... Any other method...
}
```

### 绑定主模型

Tent API 系统的理念 API-资源-模型，即一个API对应一种资源，而一种资源对应一个主模型。主模型的实例保存在 `$this->model` 中，但直接操作该属性容易出现混乱，造成异常。

通过调用 `$this->bindModel()` 来绑定主模型，传入的模型为ThinkPHP 的模型实例，需要定义主模型后才能使用CRUD相关功能。

```php
<?php

namespace app\api\controller\v3\admin;
use app\api\controller\v3\Api;
use app\api\model\User as MainModel;

class User extends Api
{
    function initialize()
    {
        $this->bindModel(new MainModel()); //主模型可以在初始化时定义
    }

    public function index()
    {
        //可直接通过 $this->model 对模型进行链式操作。
        $query = $this->model->order('updatedAt desc');
        //也可以创建一个新的模型实例
        $query = new OtherModel();
        
        //最终操作的模型以最后绑定的模型为准
        return $this->bindModel($query)->getList();
    }
    
    //... Any other method...
}
```

### 设置可变字段

通过 `$allowCreateFields` 和 `$allowUpdateFields` 定义设置可写入字段。默认情况下所有的字段都是可以写入的，建议设置允许写入字段来确保系统安全。

```php
<?php

namespace app\api\controller\v3\admin;

use app\api\controller\v3\Api;

class User extends Api
{
    protected $allowCreateFields = ['username', 'password'];
    protected $allowUpdateFields = ['password', 'nickname', 'group'];
}
```

### 控制器中的其他方法



## 保留参数

保留参数指在请求的URL中的保留query string.

#### List API

- `page` int
- `pageSize` int
- `search` string

## License

MIT