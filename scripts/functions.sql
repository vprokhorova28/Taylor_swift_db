-- Функция для получения средней продолжительности песен в определенном альбоме
CREATE OR REPLACE FUNCTION get_average_song_duration(album_id INT)
RETURNS INTERVAL
AS $$
DECLARE
    avg_duration INTERVAL;
BEGIN
    SELECT AVG(duration) INTO avg_duration
    FROM Songs s
    WHERE s.album_id = album_id;
    
    RETURN avg_duration;
END;
$$ LANGUAGE plpgsql;



-- Функция для нахождения наиболее крупного и наименее крупного альбомов по количеству песен
CREATE OR REPLACE FUNCTION find_largest_smallest_albums()
RETURNS TABLE (largest_album_name VARCHAR(256), largest_song_count INT,
               smallest_album_name VARCHAR(256), smallest_song_count INT)
AS $$
BEGIN
    RETURN QUERY (
        SELECT a1.album_name, COUNT(s.song_id) AS song_count
        FROM Albums a1
        JOIN Songs s ON a1.album_id = s.album_id
        GROUP BY a1.album_id
        ORDER BY song_count DESC
        LIMIT 1
    );
    
    RETURN QUERY (
        SELECT a2.album_name, COUNT(s.song_id) AS song_count
        FROM Albums a2
        JOIN Songs s ON a2.album_id = s.album_id
        GROUP BY a2.album_id
        ORDER BY song_count
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;



-- Функция будет возвращать список альбомов, их песен и их наград,
-- учитывая заданный жанр и диапазон лет выпуска альбомов
DROP FUNCTION IF EXISTS get_album_details_by_genre_and_year(VARCHAR(256), INT, INT);
CREATE OR REPLACE FUNCTION get_album_details_by_genre_and_year(
    genre_name VARCHAR(256),
    start_year INT,
    end_year INT
)
RETURNS TABLE (
    album_name VARCHAR(256),
    song_name VARCHAR(256),
    awards_list TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT a.album_name, s.song_name, STRING_AGG(aa.award_name, ', ') AS awards_list
    FROM taylorswift.Albums a
    JOIN taylorswift.Songs s ON a.album_id = s.album_id
    LEFT JOIN taylorswift.AlbumAwards aa ON a.album_id = aa.album_id
    WHERE a.genre = genre_name
    AND a.release_year BETWEEN start_year AND end_year
    GROUP BY a.album_name, s.song_name;
 END;
$$ LANGUAGE plpgsql;



-- пример запроса
SELECT * FROM get_album_details_by_genre_and_year('Pop', 2010, 2020);