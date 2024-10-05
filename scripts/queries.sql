-- 1) Список песен альбома 1989, отсортированных по длительности
SELECT *
FROM Songs
WHERE album_id = (SELECT album_id FROM Albums WHERE album_name = '1989')
ORDER BY duration;

-- 2) Среднее количество концертов в туре
SELECT AVG(show_count) AS avg_show_cnt
FROM Tours;

-- 3) Количество песен в каждом альбом
SELECT a.album_name, COUNT(s.song_id) AS song_number
FROM Albums a
LEFT JOIN Songs s ON a.album_id = s.album_id
GROUP BY a.album_name;

--4) Список альбомом с количеством песен из архива больше 1
SELECT a.album_name
FROM Albums a
JOIN Songs s ON a.album_id = s.album_id
WHERE s.from_the_vault = true
GROUP BY a.album_id
HAVING COUNT(s.song_id) > 2;

--5) Список туров по нескольким альбомам
SELECT t.tour_name
FROM Tours t
JOIN TourSongs ts ON t.tour_id = ts.tour_id
GROUP BY t.tour_id, t.tour_name
HAVING COUNT(ts.album_id) > 1;

--6) Награды, полученные за альбомы в хронологическом порядке
SELECT aa.award_name, aa.year_received, a.album_name
FROM AlbumAwards aa
JOIN Albums a ON aa.album_id = a.album_id
ORDER BY aa.year_received;

--7) Количество наград за альбомы по возрастанию, считая только награды после 2015 года
SELECT a.album_name, COUNT(aa.award_id) AS award_count
FROM Albums a
LEFT JOIN AlbumAwards aa ON a.album_id = aa.album_id
WHERE aa.year_received > 2015 OR aa.year_received IS NULL
GROUP BY a.album_name
ORDER BY award_count;

--8) Список туров, которые попали в промежуток дат с 20.05.2023 до 01.01.2024
SELECT tour_name, start_date, end_date
FROM Tours
WHERE start_date BETWEEN '2023-05-20' AND '2024-01-01'
   OR end_date BETWEEN '2023-05-20' AND '2024-01-01';

--9) Список средней продолжительности песен для каждого альбома выпущенного после 2018
SELECT DISTINCT a.album_id, a.album_name, a.release_year, 
       AVG(EXTRACT(SECOND FROM s.duration)) OVER (PARTITION BY a.album_id) as avg_duration_seconds
FROM Albums a
JOIN Songs s ON a.album_id = s.album_id
WHERE a.release_year >= 2018;

--10) Список альбомов, количества песен в каждом альбоме и их рейтинг в зависимости от количества
SELECT a.album_id, a.album_name, 
       COUNT(s.song_id) as song_count,
       RANK() OVER (ORDER BY COUNT(s.song_id) DESC) as album_rank
FROM Albums a
JOIN Songs s ON a.album_id = s.album_id
GROUP BY a.album_id, a.album_name;
