CREATE TABLE IF NOT EXISTS "T_News" (
"postid" text NOT NULL,
"tid" text NOT NULL,
"news" text NOT NULL,
"createTime" TEXT DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("postid","tid")
);
