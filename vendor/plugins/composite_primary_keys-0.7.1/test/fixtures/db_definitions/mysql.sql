CREATE TABLE `reference_types` (
  `reference_type_id` int(11) NOT NULL auto_increment,
  `type_label` varchar(50) default NULL,
  `abbreviation` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  PRIMARY KEY  (`reference_type_id`)
) TYPE=InnoDB;

CREATE TABLE `reference_codes` (
  `reference_type_id` int(11) NOT NULL,
  `reference_code` int(11) NOT NULL,
  `code_label` varchar(50) default NULL,
  `abbreviation` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  PRIMARY KEY  (`reference_type_id`,`reference_code`)
) TYPE=InnoDB;

CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `tariffs` (
  `tariff_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `amount` integer(11) default NULL,
  PRIMARY KEY  (`tariff_id`,`start_date`)
) TYPE=InnoDB;

CREATE TABLE `product_tariffs` (
  `product_id` int(11) NOT NULL,
  `tariff_id` int(11) NOT NULL,
  `tariff_start_date` date NOT NULL,
  PRIMARY KEY  (`product_id`,`tariff_id`,`tariff_start_date`)
) TYPE=InnoDB;

CREATE TABLE `suburbs` (
  `city_id` int(11) NOT NULL,
  `suburb_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`city_id`,`suburb_id`)
) TYPE=InnoDB;

CREATE TABLE `streets` (
  `id` int(11) NOT NULL auto_increment,
  `city_id` int(11) NOT NULL,
  `suburb_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `readings` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

