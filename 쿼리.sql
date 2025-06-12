mydb	-- 관계형 데이터베이스 관리 시스템(RDBMS) 중 MariaDB 설치 후 사용 
-- DB 생성 - CREATE DATABASE DB명
-- CREATE DATABASE mydb;
-- USE mydb;
-- SHOW DATABASES; -- DB명 목록 보기
-- DB 삭제 - DROP DATABASE DB명
-- 스키마, 정규화에 대한 이해 필요

-- 테이블 생성
-- CREATE TABLE TABLE명(칼럼명 자료형...제약조건...)
-- SQL 규칙은 명령문과 테이블 명은 모두 대문자를 사용한다
CREATE TABLE test (NO INT, NAME CHAR(10)); 
DESC test;
SHOW TABLES;
DROP TABLE test;

CREATE TABLE test(NO INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL,tel VARCHAR(15), inwon INT, addr TEXT) CHARSET=UTF8;

DESC test;

-- 자료 추가
-- INSERT INTO 테이블명(칼럼명...) VALUES(자료...)
INSERT INTO test(NO,NAME,tel,inwon,addr) VALUES(1,'인사과','111-1111',3,'역삼 1동');
INSERT INTO test VALUES(2,'영업과','111-222',5,'역삼 1동');
INSERT INTO test(NO,NAME) VALUES(3,'자재과');
INSERT INTO test(NAME,NO) VALUES('판매과',4);

SELECT * FROM test; -- 모든 행 출력 
SELECT * FROM test WHERE NO=1; -- 조건에 맞는 행 출력


-- INSERT INTO test(NO,tel) VALUES(4,'111-5555');
-- INSERT INTO test(NO,NAME) VALUES(5,'자재과는 일이 매우 많은 그런 부서입니다'); -- 데이터 길이보다 길 경우 오류
-- INSERT INTO test VALUES(5, '111-5555'); -- 입력 자료의 갯수와 열 갯수 불일치

-- 자료 수정
-- UPDATE INTO 테이블명 SET 칼럼명=수정값,...where 조건
UPDATE test SET tel='666-6666' WHERE NO=1;
UPDATE test SET inwon=12,tel='666-7777' WHERE NO=3;
UPDATE test SET tel=null WHERE NO=3; -- 문자열에 따옴표 없이 null값을 그냥 쓰면 된다 
-- UPDATE test SET name=null WHERE NO=3; -- not null을 null로 설정할 경우  오류 
UPDATE test SET NO=9 WHERE NO=3; -- 문법상의 문제는 없지만 기본키 칼럼은 수정에서 제외해야한다

SELECT * FROM test;

-- 자료 삭제
-- DELETE 테이블명 WHERE 조건
DELETE FROM test WHERE NAME='영업과';

DELETE FROM test; -- 조건 추가 가능한 모든 행 삭제 속도가 느리다
TRUNCATE TABLE test; -- 조건없이 모든 행  삭제
DROP TABLE test; -- 테이블 삭제, 구조가 사라짐

-- SQL도 로컬 수정 내역을 커밋으로 데이터베이스에 적용시켜주어야 한다 .
-- 무결성 제약조건 : 잘못된 자료의 입력을 방지할 목적으로 테이블 생성 시 제한조건 부여 
-- domain constraint : 칼럼 생성시 각 칼럼의 이름, 성격, null 허용 여부 지정
-- PRIMARY KEY CONSTRAINT : 중복을 허용하지 않을 칼럼에 부여 
-- 사용자 정의 constraint : check, unique, foreign key ...

-- 기본키 제약조건 - 중복자료 입력 방지
-- 방법 1 - 칼럼 레벨 : 칼럼 선언시 제약조건 부여 (pk의 이름은 DBMS가 준다)
CREATE TABLE aa(bun INT PRIMARY KEY, irum VARCHAR(10) NOT null); -- domain  constraint도 적용 
DESC aa;
SHOW INDEX FROM aa;
SELECT * FROM information_schema.table_constraints WHERE TABLE_NAME='aa';
DROP TABLE aa;
-- 방법 2 - 테이블 레벨 : 칼럼을 모두 정의한 후 제약조건 부여

CREATE TABLE aa(bun INT, irum VARCHAR(10) NOT NULL, CONSTRAINT aa_bun_pk PRIMARY KEY(bun));
DESC aa;

-- check 제약조건 : 특정 칼럼에 입력되는 자료의 값을 검사

CREATE TABLE aa(bun INT, irum VARCHAR(10),nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1,'tom',33);
INSERT INTO aa VALUES(1,'tom',13); -- check 제약 조건에 걸림
SELECT * FROM aa;

-- unique 제약조건 : 특정 칼럼에 입력되는 자료의 값의 중복을 불허함
CREATE TABLE aa(bun INT, irum VARCHAR(10) UNIQUE);
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(1,'james');
INSERT INTO aa VALUES(3,'tom'); -- 중복된 이름값 제약조건에 걸림

-- foreign key(FK) - 외래키 제약조건 : 다른 테이블의 칼럼값 참조 fk의 대상은 pk 이다 기본 테이블을 참조시키는 제약조건
-- on delete cascade : 부모 테이블의 행이 삭제 되는 경우 참조하고 있는 자식 테이블의 종속행 자동삭제

CREATE TABLE sawon(bun INT PRIMARY KEY, irum VARCHAR(10), buser CHAR(10));
INSERT INTO sawon VALUES(1,'한국인','인사과');
INSERT INTO sawon VALUES(2,'한송이','자재과');
INSERT INTO sawon VALUES(3,'한사람','판매과');
SELECT * FROM sawon;

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10), birth DATETIME,sawon_bun INT, FOREIGN KEY(sawon_bun) REFERENCES sawon(bun));
DESC gajok;
INSERT INTO gajok VALUES(100, '지구인', '1980-1-12', 1);
INSERT INTO gajok VALUES(200, '우주인', '1982-10-12', 2);
INSERT INTO gajok VALUES(300, '이기자', '1986-12-12', 5); -- 외래키의 참조 불가 에러
SELECT * FROM gajok;
DELETE FROM gajok WHERE CODE = 200;
DELETE FROM sawon WHERE bun=1; -- 외래키로 참조중인 행은 삭제 불가 외래키가 있는참조테이블 행부터 삭제 가능
DROP TmydbmydbmydbABLE sawon; -- 테이블 삭제도 불가능하다 
DROP TABLE gajok;

-- default : 특정 칼럼에 초기지 부여 제약조건은 아님 NULL이 입력되는것을 방지하는 것을 목적

CREATE TABLE aa(bun INT, irum VARCHAR(10), jus VARCHAR(30) DEFAULT '역삼동');
DESC aa;
INSERT INTO aa VALUES(1,'김밥','서초3동');
INSERT INTO aa(bun) VALUES(2);
SELECT *FROM aa;
DROP TABLE aa;

-- 숫자 자동 증가 (auto_increment) - 단 오라클은 auto_increment 대신 sequence를 사용 INT 키에 특히 PRIMARY KEY에 많이 사용한다 
-- RDBMS에 따라 auto_increment 가 아니라 autoincrement 인 경우도 있다 시작 값은 ALTER로 변경이 가능하다 
CREATE TABLE aa(bun INT AUTO_INCREMENT PRIMARY KEY, irum VARCHAR(10));
DESC aa;
INSERT INTO aa VALUES(0,'박치기');
INSERT INTO aa VALUES(null,'한국인');
SELECT *FROM aa;
INSERT INTO aa(irum) VALUES('주먹밥');
ALTER TABLE aa AUTO_INCREMENT=50;
SET @@AUTO_INCREMENT_INCREMENT=3;  -- 증가값을 변경

--  index(색인) : 검색속도를 빠르게 하기 위해 검색대상 칼럼에 색인 부여
-- pk 칼럼은 자동으로 색인 부여
--  index를 사용해야 하는 경우 자료수가 많을때 조건에 의한 검색이 많을때 
--  index를 자제해야 하는 경우 insert, update, delete가 빈번한 테이블 
--  Ascending (오름차순) Descending (내림차순)

CREATE TABLE aa(irum VARCHAR(10), juso VARCHAR(20));
ALTER TABLE aa ADD(job_id INT);
INSERT INTO aa VALUES(2,'bb','seoul');
INSERT INTO aa VALUES('tom', 'seoul', 10);
ALTER TABLE aa CHANGE job_id job_num INT; -- 칼럼 이름 변경 
ALTER TABLE aa MODIFY job_num VARCHAR(5); --칼럼 타입 변경
INSERT INTO aa VALUES(3,'cc','suwon');
INSERT INTO aa VALUES(1,'aa','busan'); -- PRIMARY KEY에 자동 색인 생성
SHOW INDEX FROM aa;
-- BTREE(Balanced TREE) : 칼럼의 값을 변경하지 않고 원래의 값을 이용해 인덱싱
-- 기본적으로 이진(이분)검색을 한다

ALTER TABLE aa ADD INDEX ind_irum (irum);  -- 인덱스 추가 녹색 키모양 추가 
DROP INDEX ind_irum ON aa;
DESC aa;

SELECT *FROM aa; 
ALTER TABLE aa RENAME kbs;
DROP TABLE kbs;

ALTER TABLE aa DROP COLUMN job_num; -- 칼럼 삭제

-- 본격적인 query(질의) 연습 

DESC buser;
DESC jikwon;
DESC sangdata;
DESC gogek;

SELECT *FROM jikwon; -- 전체 로우, 컬럼 자료 읽기
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon; -- 일부 요청 컬럼들만 불러온다. projection
SELECT jikwonpay, jikwonname, jikwonno FROM jikwon; -- 칼럼들의 순서는 입력 순서에 따라 달라진다.
SELECT *FROM jikwon WHERE jikwonno<=10; -- 특정조건에 맞는 데이터들을 불러온다. selection
-- 다른 프로그램으로 데이터를 보내서 사용할 시 정보의 순서는 매우 중요하다. 요청한 데이터의 순서가 영향을 준다.

SELECT jikwonpay AS 연봉, jikwonno 직원번호, jikwonname 직원명 FROM jikwon; -- 칼럼명을 임의의 이름으로 변경하며 불러온다. AS는 띄어쓰기로 생략가능. 
-- 변경한 이름 부분을  띄어쓰기 위해선 ''를 둘러줘야한다. 

SELECT 10, 10+5, 12/3 AS 결과, '안녕' FROM DUAL; -- DUAL = 가상 테이블 사용
SELECT 10, 10+5, 12/3 AS 결과, '안녕';

SELECT jikwonname AS 이름, jikwonpay * 0.05 AS 결과 FROM jikwon; -- 자바에서 부를땐 그저 1, 2 이지만 사람이 인식하는데엔 힘들수가 있다 그럴때 이렇게 임시적인 이름을 부여
SELECT CONCAT(jikwonname,'님') FROM jikwon; -- HeidiSQL식 문자열 더하기
-- 국어, 영어, 총점, 평균이 필요하다고 할때 테이블 생성시 국어,영어만 칼럼을 작성하고 총점, 평균 등 연산 의해 얻을 수 있는 부분은 따로 컬럼으로 작성하지 않는다.

-- 정렬 : ORDER BY ASC|DESC 여러개의 컬럼마다 다양한 방식으로 정렬할 수 있다.

SELECT *FROM jikwon ORDER BY jikwonpay DESC; -- Descending 내림차순
SELECT *FROM jikwon ORDER BY jikwonpay ASC; -- Ascending 오름차순(ASC|DESC 입력 생략시 기본 적용)
SELECT *FROM jikwon ORDER BY jikwonjik DESC; -- 문자열은 사전 순으로 간다 그룹화가 가능

SELECT *FROM jikwon ORDER BY jikwonjik, jikwonpay DESC, jikwongen; -- ASC는 기본적으로 적용되므로 보통은 컬럼명과 DESC만 사용하게 된다 

SELECT mydb.jikwon.jikwonno,jikwonname, jikwonjik FROM jikwon ORDER BY jikwonjik DESC; 
-- 컬럼명을 정확히 사용한다면 데이터베이스 명부터 들어가야한다 같은 데이터베이스와 테이블을 사용하므로 생략이 가능하다  다를경우 다른 부분부터 불러와야한다

SELECT DISTINCT jikwonjik FROM jikwon; -- DISTINCT : 중복 데이터를 배제하고 고유한 값만을 꺼냄 두개 이상의 컬럼값을 같이 쓰지 않는것을 권장한다

-- 연산자( 우선순위 ()안의 내용 > 산술연산자 (곱셈 나눗셈  > 덧셈 뺄셈) > 관계(비교) > is null, like, in > between, not > and > or )

SELECT*FROM jikwon WHERE jikwonjik='대리'; -- selection :행을 제한
SELECT*FROM jikwon WHERE jikwonno=5; -- 숫자엔 ''를 둘러주지 않아도 되지만 문자열 부분은 반드시 둘러줘야한다
SELECT*FROM jikwon WHERE jikwonibsail='2017-08-05';
SELECT*FROM jikwon WHERE jikwonibsail='17-8-5';
SELECT*FROM jikwon WHERE jikwonno=5+3;
SELECT*FROM jikwon WHERE jikwonno=16/2; -- 연산자를 써줄 수 있다 문자열엔 CONCAT() 사용
SELECT*FROM jikwon WHERE jikwonno=4+2*2;
SELECT*FROM jikwon WHERE jikwonjik='사원' OR jikwonjik='부장';
SELECT*FROM jikwon WHERE jikwonjik='대리' AND jikwonjik='부장'; -- 잘못된 조건 
SELECT*FROM jikwon WHERE jikwonjik='사원' AND jikwongen='남' AND jikwonpay<=4500;
SELECT*FROM jikwon WHERE jikwonjik='사원' AND (jikwongen='남' OR jikwonpay<=4500);
SELECT*FROM jikwon WHERE jikwonno>=5 AND jikwonno<=10;
SELECT*FROM jikwon WHERE jikwonno BETWEEN 5 AND 10; -- BETWEEN AND = 이상, 이하 범위 지정
SELECT*FROM jikwon WHERE jikwonibsail BETWEEN '2015-1-1' AND '2016-12-12';
SELECT*FROM jikwon WHERE jikwonjik!='사원';
SELECT*FROM jikwon WHERE jikwonjik<>'사원'; -- 조건 부정 조건이 아닌 것을 찾을때 사용한다
SELECT*FROM jikwon WHERE jikwonno NOT BETWEEN 5 AND 10; -- BETWEEN을 먼저 찾은 후에 NOT을 찾는다
SELECT*FROM jikwon WHERE jikwonname>='김이화'; -- 문자도 대소 비교를 할수 있다 (ASCII 코드 기반)
SELECT ASCII('a'), ASCII('A'), ASCII(0), ASCII('가'), ASCII('나') FROM DUAL;
SELECT*FROM jikwon WHERE jikwonname>='김' AND jikwonname<='박';
SELECT*FROM jikwon WHERE jikwonname BETWEEN '김' AND '박';
SELECT*FROM jikwon WHERE jikwonjik='대리' OR jikwonjik='부장' OR jikwonjik='이사';
SELECT*FROM jikwon WHERE jikwonjik IN('대리','부장','이사'); -- in 연산자 OR을 여러번 쓰는것을 줄여준다
SELECT*FROM jikwon WHERE busernum IN(10,30) ORDER BY busernum;
SELECT*FROM jikwon WHERE jikwonname LIKE '이%'; -- like : %(0개 이상의 문자열) 첫글자에 해당하는 문자열 전부
SELECT*FROM jikwon WHERE jikwonname LIKE '%라';
SELECT*FROM jikwon WHERE jikwonname LIKE '%유%';
SELECT*FROM jikwon WHERE jikwonname LIKE '이%라'; -- 사이의 글자가 몇 글자이던 찾는다
SELECT*FROM jikwon WHERE jikwonname LIKE '이_라'; -- _ 는 한글자만 지정해서 찾는다
SELECT*FROM jikwon WHERE jikwonname LIKE '__'; -- 두글자짜리만 찾기
SELECT*FROM gogek WHERE gogekname LIKE '이%' OR gogekname LIKE '차%';
SELECT*FROM gogek WHERE gogekjumin LIKE '%-1%';
SELECT*FROM gogek WHERE gogekjumin LIKE '_______1%';
SELECT*FROM jikwon WHERE jikwonpay LIKE '5%';
SELECT*FROM jikwon;
UPDATE jikwon SET jikwonjik=NULL WHERE jikwonno=5;
SELECT *FROM jikwon WHERE jikwonjik=NULL; -- 잘못된 조건
SELECT*FROM jikwon WHERE jikwonjik IS NULL; -- IS NULL을 해야 NULL이 검색된다
SELECT*FROM jikwon WHERE jikwonno<=10 LIMIT 3; -- 갯수 제한 오라클에선 rownum
SELECT*FROM jikwon WHERE jikwonno<=10 ORDER BY jikwonno DESC LIMIT 3; -- 추가 조건
SELECT jikwonno, jikwonname FROM jikwon WHERE jikwonno<=10 LIMIT 4,2; -- LIMIT 행 이후, 갯수 ~행의 다음부터 ~개 제한 검색
SELECT jikwonno AS 직원번호, jikwonname 직원명, jikwonjik 직급, jikwonpay 연봉, jikwonpay/12 AS 보너스, jikwonibsail 입사일 FROM jikwon 
WHERE jikwonjik IN('과장','사원') AND ((jikwonpay>=4000 AND jikwonibsail BETWEEN '2015-1-1' AND '2020-12-31') OR (jikwonname LIKE '이%' AND jikwonibsail BETWEEN '2015-1-1' AND '2020-12-31')) ORDER BY jikwonjik,jikwonpay DESC LIMIT 3;

--  MariaDB 제공 함수 ( 클래스의 메소드) 사용
-- 데이터 조작의 효율성이 증대
-- 단일 행 함수 : 각 행에 대해 적용, 행단위 처리
-- 문자 함수
SELECT LOWER('Hello'), UPPER('Hello') FROM DUAL;  -- LOWER 소문자 처리 UPPER 대문자 처리
SELECT CONCAT('Hello', 'world'), SUBSTR('Hello World',3),SUBSTR('Hello World',3,5); -- CONCAT('문자열','문자열')=문자열문자열 : 문자열 더하기, SUBSTR : 문자열 추출 SUBSTR('문자열,여기부터,몇개까지)
SELECT LENGTH('Hello World'), INSTR('Hello World','e');  -- LENGTH 문자열 길이 추출 INSTR('문자열', 추출 글자) 문자열 내 처음 글자 위치 추출
SELECT TRIM('   kbs mbc   '), REPLACE('Hello World','l','엘'); -- TRIM 앞뒤 공백 삭제 REPLACE 지정 문자열 교체

SELECT jikwonno,jikwonname,jikwonibsail,REPLACE(jikwonibsail,'-','.') FROM jikwon;
-- jikwon 테이블에서 이름에 '이'가 포함된 경우 '이'부터 두 글자 출력
SELECT jikwonname FROM jikwon WHERE jikwonname LIKE '%이%';
SELECT jikwonname, SUBSTR(jikwonname, INSTR(jikwonname,'이'), 2) result FROM jikwon WHERE jikwonname LIKE '%이%';

-- 숫자 함수 
SELECT ROUND(45.678,2),ROUND(45.678,0),ROUND(45.678),ROUND(45.678,-1); -- ROUND(소수점 숫자, 몇번째자리(음수가능)) 자리지정 없을시 기본 소수점 첫째자리 반올림
SELECT CEILING(4.7), CEILING(4.2), FLOOR(4.7), FLOOR(4.2); -- CEILING 올림 FLOOR 버림
SELECT jikwonno, jikwonname, jikwonpay,
ROUND(jikwonpay*0.123) AS tax,ROUND(jikwonpay*0.123,2) AS tax2, CEILING(jikwonpay*0.123) AS tax3, FLOOR(jikwonpay*0.123)AS tax4 FROM jikwon WHERE jikwonjik='대리';
SELECT TRUNCATE(45.678,0),TRUNCATE(45.678,1),TRUNCATE(45.678,-1); -- 소숫점 자리 기준 숫자 버림
SELECT 15/2, 15 MOD 2, MOD(15,2); -- MOD 나머지 구하기

-- 날짜 함수
SELECT CURDATE(),CURDATE()+0,CURRENT_DATE(),TO_DAYS(NOW());  -- TO_DAYS()의 날짜의 기준은 1970년 1월 1일 UNIX 시작 날짜
SELECT NOW(), NOW()+0,SYSDATE();
SELECT NOW(), SLEEP(3), NOW(); -- 하나의 쿼리안에서 동일값 유지
SELECT SYSDATE(), SLEEP(3), SYSDATE(); -- 실행 시점마다 다름
SELECT ADDDATE(DATE'2020-8-1',3), SUBDATE(DATE'2020-8-1',3); -- 날짜 더하기
SELECT DATE_ADD(NOW(),INTERVAL 1 MINUTE);
SELECT DATE_ADD(NOW(),INTERVAL 5 DAY);
SELECT DATE_ADD(NOW(),INTERVAL 2 MONTH);
SELECT DATE_SUB(NOW(),INTERVAL -2 YEAR);
SELECT DATEDIFF(NOW(),'2020-5-5'); -- 일자 차이 계산
SELECT TIMEDIFF('15:12-6','10:11:12'); -- 시간 차이 
SELECT TIMESTAMPDIFF(QUARTER,NOW(),'2023-5-5'); -- 분기 차이 계산 /타임 스탬프 : 특정 순간의 날짜와 시간을 나타낸 값

-- 형 변환 함수
SELECT DATE_FORMAT(NOW(),'%Y%m%d'), DATE_FORMAT(NOW(),'%Y년 %m월 %d일';
SELECT 1234.567, FORMAT(1234.567, 2), FORMAT(1234.567,0);
SELECT STR_TO_DATE('2025-02-13','%Y-%m-%d');

-- 기타 함수 
-- RANK() 순위 결정
SELECT jikwonno,jikwonname,jikwonpay, RANK() OVER(ORDER BY jikwonpay DESC) FROM jikwon; -- jikwonpay별 순위가 결정 DESC로 내림차 가능 
SELECT jikwonno,jikwonname,jikwonpay, RANK() OVER(ORDER BY jikwonpay), DENSE_RANK() OVER(ORDER BY jikwonpay) FROM jikwon;

-- RANK(), DENSE_RANK() 동점자 처리 후에 그 다음값에 차이가 있음 DENSE는 동점자를 동일 순위 처리함 
-- null 자료 관련 함수 
-- nvl(value1,value2) : value1이 null이면 value2를 취함
SELECT jikwonno,jikwonname,jikwonjik, nvl(jikwonjik,'임시직') FROM jikwon; -- null값 대체 처리
-- nvl2(value1, value2, value3) : value1이 null인지 평가 후 null 이면 value2를 취함 아니면 value3을 취함
SELECT jikwonno,jikwonname,jikwonjik, nvl2(jikwonjik,'정규직','임시직') FROM jikwon;
-- nullif(value1, value2) : 두 개의 값이 일치하면 null을 일치하지 않으면 value1을 취합
SELECT jikwonno,jikwonname,jikwonjik,NULLIF(jikwonjik,'대리') FROM jikwon; -- NULL 값 주기 

-- 조건 표현식 (Conditional Expressions)
-- 형식1) case 표현식 when 비교값1 then 결과1 when 비교값2 then 결과2...[else 결과n] end as 컬럼별명
SELECT jikwonno,jikwonname, jikwonpay,
CASE jikwonpay 
WHEN 3000 THEN '연봉3000' 
WHEN 5000 THEN '연봉5000' ELSE '기타연봉' END AS ypay FROM jikwon; 
SELECT jikwonno, jikwonname, jikwonpay,jikwonjik,
CASE jikwonjik
WHEN '이사' THEN jikwonpay*0.05
WHEN '부장' THEN jikwonpay*0.04
WHEN '과장' THEN jikwonpay*0.03
ELSE jikwonpay*0.02 END donation FROM jikwon; -- 결과의 검증은 중요하다 

-- 형식2) case when 조건1 then 결과1 when 조건2 then 결과2 ... [else 결과n] end as 컬럼별명
SELECT jikwonno,jikwonname,jikwonpay,jikwonjik,
CASE
WHEN jikwonpay >= 7000 THEN '고액연봉'
WHEN jikwonpay >= 5000 THEN '보통연봉' ELSE '저조' END AS result 
FROM jikwon WHERE jikwonjik IN('대리','과장','사원') ORDER BY jikwonjik;
SELECT jikwonno,jikwonname,jikwonpay,jikwonjik,
CASE
WHEN (2000-jikwonpay)>0 THEN '2000미만'
WHEN (3000-jikwonpay)>0 THEN '2000대'
WHEN (4000-jikwonpay)>0 THEN '3000대'
WHEN (5000-jikwonpay)>0 THEN '4000대'
WHEN (6000-jikwonpay)>0 THEN '5000대'
ELSE '기타연봉' END AS result
FROM jikwon;


-- 복수행 함수(집계 함수) : 전체 자료를 그룹별로 구분하여 통계 결과를 얻기 위한 함수
-- NULL 값은 무시됨 count(*)는 NULL값 적용됨
SELECT SUM(jikwonpay) AS 합,FLOOR(AVG(jikwonpay)) AS 평균, MAX(jikwonpay) AS 최대연봉, MIN(jikwonpay) AS 최소연봉, COUNT(jikwonpay) AS 인원수 FROM jikwon;
SELECT *FROM jikwon;
UPDATE jikwon SET jikwonpay = NULL WHERE jikwonno=5;
SELECT AVG(jikwonpay), AVG(nvl(jikwonpay,0)) FROM jikwon; -- 값이 NULL인 행은 작업에서 무시함
SELECT SUM(jikwonpay)/29, SUM(jikwonpay)/30 FROM jikwon;
SELECT COUNT(jikwonpay),COUNT(jikwonno), COUNT(*) FROM jikwon;

-- 대리는 몇명인가
SELECT COUNT(*) AS '대리 인원수' FROM jikwon WHERE jikwonjik='대리';
-- 2010년 이전 입사한 남자직원은?
SELECT COUNT(*) AS '2010년 이전 입사 남자직원' FROM jikwon WHERE jikwonibsail<'2010-1-1' AND jikwongen='남';
-- 2015년 이후 입사한 여자직원의 연봉합, 평균, 인원수?
SELECT SUM(jikwonpay) 연봉합, ROUND(AVG(jikwonpay),0) 평균, COUNT(*) 인원수 FROM jikwon WHERE jikwonibsail>='2015-1-1' AND jikwongen='여';

-- 그룹 함수 : GROUP BY 소계를 구할 수 있다. 형식 ) SELECT 그룹컬럼명,.... 계산함수 FROM 테이블명 WHERE 조건 GROUP BY 그룹컬럼명,... HAVING 소계결과조건
--  GROUP BY 전에 ORDER BY 사용 불가 GROUP BY 내에서 ORDER BY를 하는 중임, GROUP BY HAVING 조건 이후 사용가능
-- 간단하게 중복 행을 그룹으로 합쳐준다
-- 성별 연봉의 평균과 인원수 출력
SELECT AVG(jikwonpay),COUNT(*) FROM jikwon WHERE jikwongen='남';
SELECT AVG(jikwonpay),COUNT(*) FROM jikwon WHERE jikwongen='여';
SELECT jikwongen 성별,AVG(jikwonpay) 연봉평균,COUNT(*) 인원수 FROM jikwon GROUP BY jikwongen; -- 여러 단위의 데이터 처리에 매우 효율적임
-- 부서별 연봉합을 구함
SELECT busernum 부서, SUM(jikwonpay) 연봉합 FROM jikwon GROUP BY busernum;
-- 부서별 여직원 연봉합
SELECT busernum 부서, SUM(jikwonpayjikwon) 연봉합 FROM jikwon WHERE jikwongen='여' GROUP BY busernum; -- 이후에 별명값만으로 명령문 내에서 호출가능 mariadb만의 기능이던 뭐던 유용하니 알아두자
-- 부서별 여직원 연봉합 출력 연봉합 15000이상인 경우만 출력
SELECT busernum 부서, SUM(jikwonpay) 연봉합 FROM jikwon WHERE jikwongen='여' GROUP BY busernum HAVING 연봉합> 15000;
SELECT busernum, SUM(jikwonpay) FROM jikwon WHERE jikwongen='여' GROUP BY busernum HAVING SUM(jikwonpay) >= 5000 ORDER BY busernum DESC;
SELECT busernum, SUM(jikwonpay), AVG(jikwonpay), COUNT(*) FROM jikwon WHERE jikwongen='여' GROUP BY busernum HAVING SUM(jikwonpay)>=5000 ORDER BY SUM(jikwonpay) DESC;
SELECT jikwonjik 직급, ROUND(AVG(jikwonpay),0) 급여평균 FROM jikwon WHERE jikwonjik IS NOT NULL GROUP BY 직급; 
SELECT jikwonjik 직급, SUM(jikwonpay) 급여총합 FROM jikwon WHERE jikwonjik IN('부장','과장') GROUP BY 직급; 
SELECT DATE_FORMAT(jikwonibsail, '%Y') 입사년도,COUNT(*) 입사인원수 FROM jikwon WHERE jikwonibsail<'2015-1-1' GROUP BY 입사년도;
SELECT nvl(jikwonjik,'임시직') 직급,jikwongen 성별, COUNT(*) 인원수,SUM(nvl(jikwonpay,0)) 급여합 FROM jikwon GROUP BY jikwonjik,jikwongen;
SELECT busernum 부서번호,SUM(jikwonpay) 급여총합 FROM jikwon WHERE busernum IN(10,20) GROUP BY busernum;
SELECT nvl(jikwonjik,'임시직') 직급, SUM(jikwonpay) 급여합 FROM jikwon GROUP BY jikwonjik HAVING  급여합>=7000;
SELECT nvl(jikwonjik,'임시직') 직급,COUNT(*), SUM(jikwonpay) 급여합 FROM jikwon GROUP BY jikwonjik HAVING COUNT(jikwonjik)>=3;

-- join : 하나 이상의 테이블에서 원하는 데이터 (행, 열) 추출
-- 원활한 실습을 위해 자료를 일부 추가, 수정함

INSERT INTO buser VALUES(50, '전략기획부','서울','02-100-4444'); -- 부서 테이블과 직원 테이블의 부서번호를 이용해 join을 연습하기 위한 buser 테이블 행 추가
SELECT*FROM buser; -- 전략 기획부엔 직원이 없는 상태다
SELECT*FROM jikwon; -- 직원 테이블 특정 행 부서번호에 NULL을 입력
DESC jikwon; -- 부서번호 busernum은 not null 상태이므로 null을 허용하게 구조 변경
ALTER TABLE jikwon MODIFY busernum INT NULL; -- 직원테이블 부서번호 null 허용하게 구조 변경
UPDATE jikwon SET busernum=NULL WHERE jikwonno=5;
SELECT mydb.jikwon.jikwonname FROM jikwon; -- db명.테이블명.컬럼명이 원래 기본 구조다
SELECT jiktable.jikwonname FROM jikwon AS jiktable; -- 테이블명에 별명을 주고 별명. 칼럼명도 가능

-- CROSS JOIN : 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든 행을 한번씩 연결하는 기능
SELECT jikwonname, busername FROM jikwon,buser; -- 각 행의 항목이 1:1 대응 형식으로 출력됨
SELECT jikwonname, busername FROM jikwon CROSS JOIN buser; -- 위와 같은 기능이다. 실무에서 쓰일 일은 별로 없다. 이런 식의 join도 있다는걸 참고 
-- CROSS JOIN 중에서 SELF JOIN이라고 함 - 자신이 자신과 조인하는 의미로 1개의 테이블을 사용함
SELECT tab1.jikwonname, tab2.jikwonname FROM jikwon AS tab1 CROSS JOIN jikwon AS tab2; -- 이것도 실무에선 쓰일일은 거의 없다.
-- EQUI join : 조인 조건식에 '=' 를 사용, 일반적으로 사용
SELECT jikwonname, busername FROM jikwon, buser WHERE jikwon.busernum = buser.buserno; -- 두 테dl블의 부서 번호를 통해 직원 이름과 부서 이름을 직원 이름과 이어줌
-- NON-EQUI join : 조인 조건식에 '=' 이외의 관계 연산자를 사용
-- NON-EQUI join 사용을 위해 새로운 연습용 테이블을 생성하고 데이터를 입력해준다.
-- jikwonpay에 등급을 표시하기 위함
CREATE TABLE paygrade(grade INT PRIMARY KEY, lpay INT, hpay INT);
INSERT INTO paygrade VALUES(1,0,1999);
INSERT INTO paygrade VALUES(2,2000,2999);
INSERT INTO paygrade VALUES(3,3000,3999);
INSERT INTO paygrade VALUES(4,4000,4999);
INSERT INTO paygrade VALUES(5,5000,9999);
SELECT*FROM paygrade;

SELECT jiktab.jikwonname, jiktab.jikwonpay, paytab.grade 
FROM jikwon AS jiktab, paygrade AS paytab 
WHERE jiktab.jikwonpay >= paytab.lpay AND jiktab.jikwonpay <= paytab.hpay;
-- 관계연산자를 >=, <= 를 사용하는 것을 NON-EQUI join이라 한다.
-- INNER JOIN과 OUTER JOIN : 테이블을 조인할때 두 테이블에 모두 지정한 열의 데이터가 있어야한다.
-- 두 테이블 중 어느 한 쪽이라도 데이터가 없는 경우는 작업에서 제외한다.
-- 방법1 INNER JOIN 사용 하지 않음
SELECT jikwonno,jikwonname,busername FROM jikwon,buser WHERE busernum=buserno; -- 주로 오라클에서 많이 사용
SELECT jikwon.jikwonno,jikwon.jikwonname,buser.busername FROM jikwon,buser WHERE jikwon.busernum=buser.buserno; -- 두개의 테이블에 중복된 열 이름이 없다면 테이블명 생략
SELECT jtab.jikwonno,jtab.jikwonname, butab.busername FROM jikwon jtab,buser butab WHERE jtab.busernum=butab.buserno; -- 별명도 가능
SELECT jikwonno,jikwonname,busername FROM jikwon,buser WHERE busernum=buserno AND jikwongen='남'; -- WHERE 조건에서 join 조건과 행 제한 조건을 같이 적게 되므로 가독성이 저하
-- 방법2 INNER JOIN 사용
SELECT jikwonno, jikwonname, busername FROM jikwon INNER JOIN buser ON busernum = buserno; -- 조인 조건은 on 키워드를 사용
SELECT jikwonno, jikwonname, busername FROM jikwon INNER JOIN buser ON busernum = buserno WHERE jikwongen='남';

-- OUTER JOIN : 두 테이블을 조인할때 1개의 테이블에만 데이터가 있어도 결과가 나온다
-- LEFT OUTER JOIN
SELECT jikwonno, jikwonname, busername FROM jikwon,buser WHERE busernum=buserno(+); -- 오라클에서 사용할때 MariaDB에선 안됨
SELECT jikwonno, jikwonname, busername FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno; -- 먼저 적어준 테이블이 기준, 대응안된 부서에 null 허용, 오라클에서도 됨

-- RIGHT OUTER JOIN
SELECT jikwonno, jikwonname, busername FROM jikwon, buser WHERE busernum(+)=buserno; -- 오라클 사용법
SELECT jikwonno, jikwonname, busername FROM jikwon RIGHT OUTER JOIN buser ON busernum=buserno; -- 나중에 적어준 테이블이 기준, buser의 모든 행이 출력

-- FULL OUTER JOIN은 MariaDB에 없다. 대신 union으로 처리한다. 
SELECT jikwonno, jikwonname, busername FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno
UNION
SELECT jikwonno, jikwonname, busername FROM jikwon RIGHT OUTER JOIN buser ON busernum=buserno; 

-- JOIN은 두 개의 테이블을 사용해 마치 하나의 테이블 처럼(가상 테이블) 사용하는 기법 그러므로 테이블 두 개 사용한다는 것 이외의 나머지는 기존 작업과 동일하다
SELECT jikwonno, jikwonname,busername, jikwonpay FROM jikwon INNER JOIN buser ON busernum=buserno WHERE jikwonname LIKE '김%';
SELECT jikwongen AS gender,SUM(jikwonpay) AS hap, COUNT(*) AS COUNT FROM jikwon INNER JOIN buser ON busernum=buserno WHERE jikwonname LIKE '김%' GROUP BY jikwongen;

-- 참고 : jikwon 과 buser는 JOIN이 가능하다- busernum = buserno, jikwon 과 gogek은 조인 가능하다 : jikwonno = gogekdamsano
--  buser와 gogek은 조인 불가능 : 공통 컬럼이 없다. 3개의 테이블은 동시에 조인 시킬순 없다. 공통 컬럼을 가진 테이블만 join 가능

SELECT jikwonno 직원번호, jikwonname 직원명,jikwonjik 직급,gogekname 고객명,gogektel 고객전화번호, CASE WHEN gogekjumin LIKE '%-1%' OR gogekjumin='%-3%' THEN '남' WHEN gogekjumin LIKE '%-2%' OR gogekjumin='%-4%' THEN '여'ELSE '없음'END AS 성별 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano WHERE jikwonjik = '사원';
SELECT jikwonno 직원번호, jikwonname 직원명,jikwonjik 직급,COUNT(gogekdamsano) 고객확보수 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano GROUP BY jikwonname ORDER BY jikwonno;
SELECT jikwonname 직원명,jikwonjik 직급 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano WHERE gogekname='강나루';
SELECT gogekname 고객명, gogektel 전화번호, gogekjumin 주민번호, TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW()) 나이 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano WHERE jikwonname='한송이';

-- 3개의 테이블을 조인
SELECT jikwonname 직원명, busername 부서, gogekname 고객명 FROM jikwon,buser,gogek WHERE busernum=buserno AND jikwonno=gogekdamsano; -- 하나의 테이블에 다른 두개 테이블과 이어지는 부분을 이어서 3개의 테이블을 조인
SELECT jikwonname 직원명, busername 부서, gogekname 고객명 FROM jikwon INNER JOIN buser ON busernum=buserno INNER JOIN gogek ON jikwonno=gogekdamsano ORDER BY 직원명;


-- 문1) 총-- 무부에서 관리하는 고객수 출력 (고객 30살 이상만 작업에 참여)
SELECT busername 부서, COUNT(gogekno) 고객수 FROM jikwon INNER JOIN buser ON busernum=buserno INNER JOIN gogek ON jikwonno=gogekdamsano WHERE TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW()) >=30 AND busernum=10;
-- 문2) 부서명별 고객 인원수 (부서가 없으면 "무소속")
SELECT nvl(busername, '무소속') 부서, COUNT(gogekname) 고객인원수 FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno INNER JOIN gogek ON jikwonno=gogekdamsano GROUP BY busername;
-- 문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면  담당직원 자료 출력  
SELECT jikwonname 직원명,jikwonjik 직급, busername 부서명, busertel 부서전화, jikwongen 성별 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano INNER JOIN buser ON buserno=busernum WHERE gogekname='강나루';
-- 문4) 부서와 직원명을 입력하면 관리고객 자료 출력
SELECT gogekname 고객명, gogektel 고객전화, CASE WHEN MOD(SUBSTR(gogekjumin,8,1),2)=0 THEN '여' ELSE '남' END AS 성별 FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano INNER JOIN buser ON buserno=busernum WHERE busername='영업부' AND jikwonname='이순신';

-- CASE WHEN MOD(SUBSTR(gogekjumin,8,1),2)=0 then '여' ELSE '남' END AS 성별  -- 주민번호로 성별 쉽게 구분하는법
-- TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW()) -- 주민번호로 나이 쉽게 구하는법

-- UNION : 구조가 일치하는 두개 이상의 테이블 자료 합쳐서 보기, 원래의 테이블은 계속 유지됨

CREATE TABLE pum1(bun INT,pummok VARCHAR(20));
INSERT INTO pum1 VALUES(1,'귤');
INSERT INTO pum1 VALUES(2,'바나나');
INSERT INTO pum1 VALUES(3,'한라봉');
SELECT*FROM pum2;
CREATE TABLE pum2(num INT,sangpum VARCHAR(20));
INSERT INTO pum2 VALUES(10,'토마토');
INSERT INTO pum2 VALUES(11,'딸기');
INSERT INTO pum2 VALUES(12,'참외');
INSERT INTO pum2 VALUES(13,'수박');
SELECT bun AS 번호, pummok AS 상품명 FROM pum1 UNION SELECT num, sangpum FROM pum2; -- 두개의 테이블 자료가 합쳐진 가상의 테이블

-- 서브쿼리 (Subquery) : 쿼리(질의) 내에 쿼리가 있는 형태(일반적으로 안쪽 쿼리 결과를 바깥쪽 쿼리에서 참조)

-- 한송이 직원과 직급이 같은 직원 출력
SELECT jikwonjik FROM jikwon WHERE jikwonname='한송이';
SELECT*FROM jikwon WHERE jikwonjik='부장'; -- 두번이나 그 이상의 SELECT 요청을 효율적으로 한번에 하기위해 서브쿼리를 사용한다
SELECT*FROM jikwon WHERE jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='한송이'); -- 서브쿼리 사용해 한번에 처리 (  ) 로 구분

-- 직급이 대리 중 가장 먼저 입사한 직원은?
SELECT*FROM jikwon WHERE jikwonibsail=(SELECT MIN(jikwonibsail) FROM jikwon WHERE jikwonjik='대리');
SELECT*FROM jikwon WHERE jikwonjik='대리' AND jikwonibsail=(SELECT MIN(jikwonibsail) FROM jikwon WHERE jikwonjik='대리');
-- 서브쿼리에서 주의할 점 내부 쿼리에서 외부 쿼리의 조건문을 써주어도 외부 쿼리의 분별 조건이 되지 못하므로 따로 외부 쿼리의 조건을 확인해야한다

-- 인천에 근무하는 직원을 출력
SELECT*FROM jikwon WHERE busernum!=(SELECT buserno FROM buser WHERE buserloc='인천');

-- 인천 이외 지역에 근무하는 직원 출력
SELECT*FROM jikwon WHERE busernum IN(SELECT buserno FROM buser WHERE NOT buserloc='인천');
-- 서브 쿼리 결과값이 1개 이상일땐 IN으로 받아야한다. 

-- 김혜순 고객과 담당 직원이 같은 고객 자료 출력
SELECT*FROM gogek WHERE gogekdamsano=(SELECT gogekdamsano FROM gogek WHERE gogekname='김혜순');
-- 서브쿼리는 SQL 명령문에 포함된 SELECT 문이다. INSERT UPDATE 등에도 쓰일수 있다. 무조건 괄호안의 서브쿼리를 먼저 수행 
-- 단일행 서브쿼리 비교연산자로 =, <, >, <=, >=, <>를 사용한다.
-- 다중행 서브쿼리 비교연산자로 IN, ANY, ALL, SOME, EXIST를 사용한다.

-- JIKWON, buser, GOGEK 테이블을 사용한다.
-- 
-- 문1) 2010년 이후에 입사한 남자 중 급여를 가장 많이 받는 직원은?
SELECT*FROM jikwon WHERE jikwonibsail>='2010-01-01' AND jikwongen='남' AND jikwonpay=(SELECT MAX(jikwonpay) FROM jikwon WHERE jikwonibsail>'2010-01-01' AND jikwongen='남');
-- 문2)  평균급여보다 급여를 많이 받는 직원은?
SELECT*FROM jikwon WHERE jikwonpay>(SELECT AVG(jikwonpay) FROM jikwon); 
-- 문3) '이미라' 직원의 입사 이후에 입사한 직원은?
SELECT*FROM jikwon WHERE jikwonibsail>=(SELECT jikwonibsail FROM jikwon WHERE jikwonname='이미라');
-- 문4) 2010 ~ 2015년 사이에 입사한 총무부(10),영업부(20),전산부(30) 직원 중 급여가 가장 적은 사람은?
SELECT*FROM jikwon WHERE jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31' AND busernum IN(10,20,30) AND jikwonpay IN(SELECT MIN(jikwonpay) FROM jikwon WHERE busernum IN(10,20,30) AND jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31');
-- 문5) 한송이, 이순신과 직급이 같은 사람은 누구인가?
SELECT*FROM jikwon WHERE jikwonjik IN(SELECT jikwonjik FROM jikwon WHERE jikwonname IN('한송이','이순신'));
-- 문6) 과장 중에서 최대급여, 최소급여를 받는 사람은?
SELECT*FROM jikwon WHERE jikwonjik = '과장' AND jikwonpay IN(SELECT jikwonpay FROM jikwon WHERE jikwonpay=(SELECT MAX(jikwonpay) FROM jikwon WHERE jikwonjik='과장') OR jikwonpay=(SELECT MIN(jikwonpay) FROM jikwon WHERE jikwonjik='과장')); 
-- 문7) 10번 부서의 최소급여보다 많은 사람은?
SELECT*FROM jikwon WHERE jikwonpay<ANY(SELECT jikwonpay FROM jikwon WHERE busernum='10');
-- 문8) 30번 부서의 평균급여보다 급여가 많은 '대리' 는 몇명인가?
SELECT*FROM jikwon WHERE jikwonjik='대리' AND jikwonpay>(SELECT AVG(jikwonpay) FROM jikwon WHERE busernum='30');
-- 문9) 고객을 확보하고 있는 직원들의 이름, 직급, 부서명을 입사일 별로 출력하라.
SELECT DISTINCT jikwonname 직원명, jikwonjik 직급, busername 부서명, jikwonibsail 입사일 
FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno INNER JOIN gogek ON jikwonno=gogekdamsano WHERE jikwonno IN(SELECT gogekdamsano FROM gogek) ORDER BY 입사일;
-- 문10) 이순신과 같은 부서에 근무하는 직원과 해당 직원이 관리하는 고객 출력
SELECT jikwonname 직원명, busername 부서명, busertel 부서전화, jikwonjik 직급, gogekname 고객명, gogektel 고객전화, 
CASE 
WHEN TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW())<=30 THEN '청년'
WHEN TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW())<=50 THEN '중년'
ELSE '노년' END 고객구분 
FROM jikwon INNER JOIN gogek ON jikwonno=gogekdamsano INNER JOIN buser ON busernum=buserno 
WHERE busernum =(SELECT busernum FROM jikwon WHERE jikwonname='이순신');

SELECT TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW()) 고객나이 FROM gogek;

-- DISTINCT = GROUP BY와 중복제거 효과가 비슷한가?

SELECT gogekno,gogekname,gogektel FROM gogek
WHERE gogekdamsano IN(SELECT jikwonno FROM jikwon WHERE busernum=(SELECT buserno FROM buser WHERE busername='총무부'));

-- join 사용
SELECT gogekno, gogekname, gogektel FROM gogek INNER JOIN jikwon ON jikwonno=gogekdamsano INNER JOIN buser ON busernum=buserno WHERE busername='총무부';

-- Null값의 처리를 위해선 LEFT RIGHT OUTER JOIN을 이용해야한다.
--  DISTINCT는 중복값을 간단하게 처리할때만 쓴다.

-- any, all 연산자 : null인 자료는 제외하고 작업한다. 서브쿼리 반환값들의 최소값 최대값의 비교연산자 역할 

-- <ANY : subquery의 반환값 중 최대값보다 작은
-- >ANY : subquery의 반환값 중 최소값보다 큰
-- <ALL : subquery의 반환값 중 최소값보다 작은
-- >ALL : subquery의 반환값 중 최대값보다 큰

-- 직급'대리'의 최대값보다 작은 연봉을 받는 직원
SELECT*FROM jikwon WHERE jikwonpay<ANY(SELECT jikwonpay FROM jikwon WHERE jikwonjik='대리');
-- 30번 부서의 최고 연봉자보다 연봉을 많이 받는 직원
SELECT*FROM jikwon WHERE jikwonpay>ALL(SELECT jikwonpay FROM jikwon WHERE busernum=30);
-- 30번 부서의 최저 연봉자보다 연봉을 많이받는 직원
SELECT*FROM jikwon WHERE jikwonpay>ANY(SELECT jikwonpay FROM jikwon WHERE busernum=30);

-- EXISTS 연산자 : True값을 반환한다.
-- 직원이 있는 부서 출력
SELECT*FROM buser WHERE EXISTS(SELECT*FROM jikwon WHERE busernum=buserno);
-- 직원이 없는 부서 출력
SELECT*FROM buser WHERE NOT EXISTS(SELECT*FROM jikwon WHERE busernum=buserno);

-- 상관 서브쿼리 : 외부 쿼리의 각 행을 내부 쿼리에서 참조하여 수행하는 서브쿼리, 내부 쿼리에 외부 쿼리의 값을 참조시키게 만들어 작동시킨다.
-- 각 부서의 최대 연봉자는?
SELECT*FROM jikwon a WHERE jikwonpay=(SELECT MAX(b.jikwonpay) FROM jikwon b WHERE a.busernum=b.busernum);

-- FROM 절에 서브쿼리 사용
-- 각부서의 최대 연봉자
SELECT a.jikwonno, a.jikwonname, a.jikwonpay, a.busernum FROM jikwon AS a,(SELECT busernum,MAX(jikwonpay) AS maxpay FROM jikwon GROUP BY busernum) b WHERE a.busernum=b.busernum AND a.jikwonpay=b.maxpay;
-- HAVING 중에 서브쿼리 사용
-- 부서별 평균 연봉 중 30번 부서의 평균연봉 보다 큰 부서 출력
SELECT busernum, AVG(jikwonpay) FROM jikwon GROUP BY busernum HAVING AVG(jikwonpay) > (SELECT AVG(jikwonpay) FROM jikwon WHERE busernum=30);
SELECT DISTINCT busernum FROM jikwon INNER JOIN buser on busernum=buserno;
-- 서브 쿼리를 사용해 CREATE 및 INSERT 수행
CREATE TABLE ji1 AS (SELECT*FROM jikwon WHERE 1=0); -- 구조 및 데이터 복사
SHOW TABLES;
DESC ji3;
SELECT*FROM ji1; -- 기본키가 없음
SELECT*FROM jikwon;
CREATE TABLE ji2 AS (SELECT*FROM jikwon WHERE 1=0); -- 구조만 복사 데이터 없음

INSERT INTO ji2 (SELECT*FROM jikwon WHERE jikwonjik='과장'); -- 서브쿼리로 데이터 삽입 수행
CREATE TABLE ji3 AS (SELECT jikwonno,jikwonname,jikwonpay FROM jikwon WHERE 1=0);

-- UPDATE 서브쿼리
SELECT*FROM ji1;
UPDATE ji1 SET jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='이순신') WHERE jikwonno=2;

-- DELETE 서브쿼리
DELETE FROM ji1 WHERE jikwonno IN(SELECT DISTINCT gogekdamsano FROM gogek);

-- 트랜잭션(Transaction) 단위별 데이터 처리
-- 한 사용자에 의해 한개 이상의 SQL 구문(INSERT, DELETE, UPDATE)를 포함하는 가장 작은 논리적인 작업단위다.
-- 트랜잭션은 Commit이나 Rollback에 의해 마스터 DB에 저장 또는 작업 취소를 할 수 있다.
-- 데이터 일관성 보장이 가능해진다. ACID 속성을 지님 원자성,일관성,독립성,지속성
SHOW VARIABLES LIKE 'autocommit%'; -- auto commit 상태 확인
SET autocommit=FALSE; -- autocommit 값 변경
SET autocommit=TRUE;
-- 연습용 테이블
CREATE TABLE jiktab AS (SELECT*FROM jikwon);
SELECT*FROM jiktab;
-- test 1
DELETE FROM jiktab WHERE jikwonjik='사원'; -- 트랜잭션 시작
COMMIT; -- 트랜잭션 종료
ROLLBACK;
SELECT*FROM jiktab;
-- test 2 저장점 사용
SELECT*FROM jiktab WHERE jikwonno IN(7,8);
UPDATE jiktab SET jikwonpay=1111 WHERE jikwonno=8;
SAVEPOINT KBS;
UPDATE jiktab SET jikwonpay=2222 WHERE jikwonno=8;
ROLLBACK TO SAVEPOINT KBS;

-- deadlocks : 두개의 트랜잭션이 서로의 진행을 막고 충돌하는 상황
-- 해결책은 트랜잭션 발생 후 반드시 COMMIT 또는 ROLLBACK 으로 트랜잭션 종료를 해야한다.
SELECT*FROM ji1;
UPDATE ji1 SET jikwonpay=1111 WHERE jikwonno =10;
COMMIT; -- 하나의 트랜잭션은 무조건 끝나야한다.

-- view 파일 : 물리적인 테이블을 근거로 SELECT 문의 조건을 파일로 작성한 후 가상의 테이블로 사용한다. 물리적 공간을 만들지 않아 메모리를 절약할 수 있다.
-- 복잡하고 긴 쿼리문을 단순화, 보안 강화, 동일한 데이터 로부터 다양한 가상 테이블을 얻을 수 있다. 자료 독립성 보장
-- 형식 CREATE 또는 REPLACE VIEW 뷰파일명 AS SELECT 구문
-- ALTER VIEW로 수정하거나 REPLACE로 뷰 덮어쓰기가 가능하다.
-- DROP VIEW 뷰파일명

SHOW TABLES;
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon WHERE jikwonjik='사원'; -- SELECT로 불러온 가상 테이블
CREATE VIEW ex1 AS SELECT jikwonno, jikwonname, jikwonpay FROM jikwon WHERE jikwonjik='사원'; -- SELECT의 조건을 저장해 두는 가상의 테이블로서 저장된다
SHOW FULL TABLES IN mydb WHERE table_type LIKE 'view'; -- 뷰 목록 확인 명령
DROP VIEW ex6;
SELECT SUM(jikwonpay) FROM ex1;
DESC ex1;
-- 가상의 테이블을 이용해 SELECT 수행
CREATE VIEW ex2 AS SELECT*FROM jikwon WHERE jikwonname LIKE '김%' OR jikwonname LIKE '박%';
SELECT*FROM ex1;
SELECT*FROM ex2; 
ALTER TABLE jikwon RENAME kbs; -- 테이블의 이름 변경
-- 뷰는 조건문을 그대로 저장해두므로 테이블의 이름이 변경되면 사용이 불가능해진다 또는 컬럼명의 변경도 마찬가지다

CREATE VIEW ex3 AS SELECT*FROM jikwon ORDER BY jikwonpay DESC;
SELECT*FROM ex3;
CREATE VIEW ex4 AS SELECT jikwonno, jikwonname, jikwonpay*10000 AS ypay FROM jikwon;
SELECT*FROM ex4;
CREATE VIEW ex5 AS SELECT jikwonno, jikwonname, ypay FROM ex4 WHERE ypay>=50000000;
SELECT*FROM ex5; -- view로 view 작성 가능 (별명 사용 주의)
UPDATE ex5 SET jikwonname='공기밥' WHERE jikwonname='홍길동';
SELECT*FROM jikwon; -- view 파일 데이터 수정은 원본 테이블 데이터까지 정보가 수정됨 다른 모든 view 파일에도 영향을 준다
UPDATE ex5 SET ypay=0 WHERE jikwonname='공기밥'; -- 뷰에서 계산에 의해 만든 가상 컬럼은 수정 자체가 불가능하다.
UPDATE ex5 SET jikwonname='홍길동' WHERE ypay=99000000;
DELETE FROM ex5 WHERE jikwonno=28; -- view 파일로 데이터를 삭제하면 원본 테이블 데이터도 삭제된다
DELETE FROM ex5 WHERE ypay=59000000; -- 계산에 의해 만든 가상 컬럼은WHERE의 조건으로는 쓸수 있다.

CREATE VIEW ex6 AS SELECT jikwonno, jikwonname, busernum, jikwonpay FROM jikwon WHERE busernum=10;
SELECT*FROM ex6;
INSERT INTO ex6 VALUES(50,'한사람',10,8888);
INSERT INTO ex6 VALUES(51,'두사람',10,7777);
INSERT INTO ex6 VALUES(52,'세사람',20,6666);
INSERT INTO ex6(jikwonno, jikwonname, busernum) VALUES(53,'네사람',10);
INSERT INTO ex6(jikwonno, busernum) VALUES(54,10);  -- 원본 테이블의 데이터 입력 규칙을 따른다(NULL 허용 여부, 데이터 형식) 
DESC jikwon;

-- GROUP BY view
CREATE OR REPLACE VIEW ex7 AS SELECT jikwonjik, SUM(jikwonpay) AS hap, AVG(jikwonpay) AS ave FROM jikwon GROUP BY jikwonjik;
SELECT*FROM ex7;
DELETE FROM ex7 WHERE jikwonjik'과장';
UPDATE ex7 SET jikwonjik='회장' WHERE jikwonjik='과장'; -- GROUP BY 에 의한 view는 참조만 가능 수정과 삭제가 불가능하다.
SELECT*FROM jikwon WHERE jikwonjik='과장';
UPDATE jikwon SET jikwonpay=0 WHERE jikwonno=3;
-- 계산에 의해 작성된 컬럼은 원본자료가 변경되면 값이 변경된다. 

-- join view
CREATE OR REPLACE VIEW ex8 AS SELECT jikwonno,jikwonname,busername,jikwonpay FROM jikwon INNER JOIN buser ON busernum=buserno
WHERE busernum IN(10,20);
SELECT*FROM ex8;
UPDATE ex8 SET jikwonname='장비' WHERE jikwonno=1;
UPDATE ex8 SET jikwonname='유비',jikwonpay=1111 WHERE jikwonno=2;
UPDATE ex8 SET jikwonname='관우',busername='축구부' WHERE jikwonno=3; -- join view는 두 테이블 동시 수정은 불가능하다.
DELETE FROM ex8 WHERE jikwonno=2; -- join view 에선 삭제가 불가능



-- 문1) 사번   이름    부서  직급  근무년수  고객확보
--         1   홍길동  영업부 사원     6           O   or  X
-- 조건 : 직급이 없으면 임시직, 전산부 자료는 제외

CREATE VIEW v_exam1 AS SELECT DISTINCT jikwonno 사번, jikwonname 이름, busername 부서,nvl(jikwonjik,'임시직') 직급,
TIMESTAMPDIFF(YEAR,SUBSTR(jikwonibsail,1),NOW()) AS 근무년수, 
CASE WHEN EXISTS(SELECT*FROM gogek WHERE jikwonno=gogekdamsano) THEN 'O' ELSE 'X' END AS 고객확보
FROM jikwon INNER JOIN buser ON busernum=buserno LEFT OUTER JOIN gogek ON jikwonno=gogekdamsano 
WHERE busername<>'전산부' OR busername IS NULL;

SELECT*FROM v_exam1;

-- 문2) 부서명   인원수
--        영업부     7

-- 조건 : 직원수가 가장 많은 부서 출력
CREATE VIEW v_exam2 AS SELECT b.busername AS 부서명,COUNT(a.jikwonno) AS 인원수 
FROM jikwon a INNER JOIN buser b ON a.busernum=b.buserno 
GROUP BY b.busername HAVING 인원수+1>ALL(SELECT COUNT(c.jikwonno) FROM jikwon c INNER JOIN buser d ON c.busernum=d.buserno GROUP BY d.busername);
CREATE TABLE customers (cno INT PRIMARY KEY,cname CHAR(10), caddress VARCHAR(50), cemail CHAR(20), cphone VARCHAR(20));
SELECT*FROM v_exam3;
-- 문3) 가장 많은 직원이 입사한 요일에 입사한 직원 출력
CREATE VIEW v_exam3 AS SELECT jikwonname 직원명,DAYNAME(jikwonibsail) 요일, busername 부서명, busertel 부서전화 
FROM jikwon LEFT OUTER JOIN buser ON busernum=buserno
WHERE DAYNAME(jikwonibsail)=(SELECT DAYNAME(jikwonibsail) FROM jikwon ORDER BY COUNT(DAYNAME(jikwonibsail)));
DROP VIEW v_exam3;
SELECT DAYNAME(jikwonibsail) FROM jikwon ORDER BY COUNT(DAYNAME(jikwonibsail));
--     직원명   요일     부서명   부서전화
--     한국인  수요일   전산부   222-2222 
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon WHERE jikwonpay>=5000 AND jikwonpay<=7000;
-- 계정 사용자 생성 삭제 및 권한, 보안
-- create user '사용자이름'@'접속위치' identified by '비밀번호'';
-- grant all privileges on DB이름.* to '사용자이름'@'접속위치';
-- flush privileges; -- 권한 설정 새로고침
CREATE VIEW vtest AS SELECT jikwonpay FROM jikwon WHERE jikwonpay>(SELECT AVG(jikwonpay) FROM jikwon);
SELECT USER,HOST,PASSWORD FROM mysql.user; -- 사용자 목록 조회
SHOW GRANTS FOR 'root'@'%'; -- root 사용자 권한을 확인
-- GRANT ALL PRIVILEGES ON *.* -- 모든 데이터 베이스의 권한을 준다
-- TO `root`@`%` IDENTIFIED VIA mysql_native_password USING '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257' OR gssapi USING 'SID:BA' WITH GRANT OPTION
-- 데이터베이스 사용 권한을 testuser 계정 만들어 권한주기 연습
CREATE USER 'testuser'@'%' IDENTIFIED BY '1234'; -- 프롬프트로 확인시 데이터베이스 권한이 없다
GRANT ALL PRIVILEGES ON mydb.* TO 'testuser'@'%'; -- testuser에 mydb 관련 모든 권한 부여 
FLUSH PRIVILEGES; -- 권한 변경사항을 적용하기 위한 새로고침
SHOW GRANTS FOR 'testuser'@'%';
REVOKE ALL ON mydb .* FROM 'testuser'@'%'; -- testuser 로부터 mydb 사용관련 모든 권한 해제
-- testuser 계정에게 mydb의 gogek, 한 테이블의 SELECT,UPDATE 권한을 부여 
GRANT SELECT,UPDATE ON mydb.gogek TO 'testuser'@'%';
REVOKE UPDATE ON mydb.gogek FROM 'testuser'@'%'; -- UPDATE 권한 해제
-- 계정의 비밀번호를 바꾸려면
SET PASSWORD FOR 'testuser'@'%'=PASSWORD('123456');
-- 사용자 계정 삭제
DROP USER 'testuser'@'%';

-- 저장 프로시저 (Stored Procedure)
-- 일련의 쿼리를 마치 하나의 함수처럼 실행하기 위한 쿼리들의 집합
-- SQL에 절차적인 프로그래밍 기법을 추가
-- 기본 구조는 BEGIN ~ EXCEPTION ~ END 로 이루어진 

-- 저장 프로시저 생성
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp1(a INT, b INT)
BEGIN 
DECLARE x, y INT DEFAULT 0; -- 변수 선언, 대소문자 구분없음
SET x=10; -- 변수에 값을 저장(대입)
SELECT x,y;
SELECT a+b;
END;
$$ DELIMITER ;

CALL sp1(2, 3); -- 저장 프로시저에 값을 주고 저장 프로시저를 실행
SHOW PROCEDURE STATUS;  -- 프로시저 목록 확인
SHOW CREATE PROCEDURE sp1; -- 프로시저 내용 확인
DROP PROCEDURE sp1; -- 프로시저 제거

DELIMITER $$
CREATE OR REPLACE PROCEDURE sp2()
BEGIN
SELECT*FROM jikwon WHERE jikwonno<=3;
SELECT*FROM buser;
END;
$$ DELIMITER ;

CALL sp2;

DELIMITER $$
CREATE OR REPLACE PROCEDURE sp3(para1 INT, para2 INT)
BEGIN
SELECT*FROM jikwon WHERE jikwonno=para1;
SELECT*FROM jikwon WHERE jikwonno=para2;
END;
$$ DELIMITER ;

CALL sp3(2, 16);

-- if 조건 판단문
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp4(IN jik VARCHAR(20), num INT)
BEGIN
SELECT*FROM jikwon WHERE jikwonjik=jik;
IF(num=10) THEN SELECT*FROM jikwon WHERE busernum=10;
ELSEIF (num=20) THEN SELECT*FROM jikwon WHERE busernum=20;
ELSE SELECT*FROM jikwon WHERE busernum=num; END IF;
END;
$$ DELIMITER ;

DROP PROCEDURE sp5;

CALL sp4('대리', 20);
CALL sp4('부장', 30);

-- while 반복문
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp5()
BEGIN
DECLARE num INT;
DECLARE ss VARCHAR(255);
SET num=1;
SET ss='';
WHILE num<=5 DO 
SET ss = CONCAT(ss,num,',');
SET num = num+1;
END WHILE;
SELECT ss;
END;
$$ DELIMITER ;

CALL sp5;

-- repeat 반복문
DELIMITER $$
CREATE PROCEDURE sp6()
BEGIN
DECLARE a INT;
DECLARE str VARCHAR(255);
SET a=1;
SET str='';
REPEAT
SET str=CONCAT(str,a,',');
SET a=a+1;
UNTIL a>5
END REPEAT;
SELECT str;
END
$$ DELIMITER ;

CALL sp6;

-- if 문을 이용한 gogek table 처리
-- 고객번호를 입력하면 해당 고객 정보 조회
-- 담당 직원번호를 입력하면 해당 직원이 관리하는 고객목록 조회
-- 둘 다 입력하지 않으면 모든 고객 정보 조회

DELIMITER $$
CREATE PROCEDURE sp7_gogek(IN p_gogekno INT, IN p_damsano INT)
BEGIN
IF p_gogekno IS NOT NULL THEN
	SELECT*FROM gogek WHERE gogekno=p_gogekno;
ELSEIF p_damsano IS NOT NULL THEN
	SELECT*FROM gogek WHERE gogekdamsano=p_damsano;
ELSE
	SELECT*FROM gogek;
END IF;
END 
$$ DELIMITER ;

CALL sp7_gogek(6,NULL);

-- while 문을 사용한 gogek table 처리
-- 입력 startno 부터 endno 까지 고객자료 출력
DELIMITER $$
CREATE PROCEDURE sp8_gogek(IN startno INT, IN endno INT)
BEGIN
WHILE startno<=endno DO
	SELECT*FROM gogek WHERE gogekno=startno;
	SET startno=startno+1;
END WHILE;
END
$$ DELIMITER ;

CALL sp8_gogek(2, 4);

-- 사용자 정의 함수 만들기
-- 프로시저는 리턴값이 없지만 사용자 정의 함수는 리턴값이 있다
-- BMI 구하기 공식 = 몸무게(kg)에 키(cm)의 제곱으로 나눈 값
-- 22를 표준 체중이라 가정하고 표준체중 = 키*키*22/10000 공식을 사용해본다
-- 키를 입력할때 적절한 몸무게를 반환함
DELIMITER $$
CREATE FUNCTION fu1(height INT) RETURNS DOUBLE
BEGIN
RETURN height*height*22/10000;
END
$$ DELIMITER ;

SELECT sp8_BMI(166);

-- 직원 전체의 연봉 평균 반환함수
DELIMITER $$ 
CREATE FUNCTION fu2() RETURNS DOUBLE
BEGIN
DECLARE result DOUBLE;
SELECT AVG(jikwonpay) INTO result FROM jikwon;
RETURN result;
END
$$ DELIMITER ;

SELECT fu2();

-- 각 직원의 연봉의 10% 반환 함수
DELIMITER $$
CREATE FUNCTION fu3(no INT) RETURNS INT
BEGIN
DECLARE pay INT;
SELECT jikwonpay*0.1 INTO pay FROM jikwon WHERE jikwonno= no;
RETURN pay;
END
$$ DELIMITER ;

SELECT fu3(8);

SELECT jikwonno,jikwonname,jikwonpay,fu3(jikwonno) 세금 FROM jikwon WHERE jikwonpay IS NOT NULL;

--  각 직원의 부서명 반호나 함수 작성
DELIMITER $$
CREATE FUNCTION fu4(no INT) RETURNS VARCHAR(10)
BEGIN
DECLARE buname VARCHAR(10);
SELECT busername INTO buname FROM buser WHERE buserno=(SELECT busernum FROM jikwon WHERE jikwonno=no);
RETURN buname;
END
$$ DELIMITER ;

SELECT jikwonno, jikwonname, fu4(jikwonno) FROM jikwon WHERE busernum IS NOT NULL;

-- 부서번호로 부서명 반환 함수
DELIMITER $$
CREATE FUNCTION fu5(num INT) RETURNS VARCHAR(10)
BEGIN
DECLARE buname VARCHAR(10);
SELECT busername INTO buname FROM buser WHERE buserno=num;
RETURN buname;
END
$$ DELIMITER ;

SELECT jikwonno, jikwonname, fu5(busernum) FROM jikwon WHERE busernum IS NOT NULL;

-- 문1) jikwon 테이블에 대해 부서번호가 있으면 부서명을 없으면 '임시직'을 반환하는 함수 작성
DELIMITER $$
CREATE FUNCTION bufu1(num INT) RETURNS VARCHAR(10)
BEGIN
DECLARE buname VARCHAR(10);
IF num IS NOT NULL THEN SELECT busername INTO buname FROM buser WHERE buserno=num;
ELSE SET buname='임시직';
END IF;
RETURN buname;
END
$$ DELIMITER ;

SELECT jikwonno, jikwonname, bufu1(busernum) FROM jikwon;
DELETE FROM buser WHERE buserno = 30;
DELIMITER $$
CREATE FUNCTION bufu2(num INT) RETURNS INT
BEGIN
DECLARE age INT;
SELECT TIMESTAMPDIFF(YEAR,STR_TO_DATE(SUBSTR(gogekjumin,1,6),'%y %m %d'),NOW()) INTO age FROM gogek WHERE gogekno=num;
RETURN age;
END


$$ DELIMITER ;

SELECT gogekno,gogekname AS 이름 FROM gogek;

SELECT AVG(jikwonpay) || '원' FROM jikwon;

SELECT jikwonno, jikwonname, jikwonjik, jikwongen FROM jikwon WHERE busernum=(SELECT buserno FROM buser INNER JOIN jikwon ON buserno=busernum WHERE jikwonname="홍길동");

SELECT jikwonno, jikwonname, jikwonjik, jikwongen, (SELECT AVG(jikwonpay) FROM jikwon WHERE jikwongen="여" AND busernum=a.busernum) AS 여직원평균, (SELECT AVG(jikwonpay) FROM jikwon WHERE jikwongen="남" AND busernum=a.busernum) AS 남직원평균 FROM jikwon a WHERE busernum=(SELECT buserno FROM buser WHERE busername="총무부");

SELECT * FROM jikwon AS 직원 WHERE busernum=(SELECT buserno FROM buser AS 부서 WHERE 부서.buserno=직원.busernum);

select jikwonno, jikwonname,jikwonjik,SUBSTR(jikwonibsail,1,4) AS jikwonibsail,jikwongen from jikwon

SELECT busernum,jikwonjik,SUM(jikwonpay) FROM jikwon GROUP BY GROUPING((busernum, jikwonjik));
}