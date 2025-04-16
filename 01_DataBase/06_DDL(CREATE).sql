/*
    *데이터 정의어
    오라클에서 제공하는 객체를 새로 만들고(CREATE), 구조를 변경하고(ALTER), 구조자체를 삭제(DELETE)하는 언어
    즉, 실제 데이터값이 아닌 규칙 자체를 정의하는 언어
    
    오라클에서 객체(구조) : 테이블, 뷰, 시퀀스
                            인덱스, 패키지, 트리거,
                            프로시저, 함수, 동의어, 사용자
    
    <CREATE>
    객체를 새로 생성하는 구문
*/

/*
    1. 테이블 생성
    - 테이블이란 : 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
                  모든 데이터들은 테이블을 통해 저장된다.
                  (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
    
    [표현식]
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형
        ...
    )    
    
    *자료형
    -숫자(NUMBER)
    -문자(CHAR(바이트크기) | VARCHAR2(바이트크기)) -> 반드시 크기를 지정해 줘야 함
         - CHAR : 최대 2000바이트까지 지정가능 / 고정길이(고정된 글자수의 데이터가 담길 경우)
         - VARCHAR : 최대 4000바이트까지 지정가능 / 가변길이(몇글자의 데이터가 들어올지 모르는 경우)
    -날짜(DATE)
*/
--회원에 대한 데이터를 담기위한 테이블 MEMBER 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),--user01, alwaysjone
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

SELECT * FROM MEMBER;
--------------------------------------------------------------------
/*
    2. 컬럼에 주석달기(컬럼에대한 간단한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남/여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

--테이블을 삭제하고자 할 때 : DROP TABLE 테이블명;
DROP TABLE MEMBER;

--INSERT INTO 테이블명 VALUES(값,값,값...);
INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

SELECT * FROM MEMBER;

INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', NULL, NULL, '010-1111-2222', NULL, NULL);

----------------------------------------------------------------------------
/*
    <제약조건>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다.
    
    종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/*
    *NOT NULL
    해당 컬럼에 반드시 값이 존재해야만 하는 경우(즉, 절대 NULL이 들어오면 안되는 경우)
    삽입/수정시 NULL값을 허용하지 않도록 제한
    
    제약조건을 부여하는 방식은 크게 2가지가 있다.(컬럼레벨방식, 테이블레벨방식)
    NOT NULL제약조건은 무조건 컬럼레벨방식만 가능하다.
*/

CREATE TABLE MEMBER(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,--user01, alwaysjone
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

SELECT * FROM MEMBER;

INSERT INTO MEMBER
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL, NULL);

INSERT INTO MEMBER
VALUES(3, NULL, 'PASS3', '홍길삼', NULL, NULL, NULL, NULL);

INSERT INTO MEMBER
VALUES(3, 'USER2', 'PASS3', '홍길삼', NULL, NULL, NULL, NULL);
--아이디가 중복되었음에도 불구하고 잘 추가가된다.

------------------------------------------------------------------
/*
    *UNIQUE 제약조건
    해당 컬럼에 중복값이 들어가서는 안될 경우 사용한다.
    컬럼값에 중복값을 제한하는 제약조건이다.
    삽입/수정시 기존에 있는 데이터값 중 중복값이 있을 경우 오류를 발생시킨다.
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    UNIQUE(EMAIL) -- 테이블레벨방식
);

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

SELECT *
FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER1', 'PASS2', '홍길동', '여', '010-1111-3333', 'BBB@NAVER.COM', '24/12/23');
--UNIQUE제약조건에 위배되었으므로 INNSERT 실패
--> 오류구분을 제약조건명으로 알려준다.
--> 쉽게 어떤 제약조건이 위반인지 알기 어렵다.
--> 제약조건 부여시 제약조건명을 지정할 수 있다.(지정하지 않으면 시스템에서 자동으로 부여함)

-----------------------------------------------------------------------------------
/*
    *제약조건 부여시 제약조건명까지 부여하는 방법
    > 컬럼레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건
    )
    
    >테이블레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        CONSTRAINT 제약조건명 제약조건(컬럼명)
    )
*/

DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER CONSTRAINT MEMNO_NT NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NT NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NT NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NT NOT NULL,
    GENDER CHAR(3), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID) -- 테이블레벨방식
);

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL, NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(4, 'USER3', 'PASS4', '홍길사', NULL, NULL, NULL, NULL);


---------------------------------------------------------------------------
/*
    *CHECK(조건식)
    해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해줄 수 있다.
    해당조건에 만족하는 데이터값만 담길 수 있음.
*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    UNIQUE(MEM_ID)
--    CHECK(GENDER IN ('남', '여'))-- 테이블레벨방식
);
INSERT INTO MEM_CHECK
VALUES(1, 'USER1', 'PASS1', '홍길동', NULL, '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', '홍길순', '자', '010-1111-3333', 'BBB@NAVER.COM', '24/12/23');
--CHECK 제약조건 때문에 예외가 발생한다.
--GENDER컬럼에는 CHECK제약조건을 만족하는 값을 넣어야한다.
--단, NULL은 값이 없다는 뜻이기 때문에 가능하다.

INSERT INTO MEM_CHECK
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', '010-1111-3333', 'BBB@NAVER.COM', '24/12/23');

-----------------------------------------------------------------------------
/*
    PRIMARY KEY(기본키) 제약조건
    테이블에서 각 행(R0W)를 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
    
    EX) 회원번호, 학번, 군번, 부서코드, 직급코드, 주민등록번호, 택배운송장번호, 예약번호...
    PRIMARY KEY -> NOT NULL + UNIQUE
    
    한테이블당 오직 한개만 설정 가능
*/

CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_PRI
VALUES(1, 'USER1', 'PASS1', '홍길동', NULL, '010-1111-2222', 'AAA@NAVER.COM', '24/12/23');

INSERT INTO MEM_PRI
VALUES(1, 'USER2', 'PASS2', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');
--기본키에 중복값을 담으려고할 때(UNIQUE제약조건 위반)

INSERT INTO MEM_PRI
VALUES(NULL, 'USER2', 'PASS2', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');
--기본키에 NULL을 담으려고할 때(NOT NULL제약조건 위배)

INSERT INTO MEM_PRI
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');

CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);
--복합키 : 두개의 컬럼을 동시에 하나의 PRIMARI KEY로 지정하는 것

INSERT INTO MEM_PRI2
VALUES(1, 'USER1', 'PASS1', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');
INSERT INTO MEM_PRI2
VALUES(2, 'USER2', 'PASS2', '홍길동', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');
INSERT INTO MEM_PRI2
VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');
INSERT INTO MEM_PRI2
VALUES(4, 'USER4', 'PASS4', '홍길사', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23');

--복합키 사용 예(어떤 회원이 어떤 상품을 찜했는지에 대한 데이터를 보관하는 테이블)
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(20),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

-- 회원4명(1,2,3,4번)
-- 상품2개(자전거A, 자전거B)

INSERT INTO TB_LIKE VALUES(1, '자전거A', SYSDATE); --홍길순이 자전거A 좋아요 누름
INSERT INTO TB_LIKE VALUES(1, '자전거B', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, '자전거A', SYSDATE);
INSERT INTO TB_LIKE VALUES(2, '자전거A', SYSDATE);


-------------------------------------------------------------------------------
--회원 등급에 대한 데이터를 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');
INSERT INTO MEM_GRADE VALUES(40, 'VIP회원');

SELECT * FROM MEM_GRADE;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    GRADE_ID NUMBER
);

INSERT INTO MEM
VALUES(1, 'USER1', 'PASS1', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', NULL);

INSERT INTO MEM
VALUES(2, 'USER2', 'PASS2', '홍길동', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 10);

INSERT INTO MEM
VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 30);

INSERT INTO MEM
VALUES(4, 'USER4', 'PASS4', '홍길사', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 20);

--유효하지않은 회원등급번호가 정상적으로 INSERT된다.
INSERT INTO MEM
VALUES(5, 'USER5', 'PASS5', '홍길오', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 50);
/*
    FOREIGN_KEY(외래키) 제약조건
    다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
    -> 다른 테이블을 참조한다고 표현
    -> 주로 FORIGN KEY 제약조건으로 인해 테이블간 관계가 형성된다.
    
    >컬럼레벨방식
    컬럼명 자료형 REFERENCES 참조할 테이블명[참조할 컬럼명]
    
    >테이블레벨방식
    FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명[참조할 컬럼명]
    
    -> 참조할 컬럼명 생략시 참조할 테이블의 PRIMARY KEY로 지정된 컬럼이 매칭된다.
*/

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)
);

INSERT INTO MEM
VALUES(1, 'USER1', 'PASS1', '홍길순', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', NULL);

INSERT INTO MEM
VALUES(2, 'USER2', 'PASS2', '홍길동', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 10);

INSERT INTO MEM
VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 30);

INSERT INTO MEM
VALUES(4, 'USER4', 'PASS4', '홍길사', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 20);

--유효하지않은 회원등급번호가 정상적으로 INSERT된다.
INSERT INTO MEM
VALUES(5, 'USER5', 'PASS5', '홍길오', NULL, '010-1111-3333', 'AAA@NAVER.COM', '24/12/23', 50);
-- PARENT KEY를 찾을 수 없다는 오류가 발생

SELECT * FROM MEM;
-- MEM_GRADE(부모테이블) -|--------<-MEM(자식테이블)
-- 1:N관계 1쪽이 부모테이블 N이 자식테이블

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--MEM테이블에서 10이라는 값을 사용하고 있기 때문에 삭제가 안됨.

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 40;
--MEM테이블에서 40이라는 값을 사용하고있지 않기 때문에 삭제가 된다.

--자식테이블에서 이미 사용하고 있는 값이 있을 경우
--부모테이블로부터 무조건 삭제가 안되는 "삭제제한"옵션이 걸려있다.

--------------------------------------------------------------------------------------
/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    *삭제옵션 : 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 할것인가?
    
    -ON DELETE RESTRICTED(기본값) : 삭제제한옵션, 자식데이터로부터 쓰이는 부모데이터는 삭제가 안됨!
    -ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 사용하고 있는 자식데이터의 값을 NULL로변경
    -ON DELETE CASCADE : 부모데이터 삭제시 해당 데이터를 사용하고있는 자식데이터도 모두 삭제.
*/


DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'USER1', 'PASS1', '홍길순', NULL, NULL, NULL, NULL, NULL);
INSERT INTO MEM VALUES(2, 'USER2', 'PASS2', '홍길동', NULL, NULL, NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL,NULL, NULL, NULL, 30);
INSERT INTO MEM VALUES(4, 'USER4', 'PASS4', '홍길사', NULL, NULL, NULL, NULL, 20);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 20;

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,--컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --남, 여
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO MEM VALUES(1, 'USER1', 'PASS1', '홍길순', NULL, NULL, NULL, NULL, NULL);
INSERT INTO MEM VALUES(2, 'USER2', 'PASS2', '홍길동', NULL, NULL, NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER3', 'PASS3', '홍길삼', NULL,NULL, NULL, NULL, 30);
INSERT INTO MEM VALUES(4, 'USER4', 'PASS4', '홍길사', NULL, NULL, NULL, NULL, 20);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;

----------------------------------------------------------------
/*
    <DEFAULT 기본값> *제약조건은 아니다.
    컬럼을 선정하지않고 INSERT시에 NULL아닌 기본값을 INSERT하고자한다.
    미리 값을 세팅해 둘 수 있다.
    
    컬럼값 자료형 DEFAULT 기본값
*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    ENROLL_DATE DATE DEFAULT SYSDATE
);

--INSERT INTO 테이블명 VALUES(값1, 값2,...)
INSERT INTO MEMBER VALUES(1, '빵빵이', 20, '운동', '20/01/01');
INSERT INTO MEMBER VALUES(2, '옥지', 20, NULL, NULL);
INSERT INTO MEMBER VALUES(3, '최지원', 19, DEFAULT, DEFAULT);

--INSERT INTO 테이블명(컬럼1,컬럼2,...) VALUES(값1, 값2...)
INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES(4, '최지투');
--> 선택되지 않은 컬럼에는 기본적으로 NULL이 적용됨
-->단, 해당 컬럼에 DEFAULT값이 부여되어 있을 경우 NULL이 아닌 DEFAULT값이 들어감


-----------------------------------------------------------------------------------
--관리자계정으로 생성
CREATE USER C##KH IDENTIFIED BY KH;

GRANT CONNECT, RESOURCE TO C##KH;

ALTER USER C##KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--KH계정으로 전환
-------------------------------------------------------------------------
--테이블을 복제할 수 있다. 여기서부터 KH계정 이용
CREATE TABLE EMPLOYEE_COPY
AS (SELECT * FROM EMPLOYEE);

DROP TABLE EMPLOYEE_COPY;

--테이블 구조만 복사
CREATE TABLE EMPLOYEE_COPY
AS (SELECT * FROM EMPLOYEE WHERE 1=0);

--------------------------------------------------------------
/*
    테이블이 다 생성된 후에 제약조건을 추가하는 방법
    ALTER TABLE 테이블명 변경할 내용

    -PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMAR KEY(컬럼명);
    -FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명(컬럼명);
    -UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    -CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한 조건식);
    -NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL; 
*/

--EMPLOYEE_COPY테이블에 PRIMAR KEY 제약조건 추가(EMP_ID)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

--EMPLOYEE테이블에 DEPT_CODE에 외래키 제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

--EMPLOYEE테이블에 JOB_CODE에 외래키 제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

--DEPARTMENT테이블에 LOCATION_ID에 외래키 제약조건 추가
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;



