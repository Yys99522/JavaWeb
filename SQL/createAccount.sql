
CREATE USER 'user'@'%' IDENTIFIED BY '1234';

use gym;
GRANT SELECT,INSERT,UPDATE ON GYM.* TO 'user'@'%';


RENAME USER 'user'@'localhost' TO 'user'@'%';


GRANT EXECUTE ON PROCEDURE gym.forget TO 'user'@'%';
GRANT EXECUTE ON PROCEDURE gym.member TO 'user'@'%';
GRANT EXECUTE ON PROCEDURE gym.login TO 'user'@'%';
GRANT EXECUTE ON PROCEDURE gym.updatemember TO 'user'@'%';

