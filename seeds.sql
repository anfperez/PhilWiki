DROP TABLE IF EXISTS articles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS categories CASCADE;


CREATE TABLE categories(
 id  SERIAL PRIMARY KEY,
 title  VARCHAR(50) UNIQUE,
 image VARCHAR NOT NULL,
 num_articles INTEGER NOT NULL
 -- articles_id INTEGER REFERENCES articles(id)
);

CREATE TABLE users (
  id   SERIAL PRIMARY KEY,
  user_name   VARCHAR,
  login_password VARCHAR NOT NULL,
  num_articles INTEGER,
  image VARCHAR,
  profile VARCHAR
);

CREATE TABLE articles(
 id      SERIAL PRIMARY KEY,
 title    VARCHAR,
 image VARCHAR NOT NULL,
 category INTEGER REFERENCES categories(id),
 author VARCHAR,
 body VARCHAR NOT NULL,
 time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 time_edited TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments(
 id     SERIAL PRIMARY KEY,
 email VARCHAR(75) NOT NULL,
 rating INTEGER NOT NULL,
 message VARCHAR NOT NULL,
 article_id INTEGER REFERENCES articles(id)
);

INSERT INTO categories 
( title, image, num_articles)
VALUES
('Major Places', 'http://planetden.com/wp-content/uploads/2014/12/makati-city-manila-philippines-cityscape.jpg', '4'),
('Popular Foods', 'https://upload.wikimedia.org/wikipedia/commons/8/88/Philippine_Food.jpg', '4'),
('Ghosts and Legends', 'http://amandaandrei.com/wp-content/uploads/2012/10/02.jpg', '4'),
('Native Animals', 'https://upload.wikimedia.org/wikipedia/commons/b/ba/Bohol.tarsier_jtlimphoto.JPG', '4');

INSERT INTO users
(user_name, login_password, image, profile)

VALUES
('angela_ikbi', 'piglet', 'https://s-media-cache-ak0.pinimg.com/736x/ee/2b/61/ee2b616224bfb8266217644f9ade0f22.jpg', 'Angela Ikbi lived in the Philippines for the first few years of her life. She enjoys being fuzzy.'),
('scarlett_pusa', 'cat', 'http://i.imgur.com/mhZovlN.jpg', 'Scarlett Pusa is a tabby cat who somehow got a job writing wiki articles. But she can''t even type, so I don''t know she does it.'),
('mikey_aso', 'dog', 'http://nextranks.com/data_images/dogs/pug/pug-05.jpg', 'Mikey Aso is going to be marrying a Filipino girl, so he decided to read up about all things Filipino.'),
('green_butiki', 'lizard', 'http://www.ryanphotographic.com/images/JPEGS/Hemidactylus%20frenatus,%20Common%20house%20gecko,%20Fiji.jpg', 'Green Butiki loves crawling on walls, eating bugs, and writing wiki articles');

-- #create articles
INSERT INTO articles
( title, image, category, author, body)
VALUES
( 'Manila', 'http://www.lacamaramanila.com/wp-content/uploads/2014/12/Manila-City-by-Night1.jpg', '1', 'angela_ikbi', 'Manila is the capital city of the Philippines. It also contains vast amount of significant architectural and cultural landmarks in the country. Manila is the densest populated city in the world with 42,857 people per square kilometer. It will likely be your gateway to the country.'),
( 'Boracay', 'http://www.virtourist.com/asia/philippines/boracay/imatges/01.jpg', '1', 'scarlett_pusa', 'Boracay is a small island in the Philippines located approximately 315 km (196 mi) south of Manila. Apart from its white sand beaches, Boracay is also famous for being one of the world''s top destinations for relaxation. It is also emerging among the top destinations for tranquility and nightlife.'),
( 'Banuae', 'http://www.destination360.com/asia/philippines/images/s/banaue-rice-terraces.jpg', '1', 'mikey_aso', 'The Banaue Rice Terraces (Filipino: Hagdan-hagdang Palayan ng Banawe) are 2,000-year-old terraces that were carved into the mountains of Ifugao in the Philippines by ancestors of the indigenous people. The Rice Terraces are commonly referred to as the "Eighth Wonder of the World".'),
( 'Bohol', 'http://www.mymilez.com/wp-content/uploads/2011/04/chocolate-hills-1.jpg', '1', 'green_butiki', 'Bohol is famous for its Chocolate Hills (Filipino: Tsokolateng Burol) are a geological formation. There are at least 1,260 hills but there may be as many as 1,776 hills spread over an area of more than 50 square kilometres (20 sq mi). They are covered in green grass that turns brown (like chocolate) during the dry season, hence the name.'),
( 'pancit', 'http://i0.wp.com/www.kusinamasterrecipes.com/wp-content/uploads/2015/03/Pancit-Canton.jpg?resize=1500%2C1000', '2', 'angela_ikbi', 'In Filipino cuisine, pancit or pansit are noodles. Different types of pancit have developed by local region. Some common types are pancit bihon, pancit canton, and pancit palabok.'),
( 'abobo', 'http://kitchenconfidante.com/wp-content/uploads/2011/05/Filipino-Adobo-Chicken.jpg', '2', 'scarlett_pusa', 'Philippine Adobo (from Spanish adobar: "marinade," "sauce" or "seasoning") is a popular dish and cooking process in Philippine cuisine that involves meat, seafood, or vegetables marinated in vinegar, soy sauce, and garlic, which is browned in oil, and simmered in the marinade. It has sometimes been considered as the unofficial national dish in the Philippines.'),
( 'lumpia', 'http://www.ramarfoods.com/images/ban-lumpia_party.jpg', '2', 'mikey_aso', 'Lumpiang Shanghai is believed to originate from Shanghai but, in truth, no recipe of this existed in Shanghai, China. These meat-laden, fried type lumpya are filled with ground pork or beef, minced onion, carrots, and spices with the mixture held together by beaten egg. They may sometimes contain green peas, cilantro (Chinese parsley or coriander) or raisins.'),
( 'halo-halo', 'http://www.fairfaxinnrestaurant.com/wp-content/uploads/halo-halo-filipino-desserts-fairfaxinnrestaurant.jpg', '2', 'green_butiki', 'Haluhalo or halo-halo (Tagalog: [haluhaˈlo], "mixed together") is a popular Filipino dessert with mixtures of shaved ice and evaporated milk to which are added various boiled sweet beans, jello and fruits. It is served in a tall glass or bowl.'),
( 'aswang', 'http://www.philippinetalks.com/wp-content/uploads/2015/08/aswang.jpg', '3', 'angela_ikbi', 'An Aswang (or Asuwang) is a vampire-like witch ghoul in Filipino folklore. Aswangs are shape-shifters. Stories recount aswangs living as regular townspeople. As regular townspeople, they are quiet, shy and elusive. At night, they transform into creatures such as a cat, bat, bird, boar or most often, a dog.'),
( 'tikbalang', 'http://pre15.deviantart.net/903f/th/pre/i/2013/305/e/4/tikbalang_by_davesrightmind-d6so7s1.jpg', '3', 'scarlett_pusa', 'Tikbalang (also written as Tigbalang, Tigbalan, or Tikbalan) is a creature of Philippine folklore said to lurk in the mountains and forests of the Philippines. It is generally described as a tall, bony humanoid creature with disproportionately long limbs, to the point that its knees reach above its head when it squats down. It has the head and feet of an animal, most commonly a horse.'),
( 'manananggal', 'http://vignette4.wikia.nocookie.net/warriorsofmyth/images/e/ed/Manananggal_filipino_folklore_creature_by_renzzero-d5zn1zz.jpg/revision/latest?cb=20131107203901', '3', 'mikey_aso', 'The Manananggal (sometimes confused with the Wak Wak) is a vampire-like mythical creature of the Philippines, a malevolent, man-eating and blood-sucking monster or witch. The manananggal is described as hideous, scary, often depicted as female, and capable of severing its upper torso and sprouting huge bat-like wings to fly into the night in search of its victims.'),
( 'kapre', 'http://www.wowparadisephilippines.com/wp-content/uploads/2007/09/kapre_with_little_girl_by_mau_i.jpg', '3', 'green_butiki', 'Kapre is a Philippine mythical creature that could be characterized as a tree demon. It is described as being a tall (7 to 9 ft), dark, muscular creature. Kapres are normally described as having a strong smell that would attract human attention. Kapres are not necessarily considered to be evil, unlike the Aswang. Kapres may make contact with people to offer friendship, or if it is attracted to a woman. If a Kapre befriends any human, especially because of love, the Kapre will consistently follow its "love interest" throughout life.'),
( 'tarsier', 'https://upload.wikimedia.org/wikipedia/commons/7/7e/Bohol_Tarsier.jpg', '4', 'angela_ikbi', 'The Philippine tarsier (Carlito syrichta), known locally as mawmag in Cebuano/Visayans and mamag in Luzon, is a species of tarsier endemic to the Philippines. Their eyes are disproportionately large, having the largest eye-to-body size ratio of all mammals. These huge eyes provide this nocturnal animal with excellent night vision. The Philippine tarsier is a shy nocturnal animal that leads a mostly hidden life.'),
( 'carabao', 'https://c1.staticflickr.com/5/4013/4573417088_3a12838dcc_b.jpg', '4', 'scarlett_pusa', 'The carabao is a swamp-type domestic water buffalo (Bubalus bubalis) found in the Philippines. It is considered as the national animal of the Philippines. Carabaos have the low, wide, and heavy build of draught animals. They vary in colour from light grey to slate grey. The horns are sickle-shaped or curve backward toward the neck.'),
( 'eagle', 'http://www.ourendangeredworld.com/wp-content/uploads/2013/10/Philippine-Eagle-close-up-700x3501.jpg', '4', 'mikey_aso', 'The Philippine eagle (Pithecophaga jefferyi), also known as the monkey-eating eagle or great Philippine eagle, is an eagle of the family Accipitridae endemic to forests in the Philippines. It has brown and white-coloured plumage, and a shaggy crest, and generally measures 86 to 102 cm (2.82 to 3.35 ft) in length and weighs 4.7 to 8.0 kilograms (10.4 to 17.6 lb). Among the rarest and most powerful birds in the world, it has been declared the Philippine national bird.'),
( 'gecko', 'http://www.michaeldsellers.com/wp-content/uploads/2011/11/gecko.jpg', '4', 'green_butiki', 'The common house gecko (Hemidactylus frenatus) (not to be confused with the Mediterranean species Hemidactylus turcicus known as Mediterranean house gecko), is a native of Southeast Asia. It is also known as the Pacific house gecko, the Asian house gecko, or simply, the house lizard. Most geckos are nocturnal, hiding during the day and foraging for insects at night. They can be seen climbing walls of houses and other buildings in search of insects attracted to porch lights, hence their name "house gecko".');

INSERT INTO comments
(email, rating, message, article_id)

VALUES
('cocolala@palm.com', '5', 'Perfect article! I love living in the Philippines, it has tons of palm trees!', '1');
