Create DATABASE JellyCinema;
USE JellyCinema;

Grant all PRIVILEGES on JellyCinema.* to 'jelly'@'%';

SET GLOBAL log_bin_trust_function_creators = 1;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE Admin
(
    AdminID      INT auto_increment NOT NULL,
    first        varchar(40)        NOT NULL,
    last         varchar(40)        NOT NULL,
    email        varchar(50)        NOT NULL,
    birthdate    DATE               NOT NULL,
    password     varchar(40)        NOT NULL,
    dateJoined   DATETIME DEFAULT CURRENT_TIMESTAMP,
    lastActivity DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (AdminID)
);

CREATE TABLE User
(
    UserID       INT auto_increment NOT NULL,
    first        varchar(40)        NOT NULL,
    last         varchar(40)        NOT NULL,
    email        varchar(50)        NOT NULL,
    birthdate    DATE               NOT NULL,
    password     varchar(40)        NOT NULL,
    dateJoined   DATETIME DEFAULT CURRENT_TIMESTAMP,
    lastActivity DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID)
);

CREATE TABLE Critic
(
    CriticID     INT auto_increment NOT NULL,
    first        varchar(40)        NOT NULL,
    last         varchar(40)        NOT NULL,
    email        varchar(50)        NOT NULL,
    birthdate    Date               NOT NULL,
    password     varchar(40)        NOT NULL,
    dateJoined   DATETIME DEFAULT CURRENT_TIMESTAMP,
    lastActivity DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (CriticID)
);

CREATE TABLE UserAdmin
(
    UserID  INT NOT NULL,
    AdminID INT NOT NULL,
    PRIMARY KEY (UserID, AdminID),
    CONSTRAINT fk_1
        foreign key (UserID) references User (UserID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_2
        foreign key (AdminID) references Admin (AdminID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE CriticAdmin
(
    CriticID INT NOT NULL,
    AdminID  INT NOT NULL,
    PRIMARY KEY (CriticID, AdminID),
    CONSTRAINT fk_3
        foreign key (CriticID) references Critic (CriticID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_4
        foreign key (AdminID) references Admin (AdminID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Series
(
    SeriesID INT auto_increment NOT NULL,
    title    varchar(40)        NOT NULL,
    PRIMARY KEY (SeriesID)
);

CREATE TABLE Movie
(
    MovieID     INT auto_increment NOT NULL,
    title       varchar(100)       NOT NULL,
    runtime     INT                NOT NULL,
    releaseDate DATE               NOT NULL,
    IMDBRating  Double(4, 2)       NOT NULL,
    description TEXT               NOT NULL,
    trailer     varchar(100)       NOT NULL,
    image       TEXT               NOT NULL,
    seriesID    INT,
    PRIMARY KEY (MovieID),
    CONSTRAINT rating_1 CHECK (IMDBRating between 0 and 10),
    CONSTRAINT fk_5
        FOREIGN KEY (seriesID) REFERENCES Series (seriesID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE MovieLike
(
    MovieID INT NOT NULL,
    UserID  INT NOT NULL,
    PRIMARY KEY (MovieID, UserID),
    CONSTRAINT fk_6
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_7
        FOREIGN KEY (UserID) REFERENCES User (UserID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE MovieRating
(
    MovieID  INT          NOT NULL,
    CriticID INT          NOT NULL,
    Rating   DOUBLE(4, 2) NOT NULL,
    Comment  TEXT         NOT NULL,
    Date     DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MovieID, CriticID, Rating),
    CONSTRAINT fk_8
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_9
        FOREIGN KEY (CriticID) REFERENCES Critic (CriticID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT rating_10 CHECK (Rating between 0 and 10)
);

CREATE TABLE MovieGenre
(
    GenreID INT auto_increment NOT NULL,
    name    varchar(40)        NOT NULL,
    PRIMARY KEY (GenreID)
);

CREATE TABLE MGenre
(
    MovieID INT NOT NULL,
    GenreID INT NOT NULL,
    PRIMARY KEY (MovieID, GenreID),
    CONSTRAINT fk_10
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_11
        FOREIGN KEY (GenreID) REFERENCES MovieGenre (GenreID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE TVShow
(
    ShowID      INT auto_increment NOT NULL,
    title       varchar(80)        NOT NULL,
    description TEXT               NOT NULL,
    IMDBRating  Double(4, 2)       NOT NULL,
    image       TEXT               NOT NULL,
    PRIMARY KEY (ShowID),
    CONSTRAINT rating_3 CHECK (IMDBRating between 0 and 10)
);

CREATE TABLE TVGenre
(
    GenreID INT auto_increment NOT NULL,
    name    varchar(40)        NOT NULL,
    PRIMARY KEY (GenreID)
);

CREATE TABLE TGenre
(
    ShowID  INT NOT NULL,
    GenreID INT NOT NULL,
    PRIMARY KEY (ShowID, GenreID),
    CONSTRAINT fk_12
        FOREIGN KEY (ShowID) REFERENCES TVShow (ShowID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_13
        FOREIGN KEY (GenreID) REFERENCES TVGenre (GenreID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE TVLike
(
    ShowID INT NOT NULL,
    UserID INT NOT NULL,
    PRIMARY KEY (ShowID, UserID),
    CONSTRAINT fk_14
        FOREIGN KEY (ShowID) REFERENCES TVShow (ShowID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_15
        FOREIGN KEY (UserID) REFERENCES User (UserID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE TVRating
(
    ShowID   INT          NOT NULL,
    CriticID INT          NOT NULL,
    Rating   DOUBLE(4, 2) NOT NULL,
    Comment  TEXT         NOT NULL,
    Date     DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ShowID, CriticID, Rating),
    CONSTRAINT fk_16
        FOREIGN KEY (ShowID) REFERENCES TVShow (ShowID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_17
        FOREIGN KEY (CriticID) REFERENCES Critic (CriticID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Season
(
    SeasonID INT auto_increment NOT NULL,
    title    TEXT               NOT NULL,
    ShowID   INT                NOT NULL,
    PRIMARY KEY (SeasonID),
    CONSTRAINT fk_18
        FOREIGN KEY (ShowID) REFERENCES TVShow (ShowID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Episode
(
    EpID        INT auto_increment NOT NULL,
    title       varchar(80)        NOT NULL,
    runtime     INT                NOT NULL,
    releaseDate DATE               NOT NULL,
    description TEXT               NOT NULL,
    SeasonID    INT,
    PRIMARY KEY (EpID),
    CONSTRAINT fk_19
        FOREIGN KEY (SeasonID) REFERENCES Season (SeasonID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE FavList
(
    ListID   INT auto_increment NOT NULL,
    name     varchar(40)        NOT NULL,
    CriticID INT                NOT NULL,
    PRIMARY KEY (ListID),
    CONSTRAINT fk_35
        FOREIGN KEY (CriticID) REFERENCES Critic (CriticID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE FavMovie
(
    ListID  INT NOT NULL,
    MovieID INT NOT NULL,
    ranks   INT NOT NULL,
    CONSTRAINT rating_4 CHECK (ranks between 0 and 10),
    PRIMARY KEY (ListID, MovieID),
    CONSTRAINT fk_20
        FOREIGN KEY (ListID) REFERENCES FavList (ListID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_21
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE FavShow
(
    ListID INT NOT NULL,
    ShowID INT NOT NULL,
    ranks  INT NOT NULL,
    CONSTRAINT rating_30 CHECK (ranks between 0 and 10),
    PRIMARY KEY (ListID, ShowID),
    CONSTRAINT fk_22
        FOREIGN KEY (ListID) REFERENCES FavList (ListID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_23
        FOREIGN KEY (ShowID) REFERENCES TVShow (ShowID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Actor
(
    ActorID   INT auto_increment NOT NULL,
    first     varchar(40)        NOT NULL,
    last      varchar(40)        NOT NULL,
    birthdate DATE               NOT NULL,
    hometown  varchar(40)        NOT NULL,
    country   varchar(40)        NOT NULL,
    PRIMARY KEY (ActorID)
);

CREATE TABLE MovieAct
(
    MovieID        INT         NOT NULL,
    ActorID        INT         NOT NULL,
    characterFirst varchar(40) NOT NULL,
    characterLast  varchar(40) NOT NULL,
    PRIMARY KEY (MovieID, ActorID),
    CONSTRAINT fk_24
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_25
        FOREIGN KEY (ActorID) REFERENCES Actor (ActorID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE ShowAct
(
    EpID           INT         NOT NULL,
    ActorID        INT         NOT NULL,
    characterFirst varchar(40) NOT NULL,
    characterLast  varchar(40) NOT NULL,
    PRIMARY KEY (EpID, ActorID),
    CONSTRAINT fk_26
        FOREIGN KEY (EpID) REFERENCES Episode (EpID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_27
        FOREIGN KEY (ActorID) REFERENCES Actor (ActorID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE Director
(
    DirID     INT auto_increment NOT NULL,
    first     varchar(40)        NOT NULL,
    last      varchar(40)        NOT NULL,
    birthdate DATE               NOT NULL,
    hometown  varchar(100)       NOT NULL,
    country   varchar(40)        NOT NULL,
    PRIMARY KEY (DirID)
);

CREATE TABLE MovieDir
(
    MovieID INT NOT NULL,
    DirID   INT NOT NULL,
    PRIMARY KEY (MovieID, DirID),
    CONSTRAINT fk_28
        FOREIGN KEY (MovieID) REFERENCES Movie (MovieID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_29
        FOREIGN KEY (DirID) REFERENCES Director (DirID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE ShowDir
(
    EpID  INT NOT NULL,
    DirID INT NOT NULL,
    PRIMARY KEY (EpID, DirID),
    CONSTRAINT fk_30
        FOREIGN KEY (EpID) REFERENCES Episode (EpID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,
    CONSTRAINT fk_31
        FOREIGN KEY (DirID) REFERENCES Director (DirID)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

insert into Admin (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Eadie', 'Fridlington', 'efridlington0@prnewswire.com', '1985-09-11', 'ZGnsRb3P4hK', '2021-01-23 19:17:00',
        '2022-07-13 02:24:48');
insert into Admin (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Kristine', 'Sinkin', 'ksinkin1@paypal.com', '2003-12-15', 'Kzkwhi', '2020-12-29 20:55:44',
        '2022-10-23 17:18:11');
insert into Admin (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Garrik', 'Sprull', 'gsprull2@barnesandnoble.com', '1990-06-23', 'gHguWG7wKDE', '2021-03-14 11:17:23',
        '2022-07-08 16:27:52');

insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Tamqrah', 'Van Rembrandt', 'tvanrembrandt0@behance.net', '1995-10-04', 'Vfr9b2YLw', '2020-05-19 11:34:46',
        '2022-11-10 20:09:58');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Corina', 'Woodwin', 'cwoodwin1@about.com', '1986-03-18', 'KXQzo1j2M', '2020-08-17 19:49:15',
        '2022-06-10 10:12:25');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Dean', 'Arthy', 'darthy2@tiny.cc', '1981-10-26', '4soN0GP', '2020-06-19 03:21:30', '2022-01-17 14:54:45');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Laina', 'Carabine', 'lcarabine3@auda.org.au', '2004-11-09', '4mQxwbw9ECp', '2020-10-08 09:03:09',
        '2022-08-08 04:15:05');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Albrecht', 'MacWhan', 'amacwhan4@spotify.com', '2001-12-22', 'wEI75HJhtHqa', '2021-02-13 07:14:44',
        '2022-01-08 05:02:12');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Vi', 'Ortzen', 'vortzen5@tuttocitta.it', '1983-10-06', 'ejeb8wSYf', '2020-09-26 23:34:20',
        '2022-03-13 22:53:47');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Jo ann', 'Zanazzi', 'jzanazzi6@ebay.co.uk', '1988-07-24', 'i82dmQ5kgUi', '2021-08-02 17:33:07',
        '2022-05-07 19:52:03');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Madella', 'Goroni', 'mgoroni7@nsw.gov.au', '2001-01-22', 'drYE4J', '2021-10-20 22:45:13',
        '2022-09-25 18:46:46');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Lulu', 'Jacks', 'ljacks8@blog.com', '1999-04-02', 'xVhtbPGVz', '2021-10-05 10:40:35', '2022-06-04 15:35:08');
insert into User (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Alikee', 'Shatliff', 'ashatliff9@ed.gov', '2002-08-04', '2pjfEw', '2021-03-05 05:21:36',
        '2022-07-29 01:35:19');

insert into Critic (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Bryanty', 'Starzaker', 'bstarzaker0@delicious.com', '1984-08-18', 'oemTUt5F', '2021-06-15 06:55:44',
        '2022-04-25 08:31:47');
insert into Critic (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Waverley', 'Fieldgate', 'wfieldgate1@mac.com', '1996-04-09', 'fZGvnDP9agsE', '2020-11-19 19:28:47',
        '2022-03-13 04:34:40');
insert into Critic (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Tudor', 'Whisker', 'twhisker2@apple.com', '1985-12-28', 'uRX8ul5', '2021-04-16 19:31:18',
        '2022-05-29 16:44:25');
insert into Critic (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Dasi', 'Hallawell', 'dhallawell3@desdev.cn', '1983-07-04', 'gjdejUJ8', '2020-11-18 19:02:07',
        '2022-03-24 14:39:34');
insert into Critic (first, last, email, birthdate, password, dateJoined, lastActivity)
values ('Morgun', 'Wraith', 'mwraith4@altervista.org', '1994-04-25', 'hnt3kCiPcJ', '2021-08-15 08:51:51',
        '2022-09-25 11:27:25');

insert into Actor (first, last, birthdate, hometown, country)
values ('Ranique', 'Andreucci', '2000-03-31', 'Jiangyin', 'China');
insert into Actor (first, last, birthdate, hometown, country)
values ('Timothee', 'Ollie', '1984-05-09', 'Tilburg', 'Netherlands');
insert into Actor (first, last, birthdate, hometown, country)
values ('Bartolemo', 'Delieu', '1986-04-23', 'Pende', 'Indonesia');
insert into Actor (first, last, birthdate, hometown, country)
values ('Nancie', 'Knappe', '1980-07-14', 'Chaiwan', 'China');
insert into Actor (first, last, birthdate, hometown, country)
values ('Tybie', 'McEllen', '2000-01-16', 'Porto Ferreira', 'Brazil');
insert into Actor (first, last, birthdate, hometown, country)
values ('Jarrid', 'Brake', '1982-01-21', 'Shenjing', 'China');
insert into Actor (first, last, birthdate, hometown, country)
values ('Corenda', 'Di Matteo', '1992-01-03', 'São Pedro da Aldeia', 'Brazil');
insert into Actor (first, last, birthdate, hometown, country)
values ('Violette', 'Weond', '1998-11-05', 'Sombor', 'Serbia');
insert into Actor (first, last, birthdate, hometown, country)
values ('Cherlyn', 'Buckel', '1997-01-06', 'San Pedro', 'Mexico');
insert into Actor (first, last, birthdate, hometown, country)
values ('Kylynn', 'Wickersham', '1995-12-24', 'Kinsealy-Drinan', 'Ireland');
insert into Actor (first, last, birthdate, hometown, country)
values ('Hanny', 'Boarleyson', '1981-11-27', 'Viljakkala', 'Finland');
insert into Actor (first, last, birthdate, hometown, country)
values ('Elvis', 'McGairl', '1986-03-28', 'Khadīr', 'Afghanistan');
insert into Actor (first, last, birthdate, hometown, country)
values ('Mella', 'Foulsham', '2004-10-13', 'Stary Sącz', 'Poland');
insert into Actor (first, last, birthdate, hometown, country)
values ('Josepha', 'Bulbeck', '1998-11-11', 'Soi Dao', 'Thailand');
insert into Actor (first, last, birthdate, hometown, country)
values ('Jeane', 'Krates', '1995-01-13', 'Kỳ Anh', 'Vietnam');
insert into Actor (first, last, birthdate, hometown, country)
values ('Jannelle', 'Cowles', '1981-08-09', 'Lafayette', 'United States');
insert into Actor (first, last, birthdate, hometown, country)
values ('Coop', 'Semiras', '1990-03-15', 'Strömsnäsbruk', 'Sweden');
insert into Actor (first, last, birthdate, hometown, country)
values ('Abbye', 'Chalk', '1986-10-13', 'Jieshi', 'China');
insert into Actor (first, last, birthdate, hometown, country)
values ('Cristabel', 'Scarlan', '2003-03-09', 'Uyugan', 'Philippines');
insert into Actor (first, last, birthdate, hometown, country)
values ('Frankie', 'Bowe', '1990-10-23', 'Bodeh', 'Indonesia');

insert into Director (first, last, birthdate, hometown, country)
values ('Celka', 'Ahrendsen', '1991-10-13', 'Ljubovija', 'Serbia');
insert into Director (first, last, birthdate, hometown, country)
values ('Cristie', 'Coonihan', '1990-02-08', 'Wiang Chiang Rung', 'Thailand');
insert into Director (first, last, birthdate, hometown, country)
values ('Pippo', 'Zettler', '2000-10-20', 'Beloostrov', 'Russia');
insert into Director (first, last, birthdate, hometown, country)
values ('Ezekiel', 'Matysiak', '1991-03-12', 'Apitong', 'Philippines');
insert into Director (first, last, birthdate, hometown, country)
values ('Charmain', 'McGrady', '2000-04-28', 'Guanyinsi', 'China');
insert into Director (first, last, birthdate, hometown, country)
values ('Desi', 'Hubbert', '1987-04-29', 'Xilian', 'China');
insert into Director (first, last, birthdate, hometown, country)
values ('Ellerey', 'Brookz', '1980-09-09', 'Les Abymes', 'Guadeloupe');
insert into Director (first, last, birthdate, hometown, country)
values ('Ashlin', 'Doidge', '2003-06-10', 'Aghavnatun', 'Armenia');
insert into Director (first, last, birthdate, hometown, country)
values ('Chadwick', 'Halleday', '1987-03-09', 'Kendalngupuk', 'Indonesia');
insert into Director (first, last, birthdate, hometown, country)
values ('Teirtza', 'Hallatt', '1994-09-28', 'Birr', 'Ireland');

insert into Season (title, ShowID)
values ('21 Jump Street', 80);
insert into Season (title, ShowID)
values ('Comet', 4);
insert into Season (title, ShowID)
values ('Sacro GRA', 32);
insert into Season (title, ShowID)
values ('Slammin'' Salmon, The', 51);
insert into Season (title, ShowID)
values ('Listy do M.', 83);
insert into Season (title, ShowID)
values ('Forgiving Dr. Mengele', 23);
insert into Season (title, ShowID)
values ('Demonic', 35);
insert into Season (title, ShowID)
values ('Book Thief, The', 21);
insert into Season (title, ShowID)
values ('Bucket List, The', 99);
insert into Season (title, ShowID)
values ('Silmido', 52);
insert into Season (title, ShowID)
values ('Ernest Film Festival, The', 78);
insert into Season (title, ShowID)
values ('Signs of Life (Lebenszeichen)', 29);
insert into Season (title, ShowID)
values ('Commune', 77);
insert into Season (title, ShowID)
values ('Bridal Party in Hardanger, The (Brudeferden i Hardanger)', 2);
insert into Season (title, ShowID)
values ('Too Late Blues', 33);
insert into Season (title, ShowID)
values ('Incantato (Il cuore altrove)', 36);
insert into Season (title, ShowID)
values ('What? (Che?)', 5);
insert into Season (title, ShowID)
values ('Good Bye (Bé omid é didar)', 65);
insert into Season (title, ShowID)
values ('Captain January', 60);
insert into Season (title, ShowID)
values ('Kung Phooey!', 90);
insert into Season (title, ShowID)
values ('Port of Call (Hamnstad)', 98);
insert into Season (title, ShowID)
values ('Swept Away', 6);
insert into Season (title, ShowID)
values ('Little Nicky', 31);
insert into Season (title, ShowID)
values ('Blue Thunder', 16);
insert into Season (title, ShowID)
values ('Winter of Discontent', 22);
insert into Season (title, ShowID)
values ('Diario de un skin', 84);
insert into Season (title, ShowID)
values ('Gang Related', 88);
insert into Season (title, ShowID)
values ('Strange Wilderness', 12);
insert into Season (title, ShowID)
values ('Hercules and the Circle of Fire', 66);
insert into Season (title, ShowID)
values ('Joe Kidd', 75);
insert into Season (title, ShowID)
values ('Carcasses', 44);
insert into Season (title, ShowID)
values ('On My Way (Elle s''en va)', 28);
insert into Season (title, ShowID)
values ('Brokedown Palace', 87);
insert into Season (title, ShowID)
values ('Wolf of Wall Street, The', 81);
insert into Season (title, ShowID)
values ('Housekeeper, The (femme de ménage, Une)', 97);
insert into Season (title, ShowID)
values ('Until September', 38);
insert into Season (title, ShowID)
values ('Maya Lin: A Strong Clear Vision', 22);
insert into Season (title, ShowID)
values ('Pretty Woman', 51);
insert into Season (title, ShowID)
values ('Edge of Seventeen', 5);
insert into Season (title, ShowID)
values ('Murder on the Orient Express', 70);
insert into Season (title, ShowID)
values ('Splitting Heirs', 12);
insert into Season (title, ShowID)
values ('Siblings', 50);
insert into Season (title, ShowID)
values ('Messages Deleted', 89);
insert into Season (title, ShowID)
values ('Conan O''Brien Can''t Stop', 81);
insert into Season (title, ShowID)
values ('Boy Friend, The', 95);
insert into Season (title, ShowID)
values ('Waking Ned Devine (a.k.a. Waking Ned)', 55);
insert into Season (title, ShowID)
values ('Forbidden City Cop (Dai lap mat tam 008)', 50);
insert into Season (title, ShowID)
values ('East, The', 59);
insert into Season (title, ShowID)
values ('Count Three and Pray', 98);
insert into Season (title, ShowID)
values ('Towering Inferno, The', 56);
insert into Season (title, ShowID)
values ('FBI Story, The', 64);
insert into Season (title, ShowID)
values ('Science and Islam', 36);
insert into Season (title, ShowID)
values ('Up in the Wind', 21);
insert into Season (title, ShowID)
values ('Love and Other Troubles', 66);
insert into Season (title, ShowID)
values ('Hoodwinked!', 80);
insert into Season (title, ShowID)
values ('Long and Short of It, The', 99);
insert into Season (title, ShowID)
values ('Private Property (Nue propriété)', 97);
insert into Season (title, ShowID)
values ('Voodoo Tiger', 47);
insert into Season (title, ShowID)
values ('Tube Tales', 96);
insert into Season (title, ShowID)
values ('(Untitled)', 72);
insert into Season (title, ShowID)
values ('Christmas Party, The (Joulubileet)', 15);
insert into Season (title, ShowID)
values ('Prince Avalanche', 90);
insert into Season (title, ShowID)
values ('Marathon Family, The (Maratonci Trce Pocasni Krug)', 47);
insert into Season (title, ShowID)
values ('Captive (Cautiva) ', 49);
insert into Season (title, ShowID)
values ('Junebug', 33);
insert into Season (title, ShowID)
values ('Joyride', 52);
insert into Season (title, ShowID)
values ('Satan''s Sword (Daibosatsu tôge)', 99);
insert into Season (title, ShowID)
values ('Rollerball', 19);
insert into Season (title, ShowID)
values ('Backlash', 68);
insert into Season (title, ShowID)
values ('Speed', 39);
insert into Season (title, ShowID)
values ('Transylvania 6-5000', 86);
insert into Season (title, ShowID)
values ('Suzanne''s Diary for Nicholas', 17);
insert into Season (title, ShowID)
values ('Sunday Bloody Sunday', 38);
insert into Season (title, ShowID)
values ('Perfect Host, The', 93);
insert into Season (title, ShowID)
values ('My Father and My Son (Babam ve oglum)', 71);
insert into Season (title, ShowID)
values ('Bathory', 100);
insert into Season (title, ShowID)
values ('Blade', 22);
insert into Season (title, ShowID)
values ('Caravaggio', 2);
insert into Season (title, ShowID)
values ('My Life in Orange (Sommer in Orange)', 53);
insert into Season (title, ShowID)
values ('Single White Female 2: The Psycho', 50);
insert into Season (title, ShowID)
values ('Skin Deep', 80);
insert into Season (title, ShowID)
values ('22 Jump Street', 80);
insert into Season (title, ShowID)
values ('Fortune Cookie, The', 61);
insert into Season (title, ShowID)
values ('Childhood of Maxim Gorky, The (Detstvo Gorkogo)', 43);
insert into Season (title, ShowID)
values ('Pleasures of the Flesh (Etsuraku)', 35);
insert into Season (title, ShowID)
values ('7 Dwarves: The Forest Is Not Enough', 50);
insert into Season (title, ShowID)
values ('Heaven''s Burning', 4);
insert into Season (title, ShowID)
values ('Bhaji on the Beach', 13);
insert into Season (title, ShowID)
values ('Small Town Murder Songs', 16);
insert into Season (title, ShowID)
values ('Kauwboy', 71);
insert into Season (title, ShowID)
values ('Dinner Rush', 28);
insert into Season (title, ShowID)
values ('Happy Times (Xingfu shiguang)', 71);
insert into Season (title, ShowID)
values ('Here on Earth', 92);
insert into Season (title, ShowID)
values ('Ten Violent Women', 88);
insert into Season (title, ShowID)
values ('Out Late ', 9);
insert into Season (title, ShowID)
values ('All Is Forgiven (Tout est pardonné)', 29);
insert into Season (title, ShowID)
values ('Fourth State, The (Die vierte Macht)', 61);
insert into Season (title, ShowID)
values ('Telephone, The', 46);
insert into Season (title, ShowID)
values ('Howling V: The Rebirth', 75);
insert into Season (title, ShowID)
values ('Don''t Give Up the Ship', 14);
insert into Season (title, ShowID)
values ('Out of Africa', 33);
insert into Season (title, ShowID)
values ('Smart Set, The', 97);
insert into Season (title, ShowID)
values ('All About My Mother (Todo sobre mi madre)', 10);
insert into Season (title, ShowID)
values ('Attack of the 50ft Cheerleader', 59);
insert into Season (title, ShowID)
values ('Shadowzone', 75);
insert into Season (title, ShowID)
values ('Satan''s Brew (Satansbraten)', 17);
insert into Season (title, ShowID)
values ('Jump Tomorrow', 48);
insert into Season (title, ShowID)
values ('King Is Dead!, The', 15);
insert into Season (title, ShowID)
values ('After Life (Wandafuru raifu)', 76);
insert into Season (title, ShowID)
values ('Chang: A Drama of the Wilderness', 18);
insert into Season (title, ShowID)
values ('Flodder', 81);
insert into Season (title, ShowID)
values ('Marlowe', 4);
insert into Season (title, ShowID)
values ('A Walk in the Woods', 99);
insert into Season (title, ShowID)
values ('First Man Into Space', 68);
insert into Season (title, ShowID)
values ('Lovers on the Bridge, The (Amants du Pont-Neuf, Les)', 74);
insert into Season (title, ShowID)
values ('Rich in Love', 64);
insert into Season (title, ShowID)
values ('Attack of the 50ft Cheerleader', 31);
insert into Season (title, ShowID)
values ('Adventures of Priscilla, Queen of the Desert, The', 41);
insert into Season (title, ShowID)
values ('Hell of a Day, A (Reines d''un jour)', 99);
insert into Season (title, ShowID)
values ('They Shoot Horses, Don''t They?', 37);
insert into Season (title, ShowID)
values ('Bay of Blood (a.k.a. Twitch of the Death Nerve) (Reazione a catena)', 31);
insert into Season (title, ShowID)
values ('Great Train Robbery, The', 92);
insert into Season (title, ShowID)
values ('Thunderbirds Are GO', 19);
insert into Season (title, ShowID)
values ('Magic in the Moonlight', 53);
insert into Season (title, ShowID)
values ('Magdalene Sisters, The', 30);
insert into Season (title, ShowID)
values ('Is It Easy to be Young?', 73);
insert into Season (title, ShowID)
values ('Magic Christian, The', 82);
insert into Season (title, ShowID)
values ('Trumpet of the Swan, The', 82);
insert into Season (title, ShowID)
values ('Polyester', 35);
insert into Season (title, ShowID)
values ('Looking for Hortense (Cherchez Hortense) ', 88);
insert into Season (title, ShowID)
values ('Malibu''s Most Wanted', 15);
insert into Season (title, ShowID)
values ('Kill Your Darlings', 50);
insert into Season (title, ShowID)
values ('Pearl Jam Twenty', 38);
insert into Season (title, ShowID)
values ('And Now... Ladies and Gentlemen...', 20);
insert into Season (title, ShowID)
values ('Tough Guys', 33);
insert into Season (title, ShowID)
values ('Grey Gardens', 22);
insert into Season (title, ShowID)
values ('Three Wise Fools', 44);
insert into Season (title, ShowID)
values ('Shadows Over Chinatown', 9);
insert into Season (title, ShowID)
values ('Summer Interlude (Sommarlek)', 51);
insert into Season (title, ShowID)
values ('Morgen', 6);
insert into Season (title, ShowID)
values ('Who Do I Gotta Kill?', 51);
insert into Season (title, ShowID)
values ('9 Songs', 92);
insert into Season (title, ShowID)
values ('Poison Ivy: New Seduction', 51);
insert into Season (title, ShowID)
values ('Fur: An Imaginary Portrait of Diane Arbus', 50);
insert into Season (title, ShowID)
values ('Swamp, The (Ciénaga, La)', 15);
insert into Season (title, ShowID)
values ('Becky Sharp', 60);
insert into Season (title, ShowID)
values ('Lonely Are the Brave', 78);
insert into Season (title, ShowID)
values ('Murmur of the Heart (Le souffle au coeur)', 42);
insert into Season (title, ShowID)
values ('Trust the Man', 65);
insert into Season (title, ShowID)
values ('Ironclad 2: Battle for Blood', 29);
insert into Season (title, ShowID)
values ('Lazybones', 14);
insert into Season (title, ShowID)
values ('My Father the Hero (Mon père, ce héros.)', 48);
insert into Season (title, ShowID)
values ('Never Back Down', 64);
insert into Season (title, ShowID)
values ('Daddy Day Care', 23);
insert into Season (title, ShowID)
values ('They Died with Their Boots On', 92);
insert into Season (title, ShowID)
values ('Family Jewels, The (Eierdiebe)', 67);
insert into Season (title, ShowID)
values ('Score: A Hockey Musical', 97);
insert into Season (title, ShowID)
values ('Grandmaster, The (Yi dai zong shi)', 49);
insert into Season (title, ShowID)
values ('Big Lift, The', 63);
insert into Season (title, ShowID)
values ('Mystery, Alaska', 74);
insert into Season (title, ShowID)
values ('Teenage Mutant Ninja Turtles: Turtles Forever', 36);
insert into Season (title, ShowID)
values ('Funny Games', 59);
insert into Season (title, ShowID)
values ('Devil''s Chair, The', 2);
insert into Season (title, ShowID)
values ('Tarzan', 13);
insert into Season (title, ShowID)
values ('The First Movie', 79);
insert into Season (title, ShowID)
values ('Stargate', 50);
insert into Season (title, ShowID)
values ('Unholy Wife, The', 98);
insert into Season (title, ShowID)
values ('End of Summer, The (Early Autumn) (Kohayagawa-ke no aki)', 13);
insert into Season (title, ShowID)
values ('These Girls', 11);
insert into Season (title, ShowID)
values ('14 Blades (Jin yi wei)', 96);
insert into Season (title, ShowID)
values ('Village of the Damned', 49);
insert into Season (title, ShowID)
values ('Winning Streak', 55);
insert into Season (title, ShowID)
values ('Passion', 40);
insert into Season (title, ShowID)
values ('Covert Action', 43);
insert into Season (title, ShowID)
values ('Swan Princess, The', 72);
insert into Season (title, ShowID)
values ('Message from Akira Kurosawa: For Beautiful Movies, A (Kurosawa Akira kara no messêji: Utsukushii eiga o)', 71);
insert into Season (title, ShowID)
values ('Replacements, The', 54);
insert into Season (title, ShowID)
values ('Repeaters ', 7);
insert into Season (title, ShowID)
values ('Battleground', 24);
insert into Season (title, ShowID)
values ('Afterwards', 58);
insert into Season (title, ShowID)
values ('Blue Crush', 19);
insert into Season (title, ShowID)
values ('The Do-Deca-Pentathlon', 43);
insert into Season (title, ShowID)
values ('Charlie Chan in Shanghai', 92);
insert into Season (title, ShowID)
values ('The Raid 2: Berandal', 30);
insert into Season (title, ShowID)
values ('Pont du Nord, Le', 15);
insert into Season (title, ShowID)
values ('Man Who Would Be King, The', 51);
insert into Season (title, ShowID)
values ('Song of Sparrows, The (Avaze gonjeshk-ha)', 19);
insert into Season (title, ShowID)
values ('They Call Me Trinity', 4);
insert into Season (title, ShowID)
values ('Mabel''s Married Life', 42);
insert into Season (title, ShowID)
values ('Centurion', 13);
insert into Season (title, ShowID)
values ('Long Absence, The (Une aussi longue absence)', 67);
insert into Season (title, ShowID)
values ('The Big Cube', 22);
insert into Season (title, ShowID)
values ('Hysteria', 22);
insert into Season (title, ShowID)
values ('Naturally Native', 6);
insert into Season (title, ShowID)
values ('Cure, The', 40);
insert into Season (title, ShowID)
values ('Discreet Charm of the Bourgeoisie, The (Charme discret de la bourgeoisie, Le)', 29);
insert into Season (title, ShowID)
values ('Daleks'' Invasion Earth: 2150 A.D.', 67);
insert into Season (title, ShowID)
values ('Punks', 82);
insert into Season (title, ShowID)
values ('Killjoy Goes to Hell', 96);
insert into Season (title, ShowID)
values ('Batman Unmasked: The Psychology of the Dark Knight', 91);
insert into Season (title, ShowID)
values ('Bonaerense, El', 53);
insert into Season (title, ShowID)
values ('American Pie Presents: Band Camp (American Pie 4: Band Camp)', 71);
insert into Season (title, ShowID)
values ('Preacher''s Wife, The', 22);
insert into Season (title, ShowID)
values ('Great Diamond Robbery, The', 66);
insert into Season (title, ShowID)
values ('Tale of Sweeney Todd, The', 22);
insert into Season (title, ShowID)
values ('Story of a Prostitute (Shunpu den)', 80);
insert into Season (title, ShowID)
values ('Once Upon a Time in China II (Wong Fei-hung Ji Yi: Naam yi dong ji keung)', 17);
insert into Season (title, ShowID)
values ('Holcroft Covenant, The', 22);
insert into Season (title, ShowID)
values ('Don''t Give Up the Ship', 82);
insert into Season (title, ShowID)
values ('MirrorMask', 91);
insert into Season (title, ShowID)
values ('And Now a Word from Our Sponsor', 11);
insert into Season (title, ShowID)
values ('Closure', 16);
insert into Season (title, ShowID)
values ('Elena', 52);
insert into Season (title, ShowID)
values ('It Runs in the Family (My Summer Story)', 48);
insert into Season (title, ShowID)
values ('Executive Protection (Livvakterna)', 89);
insert into Season (title, ShowID)
values ('Lebanon, Pa.', 18);
insert into Season (title, ShowID)
values ('Boy Meets Girl', 69);
insert into Season (title, ShowID)
values ('Women Robbers (Diebinnen)', 100);
insert into Season (title, ShowID)
values ('Story of Film: An Odyssey, The', 87);
insert into Season (title, ShowID)
values ('World''s Greatest Lover, The', 81);
insert into Season (title, ShowID)
values ('Lola Montès', 15);
insert into Season (title, ShowID)
values ('Kingsman: The Secret Service', 79);
insert into Season (title, ShowID)
values ('100 Years at the Movies', 18);
insert into Season (title, ShowID)
values ('Tenebre', 44);
insert into Season (title, ShowID)
values ('I Know What I Saw', 94);
insert into Season (title, ShowID)
values ('Fährmann Maria', 9);
insert into Season (title, ShowID)
values ('Melinda and Melinda', 60);
insert into Season (title, ShowID)
values ('From Beyond the Grave (Creatures)', 15);
insert into Season (title, ShowID)
values ('Cherry', 77);
insert into Season (title, ShowID)
values ('Professional, The (Le professionnel)', 5);
insert into Season (title, ShowID)
values ('Six-String Samurai', 95);
insert into Season (title, ShowID)
values ('Art of Getting By, The', 30);
insert into Season (title, ShowID)
values ('Zeitgeist: Moving Forward', 66);
insert into Season (title, ShowID)
values ('Miss Potter', 6);
insert into Season (title, ShowID)
values ('Pocahontas II: Journey to a New World ', 64);
insert into Season (title, ShowID)
values ('First Texan, The', 19);
insert into Season (title, ShowID)
values ('Care Bears Movie II: A New Generation', 92);
insert into Season (title, ShowID)
values ('Manchurian Candidate, The', 36);
insert into Season (title, ShowID)
values ('Pushover', 59);
insert into Season (title, ShowID)
values ('Big Sky, The', 97);
insert into Season (title, ShowID)
values ('Voyage to the Bottom of the Sea', 40);
insert into Season (title, ShowID)
values ('Day of the Beast, The (Día de la Bestia, El)', 61);
insert into Season (title, ShowID)
values ('Father''s Little Dividend', 72);
insert into Season (title, ShowID)
values ('Goat, The', 34);
insert into Season (title, ShowID)
values ('Blind Justice (Hævnens nat)', 22);
insert into Season (title, ShowID)
values ('Clockwatchers', 10);
insert into Season (title, ShowID)
values ('Nothing to Lose (a.k.a. Ten Benny)', 60);
insert into Season (title, ShowID)
values ('Watcher, The', 97);
insert into Season (title, ShowID)
values ('Adventures of Food Boy, The (aka High School Superhero)', 19);
insert into Season (title, ShowID)
values ('Crimes and Misdemeanors', 25);
insert into Season (title, ShowID)
values ('I Dreamed of Africa', 56);
insert into Season (title, ShowID)
values ('Rose, The', 41);
insert into Season (title, ShowID)
values ('Zona Zamfirova', 31);
insert into Season (title, ShowID)
values ('Ca$h', 92);
insert into Season (title, ShowID)
values ('Damned, The (La Caduta degli dei)', 12);
insert into Season (title, ShowID)
values ('Hope Springs', 89);
insert into Season (title, ShowID)
values ('Bernice Bobs Her Hair', 64);
insert into Season (title, ShowID)
values ('Sex: The Annabel Chong Story', 45);
insert into Season (title, ShowID)
values ('Tyler Perry''s The Single Moms Club', 76);
insert into Season (title, ShowID)
values ('R100', 37);
insert into Season (title, ShowID)
values ('Mon Oncle Antoine', 93);
insert into Season (title, ShowID)
values ('Catch-22', 33);
insert into Season (title, ShowID)
values ('Appointment with Death', 28);
insert into Season (title, ShowID)
values ('Texas Killing Fields', 55);
insert into Season (title, ShowID)
values ('Remember Me', 54);
insert into Season (title, ShowID)
values ('Glenn Killing på Berns', 22);
insert into Season (title, ShowID)
values ('Patterns', 81);
insert into Season (title, ShowID)
values ('Opposite Day', 49);
insert into Season (title, ShowID)
values ('Three Monkeys (Üç maymun)', 52);
insert into Season (title, ShowID)
values ('Wanda', 24);
insert into Season (title, ShowID)
values ('Blind Massage (Tui na)', 81);
insert into Season (title, ShowID)
values ('Ladykillers, The', 23);
insert into Season (title, ShowID)
values ('Position Among The Stars (Stand van de Sterren)', 34);
insert into Season (title, ShowID)
values ('All Night Long', 2);
insert into Season (title, ShowID)
values ('Croupier', 35);
insert into Season (title, ShowID)
values ('Mickey''s Once Upon a Christmas', 26);
insert into Season (title, ShowID)
values ('Cirque du Freak: The Vampire''s Assistant', 86);
insert into Season (title, ShowID)
values ('Rape of Europa, The', 11);
insert into Season (title, ShowID)
values ('Baboona', 62);
insert into Season (title, ShowID)
values ('César', 98);
insert into Season (title, ShowID)
values ('Sekirei', 78);
insert into Season (title, ShowID)
values ('Father Goose', 67);
insert into Season (title, ShowID)
values ('Coup de grâce (Der Fangschuß)', 60);
insert into Season (title, ShowID)
values ('Billy Jack', 41);
insert into Season (title, ShowID)
values ('Marie Krøyer', 4);
insert into Season (title, ShowID)
values ('Oblivion', 42);
insert into Season (title, ShowID)
values ('Yearling, The', 74);
insert into Season (title, ShowID)
values ('My Girl', 87);
insert into Season (title, ShowID)
values ('Rails & Ties', 76);
insert into Season (title, ShowID)
values ('Hulk Vs.', 41);
insert into Season (title, ShowID)
values ('Sniper', 82);
insert into Season (title, ShowID)
values ('Strictly Sexual', 83);
insert into Season (title, ShowID)
values ('Wedding Night, The', 40);
insert into Season (title, ShowID)
values ('Kocken', 3);
insert into Season (title, ShowID)
values ('Lake of Fire', 73);
insert into Season (title, ShowID)
values ('Last Mogul, The', 80);
insert into Season (title, ShowID)
values ('Drawn Together Movie: The Movie!, The', 62);
insert into Season (title, ShowID)
values ('Between Two Worlds', 28);
insert into Season (title, ShowID)
values ('American Virgin', 32);
insert into Season (title, ShowID)
values ('Oslo, August 31st (Oslo, 31. august)', 58);
insert into Season (title, ShowID)
values ('Chungking Express (Chung Hing sam lam)', 91);
insert into Season (title, ShowID)
values ('Miracle at St. Anna', 78);
insert into Season (title, ShowID)
values ('Next Karate Kid, The', 77);
insert into Season (title, ShowID)
values ('Solaris (Solyaris)', 43);
insert into Season (title, ShowID)
values ('Nobody Walks', 94);
insert into Season (title, ShowID)
values ('Flightplan', 14);
insert into Season (title, ShowID)
values ('Hulk', 93);
insert into Season (title, ShowID)
values ('Lucy', 8);
insert into Season (title, ShowID)
values ('Home Movie', 72);
insert into Season (title, ShowID)
values ('Everybody''s Famous! (Iedereen beroemd!)', 1);
insert into Season (title, ShowID)
values ('Aquamarine', 84);
insert into Season (title, ShowID)
values ('Final: The Rapture', 78);
insert into Season (title, ShowID)
values ('Last Action Hero', 26);
insert into Season (title, ShowID)
values ('Sweeney, The', 24);
insert into Season (title, ShowID)
values ('Seinto Seiya: Legend of Sanctuary (Seinto Seiya: Legend of Sanctuary)', 56);
insert into Season (title, ShowID)
values ('Corpse Bride', 52);
insert into Season (title, ShowID)
values ('Spare Parts', 60);
insert into Season (title, ShowID)
values ('Olsen Gang on the Track, The (Olsen-banden på sporet)', 68);
insert into Season (title, ShowID)
values ('Sound of Thunder, A', 31);
insert into Season (title, ShowID)
values ('Room 666 (Chambre 666)', 32);
insert into Season (title, ShowID)
values ('Private Affairs of Bel Ami, The', 55);
insert into Season (title, ShowID)
values ('Hilton!', 85);
insert into Season (title, ShowID)
values ('Bellboy, The', 62);
insert into Season (title, ShowID)
values ('Study in Choreography for Camera, A', 33);
insert into Season (title, ShowID)
values ('Born American', 44);
insert into Season (title, ShowID)
values ('Stray Dogs', 39);
insert into Season (title, ShowID)
values ('12 Storeys (Shier lou)', 91);
insert into Season (title, ShowID)
values ('Fiendish Plot of Dr. Fu Manchu, The', 43);
insert into Season (title, ShowID)
values ('Heroes for Sale', 31);
insert into Season (title, ShowID)
values ('Secret Life of Zoey, The', 47);
insert into Season (title, ShowID)
values ('Chalte Chalte', 53);
insert into Season (title, ShowID)
values ('Point Blank (À bout portant)', 6);
insert into Season (title, ShowID)
values ('Bashu, the Little Stranger (Bashu, gharibeye koochak)', 54);
insert into Season (title, ShowID)
values ('Price of Forgiveness, The (Ndeysaan)', 87);
insert into Season (title, ShowID)
values ('Bagdad Cafe (Out of Rosenheim)', 17);
insert into Season (title, ShowID)
values ('Class Reunion', 8);
insert into Season (title, ShowID)
values ('Desperados, The', 31);
insert into Season (title, ShowID)
values ('Weight of Water, The', 99);
insert into Season (title, ShowID)
values ('Lili', 18);
insert into Season (title, ShowID)
values ('All the Way Home', 8);
insert into Season (title, ShowID)
values ('Come Back to Me', 60);
insert into Season (title, ShowID)
values ('Dragonworld', 3);
insert into Season (title, ShowID)
values ('Slam Dunk Ernest', 55);
insert into Season (title, ShowID)
values ('13th Letter, The', 69);
insert into Season (title, ShowID)
values ('Jerry Seinfeld: ''I''m Telling You for the Last Time''', 80);
insert into Season (title, ShowID)
values ('Gossip', 82);
insert into Season (title, ShowID)
values ('Real McCoy, The', 24);
insert into Season (title, ShowID)
values ('Entity, The', 11);
insert into Season (title, ShowID)
values ('Maximum Overdrive', 6);
insert into Season (title, ShowID)
values ('Triage', 72);
insert into Season (title, ShowID)
values ('Locke', 37);
insert into Season (title, ShowID)
values ('Eastern Drift (Indigène d''Eurasie)', 62);
insert into Season (title, ShowID)
values ('Secrets of the Tribe', 64);
insert into Season (title, ShowID)
values ('Track 29', 35);
insert into Season (title, ShowID)
values ('Born to Fight (Kerd ma lui)', 17);
insert into Season (title, ShowID)
values ('Road Hard', 6);
insert into Season (title, ShowID)
values ('Second Time Around, The', 61);
insert into Season (title, ShowID)
values ('I Smile Back', 100);
insert into Season (title, ShowID)
values ('Dog Day (Canicule)', 22);
insert into Season (title, ShowID)
values ('Vicky Donor', 45);
insert into Season (title, ShowID)
values ('Lust for Life', 27);
insert into Season (title, ShowID)
values ('Incredibles, The', 32);
insert into Season (title, ShowID)
values ('Tale from the Past, A (Përralle Nga e Kaluara)', 31);
insert into Season (title, ShowID)
values ('Despair', 82);
insert into Season (title, ShowID)
values ('Rain', 75);
insert into Season (title, ShowID)
values ('Arrowsmith', 50);
insert into Season (title, ShowID)
values ('Monkey''s Tale, A (Château des singes, Le)', 51);
insert into Season (title, ShowID)
values ('Fruitcake', 12);
insert into Season (title, ShowID)
values ('Million Dollar Hotel, The', 35);
insert into Season (title, ShowID)
values ('Lovers and Other Strangers', 43);
insert into Season (title, ShowID)
values ('Alarmist, The (a.k.a. Life During Wartime)', 36);
insert into Season (title, ShowID)
values ('Shadow, The', 48);
insert into Season (title, ShowID)
values ('Vertical Ray of the Sun, The (Mua he chieu thang dung)', 74);
insert into Season (title, ShowID)
values ('White Dog', 63);
insert into Season (title, ShowID)
values ('Harvest', 38);
insert into Season (title, ShowID)
values ('Juliet of the Spirits (Giulietta degli spiriti)', 85);
insert into Season (title, ShowID)
values ('My House in Umbria', 51);
insert into Season (title, ShowID)
values ('Corn Is Green, The', 38);
insert into Season (title, ShowID)
values ('Seven-Per-Cent Solution, The', 71);
insert into Season (title, ShowID)
values ('Prince Valiant', 52);
insert into Season (title, ShowID)
values ('Paper Clips', 83);
insert into Season (title, ShowID)
values ('I Inside, The', 19);
insert into Season (title, ShowID)
values ('Death In Love', 69);
insert into Season (title, ShowID)
values ('Mother Night', 46);
insert into Season (title, ShowID)
values ('Young Americans, The', 81);
insert into Season (title, ShowID)
values ('God''s Gun', 13);
insert into Season (title, ShowID)
values ('Anything Goes', 5);
insert into Season (title, ShowID)
values ('Only the Lonely', 2);
insert into Season (title, ShowID)
values ('Sebastian Maniscalco: What''s Wrong with People?', 61);
insert into Season (title, ShowID)
values ('Bullet for Joey, A', 80);
insert into Season (title, ShowID)
values ('Naked', 44);
insert into Season (title, ShowID)
values ('Addicted to Love', 41);
insert into Season (title, ShowID)
values ('Involuntary (De ofrivilliga)', 60);
insert into Season (title, ShowID)
values ('Dead Outside, The', 92);
insert into Season (title, ShowID)
values ('Micki + Maude', 43);
insert into Season (title, ShowID)
values ('Spooky House', 33);
insert into Season (title, ShowID)
values ('The DUFF', 14);
insert into Season (title, ShowID)
values ('Fighter', 86);
insert into Season (title, ShowID)
values ('Ghosts of Cité Soleil', 20);
insert into Season (title, ShowID)
values ('Four more years (Fyra år till)', 55);
insert into Season (title, ShowID)
values ('Man from London, The (A Londoni férfi)', 96);
insert into Season (title, ShowID)
values ('Moonwalker', 3);
insert into Season (title, ShowID)
values ('Future by Design', 49);
insert into Season (title, ShowID)
values ('Matthew''s Days', 87);
insert into Season (title, ShowID)
values ('Story of Seabiscuit, The', 5);
insert into Season (title, ShowID)
values ('Galaxina', 90);
insert into Season (title, ShowID)
values ('Badlands', 92);
insert into Season (title, ShowID)
values ('Champ, The', 4);
insert into Season (title, ShowID)
values ('Let the Bullets Fly', 86);
insert into Season (title, ShowID)
values ('Seventh Continent, The (Der siebente Kontinent)', 88);
insert into Season (title, ShowID)
values ('Blonde Ambition', 7);
insert into Season (title, ShowID)
values ('Apple, The (Sib)', 45);
insert into Season (title, ShowID)
values ('Blue Lagoon, The', 59);
insert into Season (title, ShowID)
values ('Fun', 99);
insert into Season (title, ShowID)
values ('Darkman', 85);
insert into Season (title, ShowID)
values ('Amu', 82);
insert into Season (title, ShowID)
values ('I Don''t Want to Be a Man (Ich möchte kein Mann sein)', 78);
insert into Season (title, ShowID)
values ('Kahlekuningas', 8);
insert into Season (title, ShowID)
values ('Blood: The Last Vampire', 38);
insert into Season (title, ShowID)
values ('Hell''s Kitchen', 86);
insert into Season (title, ShowID)
values ('Two Thousand Maniacs!', 30);
insert into Season (title, ShowID)
values ('Godfather, The', 67);
insert into Season (title, ShowID)
values ('Watership Down', 57);
insert into Season (title, ShowID)
values ('See You Tomorrow, Everyone', 60);
insert into Season (title, ShowID)
values ('Chronicle of a Disappearance', 76);
insert into Season (title, ShowID)
values ('Café de Flore', 16);
insert into Season (title, ShowID)
values ('Stefano Quantestorie', 3);
insert into Season (title, ShowID)
values ('Not Fade Away', 2);
insert into Season (title, ShowID)
values ('Prophecy', 94);
insert into Season (title, ShowID)
values ('Children of the Revolution', 88);
insert into Season (title, ShowID)
values ('Georg', 66);
insert into Season (title, ShowID)
values ('Pied Piper, The (Pied Piper of Hamelin, The)', 24);
insert into Season (title, ShowID)
values ('Mugabe and the White African', 27);
insert into Season (title, ShowID)
values ('Sherlock Holmes Faces Death', 67);
insert into Season (title, ShowID)
values ('Same Love, Same Rain (El mismo amor, la misma lluvia)', 97);
insert into Season (title, ShowID)
values ('48 Hrs.', 66);
insert into Season (title, ShowID)
values ('Ilsa, She Wolf of the SS', 40);
insert into Season (title, ShowID)
values ('Psycho', 100);
insert into Season (title, ShowID)
values ('Moon', 61);
insert into Season (title, ShowID)
values ('Punishment Park', 34);
insert into Season (title, ShowID)
values ('Cake Eaters, The', 36);
insert into Season (title, ShowID)
values ('Distant Thunder (Ashani Sanket)', 34);
insert into Season (title, ShowID)
values ('Torremolinos 73', 33);
insert into Season (title, ShowID)
values ('Outrage', 3);
insert into Season (title, ShowID)
values ('Hangover Part III, The', 51);
insert into Season (title, ShowID)
values ('Chasing Ghosts: Beyond the Arcade ', 23);
insert into Season (title, ShowID)
values ('Garfield: A Tail of Two Kitties', 60);
insert into Season (title, ShowID)
values ('Phantom of the Opera', 31);
insert into Season (title, ShowID)
values ('Kolmistaan', 86);
insert into Season (title, ShowID)
values ('Most Hated Family in America, The', 25);
insert into Season (title, ShowID)
values ('Busses Roar (Buses Roar)', 57);
insert into Season (title, ShowID)
values ('Aningaaq', 3);
insert into Season (title, ShowID)
values ('Man Without a Past, The (Mies vailla menneisyyttä)', 41);
insert into Season (title, ShowID)
values ('Paper Birds (Pájaros de papel)', 75);
insert into Season (title, ShowID)
values ('Montenegro', 24);
insert into Season (title, ShowID)
values ('Dolly and Her Lover (Räpsy ja Dolly eli Pariisi odottaa)', 12);
insert into Season (title, ShowID)
values ('Babylon', 100);
insert into Season (title, ShowID)
values ('Holes in My Shoes', 58);
insert into Season (title, ShowID)
values ('One in the Chamber', 30);
insert into Season (title, ShowID)
values ('Devil Rides Out, The', 78);
insert into Season (title, ShowID)
values ('What Women Want', 55);
insert into Season (title, ShowID)
values ('Rabid', 26);
insert into Season (title, ShowID)
values ('Adrift (À Deriva)', 15);
insert into Season (title, ShowID)
values ('Freakonomics', 99);
insert into Season (title, ShowID)
values ('On My Way (Elle s''en va)', 95);
insert into Season (title, ShowID)
values ('Chasing Ice', 41);
insert into Season (title, ShowID)
values ('Looking Forward', 26);
insert into Season (title, ShowID)
values ('Hustle', 6);
insert into Season (title, ShowID)
values ('Four Minutes (Vier Minuten)', 34);
insert into Season (title, ShowID)
values ('Haunted Strangler, The (Grip of the Strangler)', 92);
insert into Season (title, ShowID)
values ('Veronika Decides to Die', 66);
insert into Season (title, ShowID)
values ('Brooklyn Dodgers: The Ghosts of Flatbush', 14);
insert into Season (title, ShowID)
values ('Adjuster, The', 32);
insert into Season (title, ShowID)
values ('Last Mistress, The (vieille maîtresse, Une)', 52);
insert into Season (title, ShowID)
values ('Brown Sugar', 41);
insert into Season (title, ShowID)
values ('Time of the Gypsies (Dom za vesanje)', 29);
insert into Season (title, ShowID)
values ('Crimes of Passion', 27);
insert into Season (title, ShowID)
values ('Loose Cannons (Mine vaganti)', 12);
insert into Season (title, ShowID)
values ('Article 99', 61);
insert into Season (title, ShowID)
values ('That Old Feeling', 35);
insert into Season (title, ShowID)
values ('Mannequin', 83);
insert into Season (title, ShowID)
values ('Dutchman', 84);
insert into Season (title, ShowID)
values ('Single Girl, A (Fille seule, La)', 49);
insert into Season (title, ShowID)
values ('Beethoven', 59);
insert into Season (title, ShowID)
values ('Outlaw Josey Wales, The', 89);
insert into Season (title, ShowID)
values ('Reel Bad Arabs: How Hollywood Vilifies a People', 90);
insert into Season (title, ShowID)
values ('Frankenstein', 51);
insert into Season (title, ShowID)
values ('The Cabin in the Cotton', 55);
insert into Season (title, ShowID)
values ('Waterworld', 66);
insert into Season (title, ShowID)
values ('Aurora Borealis', 82);
insert into Season (title, ShowID)
values ('Phoebe in Wonderland', 59);
insert into Season (title, ShowID)
values ('King of Beggars (Mo jong yuen So Hat-Yi)', 16);
insert into Season (title, ShowID)
values ('To Wong Foo, Thanks for Everything! Julie Newmar', 62);
insert into Season (title, ShowID)
values ('Stewart Lee: If You Prefer a Milder Comedian, Please Ask for One', 94);
insert into Season (title, ShowID)
values ('Vermont Is For Lovers', 62);
insert into Season (title, ShowID)
values ('Homem Que Desafiou o Diabo, O', 49);
insert into Season (title, ShowID)
values ('Skeleton Crew', 95);
insert into Season (title, ShowID)
values ('Dead & Breakfast', 87);
insert into Season (title, ShowID)
values ('My Winnipeg', 29);
insert into Season (title, ShowID)
values ('Lascars', 4);
insert into Season (title, ShowID)
values ('Doc', 60);
insert into Season (title, ShowID)
values ('Piled Higher and Deeper', 92);
insert into Season (title, ShowID)
values ('Witches, The (aka Devil''s Own, The)', 35);
insert into Season (title, ShowID)
values ('Lone Survivor', 68);
insert into Season (title, ShowID)
values ('Wesley Willis: The Daddy of Rock ''n'' Roll', 11);
insert into Season (title, ShowID)
values ('Parasites, Les', 27);
insert into Season (title, ShowID)
values ('Made in Jamaica', 99);
insert into Season (title, ShowID)
values ('Because I Said So', 99);
insert into Season (title, ShowID)
values ('Our Blushing Brides', 63);
insert into Season (title, ShowID)
values ('Under the Skin', 83);
insert into Season (title, ShowID)
values ('Man Behind the Gun, The', 90);
insert into Season (title, ShowID)
values ('Thoroughbreds Don''t Cry', 80);
insert into Season (title, ShowID)
values ('Classic, The (Klassikko)', 82);
insert into Season (title, ShowID)
values ('Atalante, L''', 89);
insert into Season (title, ShowID)
values ('Old Joy', 33);
insert into Season (title, ShowID)
values ('Gun in Betty Lou''s Handbag, The', 54);
insert into Season (title, ShowID)
values ('D3: The Mighty Ducks', 74);
insert into Season (title, ShowID)
values ('Close My Eyes', 19);
insert into Season (title, ShowID)
values ('Disney Princess Collection: Jasmine''s Enchanted Tales: Jasmine''s Wish', 59);
insert into Season (title, ShowID)
values ('Hell Is Sold Out', 6);
insert into Season (title, ShowID)
values ('Born to Race', 51);
insert into Season (title, ShowID)
values ('All I Desire', 16);
insert into Season (title, ShowID)
values ('Gentlemen of Fortune (Dzhentlmeny udachi)', 63);
insert into Season (title, ShowID)
values ('I Served the King of England (Obsluhoval jsem anglického krále)', 22);
insert into Season (title, ShowID)
values ('U2: Rattle and Hum', 48);
insert into Season (title, ShowID)
values ('Young Mr. Lincoln', 26);
insert into Season (title, ShowID)
values ('Suicide Room', 72);
insert into Season (title, ShowID)
values ('Grudge 3, The', 7);
insert into Season (title, ShowID)
values ('Loving', 94);
insert into Season (title, ShowID)
values ('Each Dawn I Die', 15);
insert into Season (title, ShowID)
values ('Cirque du Soleil: Dralion', 61);
insert into Season (title, ShowID)
values ('Hunt, The (Jagten)', 74);
insert into Season (title, ShowID)
values ('Exit Wounds', 30);
insert into Season (title, ShowID)
values ('Zabriskie Point', 8);
insert into Season (title, ShowID)
values ('Topaze', 75);
insert into Season (title, ShowID)
values ('Ararat', 30);
insert into Season (title, ShowID)
values ('Bugs Bunny''s 3rd Movie: 1001 Rabbit Tales', 74);
insert into Season (title, ShowID)
values ('Arranged', 96);
insert into Season (title, ShowID)
values ('Rewrite, The', 18);
insert into Season (title, ShowID)
values ('Eichmann', 19);
insert into Season (title, ShowID)
values ('Frozen City (Valkoinen kaupunki) ', 33);
insert into Season (title, ShowID)
values ('Jim Jefferies: Alcoholocaust', 15);
insert into Season (title, ShowID)
values ('Black Gold', 44);
insert into Season (title, ShowID)
values ('Strip Nude for Your Killer (Nude per l''assassino)', 15);
insert into Season (title, ShowID)
values ('Bloody Murder 2: Closing Camp', 7);
insert into Season (title, ShowID)
values ('A Cry in the Wild', 13);
insert into Season (title, ShowID)
values ('The Skinny', 25);
insert into Season (title, ShowID)
values ('North Avenue Irregulars, The', 76);
insert into Season (title, ShowID)
values ('Tsotsi', 29);
insert into Season (title, ShowID)
values ('Darling Lili', 21);
insert into Season (title, ShowID)
values ('Petits Freres (Petits Frères)', 51);
insert into Season (title, ShowID)
values ('Enola Gay and the Atomic Bombing of Japan', 87);
insert into Season (title, ShowID)
values ('Pushing Tin', 22);
insert into Season (title, ShowID)
values ('Tale of Two Cities, A', 37);
insert into Season (title, ShowID)
values ('Demetrius and the Gladiators', 47);
insert into Season (title, ShowID)
values ('The Hyperboloid of Engineer Garin (Giperboloid inzhenera Garina)', 2);
insert into Season (title, ShowID)
values ('A Walk in the Woods', 71);
insert into Season (title, ShowID)
values ('Mechanic, The', 12);
insert into Season (title, ShowID)
values ('Admission', 37);
insert into Season (title, ShowID)
values ('The Castle of Fu Manchu', 4);
insert into Season (title, ShowID)
values ('Mad Detective (Sun taam)', 96);
insert into Season (title, ShowID)
values ('Hickey and Boggs', 6);
insert into Season (title, ShowID)
values ('PT 109', 42);
insert into Season (title, ShowID)
values ('Spirit: Stallion of the Cimarron', 30);
insert into Season (title, ShowID)
values ('Reservation Road', 66);
insert into Season (title, ShowID)
values ('I Met Him in Paris', 19);
insert into Season (title, ShowID)
values ('Gambler, The', 51);
insert into Season (title, ShowID)
values ('Sabotage', 79);
insert into Season (title, ShowID)
values ('Serbian Film, A (Srpski film)', 75);
insert into Season (title, ShowID)
values ('Nickelodeon', 49);
insert into Season (title, ShowID)
values ('Portraits of Women (Naisenkuvia)', 91);
insert into Season (title, ShowID)
values ('Mummy: Tomb of the Dragon Emperor, The', 79);
insert into Season (title, ShowID)
values ('Battle for Haditha', 90);
insert into Season (title, ShowID)
values ('Blob, The', 4);
insert into Season (title, ShowID)
values ('True Grit', 57);
insert into Season (title, ShowID)
values ('Black Orpheus (Orfeu Negro)', 43);
insert into Season (title, ShowID)
values ('Earth', 2);
insert into Season (title, ShowID)
values ('Boricua''s Bond', 49);
insert into Season (title, ShowID)
values ('Tokyo Zombie (Tôkyô zonbi)', 19);
insert into Season (title, ShowID)
values ('Look of Silence, The', 22);
insert into Season (title, ShowID)
values ('Keys of the Kingdom, The', 57);
insert into Season (title, ShowID)
values ('Paperman', 29);
insert into Season (title, ShowID)
values ('Desire', 100);
insert into Season (title, ShowID)
values ('Six Days Seven Nights', 76);
insert into Season (title, ShowID)
values ('My Sex Life... or How I Got Into an Argument (Comment je me suis disputé... (ma vie sexuelle))', 100);
insert into Season (title, ShowID)
values ('Black Coal, Thin Ice (Bai ri yan huo)', 22);
insert into Season (title, ShowID)
values ('Man in the Moon, The', 5);
insert into Season (title, ShowID)
values ('The Crowded Sky', 3);
insert into Season (title, ShowID)
values ('I''m Gonna Explode (a.k.a. I''m Going to Explode) (Voy a explotar)', 88);
insert into Season (title, ShowID)
values ('Best of Everything, The', 63);
insert into Season (title, ShowID)
values ('Incident at Oglala', 50);
insert into Season (title, ShowID)
values ('Kismet', 67);
insert into Season (title, ShowID)
values ('Tall Blond Man with One Black Shoe, The (Le grand blond avec une chaussure noire)', 85);
insert into Season (title, ShowID)
values ('You Will Meet a Tall Dark Stranger', 41);
insert into Season (title, ShowID)
values ('Fahrenhype 9/11', 83);
insert into Season (title, ShowID)
values ('P.U.N.K.S', 69);
insert into Season (title, ShowID)
values ('Mongol', 68);
insert into Season (title, ShowID)
values ('Before the Fall (NaPolA - Elite für den Führer)', 90);
insert into Season (title, ShowID)
values ('Fixed Bayonets!', 44);
insert into Season (title, ShowID)
values ('Labyrinth of Lies', 75);
insert into Season (title, ShowID)
values ('Empire of the Ants', 45);
insert into Season (title, ShowID)
values ('Steep', 89);
insert into Season (title, ShowID)
values ('Conversation, The', 91);
insert into Season (title, ShowID)
values ('DNA', 15);
insert into Season (title, ShowID)
values ('Way Out West', 85);
insert into Season (title, ShowID)
values ('Love Is a Woman (Death Is a Woman)', 44);
insert into Season (title, ShowID)
values ('All''s Well', 99);
insert into Season (title, ShowID)
values ('Kevin Hart: I''m a Grown Little Man', 36);
insert into Season (title, ShowID)
values ('Victor and the Secret of Crocodile Mansion', 92);
insert into Season (title, ShowID)
values ('Sarah Silverman:  We Are Miracles', 23);
insert into Season (title, ShowID)
values ('Kisses', 82);
insert into Season (title, ShowID)
values ('Kestrel''s Eye (Falkens öga)', 85);
insert into Season (title, ShowID)
values ('Asphyx, The', 81);
insert into Season (title, ShowID)
values ('White Heat', 100);
insert into Season (title, ShowID)
values ('This Is the End', 83);
insert into Season (title, ShowID)
values ('Come and See (Idi i smotri)', 48);
insert into Season (title, ShowID)
values ('Skeleton Key, The', 99);
insert into Season (title, ShowID)
values ('On the Other Side of the Tracks (De l''autre côté du périph)', 20);
insert into Season (title, ShowID)
values ('Majority of One, A', 40);
insert into Season (title, ShowID)
values ('Phase 7', 60);
insert into Season (title, ShowID)
values ('Snake Pit, The', 67);
insert into Season (title, ShowID)
values ('Old Man and the Sea, The', 40);
insert into Season (title, ShowID)
values ('If You Could Only Cook', 89);
insert into Season (title, ShowID)
values ('Angus', 91);
insert into Season (title, ShowID)
values ('Saving Shiloh', 70);
insert into Season (title, ShowID)
values ('Rendez-vous', 82);
insert into Season (title, ShowID)
values ('Spider-Man', 84);
insert into Season (title, ShowID)
values ('Shooter, The', 64);
insert into Season (title, ShowID)
values ('Roberta', 89);
insert into Season (title, ShowID)
values ('Last Play at Shea, The', 18);
insert into Season (title, ShowID)
values ('Dinner Rush', 90);
insert into Season (title, ShowID)
values ('Wetlands (Feuchtgebiete)', 75);
insert into Season (title, ShowID)
values ('XXY', 74);
insert into Season (title, ShowID)
values ('Outlander', 68);
insert into Season (title, ShowID)
values ('Stardust Memories', 39);
insert into Season (title, ShowID)
values ('Fall, The', 63);
insert into Season (title, ShowID)
values ('Return of the Vampire, The', 17);
insert into Season (title, ShowID)
values ('Price of Forgiveness, The (Ndeysaan)', 10);
insert into Season (title, ShowID)
values ('Vares: The Path of the Righteous Men (Vares - Kaidan tien kulkijat)', 93);
insert into Season (title, ShowID)
values ('Night in Old Mexico, A', 52);
insert into Season (title, ShowID)
values ('Ong-Bak 2: The Beginning (Ong Bak 2)', 12);
insert into Season (title, ShowID)
values ('Made', 87);
insert into Season (title, ShowID)
values ('Case of the Grinning Cat, The (Chats perchés)', 29);
insert into Season (title, ShowID)
values ('Simon Killer ', 31);
insert into Season (title, ShowID)
values ('License to Wed', 81);
insert into Season (title, ShowID)
values ('The D Train', 65);
insert into Season (title, ShowID)
values ('Metro Manila', 28);
insert into Season (title, ShowID)
values ('Psychopath, The', 29);
insert into Season (title, ShowID)
values ('Last Days of Pompeii, The (Gli ultimi giorni di Pompeii)', 69);
insert into Season (title, ShowID)
values ('Hot Saturday', 21);
insert into Season (title, ShowID)
values ('Young Frankenstein', 2);
insert into Season (title, ShowID)
values ('Safe Men', 48);
insert into Season (title, ShowID)
values ('Homeward Bound II: Lost in San Francisco', 59);
insert into Season (title, ShowID)
values ('Aurora', 18);
insert into Season (title, ShowID)
values ('Dr. Crippen', 30);
insert into Season (title, ShowID)
values ('Incredible Hulk, The', 81);
insert into Season (title, ShowID)
values ('Macbeth', 66);
insert into Season (title, ShowID)
values ('300 Spartans, The', 22);
insert into Season (title, ShowID)
values ('Adam & Paul', 38);
insert into Season (title, ShowID)
values ('Love Forbidden (Défense d''aimer)', 87);
insert into Season (title, ShowID)
values ('Resurrecting the Street Walker', 65);
insert into Season (title, ShowID)
values ('Alex Cross', 80);
insert into Season (title, ShowID)
values ('Immigrant, The', 8);
insert into Season (title, ShowID)
values ('Champ, The', 74);
insert into Season (title, ShowID)
values ('Trust Me', 53);
insert into Season (title, ShowID)
values ('Bad Taste', 30);
insert into Season (title, ShowID)
values ('Thin Blue Line, The', 78);
insert into Season (title, ShowID)
values ('Too Many Cooks', 35);
insert into Season (title, ShowID)
values ('Beautiful Ohio', 19);
insert into Season (title, ShowID)
values ('Lovers of Hate', 61);
insert into Season (title, ShowID)
values ('Russian Ark (Russkiy Kovcheg)', 41);
insert into Season (title, ShowID)
values ('Answers to Nothing', 94);
insert into Season (title, ShowID)
values ('White Material', 74);
insert into Season (title, ShowID)
values ('Enchantment', 11);
insert into Season (title, ShowID)
values ('Road Kill (a.k.a. Road Train)', 43);
insert into Season (title, ShowID)
values ('I Shot Andy Warhol', 42);
insert into Season (title, ShowID)
values ('Long Hello and Short Goodbye', 48);
insert into Season (title, ShowID)
values ('Adrenalin: Fear the Rush', 91);
insert into Season (title, ShowID)
values ('Brothers (Brødre)', 20);
insert into Season (title, ShowID)
values ('Her Highness and the Bellboy', 61);
insert into Season (title, ShowID)
values ('Corvette Summer', 19);
insert into Season (title, ShowID)
values ('Frozen Fever', 79);
insert into Season (title, ShowID)
values ('Loner (Woetoli)', 16);
insert into Season (title, ShowID)
values ('Crawlspace', 29);
insert into Season (title, ShowID)
values ('Bombshell', 39);
insert into Season (title, ShowID)
values ('Good Dick', 92);
insert into Season (title, ShowID)
values ('Manuel on the Island of Wonders (Manoel dans l''île des merveilles)', 49);
insert into Season (title, ShowID)
values ('Olympus Has Fallen', 57);
insert into Season (title, ShowID)
values ('Gas', 42);
insert into Season (title, ShowID)
values ('Mysterious Geographic Explorations of Jasper Morello, The', 20);
insert into Season (title, ShowID)
values ('Examined Life', 31);
insert into Season (title, ShowID)
values ('Robin Hood: Prince of Thieves', 15);
insert into Season (title, ShowID)
values ('Honey (Miele)', 67);
insert into Season (title, ShowID)
values ('Madame Satã', 96);
insert into Season (title, ShowID)
values ('Spiders, Part 2: The Diamond Ship, The (Die Spinnen, 2. Teil - Das Brillantenschiff)', 10);
insert into Season (title, ShowID)
values ('Dangerous Corner', 29);
insert into Season (title, ShowID)
values ('Three Stooges, The', 23);
insert into Season (title, ShowID)
values ('Cliffhanger', 39);
insert into Season (title, ShowID)
values ('The Oblong Box', 52);
insert into Season (title, ShowID)
values ('Saw V', 54);
insert into Season (title, ShowID)
values ('Thawing Out (La fonte des neiges) ', 33);
insert into Season (title, ShowID)
values ('Pandora and the Flying Dutchman', 26);
insert into Season (title, ShowID)
values ('Glamorous Life of Sachiko Hanai, The (Hatsujô kateikyôshi: sensei no aijiru)', 28);
insert into Season (title, ShowID)
values ('Slender Thread, The', 74);
insert into Season (title, ShowID)
values ('Nancy Drew: Detective', 16);
insert into Season (title, ShowID)
values ('Hungry Hill', 38);
insert into Season (title, ShowID)
values ('Scent of a Woman', 10);
insert into Season (title, ShowID)
values ('In the Basement', 91);
insert into Season (title, ShowID)
values ('Survivors, The', 34);
insert into Season (title, ShowID)
values ('The Chatterley Affair', 36);
insert into Season (title, ShowID)
values ('Jonas', 27);
insert into Season (title, ShowID)
values ('Grand Hotel', 46);
insert into Season (title, ShowID)
values ('Goodbye Again', 67);
insert into Season (title, ShowID)
values ('Wimbledon', 83);
insert into Season (title, ShowID)
values ('Parent Trap, The', 39);
insert into Season (title, ShowID)
values ('Sexy Nights of the Living Dead', 48);
insert into Season (title, ShowID)
values ('Passion of Ayn Rand, The', 17);
insert into Season (title, ShowID)
values ('Leif', 100);
insert into Season (title, ShowID)
values ('Substance of Fire, The', 86);
insert into Season (title, ShowID)
values ('Very Thought of You, The', 65);
insert into Season (title, ShowID)
values ('Good Old Daze (Le péril jeune)', 50);
insert into Season (title, ShowID)
values ('Play House, The', 17);
insert into Season (title, ShowID)
values ('Cockneys vs Zombies', 35);
insert into Season (title, ShowID)
values ('Defenseless', 90);
insert into Season (title, ShowID)
values ('Daybreakers', 21);
insert into Season (title, ShowID)
values ('Lords of Dogtown', 53);
insert into Season (title, ShowID)
values ('Producers, The', 58);
insert into Season (title, ShowID)
values ('Spencer''s Mountain', 71);
insert into Season (title, ShowID)
values ('Another Cinderella Story', 34);
insert into Season (title, ShowID)
values ('1½ Knights - In Search of the Ravishing Princess Herzelinde', 29);
insert into Season (title, ShowID)
values ('Paperhouse', 95);
insert into Season (title, ShowID)
values ('Applause (Applaus)', 6);
insert into Season (title, ShowID)
values ('Four Brothers', 42);
insert into Season (title, ShowID)
values ('Into the Blue 2: The Reef', 42);
insert into Season (title, ShowID)
values ('Dr. Otto and the Riddle of the Gloom Beam', 42);
insert into Season (title, ShowID)
values ('Five Pennies, The', 54);
insert into Season (title, ShowID)
values ('Gang''s All Here, The', 39);
insert into Season (title, ShowID)
values ('Last Mountain, The', 83);
insert into Season (title, ShowID)
values ('Clonus Horror, The', 75);
insert into Season (title, ShowID)
values ('What Dreams May Come', 86);
insert into Season (title, ShowID)
values ('Double Suicide (Shinjû: Ten no amijima)', 63);
insert into Season (title, ShowID)
values ('Follow Me, Boys!', 50);
insert into Season (title, ShowID)
values ('Moll Flanders', 89);
insert into Season (title, ShowID)
values ('Adult World', 54);
insert into Season (title, ShowID)
values ('Chambermaid on the Titanic, The (Femme de chambre du Titanic, La)', 49);
insert into Season (title, ShowID)
values ('Undefeatable', 75);
insert into Season (title, ShowID)
values ('The Castle of Fu Manchu', 87);
insert into Season (title, ShowID)
values ('Antonio Gaudí', 81);
insert into Season (title, ShowID)
values ('Babylon 5: The Gathering', 73);
insert into Season (title, ShowID)
values ('Flirt', 46);
insert into Season (title, ShowID)
values ('Good Guy, The', 76);
insert into Season (title, ShowID)
values ('Coronado', 5);
insert into Season (title, ShowID)
values ('Easy to Love', 50);
insert into Season (title, ShowID)
values ('Venus in Fur (La Vénus à la fourrure)', 71);
insert into Season (title, ShowID)
values ('Story of Science, The', 28);
insert into Season (title, ShowID)
values ('Bible, The (a.k.a. Bible... In the Beginning, The)', 2);
insert into Season (title, ShowID)
values ('Ghost Dog: The Way of the Samurai', 58);
insert into Season (title, ShowID)
values ('Five Senses, The', 54);
insert into Season (title, ShowID)
values ('Purge, The', 22);
insert into Season (title, ShowID)
values ('Bad News Bears', 44);
insert into Season (title, ShowID)
values ('American: The Bill Hicks Story', 52);
insert into Season (title, ShowID)
values ('Client, The', 65);
insert into Season (title, ShowID)
values ('What Ever Happened to Baby Jane?', 86);
insert into Season (title, ShowID)
values ('Game of Chance (Onnenpeli)', 71);
insert into Season (title, ShowID)
values ('Grand Prix', 65);
insert into Season (title, ShowID)
values ('Sgt. Pepper''s Lonely Hearts Club Band', 75);
insert into Season (title, ShowID)
values ('After the Rehearsal (Efter repetitionen)', 37);
insert into Season (title, ShowID)
values ('I Am Sam', 14);
insert into Season (title, ShowID)
values ('Accepted', 4);
insert into Season (title, ShowID)
values ('Chocolate Soldier, The', 91);
insert into Season (title, ShowID)
values ('War of the Buttons', 73);
insert into Season (title, ShowID)
values ('Slumdog Millionaire', 54);
insert into Season (title, ShowID)
values ('Stealing Home', 77);
insert into Season (title, ShowID)
values ('The Mayor of Casterbridge', 96);
insert into Season (title, ShowID)
values ('How to Be a Player', 40);
insert into Season (title, ShowID)
values ('Louis Theroux: The Most Hated Family in America in Crisis', 51);
insert into Season (title, ShowID)
values ('National Lampoon''s Lady Killers (National Lampoon''s Gold Diggers)', 59);
insert into Season (title, ShowID)
values ('Man with the Screaming Brain', 71);
insert into Season (title, ShowID)
values ('Joy Division', 77);
insert into Season (title, ShowID)
values ('Cure, The', 68);
insert into Season (title, ShowID)
values ('All Through the Night', 13);
insert into Season (title, ShowID)
values ('Pinocchio', 91);
insert into Season (title, ShowID)
values ('Shut Up and Play the Hits', 95);
insert into Season (title, ShowID)
values ('Carpetbaggers, The', 34);
insert into Season (title, ShowID)
values ('Candy', 34);
insert into Season (title, ShowID)
values ('I Was Monty''s Double', 61);
insert into Season (title, ShowID)
values ('Rules of Attraction, The', 27);
insert into Season (title, ShowID)
values ('ATF ', 85);
insert into Season (title, ShowID)
values ('Lovers & Leavers (Kuutamolla)', 73);
insert into Season (title, ShowID)
values ('Goya: Crazy Like a Genius', 77);
insert into Season (title, ShowID)
values ('Hide Your Smiling Faces', 37);
insert into Season (title, ShowID)
values ('Sunday', 84);
insert into Season (title, ShowID)
values ('Frostbitten (Frostbiten)', 54);
insert into Season (title, ShowID)
values ('Joe Dirt', 14);
insert into Season (title, ShowID)
values ('Beastie Boys: Sabotage', 15);
insert into Season (title, ShowID)
values ('Return of the Killer Tomatoes!', 49);
insert into Season (title, ShowID)
values ('Monkey''s Mask, The', 35);
insert into Season (title, ShowID)
values ('Mother and the Whore, The (Maman et la putain, La)', 38);
insert into Season (title, ShowID)
values ('Two Days, One Night (Deux jours, une nuit)', 16);
insert into Season (title, ShowID)
values ('Jonny Vang', 55);
insert into Season (title, ShowID)
values ('Star Kid', 94);
insert into Season (title, ShowID)
values ('Mother Carey''s Chickens', 3);
insert into Season (title, ShowID)
values ('Bunny and the Bull', 31);
insert into Season (title, ShowID)
values ('What Price Glory', 50);
insert into Season (title, ShowID)
values ('Harem suare', 92);
insert into Season (title, ShowID)
values ('Dirty Filthy Love', 37);
insert into Season (title, ShowID)
values ('Around the World Under the Sea', 46);
insert into Season (title, ShowID)
values ('Lincoln', 40);
insert into Season (title, ShowID)
values ('God is Great, I''m Not (Dieu est grand, je suis toute petite)', 7);
insert into Season (title, ShowID)
values ('Money (L''argent)', 62);
insert into Season (title, ShowID)
values ('Gold Diggers of 1937', 86);
insert into Season (title, ShowID)
values ('Waitress', 30);
insert into Season (title, ShowID)
values ('Lakota Woman: Siege at Wounded Knee', 47);
insert into Season (title, ShowID)
values ('Tupac: Resurrection', 7);
insert into Season (title, ShowID)
values ('Phone Call from a Stranger', 38);
insert into Season (title, ShowID)
values ('Maniacts', 58);
insert into Season (title, ShowID)
values ('Wizard, The', 93);
insert into Season (title, ShowID)
values ('Cable Guy, The', 45);
insert into Season (title, ShowID)
values ('Word Wars', 99);
insert into Season (title, ShowID)
values ('Last Lovecraft: Relic of Cthulhu, The', 98);
insert into Season (title, ShowID)
values ('Born Losers, The', 86);
insert into Season (title, ShowID)
values ('Rabid Dogs (Kidnapped) (Cani arrabbiati)', 40);
insert into Season (title, ShowID)
values ('Côte d''Azur (Crustacés et coquillages)', 5);
insert into Season (title, ShowID)
values ('Myth, The (San wa)', 58);
insert into Season (title, ShowID)
values ('Charge of the Light Brigade, The', 5);
insert into Season (title, ShowID)
values ('Life On A String (Bian chang Bian Zou)', 4);
insert into Season (title, ShowID)
values ('Farewell to Matyora', 10);
insert into Season (title, ShowID)
values ('The New Girlfriend', 95);
insert into Season (title, ShowID)
values ('Nuns on the Run', 28);
insert into Season (title, ShowID)
values ('Fifty Pills', 57);
insert into Season (title, ShowID)
values ('Another Man''s Poison', 14);
insert into Season (title, ShowID)
values ('Porgy and Bess', 75);
insert into Season (title, ShowID)
values ('Beyond Borders', 96);
insert into Season (title, ShowID)
values ('Happy Weekend', 29);
insert into Season (title, ShowID)
values ('Crash Dive', 21);
insert into Season (title, ShowID)
values ('Man on Wire', 24);
insert into Season (title, ShowID)
values ('Dogtooth (Kynodontas)', 33);
insert into Season (title, ShowID)
values ('Godzilla: Tokyo S.O.S. (Gojira tai Mosura tai Mekagojira: Tôkyô S.O.S.)', 96);
insert into Season (title, ShowID)
values ('Presentation, or Charlotte and Her Steak (Présentation ou Charlotte et son steak)', 76);
insert into Season (title, ShowID)
values ('Moebius', 28);
insert into Season (title, ShowID)
values ('Hammer of the Gods', 77);
insert into Season (title, ShowID)
values ('Cleanskin', 83);
insert into Season (title, ShowID)
values ('Naked in New York', 17);
insert into Season (title, ShowID)
values ('Shottas', 53);
insert into Season (title, ShowID)
values ('Sex, Lies, and Videotape', 45);
insert into Season (title, ShowID)
values ('Thor', 65);
insert into Season (title, ShowID)
values ('Secret, The', 27);
insert into Season (title, ShowID)
values ('Sumo Do, Sumo Don''t (Shiko funjatta)', 30);
insert into Season (title, ShowID)
values ('Girls, Les', 79);
insert into Season (title, ShowID)
values ('Full Body Massage', 89);
insert into Season (title, ShowID)
values ('Walker', 52);
insert into Season (title, ShowID)
values ('Thief of Bagdad, The', 21);
insert into Season (title, ShowID)
values ('Great Buck Howard, The', 60);
insert into Season (title, ShowID)
values ('Beatdown', 43);
insert into Season (title, ShowID)
values ('Libeled Lady', 39);
insert into Season (title, ShowID)
values ('Some Folks Call It a Sling Blade', 32);
insert into Season (title, ShowID)
values ('All the Young Men', 45);
insert into Season (title, ShowID)
values ('Burning Secret', 54);
insert into Season (title, ShowID)
values ('Village, The', 77);
insert into Season (title, ShowID)
values ('Bohemian Eyes (Boheemi elää - Matti Pellonpää)', 92);
insert into Season (title, ShowID)
values ('Strangers in Good Company', 88);
insert into Season (title, ShowID)
values ('Pink Cadillac', 63);
insert into Season (title, ShowID)
values ('Street Fight', 57);
insert into Season (title, ShowID)
values ('Old Fashioned Way, The', 61);
insert into Season (title, ShowID)
values ('Match King, The', 47);
insert into Season (title, ShowID)
values ('Bastards (Les salauds)', 23);
insert into Season (title, ShowID)
values ('Who Framed Roger Rabbit?', 25);
insert into Season (title, ShowID)
values ('Art of the Steal, The', 32);
insert into Season (title, ShowID)
values ('Take This Waltz', 6);
insert into Season (title, ShowID)
values ('Return to Life', 14);
insert into Season (title, ShowID)
values ('Valley Of Flowers', 32);
insert into Season (title, ShowID)
values ('Zero Theorem, The', 56);
insert into Season (title, ShowID)
values ('Slim Susie (Smala Sussie)', 7);
insert into Season (title, ShowID)
values ('Ghostbusters (a.k.a. Ghost Busters)', 4);
insert into Season (title, ShowID)
values ('Big Shot: Confessions of a Campus Bookie', 9);
insert into Season (title, ShowID)
values ('This Night I''ll Possess Your Corpse (Esta Noite Encarnarei no Teu Cadáver)', 18);
insert into Season (title, ShowID)
values ('Pocahontas II: Journey to a New World ', 25);
insert into Season (title, ShowID)
values ('Breathless', 50);
insert into Season (title, ShowID)
values ('Mirrors 2', 98);
insert into Season (title, ShowID)
values ('Just a Kiss', 35);
insert into Season (title, ShowID)
values ('Forgive Me', 76);
insert into Season (title, ShowID)
values ('The Adventures of André and Wally B.', 39);
insert into Season (title, ShowID)
values ('Tomie: Unlimited', 4);
insert into Season (title, ShowID)
values ('Blades of Glory', 17);
insert into Season (title, ShowID)
values ('Time of Peace (Tempos de Paz)', 75);
insert into Season (title, ShowID)
values ('High Road to China', 96);
insert into Season (title, ShowID)
values ('Believer, The', 62);
insert into Season (title, ShowID)
values ('Dominion Tank Police (Dominion)', 65);
insert into Season (title, ShowID)
values ('Dating the Enemy', 55);
insert into Season (title, ShowID)
values ('Le grand soir', 94);
insert into Season (title, ShowID)
values ('Eye of the Devil', 28);
insert into Season (title, ShowID)
values ('Screamers', 93);
insert into Season (title, ShowID)
values ('Rude Boy', 65);
insert into Season (title, ShowID)
values ('Stealing Home', 15);
insert into Season (title, ShowID)
values ('Iron Man: Rise Of Technovore', 39);
insert into Season (title, ShowID)
values ('Anvil! The Story of Anvil', 41);
insert into Season (title, ShowID)
values ('Destination Gobi', 26);
insert into Season (title, ShowID)
values ('Warning from Space (Uchûjin Tôkyô ni arawaru)', 96);
insert into Season (title, ShowID)
values ('Dealin'' with Idiots', 97);
insert into Season (title, ShowID)
values ('Agnosia', 1);
insert into Season (title, ShowID)
values ('The Prince', 68);
insert into Season (title, ShowID)
values ('Maze', 70);
insert into Season (title, ShowID)
values ('Traitor', 16);
insert into Season (title, ShowID)
values ('This So-Called Disaster', 67);
insert into Season (title, ShowID)
values ('Misadventures of Margaret, The', 63);
insert into Season (title, ShowID)
values ('Call Me Madam', 11);
insert into Season (title, ShowID)
values ('Royal Flash', 37);
insert into Season (title, ShowID)
values ('Naked Spur, The', 76);
insert into Season (title, ShowID)
values ('Madonna''s Pig', 91);
insert into Season (title, ShowID)
values ('Chastity Bites', 63);
insert into Season (title, ShowID)
values ('Olsen Gang, The (Olsen-Banden)', 37);
insert into Season (title, ShowID)
values ('Lawless Range', 34);
insert into Season (title, ShowID)
values ('Mannequin 2: On the Move', 31);
insert into Season (title, ShowID)
values ('Opera', 39);
insert into Season (title, ShowID)
values ('Walk Softly, Stranger', 29);
insert into Season (title, ShowID)
values ('Santa with Muscles', 59);
insert into Season (title, ShowID)
values ('Season''s Greetings', 63);
insert into Season (title, ShowID)
values ('Man of Her Dreams (a.k.a. The Fiancé)', 54);
insert into Season (title, ShowID)
values ('Chouchou', 41);
insert into Season (title, ShowID)
values ('Anna Karenina', 33);
insert into Season (title, ShowID)
values ('Man in the Wilderness', 16);
insert into Season (title, ShowID)
values ('Leningrad Cowboys Go America', 66);
insert into Season (title, ShowID)
values ('Alan Smithee Film: Burn Hollywood Burn, An', 30);
insert into Season (title, ShowID)
values ('Stepfather, The', 46);
insert into Season (title, ShowID)
values ('Picture This', 24);
insert into Season (title, ShowID)
values ('This Film Is Not Yet Rated', 34);
insert into Season (title, ShowID)
values ('Page One: Inside the New York Times', 12);
insert into Season (title, ShowID)
values ('Grand Theft Parsons', 52);
insert into Season (title, ShowID)
values ('Katatsumori', 71);
insert into Season (title, ShowID)
values ('Whale Rider', 32);
insert into Season (title, ShowID)
values ('Platform (Zhantai)', 33);
insert into Season (title, ShowID)
values ('Bourne Ultimatum, The', 51);
insert into Season (title, ShowID)
values ('Homicidal', 28);
insert into Season (title, ShowID)
values ('7 Days in Havana', 30);
insert into Season (title, ShowID)
values ('His Girl Friday', 88);
insert into Season (title, ShowID)
values ('Betrayal', 51);
insert into Season (title, ShowID)
values ('Battle for Brooklyn', 99);
insert into Season (title, ShowID)
values ('Kairat', 66);
insert into Season (title, ShowID)
values ('She''s Out of Control', 11);
insert into Season (title, ShowID)
values ('Ten Thousand Saints', 91);
insert into Season (title, ShowID)
values ('Big Eden', 34);
insert into Season (title, ShowID)
values ('Greater Promise, A (Iskateli Schastya)', 49);
insert into Season (title, ShowID)
values ('Raising Cain', 72);
insert into Season (title, ShowID)
values ('Boys: The Sherman Brothers'' Story, The', 42);
insert into Season (title, ShowID)
values ('Dragon Age: Blood mage no seisen (a.k.a. Dragon Age: Dawn of the Seeker)', 52);
insert into Season (title, ShowID)
values ('Like Sunday, Like Rain', 83);
insert into Season (title, ShowID)
values ('What Happened Was...', 59);
insert into Season (title, ShowID)
values ('Fly Away Home', 86);
insert into Season (title, ShowID)
values ('Hawking', 19);
insert into Season (title, ShowID)
values ('That Championship Season', 25);
insert into Season (title, ShowID)
values ('Mercy', 15);
insert into Season (title, ShowID)
values ('Above Suspicion', 84);
insert into Season (title, ShowID)
values ('Jagged Edge', 27);
insert into Season (title, ShowID)
values ('Disco Dancer', 10);
insert into Season (title, ShowID)
values ('Bangkok Dangerous', 87);
insert into Season (title, ShowID)
values ('Mighty Joe Young', 4);
insert into Season (title, ShowID)
values ('Go Fish', 94);
insert into Season (title, ShowID)
values ('Be with Me', 75);
insert into Season (title, ShowID)
values ('Phase IV', 66);
insert into Season (title, ShowID)
values ('Bat, The', 16);
insert into Season (title, ShowID)
values ('Immediate Family', 49);
insert into Season (title, ShowID)
values ('Children of the Corn 666: Isaac''s Return', 77);
insert into Season (title, ShowID)
values ('Ready to Rumble', 57);
insert into Season (title, ShowID)
values ('Animated Motion: Part 5', 64);
insert into Season (title, ShowID)
values ('Conqueror, The', 5);
insert into Season (title, ShowID)
values ('Mr. Holland''s Opus', 86);
insert into Season (title, ShowID)
values ('Man Who Loved Cat Dancing, The', 29);
insert into Season (title, ShowID)
values ('Living Wake, The', 98);
insert into Season (title, ShowID)
values ('Reign of Assassins', 41);
insert into Season (title, ShowID)
values ('Call Her Savage', 26);
insert into Season (title, ShowID)
values ('Invisible Target (Naam yi boon sik)', 33);
insert into Season (title, ShowID)
values ('Breaking In', 18);
insert into Season (title, ShowID)
values ('Girl with Green Eyes', 71);
insert into Season (title, ShowID)
values ('Ruby in Paradise', 27);
insert into Season (title, ShowID)
values ('Konopielka', 62);
insert into Season (title, ShowID)
values ('Young Einstein', 36);
insert into Season (title, ShowID)
values ('Love & Human Remains', 92);
insert into Season (title, ShowID)
values ('Free Will, The (Freie Wille, Der)', 24);
insert into Season (title, ShowID)
values ('Earth vs. the Spider', 8);
insert into Season (title, ShowID)
values ('Havre, Le', 36);
insert into Season (title, ShowID)
values ('Blind Fury', 13);
insert into Season (title, ShowID)
values ('Cavemen', 84);
insert into Season (title, ShowID)
values ('Searching for Bobby Fischer', 78);
insert into Season (title, ShowID)
values ('Madman', 43);
insert into Season (title, ShowID)
values ('Gracie', 47);
insert into Season (title, ShowID)
values ('Bob Funk', 4);
insert into Season (title, ShowID)
values ('Prisoner of Zenda, The', 25);
insert into Season (title, ShowID)
values ('Drive', 94);
insert into Season (title, ShowID)
values ('Kama Sutra: A Tale of Love', 80);
insert into Season (title, ShowID)
values ('Cop Land', 42);
insert into Season (title, ShowID)
values ('It Had to Be You', 93);
insert into Season (title, ShowID)
values ('Hellraiser', 37);
insert into Season (title, ShowID)
values ('Steam: The Turkish Bath (Hamam)', 52);
insert into Season (title, ShowID)
values ('Porky''s Revenge', 88);
insert into Season (title, ShowID)
values ('Welcome to the Jungle', 31);
insert into Season (title, ShowID)
values ('King of Thorn (King of Thorns) (Ibara no O)', 28);
insert into Season (title, ShowID)
values ('House of Angels (Änglagård)', 52);
insert into Season (title, ShowID)
values ('Thunderpants', 78);
insert into Season (title, ShowID)
values ('Stateside', 99);
insert into Season (title, ShowID)
values ('Don''t Be a Menace to South Central While Drinking Your Juice in the Hood', 20);


insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Star Trek VI: The Undiscovered Country', 33, '2022-01-09',
        'vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam',
        5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Premature Burial, The', 27, '2020-10-26', 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum',
        1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Mrs. Parker and the Vicious Circle', 53, '2009-01-09',
        'integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci',
        4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Wildflowers', 59, '2006-11-12', 'pede lobortis ligula sit amet eleifend pede libero quis orci nullam', 5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Nobody Lives Forever', 49, '2021-01-28',
        'vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in',
        5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Meet John Doe', 21, '2006-02-06',
        'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices',
        3);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Yves Saint Laurent', 43, '2002-12-08',
        'eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus', 5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Felix the Cat: The Movie', 33, '2016-01-01',
        'curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis',
        5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Get Well Soon', 53, '2001-08-30',
        'turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan', 1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Tango & Cash', 30, '2016-03-30', 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet', 4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Lana Turner... a Daughter''s Memoir', 27, '2009-11-09',
        'justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in', 2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Mandela: Long Walk to Freedom', 33, '2018-01-18',
        'eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus', 2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('The Eagle and the Hawk', 58, '2008-09-18',
        'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui', 3);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Dream Boy', 31, '2003-07-26', 'pretium quis lectus suspendisse potenti in eleifend quam a odio', 2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('With a Song in My Heart', 42, '2010-02-27',
        'turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at', 1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Solo ', 31, '2006-02-23',
        'sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede', 2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Show, The', 51, '2013-08-14',
        'sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus',
        2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Palme', 44, '2008-03-25', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', 3);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Blackball', 38, '2022-04-27',
        'mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient', 1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Grocer''s Son, The (Fils de l''épicier, Le)', 31, '2001-10-29',
        'facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget',
        4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Rasputin', 54, '2005-05-15', 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam', 4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('House, The (A Casa)', 33, '2001-08-13',
        'sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum',
        2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Bonnie Scotland (Heroes of the Regiment)', 54, '2006-03-10',
        'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh', 4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Fantomas', 36, '2008-03-25',
        'leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus',
        2);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Luminarias', 25, '2004-04-21',
        'sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue',
        4);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Americathon', 51, '2005-10-01',
        'in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum', 5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Attila (Attila the Hun)', 37, '2011-02-17',
        'proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate', 1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Client List, The', 52, '2010-01-05',
        'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at',
        5);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Evil - In the Time of Heroes (To kako - Stin epohi ton iroon)', 22, '2006-08-20',
        'vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum',
        1);
insert into Episode (title, runtime, releaseDate, description, SeasonID)
values ('Judy Berlin', 30, '2009-06-29',
        'sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam',
        4);

insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('From Within', 176, '1994-02-07', 7.01,
        'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        'http://dummyimage.com/237x191.png/5fa2dd/ffffff', 'http://dummyimage.com/127x160.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Illusionist, The (L''illusionniste)', 133, '1993-11-12', 5.91,
        'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',
        'http://dummyimage.com/147x132.png/ff4444/ffffff', 'http://dummyimage.com/131x180.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Angel''s Leap', 180, '2011-05-14', 6.12, 'Sed vel enim sit amet nunc viverra dapibus.',
        'http://dummyimage.com/174x234.png/5fa2dd/ffffff', 'http://dummyimage.com/121x116.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Treasure Island', 108, '2021-01-25', 9.26,
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.',
        'http://dummyimage.com/117x245.png/dddddd/000000', 'http://dummyimage.com/125x204.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Bridge, The', 130, '2001-08-25', 4.92, 'Vestibulum sed magna at nunc commodo placerat.',
        'http://dummyimage.com/185x160.png/5fa2dd/ffffff', 'http://dummyimage.com/157x146.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Who''s the Caboose?', 102, '2009-06-22', 9.86,
        'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.',
        'http://dummyimage.com/108x215.png/cc0000/ffffff', 'http://dummyimage.com/184x141.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Rat', 144, '1992-10-09', 8.75,
        'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.',
        'http://dummyimage.com/171x240.png/dddddd/000000', 'http://dummyimage.com/137x102.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Master of the Flying Guillotine', 128, '1998-07-13', 0.87,
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        'http://dummyimage.com/237x188.png/ff4444/ffffff', 'http://dummyimage.com/244x134.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Thrill of Brazil, The', 147, '2003-01-31', 1.56,
        'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.',
        'http://dummyimage.com/208x112.png/5fa2dd/ffffff', 'http://dummyimage.com/224x141.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Day at the Races, A', 112, '2012-10-11', 4.85, 'Pellentesque eget nunc.',
        'http://dummyimage.com/184x154.png/ff4444/ffffff', 'http://dummyimage.com/240x240.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('America: Imagine the World Without Her', 116, '2014-05-06', 3.93, 'Morbi a ipsum. Integer a nibh.',
        'http://dummyimage.com/161x170.png/dddddd/000000', 'http://dummyimage.com/105x167.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Wake Wood ', 107, '1997-05-17', 7.03,
        'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',
        'http://dummyimage.com/185x243.png/cc0000/ffffff', 'http://dummyimage.com/103x100.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Hyde Park on Hudson', 103, '2013-11-25', 6.82,
        'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',
        'http://dummyimage.com/169x183.png/ff4444/ffffff', 'http://dummyimage.com/117x163.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Confessions of a Burning Man', 101, '1992-11-19', 2.44, 'Aliquam quis turpis eget elit sodales scelerisque.',
        'http://dummyimage.com/192x172.png/cc0000/ffffff', 'http://dummyimage.com/168x239.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Crossover', 133, '2017-08-17', 4.01,
        'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.',
        'http://dummyimage.com/163x102.png/5fa2dd/ffffff', 'http://dummyimage.com/130x213.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Matthew''s Days', 161, '2016-07-26', 1.57, 'Donec semper sapien a libero. Nam dui.',
        'http://dummyimage.com/101x152.png/5fa2dd/ffffff', 'http://dummyimage.com/153x155.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('D.C.H. (Dil Chahta Hai)', 153, '2008-12-24', 0.8,
        'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.',
        'http://dummyimage.com/189x214.png/cc0000/ffffff', 'http://dummyimage.com/142x212.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Hope Floats', 146, '2014-03-13', 1.7,
        'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',
        'http://dummyimage.com/158x213.png/ff4444/ffffff', 'http://dummyimage.com/208x159.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Gunfighter, The', 135, '2009-11-06', 0.58, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.',
        'http://dummyimage.com/225x213.png/cc0000/ffffff', 'http://dummyimage.com/165x104.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Time of Peace (Tempos de Paz)', 133, '1991-01-11', 3.71,
        'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.',
        'http://dummyimage.com/206x115.png/cc0000/ffffff', 'http://dummyimage.com/217x243.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Tyler Perry''s Why Did I Get Married?', 108, '2019-08-23', 2.32,
        'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
        'http://dummyimage.com/186x249.png/ff4444/ffffff', 'http://dummyimage.com/235x177.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Return to Sender', 134, '2004-01-28', 2.75, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',
        'http://dummyimage.com/108x249.png/cc0000/ffffff', 'http://dummyimage.com/115x121.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Wake', 134, '2014-10-08', 6.59, 'Proin eu mi.', 'http://dummyimage.com/190x154.png/5fa2dd/ffffff',
        'http://dummyimage.com/233x240.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Brothers', 178, '2022-11-12', 6.24,
        'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.',
        'http://dummyimage.com/171x182.png/dddddd/000000', 'http://dummyimage.com/212x105.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Oh, Susanna!', 118, '2012-09-17', 6.52, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.',
        'http://dummyimage.com/174x231.png/5fa2dd/ffffff', 'http://dummyimage.com/100x155.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('16 to Life', 172, '2010-05-27', 9.51,
        'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.',
        'http://dummyimage.com/178x181.png/5fa2dd/ffffff', 'http://dummyimage.com/236x212.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('By the Sea', 170, '1999-05-25', 1.29, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.',
        'http://dummyimage.com/134x175.png/cc0000/ffffff', 'http://dummyimage.com/193x201.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Fingersmith', 131, '1992-06-07', 3.82,
        'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.',
        'http://dummyimage.com/129x143.png/ff4444/ffffff', 'http://dummyimage.com/136x182.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Daleks'' Invasion Earth: 2150 A.D.', 167, '1992-01-30', 0.74,
        'Duis bibendum. Morbi non quam nec dui luctus rutrum.', 'http://dummyimage.com/184x211.png/ff4444/ffffff',
        'http://dummyimage.com/144x147.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Open Up to Me (Kerron sinulle kaiken)', 119, '1995-08-18', 2.9,
        'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.',
        'http://dummyimage.com/222x164.png/ff4444/ffffff', 'http://dummyimage.com/176x126.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Upperworld', 168, '2022-04-02', 2.01,
        'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.',
        'http://dummyimage.com/171x112.png/cc0000/ffffff', 'http://dummyimage.com/136x116.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('White Noise 2: The Light', 129, '2016-07-30', 3.87,
        'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',
        'http://dummyimage.com/209x209.png/ff4444/ffffff', 'http://dummyimage.com/244x119.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Messengers, The', 138, '2000-07-22', 5.82,
        'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.',
        'http://dummyimage.com/167x120.png/dddddd/000000', 'http://dummyimage.com/108x179.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Very Good Girls', 148, '1997-07-22', 3.01,
        'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.',
        'http://dummyimage.com/235x240.png/cc0000/ffffff', 'http://dummyimage.com/151x176.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Satan''s Blood (Escalofrío)', 134, '2007-01-16', 6.92, 'Integer ac leo.',
        'http://dummyimage.com/171x216.png/cc0000/ffffff', 'http://dummyimage.com/163x148.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Hotel Chevalier', 126, '1999-05-31', 4.62,
        'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.',
        'http://dummyimage.com/164x208.png/cc0000/ffffff', 'http://dummyimage.com/165x140.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('These Three', 100, '2021-06-15', 3.99,
        'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.',
        'http://dummyimage.com/201x223.png/cc0000/ffffff', 'http://dummyimage.com/222x179.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Feuer, Eis & Dosenbier', 136, '1997-01-21', 7.14,
        'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.',
        'http://dummyimage.com/207x127.png/5fa2dd/ffffff', 'http://dummyimage.com/102x200.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Flicker (Flimmer)', 148, '2016-09-01', 7.19,
        'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.',
        'http://dummyimage.com/195x250.png/cc0000/ffffff', 'http://dummyimage.com/135x226.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Night Court', 130, '1992-01-04', 1.73, 'Cras in purus eu magna vulputate luctus.',
        'http://dummyimage.com/222x101.png/cc0000/ffffff', 'http://dummyimage.com/195x220.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Broken Arrow', 162, '2007-06-01', 1.4, 'Nullam varius. Nulla facilisi.',
        'http://dummyimage.com/145x200.png/ff4444/ffffff', 'http://dummyimage.com/105x185.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Oh, Heavenly Dog!', 149, '2018-12-22', 2.24,
        'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',
        'http://dummyimage.com/177x246.png/dddddd/000000', 'http://dummyimage.com/116x207.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Penelope', 105, '2003-05-04', 0.92, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.',
        'http://dummyimage.com/219x175.png/dddddd/000000', 'http://dummyimage.com/166x224.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Yonkers Joe', 147, '2011-12-14', 9.18, 'Aenean lectus. Pellentesque eget nunc.',
        'http://dummyimage.com/232x181.png/5fa2dd/ffffff', 'http://dummyimage.com/120x136.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Ned Kelly', 116, '1993-10-06', 4.05, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.',
        'http://dummyimage.com/124x209.png/ff4444/ffffff', 'http://dummyimage.com/105x178.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Eureka (Yurîka)', 158, '1995-01-27', 2.27,
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.',
        'http://dummyimage.com/134x176.png/ff4444/ffffff', 'http://dummyimage.com/190x177.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Splice', 124, '1997-12-20', 7.56, 'Cras in purus eu magna vulputate luctus.',
        'http://dummyimage.com/137x198.png/5fa2dd/ffffff', 'http://dummyimage.com/205x115.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Trois', 118, '2018-12-20', 1.29,
        'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.',
        'http://dummyimage.com/106x164.png/ff4444/ffffff', 'http://dummyimage.com/228x185.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Conspiracy of Torture, The (Beatrice Cenci)', 163, '2008-10-07', 7.18,
        'Aliquam erat volutpat. In congue. Etiam justo.', 'http://dummyimage.com/133x241.png/dddddd/000000',
        'http://dummyimage.com/186x140.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Perfect Plan, A (Plan parfait, Un)', 114, '2020-09-04', 9.19,
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',
        'http://dummyimage.com/135x103.png/dddddd/000000', 'http://dummyimage.com/217x119.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Riding Alone for Thousands of Miles (Qian li zou dan qi)', 128, '2011-09-09', 8.31,
        'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',
        'http://dummyimage.com/220x243.png/dddddd/000000', 'http://dummyimage.com/234x138.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Journey to the Center of the Earth', 109, '2016-09-04', 6.49,
        'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.',
        'http://dummyimage.com/167x115.png/5fa2dd/ffffff', 'http://dummyimage.com/111x215.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Giant Gila Monster, The', 125, '2022-05-18', 3.59,
        'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.',
        'http://dummyimage.com/218x128.png/ff4444/ffffff', 'http://dummyimage.com/151x191.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Torrid Zone', 134, '2007-01-24', 7.58, 'Vestibulum sed magna at nunc commodo placerat.',
        'http://dummyimage.com/121x213.png/5fa2dd/ffffff', 'http://dummyimage.com/106x192.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('X: The Man with the X-Ray Eyes', 101, '1994-01-31', 9.68, 'Morbi porttitor lorem id ligula.',
        'http://dummyimage.com/209x204.png/cc0000/ffffff', 'http://dummyimage.com/243x167.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Hill, The', 128, '2002-03-18', 1.48,
        'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.',
        'http://dummyimage.com/182x119.png/ff4444/ffffff', 'http://dummyimage.com/223x234.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Quo Vadis, Baby?', 102, '2016-06-27', 7.66,
        'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.',
        'http://dummyimage.com/239x131.png/ff4444/ffffff', 'http://dummyimage.com/106x219.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('You Were Never Lovelier', 119, '2006-11-25', 5.78,
        'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.',
        'http://dummyimage.com/244x119.png/5fa2dd/ffffff', 'http://dummyimage.com/208x222.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Cornered', 142, '2005-01-27', 8.17, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.',
        'http://dummyimage.com/119x197.png/5fa2dd/ffffff', 'http://dummyimage.com/249x207.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Idiots, The (Idioterne)', 154, '2007-06-24', 0.72,
        'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.',
        'http://dummyimage.com/148x149.png/dddddd/000000', 'http://dummyimage.com/154x231.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('To Joy (Till glädje)', 127, '2015-04-27', 5.62,
        'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.',
        'http://dummyimage.com/103x193.png/5fa2dd/ffffff', 'http://dummyimage.com/171x198.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Great Ecstasy of Robert Carmichael, The', 106, '2006-06-02', 6.68,
        'Vestibulum ac est lacinia nisi venenatis tristique.', 'http://dummyimage.com/144x246.png/dddddd/000000',
        'http://dummyimage.com/164x124.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Isolation', 105, '2008-01-12', 3.89, 'Nunc nisl.', 'http://dummyimage.com/246x145.png/cc0000/ffffff',
        'http://dummyimage.com/132x167.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('30 Beats', 115, '2019-07-20', 6.2, 'Aliquam quis turpis eget elit sodales scelerisque.',
        'http://dummyimage.com/179x188.png/5fa2dd/ffffff', 'http://dummyimage.com/185x109.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Oil, the Baby and the Transylvanians, The (Pruncul, petrolul si Ardelenii)', 131, '2013-11-11', 5.36,
        'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',
        'http://dummyimage.com/150x127.png/cc0000/ffffff', 'http://dummyimage.com/121x103.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Jack Frost', 176, '2006-11-27', 3.94, 'Pellentesque at nulla.',
        'http://dummyimage.com/202x105.png/cc0000/ffffff', 'http://dummyimage.com/204x200.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Babymother', 122, '2016-10-20', 5.91, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.',
        'http://dummyimage.com/207x172.png/cc0000/ffffff', 'http://dummyimage.com/183x222.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Open Water', 107, '2008-02-07', 5.43,
        'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.',
        'http://dummyimage.com/214x206.png/5fa2dd/ffffff', 'http://dummyimage.com/175x193.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Pyrates', 112, '2010-03-23', 1.94,
        'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.',
        'http://dummyimage.com/220x193.png/dddddd/000000', 'http://dummyimage.com/196x138.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Uptown Saturday Night', 112, '2014-06-06', 0.33,
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        'http://dummyimage.com/172x166.png/5fa2dd/ffffff', 'http://dummyimage.com/222x184.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Welcome to the Space Show (Uchû shô e yôkoso)', 121, '2014-06-13', 7.89,
        'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',
        'http://dummyimage.com/174x195.png/dddddd/000000', 'http://dummyimage.com/144x136.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Invisible Ray, The', 148, '1996-09-24', 4.98, 'Proin eu mi. Nulla ac enim.',
        'http://dummyimage.com/211x201.png/5fa2dd/ffffff', 'http://dummyimage.com/218x210.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Waxwork', 131, '2006-11-16', 8.26, 'Suspendisse ornare consequat lectus.',
        'http://dummyimage.com/245x109.png/ff4444/ffffff', 'http://dummyimage.com/203x229.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Morgen', 115, '2002-12-27', 5.8, 'Nulla ac enim.', 'http://dummyimage.com/242x106.png/dddddd/000000',
        'http://dummyimage.com/241x140.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Maria Full of Grace (Maria, Llena eres de gracia)', 104, '2018-02-19', 1.7,
        'Etiam pretium iaculis justo. In hac habitasse platea dictumst.',
        'http://dummyimage.com/182x218.png/5fa2dd/ffffff', 'http://dummyimage.com/230x125.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('The Gruffalo''s Child', 173, '2009-08-13', 9.9,
        'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.',
        'http://dummyimage.com/119x118.png/cc0000/ffffff', 'http://dummyimage.com/159x184.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Life Apart: Hasidism in America, A', 109, '2016-10-22', 2.55,
        'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.',
        'http://dummyimage.com/158x133.png/ff4444/ffffff', 'http://dummyimage.com/102x217.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Bill Bailey: Tinselworm', 110, '1999-03-25', 9.02,
        'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.',
        'http://dummyimage.com/188x223.png/ff4444/ffffff', 'http://dummyimage.com/226x231.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Lesser Blessed, The', 127, '1996-09-14', 0.31,
        'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.',
        'http://dummyimage.com/120x129.png/ff4444/ffffff', 'http://dummyimage.com/249x198.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Alien Nation: Dark Horizon', 145, '2005-11-18', 4.44,
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.',
        'http://dummyimage.com/196x112.png/ff4444/ffffff', 'http://dummyimage.com/119x118.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Goin'' South', 158, '2012-02-27', 8.73,
        'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        'http://dummyimage.com/180x215.png/ff4444/ffffff', 'http://dummyimage.com/238x117.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('The Tunnel of Love', 143, '2001-03-28', 1.31, 'Duis ac nibh.',
        'http://dummyimage.com/115x106.png/5fa2dd/ffffff', 'http://dummyimage.com/101x104.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('London', 173, '1991-10-05', 0.63, 'Fusce consequat. Nulla nisl. Nunc nisl.',
        'http://dummyimage.com/186x109.png/ff4444/ffffff', 'http://dummyimage.com/116x108.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Asfour Stah', 139, '2014-07-24', 7.02, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.',
        'http://dummyimage.com/189x139.png/cc0000/ffffff', 'http://dummyimage.com/138x139.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Unknown White Male', 143, '2007-06-19', 0.84, 'Maecenas ut massa quis augue luctus tincidunt.',
        'http://dummyimage.com/133x240.png/dddddd/000000', 'http://dummyimage.com/209x227.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Passenger Side', 120, '2018-11-11', 5.33, 'Nunc purus.', 'http://dummyimage.com/118x166.png/5fa2dd/ffffff',
        'http://dummyimage.com/137x155.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Killers from Space', 132, '2012-02-17', 5.27, 'Nulla ac enim.',
        'http://dummyimage.com/148x203.png/dddddd/000000', 'http://dummyimage.com/120x166.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Komodo', 173, '2001-04-01', 9.1,
        'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.',
        'http://dummyimage.com/124x232.png/dddddd/000000', 'http://dummyimage.com/244x153.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Wednesday!, A', 100, '1998-04-03', 1.7, 'Fusce posuere felis sed lacus.',
        'http://dummyimage.com/159x192.png/cc0000/ffffff', 'http://dummyimage.com/225x184.png/dddddd/000000', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Hamlet', 110, '2020-05-05', 1.78,
        'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.',
        'http://dummyimage.com/199x196.png/cc0000/ffffff', 'http://dummyimage.com/211x216.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Magic in the Water', 150, '1992-05-05', 5.73,
        'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.',
        'http://dummyimage.com/167x108.png/cc0000/ffffff', 'http://dummyimage.com/154x230.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Confessions of a Nazi Spy', 144, '2016-04-09', 7.69,
        'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.',
        'http://dummyimage.com/200x135.png/5fa2dd/ffffff', 'http://dummyimage.com/224x171.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Still Life', 169, '1995-05-31', 3.51,
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.',
        'http://dummyimage.com/189x165.png/ff4444/ffffff', 'http://dummyimage.com/131x191.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('No God, No Master', 106, '2016-07-02', 4.3,
        'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.',
        'http://dummyimage.com/210x106.png/cc0000/ffffff', 'http://dummyimage.com/217x206.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Devil, The (Diabel)', 173, '1994-02-09', 6.44, 'Vestibulum rutrum rutrum neque.',
        'http://dummyimage.com/187x181.png/dddddd/000000', 'http://dummyimage.com/240x239.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Dylan Moran: Like, Totally', 167, '2000-02-02', 8.31,
        'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.',
        'http://dummyimage.com/118x177.png/cc0000/ffffff', 'http://dummyimage.com/237x139.png/cc0000/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Pillow of Death', 173, '2001-05-02', 7.3,
        'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.',
        'http://dummyimage.com/142x136.png/ff4444/ffffff', 'http://dummyimage.com/186x142.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Drogówka', 145, '1997-02-23', 6.33,
        'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.',
        'http://dummyimage.com/139x212.png/ff4444/ffffff', 'http://dummyimage.com/143x177.png/5fa2dd/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Africa: The Serengeti', 138, '2013-09-07', 7.03,
        'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.',
        'http://dummyimage.com/149x228.png/dddddd/000000', 'http://dummyimage.com/179x139.png/ff4444/ffffff', null);
insert into Movie (title, runtime, releaseDate, IMDBRating, description, trailer, image, SeriesID)
values ('Angela''s Ashes', 132, '1999-05-21', 7.47,
        'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.',
        'http://dummyimage.com/205x112.png/5fa2dd/ffffff', 'http://dummyimage.com/151x205.png/dddddd/000000', null);

insert into Series (title)
values ('Harry Potter');
insert into Series (title)
values ('Hunger Games');

insert into TVShow (title, description, IMDBRating, image)
values ('Camera Buff (Amator)',
        'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.',
        2.43, 'http://dummyimage.com/140x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Return to Horror High', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.',
        5.73, 'http://dummyimage.com/153x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Come Drink with Me (Da zui xia)',
        'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.',
        9.36, 'http://dummyimage.com/166x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Cry in the Night, A',
        'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.',
        4.57, 'http://dummyimage.com/113x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Toni',
        'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.',
        0.83, 'http://dummyimage.com/142x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Dawn Patrol, The (Flight Commander)', 'Aenean sit amet justo. Morbi ut odio.', 0.47,
        'http://dummyimage.com/214x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Splatter University',
        'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',
        3.07, 'http://dummyimage.com/130x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Impromptu',
        'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 3.83,
        'http://dummyimage.com/174x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Day of the Jackal, The', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2.99,
        'http://dummyimage.com/228x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('How to Make an American Quilt',
        'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        1.82, 'http://dummyimage.com/160x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Snake Pit, The',
        'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.',
        4.96, 'http://dummyimage.com/116x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Garden, The',
        'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        4.82, 'http://dummyimage.com/248x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Faat Kiné',
        'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.',
        3.74, 'http://dummyimage.com/179x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Lupin III: The Castle Of Cagliostro (Rupan sansei: Kariosutoro no shiro)',
        'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.',
        9.73, 'http://dummyimage.com/197x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Money Matters ',
        'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.',
        0.82, 'http://dummyimage.com/150x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('From Russia with Love',
        'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.',
        1.2, 'http://dummyimage.com/194x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Funny Games U.S.',
        'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',
        8.05, 'http://dummyimage.com/170x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Spirit, The',
        'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', 9.5,
        'http://dummyimage.com/192x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Lay of the Land, The',
        'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.',
        5.12, 'http://dummyimage.com/217x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Jersey Boys', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 3.74,
        'http://dummyimage.com/144x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Prestige, The',
        'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.',
        5.71, 'http://dummyimage.com/201x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('I Am a Fugitive from a Chain Gang', 'Fusce consequat. Nulla nisl. Nunc nisl.', 4.54,
        'http://dummyimage.com/187x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Doodlebug',
        'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.',
        2.19, 'http://dummyimage.com/128x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Princess and the Pony',
        'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.',
        2.79, 'http://dummyimage.com/239x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Afterglow',
        'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
        8.5, 'http://dummyimage.com/171x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('I aionia epistrofi tou Antoni Paraskeva', 'Suspendisse potenti. In eleifend quam a odio.', 1.46,
        'http://dummyimage.com/111x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Pray the Devil Back to Hell', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', 4.59,
        'http://dummyimage.com/240x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('White Noise 2: The Light',
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.',
        7.56, 'http://dummyimage.com/194x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Three (a.k.a. 3 Extremes II) (Saam gaang)',
        'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',
        9.2, 'http://dummyimage.com/167x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Bitch Slap',
        'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.',
        9.16, 'http://dummyimage.com/165x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Säg att du älskar mig',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.',
        2.36, 'http://dummyimage.com/137x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('G.B.F.', 'Nulla mollis molestie lorem. Quisque ut erat.', 0.06,
        'http://dummyimage.com/212x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('30 Beats', 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 9.73,
        'http://dummyimage.com/172x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Big Hit, The',
        'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.',
        6.44, 'http://dummyimage.com/222x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Charlotte''s Web',
        'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', 3.98,
        'http://dummyimage.com/226x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Last Trapper, The (Le dernier trappeur)', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.',
        6.63, 'http://dummyimage.com/201x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Lotte Reiniger: Homage to the Inventor of the Silhouette Film',
        'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.',
        3.04, 'http://dummyimage.com/167x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Uncommon Valor',
        'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
        3.84, 'http://dummyimage.com/201x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('True Romance', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 1.63,
        'http://dummyimage.com/117x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Generation Kill', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', 0.82,
        'http://dummyimage.com/115x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Wrath of the Titans',
        'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.',
        6.62, 'http://dummyimage.com/247x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Aliens of the Deep',
        'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.',
        8.49, 'http://dummyimage.com/197x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Leonard Part 6',
        'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
        9.93, 'http://dummyimage.com/174x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('You Again',
        'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.',
        9.06, 'http://dummyimage.com/109x100.png/dddddd/000000');
insert into TVShow (title, description, IMDBRating, image)
values ('Bye Bye Braverman', 'Nulla mollis molestie lorem. Quisque ut erat.', 2.15,
        'http://dummyimage.com/172x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Sharpe''s Gold',
        'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.',
        6.48, 'http://dummyimage.com/152x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Madhouse',
        'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',
        2.57, 'http://dummyimage.com/205x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Monty Python''s Life of Brian',
        'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.',
        8.29, 'http://dummyimage.com/190x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Hellgate', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.',
        6.83, 'http://dummyimage.com/151x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Fast and the Furious, The',
        'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',
        4.61, 'http://dummyimage.com/151x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Beowulf',
        'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.',
        3.98, 'http://dummyimage.com/244x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Mall Girls (Galerianki)', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', 4.82,
        'http://dummyimage.com/194x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('London to Brighton', 'Nullam molestie nibh in lectus. Pellentesque at nulla.', 2.45,
        'http://dummyimage.com/130x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Enid Is Sleeping',
        'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.',
        5.49, 'http://dummyimage.com/123x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Dirty Story',
        'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', 2.18,
        'http://dummyimage.com/101x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Actress, the Dollars and the Transylvanians, The (Artista, dolarii si Ardelenii)',
        'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.',
        6.16, 'http://dummyimage.com/161x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Get on Up', 'Nunc purus. Phasellus in felis. Donec semper sapien a libero.', 9.87,
        'http://dummyimage.com/229x100.png/ff4444/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('200 M.P.H.', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 0.64,
        'http://dummyimage.com/243x100.png/cc0000/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Beethoven''s Big Break',
        'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.',
        2.13, 'http://dummyimage.com/212x100.png/5fa2dd/ffffff');
insert into TVShow (title, description, IMDBRating, image)
values ('Mondo Hollywood',
        'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',
        0.97, 'http://dummyimage.com/199x100.png/ff4444/ffffff');

insert into UserAdmin (UserID, AdminID)
values (9, 3);
insert into UserAdmin (UserID, AdminID)
values (6, 1);
insert into UserAdmin (UserID, AdminID)
values (9, 4);
insert into UserAdmin (UserID, AdminID)
values (6, 2);
insert into UserAdmin (UserID, AdminID)
values (2, 2);
insert into UserAdmin (UserID, AdminID)
values (10, 1);
insert into UserAdmin (UserID, AdminID)
values (6, 4);
insert into UserAdmin (UserID, AdminID)
values (3, 2);
insert into UserAdmin (UserID, AdminID)
values (5, 1);
insert into UserAdmin (UserID, AdminID)
values (2, 5);

insert into CriticAdmin (CriticID, AdminID)
values (2, 2);
insert into CriticAdmin (CriticID, AdminID)
values (3, 2);
insert into CriticAdmin (CriticID, AdminID)
values (5, 2);
insert into CriticAdmin (CriticID, AdminID)
values (2, 6);
insert into CriticAdmin (CriticID, AdminID)
values (3, 3);
insert into CriticAdmin (CriticID, AdminID)
values (4, 1);
insert into CriticAdmin (CriticID, AdminID)
values (4, 2);
insert into CriticAdmin (CriticID, AdminID)
values (5, 3);
insert into CriticAdmin (CriticID, AdminID)
values (3, 1);
insert into CriticAdmin (CriticID, AdminID)
values (5, 7);

insert into MovieLike (MovieID, UserID)
values (10, 8);
insert into MovieLike (MovieID, UserID)
values (2, 1);
insert into MovieLike (MovieID, UserID)
values (8, 2);
insert into MovieLike (MovieID, UserID)
values (10, 1);
insert into MovieLike (MovieID, UserID)
values (2, 4);
insert into MovieLike (MovieID, UserID)
values (2, 3);
insert into MovieLike (MovieID, UserID)
values (9, 7);
insert into MovieLike (MovieID, UserID)
values (3, 8);
insert into MovieLike (MovieID, UserID)
values (7, 7);
insert into MovieLike (MovieID, UserID)
values (5, 3);

insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (89, 3, 7.12, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2022-09-05 18:56:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (76, 1, 6.86, 'Curabitur in libero ut massa volutpat convallis.', '2013-10-25 17:50:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (87, 1, 7.69, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2014-10-13 20:05:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (10, 5, 2.66, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2016-05-03 22:29:18');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (22, 5, 9.42, 'Etiam justo. Etiam pretium iaculis justo.', '2011-08-20 02:29:32');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (30, 3, 7.67, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2016-10-01 21:37:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (22, 3, 6.49, 'Nulla ac enim.', '2020-09-26 03:53:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (25, 4, 7.1, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2018-08-13 21:12:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (35, 1, 5.76, 'Fusce consequat.', '2013-03-28 05:08:32');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (4, 2, 1.56, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2017-10-12 00:15:31');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (28, 3, 8.41, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2013-03-13 17:37:59');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (30, 4, 2.82, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2021-12-29 01:30:44');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (32, 1, 9.75, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', '2015-06-05 01:24:07');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (2, 5, 2.07, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2020-05-02 13:12:43');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (44, 2, 7.81, 'Morbi ut odio.', '2016-01-12 16:45:40');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (34, 5, 8.26, 'Sed sagittis.', '2012-06-20 04:51:04');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (27, 2, 7.81, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2020-06-15 05:17:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (65, 1, 2.77, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2014-06-04 14:25:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (60, 2, 5.8, 'Proin interdum mauris non ligula pellentesque ultrices.', '2014-06-16 00:20:39');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (82, 5, 5.65, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2022-11-02 17:09:14');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (29, 3, 1.66, 'Morbi porttitor lorem id ligula.', '2019-06-28 07:09:31');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (92, 5, 4.85, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2022-05-23 05:23:19');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (97, 3, 8.25, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2018-01-02 15:29:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (42, 2, 9.03, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2013-04-07 18:32:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (96, 5, 4.43, 'Etiam justo. Etiam pretium iaculis justo.', '2014-11-07 01:04:12');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (2, 2, 9.12, 'Sed vel enim sit amet nunc viverra dapibus.', '2015-02-21 20:46:24');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (20, 3, 9.02, 'Aliquam erat volutpat.', '2022-10-27 10:21:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (51, 2, 1.77, 'Nullam varius. Nulla facilisi.', '2018-08-14 07:44:34');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (35, 2, 4.12, 'Aenean lectus. Pellentesque eget nunc.', '2014-03-05 05:39:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (91, 4, 1.25, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2014-05-16 19:39:02');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (12, 4, 8.48, 'Nullam molestie nibh in lectus.', '2016-10-31 23:16:14');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (53, 3, 1.92, 'Fusce posuere felis sed lacus.', '2013-05-18 12:50:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (10, 4, 6.21, 'Nulla tellus. In sagittis dui vel nisl.', '2017-03-31 11:33:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (86, 5, 3.12, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2020-04-06 20:13:18');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (57, 4, 5.61, 'Nulla tellus.', '2011-06-01 10:13:50');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (55, 3, 6.24, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2018-12-22 21:51:58');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (74, 1, 9.33, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2017-12-17 11:16:07');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (62, 4, 8.86, 'Aliquam erat volutpat. In congue.', '2021-01-03 16:26:46');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (53, 4, 2.08, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2018-07-27 08:38:12');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (20, 5, 6.93, 'Donec vitae nisi.', '2017-02-06 10:26:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (16, 3, 2.33, 'In hac habitasse platea dictumst.', '2011-03-12 08:19:39');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (62, 1, 3.09, 'Vestibulum sed magna at nunc commodo placerat.', '2018-03-17 18:52:40');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (72, 1, 9.62, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2012-12-18 11:31:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (19, 4, 8.16, 'Donec ut mauris eget massa tempor convallis.', '2017-08-16 17:15:14');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (87, 5, 7.42, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2013-09-24 16:23:19');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (70, 2, 8.13, 'In hac habitasse platea dictumst.', '2018-11-24 10:41:30');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (62, 2, 7.63, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2013-10-21 21:27:42');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (84, 5, 3.6, 'Phasellus in felis. Donec semper sapien a libero.', '2019-09-27 13:20:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (81, 3, 3.17, 'Mauris ullamcorper purus sit amet nulla.', '2016-03-07 08:30:58');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (7, 3, 7.95, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2020-10-19 12:31:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (54, 4, 7.6, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2022-11-09 13:18:12');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (52, 1, 9.27, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2022-02-15 14:38:56');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (56, 4, 5.56, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2021-07-17 14:06:48');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (17, 2, 8.09, 'Aenean fermentum.', '2017-11-06 01:02:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (82, 3, 2.43, 'Nunc purus.', '2016-12-27 21:14:10');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (32, 2, 2.65, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2011-03-15 03:55:05');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (59, 4, 1.02, 'Maecenas ut massa quis augue luctus tincidunt.', '2019-10-18 17:27:14');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (41, 1, 4.1, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2018-01-28 13:47:49');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (33, 3, 5.13, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2017-03-22 07:53:27');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (33, 5, 9.2, 'Cras pellentesque volutpat dui.', '2016-09-21 09:11:57');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (95, 1, 8.45, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2012-04-30 09:22:00');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (36, 2, 7.64, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2015-07-30 01:27:05');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (96, 4, 9.57, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.', '2012-04-12 10:25:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (41, 3, 3.96, 'Aenean fermentum.', '2019-07-28 17:10:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (19, 4, 8.35, 'Maecenas rhoncus aliquam lacus.', '2014-02-06 20:13:54');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (22, 2, 4.18, 'Fusce consequat. Nulla nisl.', '2014-07-21 04:55:46');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (12, 3, 5.68, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2016-02-01 12:57:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (80, 4, 8.49, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '2011-08-30 05:13:48');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (67, 3, 9.77, 'Nulla tellus.', '2013-08-04 12:36:52');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (85, 2, 4.71, 'Donec ut mauris eget massa tempor convallis.', '2019-09-08 16:14:31');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (63, 4, 6.85, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2016-03-17 03:24:52');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (62, 4, 3.8, 'Aenean lectus.', '2020-10-11 05:29:10');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (37, 3, 7.74, 'Sed vel enim sit amet nunc viverra dapibus.', '2021-02-06 04:15:54');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (24, 3, 7.75, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2013-02-04 16:11:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (29, 2, 5.65, 'In hac habitasse platea dictumst.', '2011-09-23 18:49:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (3, 1, 10.0, 'In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2014-03-09 04:56:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (38, 1, 8.11, 'Proin at turpis a pede posuere nonummy.', '2011-08-13 01:36:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (74, 4, 4.86, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2017-02-11 14:54:18');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (38, 5, 1.94, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2016-08-29 07:23:50');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (13, 4, 4.96, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2020-08-13 07:35:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (19, 5, 1.05, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2013-07-08 09:43:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (63, 3, 8.45, 'Fusce consequat.', '2019-11-19 05:59:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (71, 1, 5.59, 'Donec ut mauris eget massa tempor convallis.', '2021-06-01 21:38:13');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (24, 5, 1.1, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2020-06-30 07:57:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (42, 3, 6.12, 'Maecenas ut massa quis augue luctus tincidunt.', '2022-02-14 04:49:15');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (65, 2, 2.01, 'Cras non velit nec nisi vulputate nonummy.', '2020-11-15 08:14:58');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (65, 4, 5.02, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '2015-07-16 19:07:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (74, 5, 9.64, 'Donec posuere metus vitae ipsum.', '2013-03-24 18:31:47');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (54, 5, 6.04, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2014-02-13 07:04:56');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (3, 1, 7.53, 'Ut tellus.', '2017-05-13 17:12:48');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (69, 3, 8.52, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2014-11-20 12:47:19');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (72, 5, 6.44, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2018-05-22 02:28:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (33, 4, 8.79, 'Quisque porta volutpat erat.', '2021-09-30 02:32:40');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (91, 3, 4.76, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2020-06-18 22:44:55');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (87, 1, 2.89, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2017-12-25 09:05:57');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (2, 3, 1.8, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2022-02-16 12:27:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (4, 2, 5.55, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2019-11-27 16:18:11');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (2, 5, 7.74, 'Nulla ac enim.', '2017-02-11 11:28:51');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (36, 5, 3.39, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2012-06-22 21:37:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (74, 1, 8.02, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2013-11-14 03:50:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (13, 1, 5.51, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2017-05-14 20:58:33');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (8, 1, 2.27, 'Aliquam erat volutpat. In congue.', '2021-11-20 13:26:43');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (60, 2, 4.55, 'Donec semper sapien a libero.', '2018-07-22 17:15:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (92, 4, 5.53, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2019-09-29 00:56:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (52, 4, 1.25, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2020-04-15 00:45:17');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (86, 1, 6.17, 'Phasellus in felis. Donec semper sapien a libero.', '2017-04-23 19:20:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (23, 3, 5.24, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2020-04-07 11:29:59');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (45, 3, 9.36, 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2021-12-05 05:00:43');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (88, 2, 1.66, 'Nunc purus.', '2016-05-11 13:30:52');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (1, 3, 1.8, 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2016-07-21 22:34:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (83, 1, 4.48, 'Fusce consequat.', '2020-01-05 20:04:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (61, 2, 2.32, 'Aliquam erat volutpat.', '2018-01-17 13:51:18');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (66, 2, 6.58, 'Phasellus in felis.', '2020-05-07 23:22:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (24, 1, 4.15, 'Aliquam erat volutpat.', '2021-01-20 11:27:42');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (31, 5, 5.47, 'Nulla suscipit ligula in lacus.', '2013-05-06 09:56:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (86, 4, 9.23, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2016-10-23 18:37:10');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (4, 3, 8.67, 'Integer tincidunt ante vel ipsum.', '2010-12-23 07:30:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (53, 1, 1.81, 'Etiam justo. Etiam pretium iaculis justo.', '2022-11-03 00:22:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (100, 5, 6.89, 'Etiam justo. Etiam pretium iaculis justo.', '2015-06-22 05:12:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (43, 2, 8.38, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2019-06-28 13:10:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (100, 1, 2.65, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2013-05-15 14:39:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (20, 1, 5.77, 'Nullam porttitor lacus at turpis.', '2011-05-16 09:38:31');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (61, 2, 7.51, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2019-03-29 19:27:58');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (38, 2, 9.81, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2019-06-15 21:20:54');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (71, 2, 5.7, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2021-10-11 11:58:27');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (59, 3, 5.85, 'Sed ante. Vivamus tortor.', '2015-10-11 09:28:48');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (29, 1, 1.3, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '2012-02-02 20:13:43');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (89, 1, 5.83, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2016-12-18 21:35:19');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (31, 2, 6.03, 'Praesent blandit. Nam nulla.', '2016-06-01 07:18:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (19, 2, 5.64, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2011-03-27 04:31:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (100, 4, 2.47, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2017-10-31 21:20:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (95, 2, 7.57, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2020-04-11 05:13:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (49, 5, 7.92, 'Suspendisse potenti.', '2022-09-20 00:59:40');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (72, 4, 4.07, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2015-10-22 23:34:00');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (59, 1, 8.2, 'Suspendisse ornare consequat lectus.', '2017-02-24 08:29:53');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (97, 2, 6.63, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-10-27 10:03:23');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (63, 1, 2.53, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2012-12-03 02:48:54');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (53, 5, 9.11, 'Ut tellus.', '2014-02-12 22:28:22');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (11, 1, 6.05, 'Nam nulla.', '2017-01-09 03:34:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (50, 2, 8.99, 'Cras in purus eu magna vulputate luctus.', '2011-02-18 11:12:17');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (68, 4, 9.36, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2017-12-04 00:22:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (41, 4, 3.23, 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2022-11-24 15:27:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (58, 3, 1.78, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2013-01-14 08:34:37');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (74, 2, 1.4, 'In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2013-11-29 19:48:28');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (46, 4, 3.77, 'Nulla ut erat id mauris vulputate elementum.', '2019-03-31 13:00:07');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (79, 4, 5.63, 'Integer a nibh.', '2022-05-05 21:44:57');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (53, 3, 1.71, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2017-12-04 22:38:34');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (92, 4, 5.87, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2013-10-26 07:35:53');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (64, 1, 2.85, 'Cras pellentesque volutpat dui.', '2020-01-13 05:15:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (80, 1, 1.08, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2019-04-12 01:08:44');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (62, 5, 5.19, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2016-02-29 23:16:34');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (22, 4, 2.17, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2019-01-01 02:28:56');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (45, 5, 8.31, 'Nulla tellus. In sagittis dui vel nisl.', '2011-01-14 04:44:21');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (46, 4, 7.61, 'In eleifend quam a odio.', '2020-11-21 16:31:50');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (1, 5, 1.99, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2011-12-14 23:41:44');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (76, 3, 1.36, 'Nulla nisl. Nunc nisl.', '2016-05-18 16:58:11');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (7, 5, 8.94, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2017-06-30 16:01:33');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (47, 4, 8.33, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2016-12-04 13:16:35');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (52, 5, 9.08, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2017-08-31 19:56:51');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (57, 2, 1.85, 'Pellentesque ultrices mattis odio. Donec vitae nisi.', '2015-03-20 23:22:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (87, 5, 9.97, 'Pellentesque viverra pede ac diam.', '2020-02-09 03:06:51');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (39, 2, 4.33, 'In hac habitasse platea dictumst.', '2014-12-29 07:50:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (66, 4, 2.85, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2020-09-03 14:23:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (67, 2, 8.73, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2015-06-25 19:34:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (45, 1, 7.78, 'Donec ut dolor.', '2020-09-24 08:16:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (76, 2, 3.39, 'In blandit ultrices enim.', '2021-10-09 11:19:32');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (66, 1, 3.8, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2020-05-14 05:57:42');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (97, 1, 8.54, 'Aliquam non mauris.', '2020-04-12 04:51:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (14, 3, 1.4, 'Maecenas rhoncus aliquam lacus.', '2018-07-28 17:18:52');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (76, 4, 7.6, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2011-07-10 16:48:37');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (45, 3, 6.76, 'Etiam vel augue. Vestibulum rutrum rutrum neque.', '2021-10-14 17:12:43');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (58, 5, 9.97, 'In sagittis dui vel nisl. Duis ac nibh.', '2021-06-16 03:07:17');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (81, 2, 2.27, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2011-11-21 09:38:48');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (48, 2, 1.89, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2019-03-24 18:06:32');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (69, 4, 3.65, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2014-08-04 15:23:32');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (2, 3, 5.41, 'Nulla tellus.', '2014-11-11 11:02:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (52, 5, 2.13, 'Pellentesque eget nunc.', '2018-10-10 12:54:06');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (46, 5, 9.04, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2020-03-05 14:56:40');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (83, 2, 5.35, 'Donec posuere metus vitae ipsum.', '2016-12-11 09:14:31');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (42, 1, 2.17, 'Nulla tellus.', '2015-05-27 06:20:09');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (27, 5, 3.7, 'Nulla tempus.', '2014-11-01 23:22:41');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (85, 5, 7.99, 'Suspendisse ornare consequat lectus.', '2013-12-19 15:11:18');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (69, 3, 4.99, 'In sagittis dui vel nisl.', '2022-02-22 04:56:20');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (29, 4, 5.61, 'In sagittis dui vel nisl.', '2016-12-06 12:43:04');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (86, 4, 7.5, 'In eleifend quam a odio.', '2017-11-08 16:05:12');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (42, 1, 5.4, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2020-07-20 17:30:26');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (37, 1, 8.76, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2013-10-14 22:51:51');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (11, 2, 7.26, 'Maecenas tincidunt lacus at velit.', '2011-06-24 16:14:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (13, 5, 5.5, 'Phasellus in felis.', '2016-01-11 00:49:16');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (45, 5, 9.42, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2021-06-21 17:59:38');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (100, 4, 9.9, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2021-05-05 15:49:57');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (85, 2, 5.85, 'Donec semper sapien a libero.', '2015-03-25 01:31:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (43, 2, 3.55, 'Praesent blandit lacinia erat.', '2013-10-09 18:20:02');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (89, 2, 7.18, 'Pellentesque ultrices mattis odio.', '2020-03-05 17:45:36');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (96, 3, 5.95, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2016-10-01 19:54:28');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (89, 4, 8.47, 'Sed vel enim sit amet nunc viverra dapibus.', '2017-12-13 01:46:01');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (54, 2, 9.02, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2014-02-04 12:34:45');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (48, 5, 2.26, 'Maecenas pulvinar lobortis est.', '2017-01-12 16:46:34');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (93, 2, 4.71, 'Nunc nisl.', '2012-06-19 22:54:50');
insert into MovieRating (MovieID, CriticID, Rating, Comment, Date) values (24, 5, 3.01, 'Nulla tempus.', '2022-11-24 03:28:43');



insert into MovieGenre (name)
values ('Drama|Mystery|Romance');
insert into MovieGenre (name)
values ('Comedy|Drama');
insert into MovieGenre (name)
values ('Drama');
insert into MovieGenre (name)
values ('Documentary|IMAX');
insert into MovieGenre (name)
values ('Comedy');

insert into MGenre (MovieID, GenreID)
values (1, 1);
insert into MGenre (MovieID, GenreID)
values (8, 2);
insert into MGenre (MovieID, GenreID)
values (2, 2);
insert into MGenre (MovieID, GenreID)
values (1, 2);
insert into MGenre (MovieID, GenreID)
values (3, 1);
insert into MGenre (MovieID, GenreID)
values (1, 4);
insert into MGenre (MovieID, GenreID)
values (5, 4);
insert into MGenre (MovieID, GenreID)
values (3, 4);
insert into MGenre (MovieID, GenreID)
values (1, 5);
insert into MGenre (MovieID, GenreID)
values (5, 8);

insert into TVGenre (name)
values ('Drama');
insert into TVGenre (name)
values ('Crime|Drama|Mystery|Thriller');
insert into TVGenre (name)
values ('Children|Comedy');
insert into TVGenre (name)
values ('Drama|Romance');
insert into TVGenre (name)
values ('Comedy|Drama|Romance');

insert into TGenre (ShowID, GenreID)
values (3, 2);
insert into TGenre (ShowID, GenreID)
values (1, 5);
insert into TGenre (ShowID, GenreID)
values (1, 1);
insert into TGenre (ShowID, GenreID)
values (2, 1);
insert into TGenre (ShowID, GenreID)
values (1, 8);
insert into TGenre (ShowID, GenreID)
values (3, 1);
insert into TGenre (ShowID, GenreID)
values (1, 2);
insert into TGenre (ShowID, GenreID)
values (1, 9);
insert into TGenre (ShowID, GenreID)
values (1, 4);
insert into TGenre (ShowID, GenreID)
values (2, 5);

insert into TVLike (ShowID, UserID)
values (1, 3);
insert into TVLike (ShowID, UserID)
values (1, 10);
insert into TVLike (ShowID, UserID)
values (2, 2);
insert into TVLike (ShowID, UserID)
values (1, 7);
insert into TVLike (ShowID, UserID)
values (1, 5);
insert into TVLike (ShowID, UserID)
values (3, 3);
insert into TVLike (ShowID, UserID)
values (3, 9);
insert into TVLike (ShowID, UserID)
values (2, 4);
insert into TVLike (ShowID, UserID)
values (2, 1);
insert into TVLike (ShowID, UserID)
values (4, 4);

insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 2, 2.34, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2022-04-06 19:30:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (5, 1, 1.8, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2018-04-16 19:05:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 1, 1.82, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2013-06-23 19:25:37');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (21, 1, 7.42, 'Donec dapibus. Duis at velit eu est congue elementum.', '2020-01-30 22:44:54');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (50, 1, 2.27, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2021-05-13 23:26:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (10, 4, 2.92, 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '2019-01-15 06:30:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 4, 2.08, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2011-07-15 15:20:24');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (54, 3, 3.79, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2014-02-27 00:46:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (17, 2, 9.35, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-10-25 20:09:29');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (2, 5, 5.77, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2021-11-24 17:51:23');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 3, 4.97, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2015-09-30 23:57:46');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (48, 3, 1.15, 'Integer ac leo. Pellentesque ultrices mattis odio.', '2016-10-04 11:30:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 5, 7.37, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-11-16 01:50:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (27, 1, 2.85, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2020-11-21 02:00:24');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (34, 3, 8.0, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2021-03-12 08:24:36');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (44, 3, 6.28, 'Donec semper sapien a libero. Nam dui.', '2019-01-15 17:56:48');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (55, 1, 7.98, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2012-12-22 17:43:29');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (53, 4, 3.67, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2021-06-30 14:56:56');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (5, 2, 5.85, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2012-11-22 00:24:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 4, 6.1, 'Nulla tempus.', '2014-02-04 09:59:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (54, 3, 6.03, 'Donec dapibus. Duis at velit eu est congue elementum.', '2019-06-17 17:32:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 5, 5.75, 'Nulla tempus.', '2021-11-27 08:26:14');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (16, 4, 5.04, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', '2012-08-29 19:36:43');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (3, 1, 4.48, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2013-02-10 02:15:57');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (30, 5, 1.04, 'Proin at turpis a pede posuere nonummy.', '2015-11-12 19:16:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (6, 1, 3.46, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', '2011-09-03 05:15:41');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (56, 1, 4.91, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2021-12-11 16:58:31');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 4, 7.94, 'Nulla tempus.', '2014-07-21 10:53:23');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (55, 4, 8.58, 'Donec ut mauris eget massa tempor convallis.', '2011-10-23 01:15:19');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (10, 4, 8.34, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2020-02-08 05:54:21');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 5, 1.79, 'Morbi non quam nec dui luctus rutrum.', '2017-10-17 17:18:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (18, 4, 2.76, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '2019-09-22 14:59:46');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (16, 1, 8.29, 'Aliquam erat volutpat. In congue.', '2012-11-14 06:33:08');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (15, 2, 9.65, 'Proin risus. Praesent lectus.', '2016-01-18 04:36:49');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (20, 2, 8.32, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2016-11-21 02:20:08');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (17, 2, 7.39, 'Etiam justo. Etiam pretium iaculis justo.', '2017-07-17 16:22:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (50, 3, 5.15, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2011-11-13 10:45:22');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (7, 2, 2.29, 'Fusce consequat. Nulla nisl.', '2020-02-05 18:22:31');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (9, 3, 6.22, 'Nulla ut erat id mauris vulputate elementum.', '2014-01-28 00:14:50');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (11, 4, 1.73, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2022-01-31 17:52:02');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (58, 2, 9.9, 'Proin eu mi.', '2016-05-14 07:54:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (23, 4, 9.77, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2011-06-21 04:55:48');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (39, 1, 3.69, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2017-04-23 05:48:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (36, 3, 9.44, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2012-05-19 02:12:30');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (5, 4, 6.06, 'Suspendisse accumsan tortor quis turpis.', '2018-07-26 03:47:20');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (46, 5, 9.97, 'In eleifend quam a odio.', '2019-02-20 12:01:39');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 3, 5.99, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2012-08-23 23:36:28');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (35, 3, 9.19, 'Fusce posuere felis sed lacus.', '2016-11-05 08:05:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 3, 3.71, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2018-07-12 19:01:09');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (33, 2, 5.79, 'Suspendisse ornare consequat lectus.', '2022-07-16 20:11:57');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 1, 7.96, 'Mauris sit amet eros.', '2020-03-08 02:37:15');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (44, 3, 6.24, 'Morbi non lectus.', '2017-08-14 07:19:49');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (5, 1, 8.88, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2014-08-20 05:21:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (24, 3, 7.23, 'Integer tincidunt ante vel ipsum.', '2020-01-18 07:22:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 5, 7.23, 'Proin at turpis a pede posuere nonummy.', '2015-02-08 09:09:14');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (13, 2, 7.64, 'Nam tristique tortor eu pede.', '2021-03-16 12:42:39');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (30, 2, 7.09, 'Donec ut mauris eget massa tempor convallis.', '2018-02-27 05:27:18');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (10, 1, 6.78, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-08-24 01:07:41');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (18, 4, 7.66, 'Nunc nisl.', '2017-10-02 21:20:48');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (9, 3, 8.88, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2019-07-20 19:11:29');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (15, 1, 8.32, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2021-04-12 20:53:28');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (55, 3, 1.54, 'Integer tincidunt ante vel ipsum.', '2021-05-12 20:33:38');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (4, 5, 9.81, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-03-27 14:31:51');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 5, 1.38, 'In sagittis dui vel nisl. Duis ac nibh.', '2020-02-16 08:14:21');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (14, 5, 8.34, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2020-03-25 20:40:55');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (53, 5, 6.59, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2022-09-04 16:59:00');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 5, 1.95, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2019-05-13 14:42:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 3, 8.9, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2012-11-01 05:17:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (25, 1, 1.42, 'Nam dui.', '2012-09-17 11:12:02');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (45, 5, 5.42, 'Phasellus in felis. Donec semper sapien a libero.', '2019-11-05 20:57:09');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 2, 8.06, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2019-08-28 20:05:35');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (31, 3, 6.04, 'Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2020-04-23 19:09:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (44, 4, 4.11, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-04-17 16:57:42');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (20, 2, 9.33, 'Aliquam non mauris.', '2018-04-29 23:47:10');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 2, 1.09, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2017-02-04 17:23:38');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 5, 4.06, 'Nunc rhoncus dui vel sem. Sed sagittis.', '2011-04-10 15:04:26');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (49, 3, 4.06, 'Aenean lectus. Pellentesque eget nunc.', '2017-06-24 07:14:56');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 4, 9.86, 'Aenean lectus.', '2020-07-06 18:48:56');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (9, 5, 8.64, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2012-02-13 08:07:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (49, 4, 9.12, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2013-03-23 10:23:38');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (40, 5, 4.9, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2020-06-23 05:28:58');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (40, 1, 1.05, 'Praesent blandit. Nam nulla.', '2011-12-22 17:19:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (31, 5, 8.32, 'Morbi a ipsum. Integer a nibh.', '2012-09-14 22:45:00');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (18, 2, 2.84, 'Duis ac nibh.', '2011-04-12 20:55:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (45, 1, 6.52, 'Aenean lectus. Pellentesque eget nunc.', '2017-07-31 09:54:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 4, 3.33, 'Nulla nisl. Nunc nisl.', '2021-09-19 08:11:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (46, 1, 5.88, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2017-02-27 00:00:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (21, 4, 8.05, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2013-11-06 04:55:42');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (34, 4, 8.42, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2013-01-11 03:30:55');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (45, 3, 8.62, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2014-04-25 20:48:15');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (48, 2, 3.31, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2019-06-16 20:48:00');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (43, 2, 3.87, 'In hac habitasse platea dictumst.', '2017-03-24 03:55:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (60, 3, 4.64, 'Cras non velit nec nisi vulputate nonummy.', '2018-10-04 08:00:00');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (3, 5, 9.77, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2012-02-12 13:55:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (7, 2, 6.77, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2011-08-11 01:07:19');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (51, 5, 7.87, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2013-08-11 01:27:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 2, 1.07, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2019-07-18 14:59:23');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (11, 1, 2.5, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2013-09-13 06:57:32');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (36, 1, 6.16, 'Suspendisse potenti.', '2018-10-18 09:06:55');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (33, 4, 5.36, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2015-05-08 14:45:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (17, 3, 6.18, 'Integer a nibh. In quis justo.', '2022-04-12 05:14:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (9, 5, 9.1, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2018-02-28 11:27:26');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (16, 5, 9.1, 'Mauris lacinia sapien quis libero.', '2021-06-17 01:41:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (13, 5, 5.63, 'In hac habitasse platea dictumst.', '2013-06-09 00:08:09');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (36, 3, 9.47, 'Donec quis orci eget orci vehicula condimentum.', '2015-05-27 08:27:14');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (25, 2, 9.58, 'Duis aliquam convallis nunc.', '2019-08-30 17:31:00');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (7, 2, 9.18, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2022-03-10 12:19:53');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (39, 2, 7.29, 'Nullam porttitor lacus at turpis.', '2013-12-19 12:27:20');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 2, 7.19, 'Aliquam non mauris. Morbi non lectus.', '2017-12-04 17:55:36');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (56, 4, 4.27, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2015-10-06 09:03:47');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (6, 5, 9.52, 'Aenean fermentum.', '2017-09-26 22:59:43');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (32, 5, 7.16, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2018-06-22 00:30:25');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (52, 2, 2.53, 'Nullam porttitor lacus at turpis.', '2021-11-24 17:12:11');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 5, 3.79, 'Nulla tellus.', '2013-01-25 07:30:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (15, 2, 3.6, 'Nam dui.', '2019-01-01 17:38:24');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (33, 3, 2.71, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2015-04-20 16:46:08');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (13, 3, 1.73, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2014-02-12 19:41:49');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (19, 4, 5.24, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2019-08-31 01:52:20');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (2, 1, 2.09, 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2015-05-20 21:42:49');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (20, 3, 1.78, 'Morbi a ipsum.', '2011-06-25 18:17:40');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (45, 3, 9.03, 'Sed ante. Vivamus tortor.', '2021-11-17 17:05:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (44, 4, 4.42, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-03-11 02:25:34');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (60, 3, 1.35, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2020-12-03 13:08:40');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (56, 4, 9.18, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2020-11-17 03:34:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (12, 1, 9.37, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2019-10-27 08:50:41');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 3, 8.8, 'Vestibulum sed magna at nunc commodo placerat.', '2013-08-17 19:15:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 4, 2.44, 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2017-03-16 15:14:39');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (48, 2, 6.82, 'In eleifend quam a odio. In hac habitasse platea dictumst.', '2011-12-17 08:32:49');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (3, 2, 9.36, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '2013-03-15 08:04:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (48, 2, 3.15, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2013-12-17 18:37:39');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (1, 2, 6.1, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2022-08-19 05:25:18');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 5, 9.81, 'Morbi non quam nec dui luctus rutrum.', '2019-09-27 14:14:08');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (38, 1, 9.03, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2018-02-21 05:54:51');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (46, 2, 7.57, 'Morbi ut odio.', '2011-09-05 16:26:19');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 5, 2.02, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2014-08-25 02:31:56');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (20, 1, 4.28, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2011-01-03 08:44:33');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (34, 5, 7.22, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2018-07-03 00:51:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 1, 3.22, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2021-02-11 18:46:52');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (27, 5, 9.25, 'Aenean lectus.', '2011-07-30 03:02:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (58, 5, 9.92, 'Mauris ullamcorper purus sit amet nulla.', '2013-08-17 19:15:24');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (7, 4, 9.02, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2021-06-22 11:01:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 5, 5.76, 'Donec dapibus. Duis at velit eu est congue elementum.', '2018-03-19 03:43:52');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (24, 2, 5.49, 'In hac habitasse platea dictumst.', '2012-11-19 18:38:06');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (39, 2, 2.15, 'In hac habitasse platea dictumst.', '2014-02-26 19:06:07');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (26, 4, 5.36, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2011-09-28 06:53:12');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (56, 5, 5.69, 'Suspendisse accumsan tortor quis turpis. Sed ante.', '2014-05-24 01:09:50');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (53, 1, 1.33, 'Vestibulum rutrum rutrum neque.', '2015-11-13 01:48:27');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (52, 1, 9.71, 'Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2015-08-31 07:40:38');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (52, 4, 6.02, 'Suspendisse accumsan tortor quis turpis. Sed ante.', '2011-10-08 17:59:33');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (3, 5, 7.17, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2019-05-20 18:25:09');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (6, 2, 2.11, 'Nulla mollis molestie lorem. Quisque ut erat.', '2014-10-16 04:13:33');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (51, 5, 5.6, 'Nulla facilisi.', '2020-05-30 21:50:13');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (12, 3, 2.84, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2013-01-07 03:04:48');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (11, 1, 1.73, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus.', '2015-11-07 12:43:10');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (59, 3, 2.93, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '2016-09-29 22:23:55');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (17, 4, 4.87, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '2012-06-22 09:34:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (15, 2, 2.14, 'Pellentesque eget nunc.', '2015-12-06 10:22:26');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 5, 9.7, 'Integer non velit.', '2014-03-06 12:49:20');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (35, 4, 2.76, 'Morbi quis tortor id nulla ultrices aliquet.', '2011-07-19 08:33:04');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (24, 1, 3.44, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2016-08-02 08:37:47');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (40, 2, 6.13, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2021-10-03 21:06:30');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (6, 4, 6.46, 'Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2013-04-23 05:27:36');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (32, 4, 8.7, 'Phasellus id sapien in sapien iaculis congue.', '2013-12-13 09:55:51');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (30, 3, 7.2, 'Donec semper sapien a libero. Nam dui.', '2019-09-12 05:10:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (22, 4, 4.13, 'Nulla suscipit ligula in lacus.', '2019-05-31 12:43:25');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (47, 5, 7.14, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2019-04-08 00:03:31');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (36, 3, 1.28, 'Curabitur at ipsum ac tellus semper interdum.', '2018-02-01 07:51:30');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (51, 1, 3.57, 'Morbi quis tortor id nulla ultrices aliquet.', '2022-06-23 00:37:23');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (13, 1, 1.14, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2015-01-26 05:28:17');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (35, 5, 9.83, 'In hac habitasse platea dictumst.', '2016-09-02 05:32:40');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 2, 1.36, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2017-05-08 07:10:45');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (27, 5, 3.68, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2014-10-03 09:06:54');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (15, 1, 5.44, 'Suspendisse potenti.', '2021-12-30 10:49:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (12, 1, 4.12, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2017-10-18 03:46:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 2, 3.35, 'Aenean sit amet justo. Morbi ut odio.', '2012-06-01 17:38:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (7, 2, 8.97, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2021-05-14 16:46:05');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (3, 2, 5.23, 'Sed sagittis.', '2012-06-12 05:29:31');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (33, 4, 6.52, 'Nulla tellus.', '2022-11-15 20:52:27');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (37, 1, 1.26, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2022-10-31 23:11:50');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (39, 4, 8.46, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2011-08-01 08:24:57');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 2, 6.56, 'Donec vitae nisi.', '2018-09-26 20:07:26');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (1, 4, 3.46, 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2021-09-18 11:34:18');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (59, 1, 5.66, 'Nunc rhoncus dui vel sem. Sed sagittis.', '2016-03-15 21:51:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (41, 3, 2.14, 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2018-05-04 20:11:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (29, 2, 4.44, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2015-12-23 11:35:09');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (34, 2, 3.39, 'Maecenas ut massa quis augue luctus tincidunt.', '2015-08-15 01:31:21');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (42, 5, 2.97, 'Suspendisse potenti. In eleifend quam a odio.', '2012-04-26 18:40:07');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (21, 1, 4.42, 'Ut at dolor quis odio consequat varius.', '2020-05-09 15:35:56');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (30, 1, 8.71, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2011-01-10 03:42:14');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (43, 3, 5.21, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2015-05-30 09:29:40');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 2, 2.48, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2021-03-10 15:22:14');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (30, 3, 8.19, 'Etiam vel augue. Vestibulum rutrum rutrum neque.', '2022-05-05 13:40:44');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (40, 5, 7.32, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '2012-06-30 10:34:40');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (43, 4, 4.26, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '2015-11-01 16:32:48');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (28, 2, 9.15, 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2021-11-03 11:37:13');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (8, 2, 6.25, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2015-01-07 04:13:23');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (40, 1, 6.99, 'Aliquam non mauris.', '2021-08-24 13:14:08');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (56, 1, 5.78, 'Donec dapibus.', '2016-09-03 08:56:03');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (20, 4, 1.31, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2021-10-16 09:44:59');
insert into TVRating (ShowID, CriticID, Rating, Comment, Date) values (44, 1, 4.03, 'Nulla facilisi.', '2014-02-02 01:52:07');


insert into FavList (ListID, name, CriticID)
values (5, 'quis', 3);
insert into FavList (ListID, name, CriticID)
values (10, 'luctus', 2);
insert into FavList (ListID, name, CriticID)
values (4, 'eget', 3);
insert into FavList (ListID, name, CriticID)
values (7, 'accumsan', 2);
insert into FavList (ListID, name, CriticID)
values (6, 'viverra', 5);
insert into FavList (ListID, name, CriticID)
values (1, 'ultrices', 5);
insert into FavList (ListID, name, CriticID)
values (3, 'semper', 3);
insert into FavList (ListID, name, CriticID)
values (8, 'nisl', 3);
insert into FavList (ListID, name, CriticID)
values (2, 'fermentum', 5);
insert into FavList (ListID, name, CriticID)
values (9, 'sit', 1);

insert into FavMovie (ListID, MovieID, ranks)
values (7, 9, 6);
insert into FavMovie (ListID, MovieID, ranks)
values (8, 10, 6);
insert into FavMovie (ListID, MovieID, ranks)
values (4, 6, 5);
insert into FavMovie (ListID, MovieID, ranks)
values (3, 9, 9);
insert into FavMovie (ListID, MovieID, ranks)
values (7, 3, 8);
insert into FavMovie (ListID, MovieID, ranks)
values (10, 8, 2);
insert into FavMovie (ListID, MovieID, ranks)
values (5, 2, 5);
insert into FavMovie (ListID, MovieID, ranks)
values (9, 4, 8);
insert into FavMovie (ListID, MovieID, ranks)
values (8, 9, 2);
insert into FavMovie (ListID, MovieID, ranks)
values (7, 2, 3);

insert into FavShow (ListID, ShowID, ranks)
values (1, 2, 5);
insert into FavShow (ListID, ShowID, ranks)
values (1, 3, 9);
insert into FavShow (ListID, ShowID, ranks)
values (7, 2, 6);
insert into FavShow (ListID, ShowID, ranks)
values (7, 1, 9);
insert into FavShow (ListID, ShowID, ranks)
values (4, 3, 5);
insert into FavShow (ListID, ShowID, ranks)
values (3, 3, 8);
insert into FavShow (ListID, ShowID, ranks)
values (2, 2, 5);
insert into FavShow (ListID, ShowID, ranks)
values (9, 3, 9);
insert into FavShow (ListID, ShowID, ranks)
values (6, 2, 9);
insert into FavShow (ListID, ShowID, ranks)
values (2, 1, 8);

insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (3, 3, 'Ashely', 'Fairlaw');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (5, 3, 'Larry', 'Lohrensen');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (1, 3, 'Cahra', 'O''Farrell');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (10, 7, 'Cad', 'Matussow');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (1, 4, 'Perri', 'Melly');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (2, 3, 'Vale', 'Mablestone');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (5, 8, 'Flint', 'Fairleigh');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (8, 1, 'Fina', 'Pigden');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (8, 4, 'Laurie', 'McGhee');
insert into MovieAct (MovieID, ActorID, characterFirst, characterLast)
values (5, 10, 'Horacio', 'Lidyard');

insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (2, 10, 'Eberto', 'Sherreard');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (15, 8, 'Pete', 'Balazot');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (18, 7, 'Lodovico', 'Kareman');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (8, 2, 'Sidonnie', 'Elphinstone');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (9, 3, 'Armstrong', 'Ornillos');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (20, 1, 'Abigail', 'Rigglesford');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (16, 8, 'Halimeda', 'Blenkhorn');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (2, 6, 'Vannie', 'Kilkenny');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (4, 7, 'Agnola', 'Gallop');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (20, 9, 'Emmanuel', 'Furneaux');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (13, 5, 'Koo', 'Pearman');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (5, 2, 'Dorelle', 'Elmer');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (15, 9, 'Aubine', 'Pareman');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (12, 9, 'Morissa', 'Turvey');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (7, 6, 'Otha', 'de Guise');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (8, 9, 'Augusto', 'Hardi');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (14, 4, 'Mason', 'Edler');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (14, 9, 'Bibbie', 'Gallant');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (4, 8, 'Gaven', 'Schelle');
insert into ShowAct (EpID, ActorID, characterFirst, characterLast)
values (15, 5, 'Velvet', 'Mattiuzzi');

insert into MovieDir (MovieID, DirID)
values (2, 4);
insert into MovieDir (MovieID, DirID)
values (7, 5);
insert into MovieDir (MovieID, DirID)
values (7, 3);
insert into MovieDir (MovieID, DirID)
values (8, 9);
insert into MovieDir (MovieID, DirID)
values (9, 1);
insert into MovieDir (MovieID, DirID)
values (10, 5);
insert into MovieDir (MovieID, DirID)
values (6, 5);
insert into MovieDir (MovieID, DirID)
values (10, 3);
insert into MovieDir (MovieID, DirID)
values (1, 10);
insert into MovieDir (MovieID, DirID)
values (5, 10);

insert into ShowDir (EpID, DirID)
values (7, 10);
insert into ShowDir (EpID, DirID)
values (19, 1);
insert into ShowDir (EpID, DirID)
values (9, 4);
insert into ShowDir (EpID, DirID)
values (5, 1);
insert into ShowDir (EpID, DirID)
values (8, 4);
insert into ShowDir (EpID, DirID)
values (19, 2);
insert into ShowDir (EpID, DirID)
values (10, 3);
insert into ShowDir (EpID, DirID)
values (19, 5);
insert into ShowDir (EpID, DirID)
values (9, 3);
insert into ShowDir (EpID, DirID)
values (8, 7);

SET FOREIGN_KEY_CHECKS = 1;