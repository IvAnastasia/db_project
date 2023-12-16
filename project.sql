CREATE DATABASE IF NOT EXISTS Archive;

CREATE TABLE IF NOT EXISTS Archive.sayings (
    id INTEGER AUTO_INCREMENT NOT NULL,
    speaker_id INT NOT NULL,
    interview_id INT NOT NULL,
    saying_text TEXT NOT NULL, 
    saying_number INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Archive.Interviews (
    interview_id INTEGER NOT NULL,
    identificator TEXT NOT NULL,
    informant_id INTEGER NOT NULL, 
    interviewer_id INTEGER NOT NULL,
    place TEXT NOT NULL,
    day INTEGER NOT NULL,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    PRIMARY KEY (interview_id)
);

CREATE TABLE IF NOT EXISTS Archive.Speakers (
    speaker_id INTEGER AUTO_INCREMENT NOT NULL, 
    speaker_role TEXT NOT NULL,
    gender TEXT NOT NULL,
    birth_year INT NOT NULL,
    age INT,
    PRIMARY KEY (speaker_id)
);

CREATE TABLE IF NOT EXISTS Archive.Speakers_info (
    speaker_id INTEGER NOT NULL, 
    speaker_role TEXT NOT NULL,
    real_name TEXT NOT NULL,
    real_surname TEXT NOT NULL,
    comment TEXT,
    email TEXT,  
    phone_number TEXT,
    PRIMARY KEY (speaker_id)
);
    
    
INSERT INTO Archive.sayings (speaker_id, interview_id, saying_text, saying_number)
    VALUES  (1, 1, "Добрый день! Скажите, вы в Мохче живете?", 1),
            (4, 1, "Здравствуйте, нет, я тут на свадьбу племянницы приехал.", 2),
            (1, 1, "Поздравляем! А ваша племянница местная?", 3),
            (4, 1, "Нет, она москвичка, но свадьбу решила здесь праздновать, экзотично типа.", 4),            
            (1, 1, "Понятно, спасибо! Мы тогда ещё людей поищем... Хорошего дня!", 5),
            (2, 2, "Здравствуйте! Нас к вам направила Зинаида Ивановна, вы ведь Лидия?", 1),
            (5, 2, "Да, это я, она про вас предупреждала. Что спрашивать будете?", 2),
            (2, 2, "Разное, но вот, например, сначала такой вопрос: вы коми язык знаете?", 3),
            (5, 2, "Нет, хотя мама у меня коми. Она меня специально не учила, чтобы на русском акцента не было. Стеснялись мы тогда на коми говорить...", 4),            
            (2, 2, "А сейчас вы не хотели бы коми выучить?", 5),
            (5, 2, "Хотела бы, вот сейчас вместе с племяшкой учу, она в школе проходит коми как родной язык. Там правда не наш вариант вроде бы...", 6),
            (3, 3, "А что у вас тут про экологию говорят? Чистая местность считается?", 1),
            (6, 3, "Ой, у нас тут в Красноборе Лукойл детский сад построил, так что даже те, кто раньше возмущались, что у Лукойла раз в год нефтеразливы, сейчас уже не говорят ничего.", 2),
            (3, 3, "А кроме нефтеразливов раньше ничего не беспокоило? Вы сами что про экологию думаете?", 3),
            (6, 3, "Да вроде нет... Ну мусор, понятно, везде проблема, но это ведь на федеральном уровне решать надо. А мне нормально, у меня семья в Кирове, а я уж на пенсии. За себя не переживаю.", 4);          

INSERT INTO Archive.Interviews (interview_id, identificator, informant_id, interviewer_id, place, day, month, year)
    VALUES (1, "KOI-1", 4, 1, "Мохча", 17, 7, 2021),
        (2, "KOI-2", 5, 2, "Краснобор", 18, 7, 2021),
        (3, "KOI-3", 6, 3, "Краснобор", 18, 7, 2021);        
        
INSERT INTO Archive.Speakers (speaker_id, speaker_role, gender, birth_year)
    VALUES (1, "interviewer", "female", 2000),
        (2, "interviewer", "male", 2001),
        (3, "interviewer", "female", 1998),
        (4, "informant", "male", 1978),       
        (5, "informant", "female", 1969),
        (6, "informant", "female", 1955);
 
INSERT INTO Archive.Speakers_info (speaker_id, speaker_role, real_name, real_surname, email, phone_number)
    VALUES (1, "interviewer", "Мария", "Иванова", "mashka2000@yandex.ru", "8800552535"),
    (2, "interviewer", "Иван", "Петров", "vanchik@yandex.ru", "8800552535"),
    (3, "interviewer", "Анна", "Сидорова", "annushka@yandex.ru", "8800552439"),
    (4, "informant", "Михаил", "Скворцов", "mdskvor@yandex.ru", "8950550935"),
    (5, "informant", "Алевтина", "Сметанина", "alevtina_smetanina@yandex.ru", "8808552556"),
    (6, "informant", "Лидия", "Кожевникова", "llidka@yandex.ru", "89220852735");
  
-- (2) update  
UPDATE Archive.Speakers
    SET age = 2023 - birth_year;
SELECT * FROM Archive.Speakers;

-- (3) SELECT  + фильтрация: выбрать информацию о пожилых информантах
SELECT *
    FROM Archive.Speakers
    WHERE age >= 60;
    
-- (4) SELECT + группировка и агрегация: найти средний возраст информантов по населенному пункту
SELECT Archive.Interviews.place, AVG(Archive.Speakers.age)
    FROM Archive.Speakers
    INNER JOIN Archive.Interviews
    ON Archive.Speakers.speaker_id = Archive.Interviews.informant_id
    GROUP BY Archive.Interviews.place;
    
-- (5) SELECT + вложенный запрос: находим населенные пункты, в которых мы в основном говорили с людьми среднего возраста (с 35 до 60 лет)
SELECT place
    FROM 
    (SELECT Archive.Interviews.place, AVG(Archive.Speakers.age) AS avr_age
    FROM Archive.Speakers
    INNER JOIN Archive.Interviews
    ON Archive.Speakers.speaker_id = Archive.Interviews.informant_id
    GROUP BY Archive.Interviews.place) AS place_age
    WHERE place_age.avr_age BETWEEN 35 and 60;
    
-- (6) SELECT + JOIN + что-то: найдем все высказывания женщин-информантов и выведем их вместе с идентификаторами интервью
SELECT Archive.Interviews.identificator, Archive.Interviews.place, Archive.Speakers_info.real_name, Archive.Speakers_info.real_surname, Archive.sayings.saying_text
    FROM Archive.Speakers
    INNER JOIN Archive.Interviews
    ON Archive.Speakers.speaker_id = Archive.Interviews.informant_id
    INNER JOIN Archive.sayings
    ON Archive.sayings.speaker_id = Archive.Speakers.speaker_id
    INNER JOIN Archive.Speakers_info
    ON Archive.Speakers_info.speaker_id = Archive.Speakers.speaker_id
    WHERE Archive.Speakers.gender = "female";
    
-- (7) Процедура: выводим тексты интервью по заданному населенному пункту
DELIMITER $$
CREATE PROCEDURE Archive.show_texts (IN int_place TEXT)
    BEGIN
        SELECT Archive.sayings.interview_id, Archive.Interviews.identificator, Archive.Speakers.speaker_role, Archive.sayings.saying_text
        FROM Archive.sayings
        INNER JOIN Archive.Interviews
        ON Archive.sayings.interview_id = Archive.Interviews.interview_id
        INNER JOIN Archive.Speakers
        ON Archive.Speakers.speaker_id = Archive.sayings.speaker_id
        WHERE Archive.Interviews.place = int_place;
END$$
DELIMITER ;

CALL Archive.show_texts("Мохча");

-- (8) Триггер: при удалении интервью из таблицы интервью удаляется также все реплики этого интервью
CREATE TRIGGER Archive.delete_interview 
    AFTER DELETE ON Archive.Interviews
    FOR EACH ROW DELETE FROM Archive.sayings 
    WHERE Archive.sayings.interview_id = OLD.interview_id;
    
DELETE FROM Archive.Interviews WHERE identificator = "KOI-2";
    
SELECT interview_id FROM Archive.sayings GROUP BY interview_id;

-- (9) Common Table Expression: выбрать интервью информантов, чей возраст выше среднего возраста информантов этого возраста
WITH age_gender AS (
    SELECT 
        Archive.Speakers.gender, AVG(Archive.Speakers.age) AS avr_age
    FROM Archive.Speakers
    GROUP BY Archive.Speakers.gender
)
SELECT interview_id, saying_text, Archive.sayings.speaker_id, speaker_role, age, Archive.Speakers.gender, avr_age FROM Archive.sayings
INNER JOIN Archive.Speakers ON Archive.sayings.speaker_id = Archive.Speakers.speaker_id
INNER JOIN age_gender ON Archive.Speakers.gender = age_gender.gender
WHERE Archive.Speakers.age > age_gender.avr_age;