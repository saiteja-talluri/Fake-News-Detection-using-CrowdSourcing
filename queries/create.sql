create table admins
    (admin_id		SERIAL,
     email          varchar(50) UNIQUE,
     name           varchar(50)  NOT NULL, 
	 password		varchar(20)  NOT NULL,
	 primary key (admin_id) 
	);

create table posts
	(
		post_id        SERIAL,
		created_timestamp      timestamp  NOT NULL,
        image			bytea,
        image_metadata varchar(10),
        body           varchar(30000)  NOT NULL,
		title          varchar(200)  NOT NULL,
     	author_name        varchar(50)  NOT NULL,
     	primary key (post_id)
	);

create table users
	(user_id		SERIAL,
     email          varchar(50) UNIQUE, 
     name           varchar(50)  NOT NULL,
	 password		varchar(20)  NOT NULL, 
     phone_number   varchar(10)  NOT NULL,
	 primary key (user_id)
	);

create table topics
	(name			varchar(50), 
	 primary key (name)
	);

create table volunteers -- See what jaggu did , use default
	(user_id		    BIGINT , 
     admin_id           BIGINT NOT NULL,
     rating             numeric(3,2) check (rating >=0) NOT NULL,
     posts_verified     numeric(10,0) NOT NULL,
     correctly_verified     numeric(10,0) NOT NULL,
	 primary key (user_id),
	 foreign key (admin_id) references admins
		on delete set null,
	 foreign key (user_id) references users
		on delete cascade
	);

create table admin_posts
	(admin_id		BIGINT NOT NULL,
	 post_id		BIGINT NOT NULL,
     primary key (post_id),
     foreign key (admin_id) references admins
        on delete cascade,
     foreign key (post_id) references posts
        on delete cascade
	);

create table published_posts
    (post_id        BIGINT NOT NULL,
     published_timestamp      timestamp NOT NULL,
 	 primary key (post_id),
     foreign key (post_id) references posts
        on delete cascade
    );


create table pending_posts
    (post_id        BIGINT NOT NULL,
	 assigned_timestamp     timestamp,
     added_timestamp     timestamp NOT NULL,
	 current_volunteer		BIGINT,
	 score              numeric(3,1) NOT NULL,
     primary key (post_id),
     foreign key (post_id) references posts
        on delete cascade,
     foreign key (current_volunteer) references volunteers
       on delete cascade
    );

create table user_posts
	(user_id		BIGINT NOT NULL,
	 post_id		BIGINT NOT NULL,
     primary key (post_id),
     foreign key (user_id) references users
        on delete cascade,
     foreign key (post_id) references posts
        on delete cascade
	);

create table user_post_info
	(user_id		BIGINT NOT NULL,
     post_id		BIGINT NOT NULL,
     liked          boolean,
     saved          boolean,
     primary key (user_id,post_id),
     foreign key (user_id) references users
        on delete cascade,
     foreign key (post_id) references posts
        on delete cascade 
	);

create table post_topics
	(post_id			BIGINT NOT NULL, 
	 topic_name			varchar(50) NOT NULL, 
	 primary key (post_id,topic_name),
     foreign key (post_id) references posts
        on delete cascade,
     foreign key (topic_name) references topics
        on delete set null
	);

create table applications
	(	user_id		    BIGINT NOT NULL,
		sop             varchar(500) NOT NULL,
        requested_time_stamp     timestamp NOT NULL,
		primary key (user_id),
		foreign key (user_id) references users
		on delete cascade
		);

create table volunteer_topics
    (user_id        BIGINT NOT NULL,
     topic_name         varchar(50) NOT NULL,
     primary key (user_id,topic_name),
     foreign key (user_id) references volunteers
		on delete cascade,
     foreign key (topic_name) references topics
        on delete set null
    );
create table application_topics
    (user_id        BIGINT NOT NULL,
     topic_name         varchar(50) NOT NULL,
     primary key (user_id,topic_name),
     foreign key (user_id) references applications
		on delete cascade,
     foreign key (topic_name) references topics
        on delete set null
    );

create table responses
    (response_id       SERIAL,
     post_id        BIGINT NOT NULL,
     user_id        BIGINT NOT NULL,
     comment        varchar(1000) NOT NULL,
     verify         boolean NOT NULL,
     response_timestamp    timestamp NOT NULL,
     primary key(user_id,post_id),
     foreign key (post_id) references posts
        on delete cascade,
     foreign key (user_id) references volunteers
        on delete cascade
    );

create table user_topics
    (user_id        BIGINT NOT NULL,
      topic_name         varchar(50) NOT NULL,
     primary key (user_id,topic_name),
     foreign key (user_id) references users
		on delete cascade,
     foreign key (topic_name) references topics
        on delete set null
    );

create table rejected_posts
    (post_id        BIGINT NOT NULL,
     user_id        BIGINT NOT NULL,
 	 primary key (post_id),
     foreign key (post_id) references posts
        on delete cascade,
     foreign key (user_id) references users
        on delete cascade
    );



