-- Триггер для обновления года выпуска переиздания альбома
-- если поле taylors_version равно true и поле remake_year равно NULL,
-- то происходит обновление значения поля remake_year на значение поля release_year
CREATE OR REPLACE FUNCTION update_remake_year()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.taylors_version = true AND NEW.remake_year IS NULL THEN
        UPDATE Albums SET remake_year = NEW.release_year WHERE album_id = NEW.album_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_remake_year_trigger
BEFORE INSERT OR UPDATE ON Albums
FOR EACH ROW
EXECUTE FUNCTION update_remake_year();



-- Триггер для подсчета количества наград у альбома после добавления новой награды
CREATE OR REPLACE FUNCTION update_album_awards_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Albums SET awards_count = (SELECT COUNT(*) FROM AlbumAwards WHERE album_id = NEW.album_id) WHERE album_id = NEW.album_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_album_awards_count_trigger
AFTER INSERT ON AlbumAwards
FOR EACH ROW
EXECUTE FUNCTION update_album_awards_count();



-- Триггер для подсчета общей длительности альбома после изменения продолжительности песни
CREATE OR REPLACE FUNCTION update_album_total_duration()
RETURNS TRIGGER AS $$
DECLARE
    total_duration_interval INTERVAL;
BEGIN
    SELECT COALESCE(SUM(duration), '00:00:00') INTO total_duration_interval
    FROM Songs
    WHERE album_id = NEW.album_id;

    UPDATE Albums 
    SET total_duration = total_duration_interval
    WHERE album_id = NEW.album_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_album_total_duration_trigger
AFTER INSERT OR UPDATE ON Songs
FOR EACH ROW
EXECUTE FUNCTION update_album_total_duration();



