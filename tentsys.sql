# Tent System Basical Database
# Date: 2018-12-25 17:34:27
# Created: icsd


#
# Structure for table "admin_api"
#

CREATE TABLE `admin_api` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `controller` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

#
# Data for table "admin_api"
#

INSERT INTO `admin_api` VALUES (1,'API List','v3','admin','ApiList','',1,1543823766,1543823766),(2,'System Config','v3','admin','Config','',1,1543823946,1543823946),(3,'User List','v3','admin','User','',1,1544080665,1544080665),(4,'Group','v3','admin','Group','',1,1544080705,1544080705);

#
# Structure for table "admin_auth_log"
#

CREATE TABLE `admin_auth_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `request_ip` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `access_token` varchar(255) DEFAULT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#
# Structure for table "admin_config"
#

CREATE TABLE `admin_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` text,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

#
# Data for table "admin_config"
#

INSERT INTO `admin_config` VALUES (1,'side_menu','{\"incId\":17,\"menuTree\":[{\"id\":1,\"label\":\"ADMIN MANAGE\",\"type\":\"header\",\"children\":[{\"id\":2,\"label\":\"User & Auth\",\"type\":\"treeview\",\"show\":true,\"children\":[{\"id\":3,\"label\":\"User\",\"type\":\"link\",\"show\":true,\"path\":\"\\/manage\\/user\\/list\",\"icon\":\"user\"},{\"id\":4,\"label\":\"Group\",\"type\":\"link\",\"show\":true,\"path\":\"\\/manage\\/group\\/list\",\"icon\":\"users\"}],\"icon\":\"user-circle\"},{\"id\":5,\"label\":\"System Config\",\"type\":\"treeview\",\"show\":true,\"path\":\"\",\"children\":[{\"id\":6,\"label\":\"Side Menu\",\"type\":\"link\",\"show\":true,\"path\":\"\\/system\\/side-menu\",\"icon\":\"tasks\"},{\"id\":14,\"label\":\"API Manage\",\"icon\":\"code\",\"type\":\"link\",\"show\":true,\"path\":\"\\/system\\/api\\/list\"}],\"icon\":\"sliders-h\"}]},{\"id\":15,\"label\":\"Demo\",\"icon\":\"\",\"type\":\"header\",\"show\":true,\"path\":\"\",\"children\":[{\"id\":16,\"label\":\"Table\",\"icon\":\"table\",\"type\":\"link\",\"show\":true,\"path\":\"\\/demo\\/table\"}]}]}',1,1541873467,1545729066);

#
# Structure for table "admin_group"
#

CREATE TABLE `admin_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `auth_menu` varchar(255) DEFAULT '[]',
  `auth_menu_json` text,
  `remark` varchar(255) DEFAULT NULL,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

#
# Data for table "admin_group"
#

INSERT INTO `admin_group` VALUES (1,'Admin','[3,4,6,14,16]',NULL,'Group for Administrator.',1,1542249471,1545729081),(2,'Guest','[11]',NULL,'',1,1542608174,1542608174),(3,'User','[11]',NULL,'',1,1543996671,1543996690);

#
# Structure for table "admin_group_api_auth"
#

CREATE TABLE `admin_group_api_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `api_id` int(11) DEFAULT NULL,
  `GET` tinyint(3) DEFAULT NULL,
  `POST` tinyint(3) DEFAULT NULL,
  `PUT` tinyint(3) DEFAULT NULL,
  `DEL` tinyint(3) DEFAULT NULL,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_api_id` (`group_id`,`api_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

#
# Data for table "admin_group_api_auth"
#

INSERT INTO `admin_group_api_auth` VALUES (1,1,1,1,1,1,1,1,1543910337,1543912402),(2,2,1,1,0,0,0,1,1543912426,1543912426),(3,1,4,1,1,1,1,1,1544080729,1544080729),(4,1,3,1,1,1,1,1,1544080869,1544080869);

#
# Structure for table "admin_user"
#

CREATE TABLE `admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `group` varchar(255) DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `last_login_time` int(11) DEFAULT NULL,
  `status` tinyint(3) DEFAULT '1',
  `create_time` int(11) DEFAULT NULL,
  `update_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

#
# Data for table "admin_user"
#

INSERT INTO `admin_user` VALUES (1,NULL,'admin','Admin',NULL,'admin@localhost','admin1','1','127.0.0.1',1545729084,1,1542164889,1544523189);
