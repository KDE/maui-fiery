
CREATE TABLE IF NOT EXISTS BOOKMARKS (
url TEXT,
title TEXT,
adddate DATE,
modified DATE,
PRIMARY KEY(url)
);

CREATE TABLE IF NOT EXISTS HISTORY (
url TEXT,
title TEXT,
adddate DATE,
PRIMARY KEY(url)
);

CREATE TABLE IF NOT EXISTS ICONS (
url TEXT,
icon TEXT,
PRIMARY KEY(url)
);


COMMIT;
