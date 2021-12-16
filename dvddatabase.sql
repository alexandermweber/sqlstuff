USE Master;
GO--The GO command executes everything above it
----Drop PurpleBoxDVD database if it exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE NAME = 'PurpleBoxDVD')--Look for PurpleBoxDVD
	DROP DATABASE PurpleBoxDVD; --Search for the PurpleBoxDVD database, and if it exists, delete it.
	--This lets us run this file multiple times
---- Create PurpleBoxDVD database
CREATE DATABASE [PurpleBoxDVD]
ON PRIMARY
(NAME = N'PurpleBoxDVD', --The N tells microso sql server that this is text
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVD.mdf',
SIZE = 5MB,
FILEGROWTH = 1MB)
LOG ON --creating log file
(NAME = PurpleBoxDVD_LOG,
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVDLog.ldf',
SIZE = 2MB,
FILEGROWTH = 1MB); --grow at 1mb each time there is growth


GO--Execute everything from CREATE DATABASE to here


--Attach to the new PurpleBoxDVD database
USE PurpleBoxDVD;


-----------------------CREATE ALL TABLES--------------------------
--You want to organize your script so that you do common things in the same area
CREATE TABLE PBUser
(
	pbUser_id int IDENTITY(1,1) NOT NULL,--synthetic key, everything with a _id will be a synthetic key.  This will auto increment.
	--pbUser_id is a hidden value, users will not see it.
	--int IDENTITY means this is a self-generating key.  (1 means that we start at 1, and the second 1 means we increment by one.
	--So our first user will have the pbuser_id 1, and the next user's pbUser_id will be 2.

	userID Nvarchar(10) NOT NULL,
	userFirstName Nvarchar(25) NOT NULL,
	userLastName Nvarchar(50) NOT NULL,
	userPassword NVarchar(255) NOT NULL,
	userPhoneNumber Nvarchar(10) NOT NULL,
	userPhoneNumber2 Nvarchar(10),
	userType Nvarchar(1) NOT NULL, --Whether user is an admin or not.  Not a boolean because we might create a third user type.
	customerType Nvarchar(1) NOT NULL, --Premium or standard customer
	banStatus Nvarchar(1) NOT NULL,
	fees money,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbUserQuestion
(

	pbUser_id int NOT NULL,
	pbQuestion_id int NOT NULL,
	Answer Nvarchar(255) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbQuestion
(
	pbQuestion_id int IDENTITY(1, 1) NOT NULL,
	Question nvarchar(255) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbMovie
(
	pbMovie_id int IDENTITY(1, 1) NOT NULL,
	movieID nvarchar(10) NOT NULL,
	movieTitle nvarchar(100) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);

CREATE TABLE PbMovieItem
(
	pbMovieItem_id int IDENTITY(1, 1) NOT NULL,
	pbMovie_id int NOT NULL,
	copyNumber int NOT NULL,
	movieType nvarchar(1),
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);

CREATE TABLE PbMovieRental
(
	pbUser_id int NOT NULL,
	pbMovieItem_id int NOT NULL,
	rentalDate dateTime2 NOT NULL,
	returnDate dateTime2,
	dueDate dateTime2 NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);

CREATE TABLE PbMovieReservation
(
	pbMovie_id int NOT NULL,
	pbUser_id int NOT NULL,
	reservationDate dateTime2 NOT NULL,
	movieType Nvarchar(1) NOT NULL,
	reservationStatus nvarchar(1) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbActor
(
	pbActor_id int IDENTITY(1, 1) NOT NULL,
	actorFirstName nvarchar(25) NOT NULL,
	actorLastName nvarchar(50) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbMovieActor
(
	pbMovie_id int NOT NULL,
	pbActor_id int NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbDirector
(
	pbDirector_id int IDENTITY(1, 1) NOT NULL,
	directorFirstName nvarchar(25) NOT NULL,
	directorLastName nvarchar(50) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);

CREATE TABLE PbMovieDirector
(
	pbMovie_id int NOT NULL,
	pbDirector_id int NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbKeyword
(
	pbKeyword_id int IDENTITY(1, 1) NOT NULL,
	Keyword nvarchar(25) NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);

CREATE TABLE PbMovieKeyword
(
	pbKeyword_id int NOT NULL,
	pbMovie_id int NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbGenre
(
	pbGenre_id int IDENTITY(1, 1) NOT NULL,
	genre Nvarchar(25) NOT NULL,
	genreDescription nvarchar(255),
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


CREATE TABLE PbMovieGenre
(
	pbMovie_id int NOT NULL,
	pbGenre_id int NOT NULL,
	lastUpdatedBy Nvarchar(25) NOT NULL,
	lastUpdatedDate datetime NOT NULL
);


---------SET Primary, Foreign and Alternate Keys--------
---- Create Primary Keys ----

ALTER TABLE PbUser
	ADD CONSTRAINT PK_PbUser--The name we give this constraint will be what we see when we get an error because of this constraint
	PRIMARY KEY CLUSTERED (pbUser_id);--CLUSTERED will let us search for it quicker

ALTER TABLE PbQuestion
	ADD CONSTRAINT PK_PbQuestion
	PRIMARY KEY CLUSTERED (pbQuestion_id);

ALTER TABLE PbUserQuestion
	ADD CONSTRAINT PK_PbUserQuestion
	PRIMARY KEY CLUSTERED (pbUser_id, pbQuestion_id);

ALTER TABLE PbMovie
	ADD CONSTRAINT PK_PbMovie
	PRIMARY KEY CLUSTERED  (PbMovie_id);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT PK_PbMovieReservation
	PRIMARY KEY CLUSTERED (pbMovie_id, pbUser_id, reservationDate, movieType);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT PK_MovieItem
	PRIMARY KEY CLUSTERED (pbMovieItem_id);

ALTER TABLE PbMovieRental
	ADD CONSTRAINT PK_PbMovieRental
	PRIMARY KEY CLUSTERED (pbUser_id, pbMovieItem_id, rentalDate);

ALTER TABLE PbActor
	ADD CONSTRAINT PK_PbActor
	PRIMARY KEY CLUSTERED (pbActor_id);

ALTER TABLE PbMovieActor 
	ADD CONSTRAINT PK_PbMovieActor
	PRIMARY KEY CLUSTERED (pbActor_id, pbMovie_id);--This table has two primary keys


ALTER TABLE PbDirector
	ADD CONSTRAINT PK_PbDirector
	PRIMARY KEY CLUSTERED (pbDirector_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT PK_PbMovieDirector
	PRIMARY KEY CLUSTERED (pbMovie_id, pbDirector_id);

ALTER TABLE PbKeyword
	ADD CONSTRAINT PK_pbKeyword
	PRIMARY KEY CLUSTERED (pbKeyword_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT PK_PbMovieKeyword
	PRIMARY KEY CLUSTERED (pbKeyword_id, pbMovie_id);

ALTER TABLE PbGenre
	ADD CONSTRAINT PK_PbGenre
	PRIMARY KEY CLUSTERED (pbGenre_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT PK_PbMovieGenre
	PRIMARY KEY CLUSTERED (pbMovie_id, pbGenre_id);



----Create Foreign Keys----
ALTER TABLE PbUserQuestion
	ADD CONSTRAINT FK_PbUserQuestion_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbUserQuestion
	ADD CONSTRAINT FK_PBUserQuestion_pbQuestion_id
	FOREIGN KEY (pbQuestion_id) REFERENCES PbQuestion(pbQuestion_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT FK_PbMovieItem_pbMovieId
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);


ALTER TABLE PbMovieRental
	ADD CONSTRAINT FK_PbMovieRental_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbMovieRental
	ADD CONSTRAINT FK_PbMovieRental_pbMovieItem_id
	FOREIGN KEY (pbMovieItem_id) REFERENCES PbMovieItem(pbMovieItem_id);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT FK_PbMovieReservation_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT FK_PbMovieReservation_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);



ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbActor_id
	FOREIGN KEY (pbActor_id) REFERENCES PbActor(pbActor_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbDirector_id
	FOREIGN KEY (pbDirector_id) REFERENCES PbDirector(pbDirector_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT FK_PbMovieKeyword_pbKeyword_id
	FOREIGN KEY (pbKeyword_id) REFERENCES PbKeyword(pbKeyword_id);

ALTER TABLE PbMovieKeyword
	ADD CONSTRAINT FK_PbMovieKeyword_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbGenre_id
	FOREIGN KEY (pbGenre_id) REFERENCES PbGenre(pbGenre_id);


----Create Alternate Keys----
ALTER TABLE PbUser
	ADD CONSTRAINT AK_PbUser_UserID
	UNIQUE(UserID);--Says that this needs to be unique.  If there is a duplicate we will get an error called "AK_PbUser_UserID".


ALTER TABLE PbQuestion
	ADD CONSTRAINT AK_PbQuestion_Question
	UNIQUE(Question);


ALTER TABLE PbMovie
	ADD CONSTRAINT AK_PbMovie_movieID
	UNIQUE(movieID);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT AK_pbMovieItem_pbMovie_id
	UNIQUE(pbMovie_id, copyNumber, movieType);




ALTER TABLE PbActor
	ADD CONSTRAINT AK_PbActor_actorFirstName
	UNIQUE(actorFirstName, actorLastName);



ALTER TABLE PbDirector
	ADD CONSTRAINT AK_PbDirector_directorFirstName
	UNIQUE(directorFirstName, directorLastName);


ALTER TABLE PbKeyword
	ADD CONSTRAINT AK_PbKeyword_Keyword
	UNIQUE(Keyword);

ALTER TABLE PbGenre
	ADD CONSTRAINT AK_PbGenre_genre
	UNIQUE(genre);


-----Adding constraints-----
ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_UserType
	CHECK(userType = 'A' OR userType = 'N');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_userPhoneNumber
	CHECK(userPhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_pbUser_id
	CHECK(userID LIKE 'PB[0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_customerType
	CHECK(customerType = 'P' OR customerType = 'S');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_banStatus
	CHECK(banStatus = 'B' OR banStatus = 'N');



ALTER TABLE PbMovieRental
	ADD CONSTRAINT CK_PbMovieRental
	CHECK(dueDate = DATEADD(day, 3, rentalDate));


ALTER TABLE PbMovieItem
	ADD CONSTRAINT CK_PbMovieItem_movieType
	CHECK(movieType = 'D' OR movieType = 'B');

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT CK_PbMovieReservation_movieType
	CHECK(movieType = 'D' OR movieType = 'B');

ALTER TABLE PbMovieReservation
	ADD CONSTRAINT CK_PbMovieReservation_reservationStatus
	CHECK(reservationStatus = 'P' OR reservationStatus = 'C');

-----Insert Users-----
INSERT INTO PbUser
(
--Do not have to create pbUser_id, that is created automatically
	userID, 
	userFirstName,
	userLastName,
	userPassword,
	userPhoneNumber,
	userPhoneNumber2,
	userType,
	customerType,
	banStatus,
	fees,
	lastUpdatedBy,
	lastUpdatedDate
)
VALUES
(
	'PB0000001',
	'Drew',
	'Weidman',
	'SQLRules',
	'8016267025',
	NULL,
	'A',
	'P',
	'N',
	0.00,
	'Alex',
	GETDATE()
),

(
	'PB0000021',
	'Spencer',
	'Hilton',
	'CSRocks!',
	'8016266098',
	'8016265500',
	'N',
	'P',
	'N',
	0.00,
	'Alex',
	GETDATE()
),

(
	'PB0000027',
	'Josh',
	'Jensen',
	'AndroidIsKing',
	'8016266323',
	'8016266000',
	'N',
	'S',
	'N',
	0.00,
	'Alex',
	GETDATE()
),

(
	'PB0000101',
	'Waldo',
	'Wildcat',
	'GoWildcats!',
	'8016266001',
	'8016268080',
	'N',
	'S',
	'N',
	0.00,
	'Alex',
	GETDATE()
),

(
	'PB0000002',
	'Alex',
	'Lastname',
	'Password',
	'0000000000',
	NULL,
	'A',
	'S',
	'N',
	0.00,
	'Alex',
	GETDATE()
),

(
	'PB0000003',
	'Userfirstname',
	'Userlastname',
	'Password',
	'0000000000',
	NULL,
	'N',
	'S',
	'N',
	0.00,
	'Alex',
	GETDATE()
);




INSERT INTO dbo.PbQuestion
(
	Question,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	'Who is the best professor in the CS Department',
	'Alex',
	GETDATE()
),

(
	'Who is the CS 3550 professor',
	'Alex',
	GETDATE()
),

(
	'Who is your professor in the CS Department',
	'Alex',
	GETDATE()
),

(
	'What is the name of your pet',
	'Alex',
	GETDATE()
),

(
	'What is your favorite color',
	'Alex',
	GETDATE()
),

(
	'What is your favorite movie',
	'Alex',
	GETDATE()
);

INSERT INTO dbo.PbUserQuestion
(
	pbUser_id,
	pbQuestion_id,
	Answer,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Drew'
	AND userLastName = 'Weidman'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the best professor in the CS Department'),

	'Josh Jensen',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Drew'
	AND userLastName = 'Weidman'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Spencer'
	AND userLastName = 'Hilton'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the best professor in the CS Department'),

	'Josh Jensen',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Spencer'
	AND userLastName = 'Hilton'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Josh'
	AND userLastName = 'Jensen'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the best professor in the CS Department'),

	'Josh Jensen',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Josh'
	AND userLastName = 'Jensen'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Waldo'
	AND userLastName = 'Wildcat'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the best professor in the CS Department'),

	'Josh Jensen',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Waldo'
	AND userLastName = 'Wildcat'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Userfirstname'
	AND userLastName = 'Userlastname'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the best professor in the CS Department'),

	'Josh Jensen',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Userfirstname'
	AND userLastName = 'Userlastname'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Alex'
	AND userLastName = 'Lastname'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is your professor in the CS Department'),

	'Drew Weidman',
	'Alex',
	GETDATE()
),

(
	(SELECT PbUser_ID FROM PbUser
	WHERE userFirstName = 'Alex'
	AND userLastName = 'Lastname'),

	(SELECT pbQuestion_id FROM PbQuestion
	WHERE question = 'Who is the CS 3550 professor'),

	'Drew Weidman',
	'Alex',
	GETDATE()
);


INSERT INTO PbMovie
(
	MovieID,
	movieTitle,
	lastUpdatedBy,
	lastUpdatedDate
)
VALUES
(
	'TRGRT',
	'True Grit',
	'Alex',
	GETDATE()
),

(
	'SonKElder',
	'The Sons of Katie Elder',
	'Alex',
	GETDATE()
),

(
	'Avngrs',
	'The Avengers',
	'Alex',
	GETDATE()
),

(
	'GrtstShwmn',
	'Greatest Showman',
	'Alex',
	GETDATE()
),

(
	'XMEN',
	'X-Men',
	'Alex',
	GETDATE()
),

(
	'Incrdbles2',
	'Incredibles 2',
	'Alex',
	GETDATE()
),

(
	'Deadpl',
	'Deadpool',
	'Alex',
	GETDATE()
),

(
	'StrWrsIVNH',
	'Star Wars: Episode IV - New Hope',
	'Alex',
	GETDATE()
);


INSERT INTO PbMovieItem
(
	pbMovie_id,
	copyNumber,
	movieType,
	lastUpdatedBy,
	lastUpdatedDate
)
VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	2,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	1,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	2,
	'D',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	1,
	'B',
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	2,
	'B',
	'Alex',
	GETDATE()
);

--Adding actors
INSERT INTO PbActor
(
	actorFirstName,
	actorLastName,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	'John',
	'Wayne',
	'Alex',
	GETDATE()
),

(
	'Glen',
	'Campbell',
	'Alex',
	GETDATE()
),

(
	'Dean',
	'Martin',
	'Alex',
	GETDATE()
),

(
	'Robert',
	'Downey Jr',
	'Alex',
	GETDATE()
),

(
	'Chris',
	'Evans',
	'Alex',
	GETDATE()
),

(
	'Hugh',
	'Jackman',
	'Alex',
	GETDATE()
),

(
	'Michelle',
	'Williams',
	'Alex',
	GETDATE()
),

(
	'Patrick',
	'Stewart',
	'Alex',
	GETDATE()
),

(
	'Craig T',
	'Nelson',
	'Alex',
	GETDATE()
),

(
	'Holly',
	'Hunter',
	'Alex',
	GETDATE()
),


(
	'Ryan',
	'Reynolds',
	'Alex',
	GETDATE()
),

(
	'Morena',
	'Baccarin',
	'Alex',
	GETDATE()
),

(
	'Mark',
	'Hamill',
	'Alex',
	GETDATE()
),

(
	'Carrie',
	'Fisher',
	'Alex',
	GETDATE()
);

--Adding directors
INSERT INTO PbDirector
(
	directorFirstName,
	directorLastName,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	'Henry',
	'Hathaway',
	'Alex',
	GETDATE()
),

(
	'Joss',
	'Whedon',
	'Alex',
	GETDATE()
),

(
	'Michael',
	'Gracey',
	'Alex',
	GETDATE()
),

(
	'Bryan',
	'Singer',
	'Alex',
	GETDATE()
),

(
	'Brad',
	'Bird',
	'Alex',
	GETDATE()
),

(
	'Tim',
	'Miller',
	'Alex',
	GETDATE()
),

(
	'George',
	'Lucas',
	'Alex',
	GETDATE()
);

--Adding keywords
INSERT INTO PbKeyword
(
	Keyword,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	'Rooster Cogburn',
	'Alex',
	GETDATE()
),

(
	'US Marshal',
	'Alex',
	GETDATE()
),

(
	'Oscar Award Winner',
	'Alex',
	GETDATE()
),

(
	'Gun Fighter',
	'Alex',
	GETDATE()
),

(
	'Family',
	'Alex',
	GETDATE()
),

(
	'Captain America',
	'Alex',
	GETDATE()
),

(
	'Iron Man',
	'Alex',
	GETDATE()
),

(
	'Thor',
	'Alex',
	GETDATE()
),

(
	'Circus',
	'Alex',
	GETDATE()
),

(
	'Barnum',
	'Alex',
	GETDATE()
),

(
	'Singing',
	'Alex',
	GETDATE()
),

(
	'Million Dreams',
	'Alex',
	GETDATE()
),

(
	'Wolverine',
	'Alex',
	GETDATE()
),

(
	'Mutants',
	'Alex',
	GETDATE()
),

(
	'Elastigirl',
	'Alex',
	GETDATE()
),

(
	'Dash',
	'Alex',
	GETDATE()
),

(
	'Jack Jack',
	'Alex',
	GETDATE()
),

(
	'Mercenary',
	'Alex',
	GETDATE()
),

(
	'Morbid',
	'Alex',
	GETDATE()
),

(
	'healing power',
	'Alex',
	GETDATE()
),

(
	'Jedi Knight',
	'Alex',
	GETDATE()
),

(
	'Darth Vader',
	'Alex',
	GETDATE()
),

(
	'Yoda',
	'Alex',
	GETDATE()
);

--Adding genres
INSERT INTO PbGenre
(
	genre,
	genreDescription,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	'Adventure',
	'Adventure',
	'Alex',
	GETDATE()
),

(
	'Drama',
	'Drama',
	'Alex',
	GETDATE()
),

(
	'Western',
	'Western',
	'Alex',
	GETDATE()
),

(
	'Action',
	'Action',
	'Alex',
	GETDATE()
),

(
	'Sci-Fi',
	'Sci-Fi',
	'Alex',
	GETDATE()
),

(
	'Biography',
	'Biography',
	'Alex',
	GETDATE()
),

(
	'Musical',
	'Musical',
	'Alex',
	GETDATE()
),

(
	'Animation',
	'Animation',
	'Alex',
	GETDATE()
),

(
	'Comedy',
	'Comedy',
	'Alex',
	GETDATE()
),

(
	'Fantasy',
	'Fantasy',
	'Alex',
	GETDATE()
);

INSERT INTO PbMovieActor
(
	pbMovie_id,
	pbActor_id,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'John'
	AND actorLastName = 'Wayne'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Glen'
	AND actorLastName = 'Campbell'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'John'
	AND actorLastName = 'Wayne'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Dean'
	AND actorLastName = 'Martin'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Robert'
	AND actorLastName = 'Downey Jr'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Chris'
	AND actorLastName = 'Evans'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Hugh'
	AND actorLastName = 'Jackman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Michelle'
	AND actorLastName = 'Williams'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Patrick'
	AND actorLastName = 'Stewart'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Hugh'
	AND actorLastName = 'Jackman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Craig T'
	AND actorLastName = 'Nelson'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Holly'
	AND actorLastName = 'Hunter'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Ryan'
	AND actorLastName = 'Reynolds'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Morena'
	AND actorLastName = 'Baccarin'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Mark'
	AND actorLastName = 'Hamill'),
	'Alex',
	GETDATE()
),


(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbActor_id FROM PbActor
	WHERE actorFirstName = 'Carrie'
	AND actorLastName = 'Fisher'),
	'Alex',
	GETDATE()
);

INSERT INTO PbMovieKeyword
(
	pbKeyword_id,
	pbMovie_id,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Rooster Cogburn'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'US Marshal'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Oscar Award Winner'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Gun Fighter'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Family'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Captain America'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Iron Man'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Thor'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Circus'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Barnum'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Singing'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Million Dreams'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Wolverine'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Mutants'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Elastigirl'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Dash'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Jack Jack'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Mercenary'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Morbid'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'healing power'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Jedi Knight'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Darth Vader'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbKeyword_id FROM PbKeyword
	WHERE Keyword = 'Yoda'),
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	'Alex',
	GETDATE()
);

INSERT INTO PbMovieDirector
(
	pbMovie_id,
	pbDirector_id,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Henry'
	AND directorLastName = 'Hathaway'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Henry'
	AND directorLastName = 'Hathaway'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Joss'
	AND directorLastName = 'Whedon'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Michael'
	AND directorLastName = 'Gracey'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Bryan'
	AND directorLastName = 'Singer'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Brad'
	AND directorLastName = 'Bird'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'Tim'
	AND directorLastName = 'Miller'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbDirector_id FROM PbDirector
	WHERE directorFirstName = 'George'
	AND directorLastName = 'Lucas'),
	'Alex',
	GETDATE()
);

INSERT INTO PbMovieGenre
(
	pbMovie_id,
	pbGenre_id,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Drama'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Western'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Western'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Sci-Fi'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Biography'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Drama'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Greatest Showman'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Musical'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'X-Men'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Sci-Fi'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Incredibles 2'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Animation'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Deadpool'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Comedy'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Action'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Adventure'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'Star Wars: Episode IV - New Hope'),
	(SELECT pbGenre_id FROM PbGenre
	WHERE genre = 'Fantasy'),
	'Alex',
	GETDATE()
);


INSERT INTO PbMovieReservation
(
	pbMovie_id,
	movieType,
	reservationDate,
	reservationStatus,
	pbUser_id,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	'D',
	GETDATE(),
	'P',
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'True Grit'),
	'B',
	GETDATE(),
	'P',
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	'D',
	GETDATE(),
	'P',
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Sons of Katie Elder'),
	'B',
	GETDATE(),
	'P',
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovie_id FROM PbMovie
	WHERE movieTitle = 'The Avengers'),
	'D',
	GETDATE(),
	'P',
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	'Alex',
	GETDATE()
);

INSERT INTO PbMovieRental
(
	pbMovieItem_id,
	pbUser_id,
	rentalDate,
	dueDate,
	lastUpdatedBy,
	lastUpdatedDate
)

VALUES
(
	(SELECT pbMovieItem_id FROM PbMovieItem
	WHERE pbMovie_id = (SELECT pbMovie_id FROM
	PbMovie WHERE movieTitle = 'The Avengers')
	AND copyNumber = 1 AND movieType = 'B'),
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	GETDATE(),
	DATEADD(day, 3, GETDATE()),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovieItem_id FROM PbMovieItem
	WHERE pbMovie_id = (SELECT pbMovie_id FROM
	PbMovie WHERE movieTitle = 'The Avengers')
	AND copyNumber = 2 AND movieType = 'B'),
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	GETDATE(),
	DATEADD(day, 3, GETDATE()),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovieItem_id FROM PbMovieItem
	WHERE pbMovie_id = (SELECT pbMovie_id FROM
	PbMovie WHERE movieTitle = 'Greatest Showman')
	AND copyNumber = 1 AND movieType = 'D'),
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	GETDATE(),
	DATEADD(day, 3, GETDATE()),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovieItem_id FROM PbMovieItem
	WHERE pbMovie_id = (SELECT pbMovie_id FROM
	PbMovie WHERE movieTitle = 'Greatest Showman')
	AND copyNumber = 2 AND movieType = 'D'),
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	GETDATE(),
	DATEADD(day, 3, GETDATE()),
	'Alex',
	GETDATE()
),

(
	(SELECT pbMovieItem_id FROM PbMovieItem
	WHERE pbMovie_id = (SELECT pbMovie_id FROM
	PbMovie WHERE movieTitle = 'Greatest Showman')
	AND copyNumber = 1 AND movieType = 'B'),
	(SELECT pbUser_id FROM PBUser
	WHERE userID = 'PB0000002'),
	GETDATE(),
	DATEADD(day, 3, GETDATE()),
	'Alex',
	GETDATE()
);


SELECT * FROM PbUser;
SELECT * FROM PbUserQuestion;
SELECT * FROM PbQuestion;
SELECT * FROM PbMovieRental;
SELECT * FROM PbMovieReservation;
SELECT * FROM PbMovieItem;
SELECT * FROM PbMovie;
SELECT * FROM PbActor;
SELECT * FROM PbMovieActor;
SELECT * FROM PbKeyword;
SELECT * FROM PbMovieKeyword;
SELECT * FROM PbDirector;
SELECT * FROM PbMovieDirector;
SELECT * FROM PbGenre;
SELECT * FROM PbMovieGenre;