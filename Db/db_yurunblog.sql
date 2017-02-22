/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50547
Source Host           : 127.0.0.1:3306
Source Database       : db_yurunblog

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2017-02-22 17:49:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for yb_category
-- ----------------------------
DROP TABLE IF EXISTS `yb_category`;
CREATE TABLE `yb_category` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Parent` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父级分类ID；0-顶级分类',
  `Articles` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分类文章数量',
  `Name` varchar(128) NOT NULL DEFAULT '' COMMENT '分类名称',
  `Title` varchar(128) NOT NULL DEFAULT '' COMMENT '在分类页面中显示的标题',
  `Keywords` varchar(1024) NOT NULL DEFAULT '' COMMENT 'SEO关键词',
  `Description` varchar(1024) NOT NULL DEFAULT '' COMMENT 'SEO描述',
  `Index` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '顺序；可选：0-255 越小越靠前',
  `IsShow` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否显示',
  `Alias` varchar(128) NOT NULL DEFAULT '' COMMENT '别名',
  `CategoryTemplate` varchar(255) NOT NULL DEFAULT '' COMMENT '使用的分类模版名称',
  `ArticleTemplate` varchar(255) NOT NULL DEFAULT '' COMMENT '分类下默认文章模版名称',
  `NavigationShow` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否在导航栏显示；0-隐藏 1-显示',
  `Level` int(11) NOT NULL DEFAULT '0' COMMENT '层级',
  PRIMARY KEY (`ID`),
  KEY `alias` (`Alias`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_category
-- ----------------------------
INSERT INTO `yb_category` VALUES ('1', '0', '0', '软件', '1', '2', '3', '0', '', 'soft', 'default', 'default', '', '0');
INSERT INTO `yb_category` VALUES ('2', '1', '0', '电脑软件', '', '', '', '0', '', 'pcsoft', 'default', 'default', '\0', '1');
INSERT INTO `yb_category` VALUES ('3', '1', '0', '安卓软件', '', '', '', '0', '', '', 'default', 'default', '\0', '1');
INSERT INTO `yb_category` VALUES ('4', '0', '2', '技术杂谈', '', '', '', '0', '', '', 'default', 'default', '\0', '0');
INSERT INTO `yb_category` VALUES ('5', '4', '1', '编程语言', '', '', '', '0', '', '', 'default', 'default', '\0', '1');
INSERT INTO `yb_category` VALUES ('6', '4', '0', '数据库', '', '', '', '0', '', '', 'default', 'default', '\0', '1');
INSERT INTO `yb_category` VALUES ('7', '5', '0', 'PHP', '', '', '', '0', '', '', 'default', 'default', '\0', '3');
INSERT INTO `yb_category` VALUES ('8', '5', '0', 'C#', '', '', '', '0', '', '', 'default', 'default', '\0', '3');
INSERT INTO `yb_category` VALUES ('9', '5', '0', 'C++', '', '', '', '0', '', '', 'default', 'default', '\0', '3');
INSERT INTO `yb_category` VALUES ('10', '6', '0', 'MySQL', '', '', '', '0', '', '', 'default', 'default', '\0', '2');
INSERT INTO `yb_category` VALUES ('11', '6', '0', 'SQL Server', '', '', '', '0', '', '', 'default', 'default', '\0', '2');
INSERT INTO `yb_category` VALUES ('12', '5', '1', '易语言', '', '', '', '0', '', '', 'default', 'default', '\0', '3');
INSERT INTO `yb_category` VALUES ('14', '12', '1', 'test', '', '', '', '0', '', '', 'default', 'default', '\0', '4');
INSERT INTO `yb_category` VALUES ('17', '14', '1', 'test2', '', '', '', '2', '', '', 'default', 'default', '\0', '5');
INSERT INTO `yb_category` VALUES ('18', '17', '1', 'test3', '', '', '', '0', '', '', 'default', 'default', '\0', '6');
INSERT INTO `yb_category` VALUES ('19', '18', '1', 'test4', '', '', '', '0', '', '', 'default', 'default', '\0', '7');
INSERT INTO `yb_category` VALUES ('20', '19', '1', 'test5', '', '', '', '0', '', '', 'default', 'default', '\0', '8');
INSERT INTO `yb_category` VALUES ('21', '20', '1', 'test6', '', '', '', '0', '\0', '', 'default', 'default', '\0', '9');
INSERT INTO `yb_category` VALUES ('22', '21', '1', 'test7', '', '', '', '0', '\0', '', 'default', 'default', '\0', '10');
INSERT INTO `yb_category` VALUES ('23', '22', '1', 'test8', '', '', '', '0', '\0', '', 'default', 'default', '\0', '11');

-- ----------------------------
-- Table structure for yb_content
-- ----------------------------
DROP TABLE IF EXISTS `yb_content`;
CREATE TABLE `yb_content` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Type` tinyint(3) unsigned NOT NULL COMMENT '数据表内部内容类型；1-文章 2-单页',
  `Status` tinyint(4) NOT NULL COMMENT '状态',
  `Author` int(11) NOT NULL COMMENT '发布人ID',
  `CategoryID` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分类ID',
  `Title` varchar(255) NOT NULL DEFAULT '' COMMENT '内容标题',
  `Content` mediumtext NOT NULL COMMENT '内容',
  `Summary` text NOT NULL COMMENT '摘要',
  `Keywords` varchar(1024) NOT NULL DEFAULT '' COMMENT 'SEO关键词',
  `Description` varchar(1024) NOT NULL DEFAULT '' COMMENT 'SEO描述',
  `View` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `Comments` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评论数量',
  `CanComment` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可被评论',
  `Top` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否指定；0-不置顶 1-置顶',
  `Alias` varchar(100) NOT NULL DEFAULT '' COMMENT '别名',
  `Template` varchar(255) NOT NULL DEFAULT '' COMMENT '使用的模版名称',
  `Index` tinyint(4) NOT NULL DEFAULT '0' COMMENT '顺序；可选：0-255 越小越靠前',
  `PostTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `UpdateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后更新时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Alias` (`Alias`) USING HASH,
  KEY `CategoryID` (`CategoryID`,`Status`,`UpdateTime`,`PostTime`),
  KEY `Author` (`Author`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_content
-- ----------------------------
INSERT INTO `yb_content` VALUES ('4', '1', '1', '1', '23', '&lt;html&gt;标签', '<p>lag后来看<span style=\"color: rgb(255, 0, 0);\"><strong>到施工</strong></span>路段时<br/></p>', '<p>123</p>', 'a,b,c', 'balabala', '0', '0', '', '', 'test', 'default', '0', '2017-02-22 15:16:47', '2017-02-22 15:16:47');
INSERT INTO `yb_content` VALUES ('6', '1', '1', '1', '4', '大师傅撒反对撒', '', '', '', '', '0', '0', '', '\0', '', 'default', '0', '2017-02-22 16:58:20', '2017-02-22 16:58:20');
INSERT INTO `yb_content` VALUES ('7', '2', '1', '1', '0', '关于我们', '', '', '', '', '0', '0', '', '\0', 'about', 'default', '0', '2017-02-22 16:59:37', '2017-02-22 16:59:37');

-- ----------------------------
-- Table structure for yb_dict
-- ----------------------------
DROP TABLE IF EXISTS `yb_dict`;
CREATE TABLE `yb_dict` (
  `Name` varchar(64) NOT NULL,
  `Type` varchar(64) NOT NULL DEFAULT '',
  `Text` varchar(64) NOT NULL,
  `Value` varchar(255) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_dict
-- ----------------------------
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS', '', '内容状态', '');
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS_DRAFT', 'CONTENT_STATUS', '草稿', '4');
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS_HIDE', 'CONTENT_STATUS', '隐藏', '5');
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS_NORMAL', 'CONTENT_STATUS', '正常', '1');
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS_VERIFY_NOT_PASS', 'CONTENT_STATUS', '审核不通过', '3');
INSERT INTO `yb_dict` VALUES ('CONTENT_STATUS_WAIT_VERIFY', 'CONTENT_STATUS', '等待审核', '2');
INSERT INTO `yb_dict` VALUES ('CONTENT_TYPE', '', '内容类型', '');
INSERT INTO `yb_dict` VALUES ('CONTENT_TYPE_ARTICLE', 'CONTENT_TYPE', '文章', '1');
INSERT INTO `yb_dict` VALUES ('CONTENT_TYPE_PAGE', 'CONTENT_TYPE', '页面', '2');
INSERT INTO `yb_dict` VALUES ('EX_DATA_TYPE', '', '扩展数据类型', '');
INSERT INTO `yb_dict` VALUES ('EX_DATA_TYPE_ARTICLE', 'EX_DATA_TYPE', '文章', '1');
INSERT INTO `yb_dict` VALUES ('EX_DATA_TYPE_CATEGORY', 'EX_DATA_TYPE', '分类', '2');
INSERT INTO `yb_dict` VALUES ('EX_DATA_TYPE_PAGE', 'EX_DATA_TYPE', '页面', '3');
INSERT INTO `yb_dict` VALUES ('TAG_TYPE', '', '标签类型', '');

-- ----------------------------
-- Table structure for yb_exdata
-- ----------------------------
DROP TABLE IF EXISTS `yb_exdata`;
CREATE TABLE `yb_exdata` (
  `Type` tinyint(3) unsigned NOT NULL COMMENT '扩展数据类型；1-文章 2-单页 3-分类',
  `AssocPk` int(10) unsigned NOT NULL COMMENT '如果是文章则是文章ID；如果是分类则是分类ID；同理……',
  `Key` varchar(255) NOT NULL COMMENT '键',
  `Value` mediumtext NOT NULL COMMENT '值',
  PRIMARY KEY (`Type`,`AssocPk`,`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_exdata
-- ----------------------------
INSERT INTO `yb_exdata` VALUES ('2', '21', 'ccc', '3');
INSERT INTO `yb_exdata` VALUES ('2', '21', 'content', 'test');
INSERT INTO `yb_exdata` VALUES ('2', '21', 'tid', '6');

-- ----------------------------
-- Table structure for yb_user
-- ----------------------------
DROP TABLE IF EXISTS `yb_user`;
CREATE TABLE `yb_user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `LevelID` tinyint(4) NOT NULL COMMENT '级别ID',
  `Username` varchar(32) NOT NULL COMMENT '用户名',
  `Name` varchar(32) NOT NULL,
  `Password` varchar(32) NOT NULL COMMENT '密码',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_user
-- ----------------------------
INSERT INTO `yb_user` VALUES ('1', '1', 'admin', '管理员', '85be93f7f51fce6dd0c0d702e98c86c8');

-- ----------------------------
-- Table structure for yb_user_level
-- ----------------------------
DROP TABLE IF EXISTS `yb_user_level`;
CREATE TABLE `yb_user_level` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of yb_user_level
-- ----------------------------
INSERT INTO `yb_user_level` VALUES ('1', '管理员');
INSERT INTO `yb_user_level` VALUES ('2', '普通用户');
