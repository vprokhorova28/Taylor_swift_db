-- Пользователи часто совершают поиск именно по названиям
-- Добавление индекса к таблице Songs
CREATE INDEX idx_SongName ON taylorswift.Songs (Song_Name);

-- Добавление индекса к таблице Albums
CREATE INDEX idx_AlbumName ON taylorswift.Albums (Album_Name);

-- Добавление индекса к таблице Tours
CREATE INDEX idx_TourName ON taylorswift.Tours (Tour_Name);

-- Добавление индексов к таблице SongAuthors
CREATE INDEX idx_AuthorName ON taylorswift.SongAuthors (Author_Name);

-- Добавление индексов к таблице AlbumAwards
CREATE INDEX idx_AlbumAwardName ON taylorswift.AlbumAwards (Award_Name);

-- Добавление индексов к таблице SongAwards
CREATE INDEX idx_SongAwardName ON taylorswift.SongAwards (Award_Name);

-- Добавим к таблицам AlbumAwards, TourSongs, Songs индексы по AlbumId, 
-- потому что часто ищем именно по AlbumId

CREATE INDEX idx_AlbumAwards_AlbumId ON taylorswift.AlbumAwards (Album_Id);
CREATE INDEX idx_TourSongs_AlbumId ON taylorswift.TourSongs (Album_Id);
CREATE INDEX idx_Songs_AlbumId ON taylorswift.Songs (Album_Id);