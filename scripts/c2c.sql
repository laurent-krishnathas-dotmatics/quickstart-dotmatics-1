CREATE USER c2c identified by clone2crystal DEFAULT tablespace USERS;
ALTER USER c2c quota unlimited on USERS;
grant connect to c2c;
grant resource to c2c;
grant create view to c2c;
grant create synonym to c2c;
exit