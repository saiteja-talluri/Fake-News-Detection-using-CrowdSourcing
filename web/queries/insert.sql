/**
delete from admins;
delete from admin_posts;
delete from posts;
delete from published_posts;
delete from pending_posts;
delete from user_posts;
delete from users;
delete from user_post_info;
delete from topics;
delete from post_topics;
delete from volunteers;
delete from applications;
delete from volunteer_topics;
delete from responses;
delete from user_topics;
delete from rejected_posts;
delete from application_topics;
**/

insert into admins values (DEFAULT, 'a0@infact.com','admin0','a0');
insert into admins values (DEFAULT, 'a1@infact.com','admin1','a1');
insert into admins values (DEFAULT, 'a2@infact.com','admin2','a2');
insert into admins values (DEFAULT, 'a3@infact.com','admin3','a3');
insert into admins values (DEFAULT, 'a4@infact.com','admin4','a4');
insert into admins values (DEFAULT, 'a5@infact.com','admin5','a5');
insert into admins values (DEFAULT, 'a6@infact.com','admin6','a6');
insert into admins values (DEFAULT, 'a7@infact.com','admin7','a7');
insert into admins values (DEFAULT, 'a8@infact.com','admin8','a8');
insert into admins values (DEFAULT, 'a9@infact.com','admin9','a9');

--insert into posts values (TIMESTAMP '2011-05-16 15:36:38','This is the body of the post 1 in the app. Stay tuned for more updates from Infact.','Post 1','user1');


insert into users values (DEFAULT, 'u0@user.com','user0','u0','9999999990');
insert into users values (DEFAULT, 'u1@user.com','user1','u1','9999999991');
insert into users values (DEFAULT, 'u2@user.com','user2','u2','9999999992');
insert into users values (DEFAULT, 'u3@user.com','user3','u3','9999999993');
insert into users values (DEFAULT, 'u4@user.com','user4','u4','9999999994');
insert into users values (DEFAULT, 'u5@user.com','user5','u5','9999999995');
insert into users values (DEFAULT, 'u6@user.com','user6','u6','9999999996');
insert into users values (DEFAULT, 'u7@user.com','user7','u7','9999999997');
insert into users values (DEFAULT, 'u8@user.com','user8','u8','9999999998');
insert into users values (DEFAULT, 'u9@user.com','user9','u9','9999999999');

insert into topics values ('Technology');
insert into topics values ('Movies');
insert into topics values ('Sports');
insert into topics values ('Art');
insert into topics values ('Politics');
insert into topics values ('Life Style');
insert into topics values ('Bussiness');
insert into topics values ('Crime');
insert into topics values ('Mythology');
insert into topics values ('International');

insert into volunteers values (2, 2, 0.0, 0, 0);
insert into volunteers values (4, 2, 0.0, 0, 0);
insert into volunteers values (3, 3, 0.0, 0, 0);
insert into volunteers values (5, 7, 0.0, 0, 0);
insert into volunteers values (7, 5, 0.0, 0, 0);


insert into volunteer_topics values (2,'Technology');
insert into volunteer_topics values (2,'Movies');
insert into volunteer_topics values (2,'Sports');
insert into volunteer_topics values (2,'Art');
insert into volunteer_topics values (2,'Politics');
insert into volunteer_topics values (2,'Mythology');
insert into volunteer_topics values (3,'Technology');
insert into volunteer_topics values (3,'Crime');
insert into volunteer_topics values (3,'International');
insert into volunteer_topics values (3,'Bussiness');
insert into volunteer_topics values (5,'Politics');
insert into volunteer_topics values (5,'Art');
insert into volunteer_topics values (7,'Sports');
insert into volunteer_topics values (7,'Movies');

insert into user_topics values (1,'Technology');
insert into user_topics values (1,'Movies');
insert into user_topics values (1,'Sports');
insert into user_topics values (1,'Art');
insert into user_topics values (1,'Politics');
insert into user_topics values (1,'Life Style');
insert into user_topics values (1,'Bussiness');
insert into user_topics values (1,'Crime');
insert into user_topics values (1,'Mythology');
insert into user_topics values (1,'International');
insert into user_topics values (2,'Politics');
insert into user_topics values (2,'Life Style');
insert into user_topics values (3,'Bussiness');
insert into user_topics values (3,'Crime');
insert into user_topics values (3,'Mythology');
insert into user_topics values (4,'International');
insert into user_topics values (5,'Life Style');
insert into user_topics values (6,'Crime');
insert into user_topics values (7,'Bussiness');
insert into user_topics values (8,'Sports');
insert into user_topics values (9,'Art');

