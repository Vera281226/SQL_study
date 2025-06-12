# MariaDB 학습 기록

MariaDB, SQL을 활용한 DBMS 종합 학습 포트폴리오

MariaDB의 데이터베이스 설계, 조작, 고급 쿼리 작성 및 관리 전반을 체계적으로 학습하여 실무에서 효율적으로 데이터베이스를 운용할 수 있는 역량을 갖추었습니다.

데이터베이스 기초
DDL 명령어(CREATE, DROP, ALTER)를 활용해 데이터베이스와 테이블을 생성, 삭제, 수정하는 방법을 익힘

테이블 설계 시 PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE 등 다양한 제약조건을 설정하여 데이터 무결성을 확보

다양한 데이터 타입의 특성을 이해하고, AUTO_INCREMENT를 통해 기본키 자동 생성을 구현

데이터 조작 및 조회
INSERT, SELECT, UPDATE, DELETE 명령어로 기본적인 데이터 입력, 조회, 수정, 삭제 작업 수행

WHERE, LIKE, BETWEEN, IN 등 조건 연산자를 활용해 원하는 데이터만 선별적으로 조회

ORDER BY, GROUP BY, HAVING을 사용해 데이터 정렬 및 그룹화, 집계 함수(SUM, AVG, COUNT, MAX, MIN)로 통계 데이터 생성

고급 쿼리 기법
INNER JOIN, LEFT/RIGHT OUTER JOIN, CROSS JOIN, SELF JOIN 등 다양한 조인 방식으로 다중 테이블 데이터 통합

단일행/다중행 서브쿼리, EXISTS, ANY, ALL 등 고급 서브쿼리 활용

문자열, 숫자, 날짜, 변환 함수 등 MariaDB 내장 함수 사용

CASE WHEN, NULL 처리 함수 등 조건부 표현식 적용

데이터베이스 관리
CREATE VIEW로 뷰 생성 및 데이터 보안 관리

트랜잭션(COMMIT, ROLLBACK, SAVEPOINT)과 ACID 속성 이해 및 적용

사용자 계정 생성과 권한(GRANT, REVOKE) 관리로 데이터 접근 통제

매개변수, 조건문, 반복문을 활용한 저장 프로시저 작성

기술적 성과
정규화 원칙을 적용해 효율적인 테이블 구조 설계

인덱스 설계 및 쿼리 최적화로 성능 향상

다중 테이블 조인, 서브쿼리, 집계 함수로 복합 데이터 분석

윈도우 함수(RANK, DENSE_RANK)로 순위 처리

뷰와 권한 관리로 데이터 보안 강화

트랜잭션 관리로 데이터 일관성 유지

저장 프로시저로 네트워크 트래픽 최소화

실무 적용 역량
집계 함수와 그룹화로 통계 데이터 분석

조건부 표현식과 날짜 함수로 데이터 분류 및 시계열 처리

다중 테이블 관계 설정, 조인, 서브쿼리로 복잡한 로직 구현

UNION과 트랜잭션을 통한 안전한 데이터 이관
