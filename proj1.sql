-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;
DROP VIEW IF EXISTS lslg_all;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era) FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear FROM people
  WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear FROM people
  WHERE namefirst LIKE '% %' ORDER BY namefirst, namelast DESC
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count FROM people
  GROUP BY birthyear
  ORDER BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT * FROM q1iii
  WHERE avgheight >= 70
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT P.namefirst, P.namelast, P.playerid, H.yearid
  FROM people AS P
  INNER JOIN halloffame AS H ON P.playerid = H.playerid
  WHERE H.inducted = 'Y'
  ORDER BY H.yearid DESC, P.playerid
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT H.namefirst, H.namelast, H.playerid, C.schoolid, H.yearid
  FROM q2i AS H
  INNER JOIN collegeplaying as C ON H.playerid = C.playerid
  INNER JOIN schools as S on S.schoolid = C.schoolid
  WHERE S.schoolState = 'CA'
  ORDER BY H.yearid DESC, C.schoolid, H.playerid
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT H.playerid, H.namefirst, H.namelast, C.schoolid
  FROM q2i AS H
  LEFT JOIN collegeplaying AS C ON H.playerid = C.playerid
  ORDER BY H.playerid DESC, C.schoolid
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT P.playerid, P.namefirst, P.namelast, B.yearid, B.slg
  FROM people AS P
  INNER JOIN (
    SELECT *, (h + h2b + 2*h3b + 3*hr) * 1.0 / ab AS slg
    FROM batting
    WHERE ab > 50
    ORDER BY slg DESC LIMIT 10
  ) AS B ON P.playerid = B.playerid
;

CREATE VIEW lslg_all(playerid, namefirst, namelast, lslg)
AS
  SELECT P.playerid, P.namefirst, P.namelast, B.lslg
  FROM people AS P
  INNER JOIN (
    SELECT playerid, (SUM(h) + SUM(h2b) + 2*SUM(h3b) + 3*SUM(hr)) * 1.0 / SUM(ab) AS lslg
    FROM batting
    GROUP BY playerid
    HAVING SUM(ab) > 50
    ORDER BY lslg DESC
  ) AS B ON P.playerid = B.playerid
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT * FROM lslg_all
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT P.namefirst, P.namelast, L.lslg
  FROM people AS P
  INNER JOIN lslg_all AS L ON P.playerid = L.playerid
  WHERE L.lslg > (
      SELECT (SUM(h) + SUM(h2b) + 2*SUM(h3b) + 3*SUM(hr)) * 1.0 / SUM(ab)
      FROM batting
      WHERE playerid = "mayswi01"
      GROUP BY playerid
      HAVING SUM(ab) > 50
  )
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT 1, 1, 1, 1, 1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT 1, 1 -- replace this line
;

