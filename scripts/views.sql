-- Это представление объединяет важную информацию о турах
-- (название тура, даты начала и окончания, количество представлений)
-- с информацией об альбомах, связанных с каждым туром
CREATE VIEW taylorswift.TourDetails AS
SELECT t.tour_id, t.tour_name, t.start_date, t.end_date, t.show_count,
  string_agg(als.album_name, ', ') AS albums
FROM taylorswift.Tours t
JOIN taylorswift.TourSongs ts ON t.tour_id = ts.tour_id
JOIN taylorswift.Albums als ON ts.album_id = als.album_id
GROUP BY t.tour_id, t.tour_name, t.start_date, t.end_date, t.show_count;

-- примеры использования
SELECT * FROM taylorswift.TourDetails
WHERE EXTRACT(DAY FROM AGE(end_date, start_date)) > 10;

SELECT * FROM taylorswift.TourDetails
WHERE tour_name LIKE '%Eras%';



-- Это представление объединяет полную информацию об альбомах
-- (название альбома, год выпуска, жанр)
-- с информацией о наградах, которые они выиграли (название награды, год получения)
CREATE VIEW taylorswift.AlbumsWithAwards AS
SELECT a.album_id, a.album_name, a.release_year, a.genre, aa.award_name, aa.year_received
FROM taylorswift.Albums a
JOIN taylorswift.AlbumAwards aa ON a.album_id = aa.album_id;

-- пример использования
SELECT * FROM taylorswift.AlbumsWithAwards
WHERE album_name = '1989';


-- Это представление соединяет данные о песнях (название песни, длительность)
-- с информацией об авторах песен
CREATE VIEW taylorswift.SongsWithAuthors AS
SELECT s.song_id, s.song_name, s.duration, string_agg(sa.author_name, ', ') AS authors
FROM taylorswift.Songs s
JOIN taylorswift.SongAuthors sa ON s.song_id = sa.song_id
GROUP BY s.song_id, s.song_name, s.duration;


-- пример использования
SELECT * FROM taylorswift.SongsWithAuthors
WHERE song_name = 'champagne problems';
