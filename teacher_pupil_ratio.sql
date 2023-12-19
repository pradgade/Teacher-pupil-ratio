-- Number of users
SELECT COUNT(DISTINCT user_id)
FROM twinkl.twinkl_pupil;

-- Number of pupils
SELECT COUNT(DISTINCT id)
FROM twinkl.twinkl_pupil;

-- Number of learners under each user with their career
DROP TEMPORARY TABLE IF EXISTS user_pupil_count;

CREATE TEMPORARY TABLE user_pupil_count
SELECT tp.user_id,
			 COUNT(tp.id) AS pupil_count,
			 cco.neat_career_category AS career
FROM twinkl.twinkl_pupil AS tp
	JOIN analytics.dx_user AS du
		ON tp.user_id = du.user_id
	JOIN analytics.career_category_overview AS cco
		ON du.career_category_id = cco.id
WHERE created_at > '2023-09-01 00:00:00'
GROUP BY tp.user_id;

SELECT COUNT(*)
FROM user_pupil_count;


SELECT *
FROM user_pupil_count;

--


-- Teacher pupil ratio for all users
SELECT pupil_count,
       COUNT(pupil_count) as count
FROM user_pupil_count
GROUP BY pupil_count
;


-- Number of users in each career for web apps
SELECT career,
			 COUNT(user_id) AS count
FROM user_pupil_count
GROUP BY career
ORDER BY count DESC;

SELECT career,
			 COUNT(DISTINCT user_id) AS career_count
FROM spelling_engagement
GROUP BY career
ORDER BY career_count DESC;

-- Librarians in all web apps
DROP TEMPORARY TABLE IF EXISTS lib_all;

CREATE TEMPORARY TABLE lib_all
SELECT DISTINCT(user_id) AS user_id,
							 career
FROM user_pupil_count
WHERE career = 'librarian';

-- Librarians in spellings app
DROP TEMPORARY TABLE IF EXISTS lib_sp;

CREATE TEMPORARY TABLE lib_sp
SELECT DISTINCT(user_id) AS user_id,
							 career
FROM spelling_engagement
WHERE career = 'librarian';

SELECT sp.user_id,
			 sp.career,
			 alld.user_id,
			 alld.career
FROM lib_sp AS sp
	LEFT JOIN lib_all AS alld
		ON sp.user_id = alld.user_id;


-- Number of users in each career for the website
SELECT cco.neat_career_category,
			 COUNT(cco.neat_career_category) AS career_count_website
FROM analytics.dx_user AS du
	JOIN analytics.career_category_overview AS cco
		ON du.career_category_id = cco.id
WHERE date_created > '2023-09-01 00:00:00'
GROUP BY cco.neat_career_category
ORDER BY career_count_website DESC;


-- Number of users in each career for the spelling app
SELECT career,
			 COUNT(DISTINCT user_id) AS count
FROM spelling_engagement
GROUP BY career
ORDER BY count DESC;



-- Number of users in each career for the ESL app
SELECT career,
			 COUNT(DISTINCT user_id) AS count
FROM esl_engagement
GROUP BY career
ORDER BY count DESC;

-- Number of users in each career for the Puzzled app
SELECT career,
			 COUNT(DISTINCT user_id) AS count
FROM puzzled_engagement
GROUP BY career
ORDER BY count DESC;
