CREATE TABLE candidate_audit 
( 
a_id int(11) NOT NULL AUTO_INCREMENT, 
a_cid int(4) NOT NULL, 
a_first_name varchar(45) NOT NULL, 
a_last_name varchar(45) NOT NULL, 
a_delegate_count int(11),
a_date timestamp NOT NULL,
CONSTRAINT audit_pk PRIMARY KEY (a_id)
);


DELIMITER //
CREATE TRIGGER after_candidate_update
AFTER UPDATE ON candidate
FOR EACH ROW
BEGIN
  INSERT INTO candidate_audit (a_cid, a_first_name, a_last_name, a_delegate_count) 
  VALUES (OLD.cid, OLD.first_name, OLD.last_name, OLD.delegate_count);
END; //
DELIMITER ;