DROP schema if exists `http`;
CREATE SCHEMA IF NOT EXISTS `http` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `http` ;
CREATE TABLE toys(id INT UNIQUE NOT NULL AUTO_INCREMENT,
								toy_id INT PRIMARY KEY,
                                name VARCHAR(50),
                                status VARCHAR(6),
                                status_updated DATE);
CREATE TABLE games(id INT UNIQUE NOT NULL AUTO_INCREMENT,
								game_id INT PRIMARY KEY,
                                name VARCHAR(100),
                                date DATE);
CREATE TABLE toys_games(id INT UNIQUE NOT NULL AUTO_INCREMENT,
						game_id INT NOT NULL,
                        toy_id INT NOT NULL,
                        note VARCHAR(100),
                        INDEX `index_game_id_games`(`game_id` asc),
                        INDEX `index_toy_id_toys`(`toy_id` asc),
                        INDEX `index_toy_id_game_id`(`toy_id`,game_id asc),
                        CONSTRAINT index_toy_id_toys FOREIGN KEY (toy_id) REFERENCES toys(toy_id) ON UPDATE CASCADE ON DELETE CASCADE,
                        CONSTRAINT index_game_id_games FOREIGN KEY (game_id) REFERENCES games(game_id) ON UPDATE CASCADE ON DELETE CASCADE);

-- task 2
CREATE TABLE toys_repair(id INT PRIMARY KEY auto_increment,
						toy_id INT ,
                        issue_description VARCHAR(100));
ALTER TABLE toys_repair
ADD FOREIGN KEY (`toy_id`) REFERENCES toys_games(`toy_id`) ON UPDATE CASCADE;
DELIMITER |
CREATE TRIGGER `update_toys_repair` AFTER INSERT ON `toys_games`
FOR EACH ROW BEGIN
   INSERT INTO toys_repair Set toy_id = NEW.toy_id , issue_description = NEW.note;
  END;
|
DELIMITER ;



INSERT INTO toys(toy_id, name, status, status_updated) 	VALUES
				(1, "boat", "broken","2018-04-12"),
				(43,"octopus", "ok","2019-03-18"),
				(2, "Chess", "repair", "2019-03-15"),
				(5, "tennis", "repair","2019-12-13"),
				(7, "Teddy Bear", "repair" ,"2019-02-22"),
                (15,"cards","ok","2019-10-23");
INSERT INTO games(game_id,name,date) VALUE
				(1,"Ships in the ocean","2018-02-12"),
				(8 ,"UNO","2020-10-01" ),
				(17 ,"checkers","2020-10-04" ),
				(19 ,"Star Wars","2020-10-10" ),
				(20 ,"Manchikin","2020-10-08" ),
				(21 ,"Ticket of ride","2020-10-05" ),
				(14,"Octopus-destroyer","2018-03-18");
INSERT INTO toys_games(game_id,toy_id,note) VALUES
						(1,43,"boat is broken "),
                        (1,1,"two tentacles are lost"),
                        (8,15,"new cards"),
                        (17,2,"lost queen"),
                        (19,15,"good game"),
                        (20,15,"bad game"),
                        (21,7,"bear feels well  "),
                        (21,5,"funny" ),
                        (14,43,"felt rather good though had no water to swim ");
-- task 4

select toys.toy_id, toys.name, toys.status, toys.status_updated, games.name as games_name, games.date,toys_games.note toys_games from toys join toys_games
on toys.toy_id = toys_games.toy_id and year(curdate()-INTERVAL 1 year) = YEAR(toys.status_updated)
join games on games.game_id = toys_games.game_id ;

-- task 5
select name from toys where name not in (select name  from toys  where  status = 'repair' group by name) group by name;
