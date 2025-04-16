/*
    <트리거>
    내가 지정한 테이블에 INSERT, UPDATE, DELETE등 DML문에 의한 변경사항이 생길 때
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있다.
    
    EX)
    회원탈퇴시 기존의 회원테이블에 데이터 DELETE한 후 곧바로 탈퇴한 회원들만 따로 보관하는 테이블에
    자동으로 INSERT시켜야한다.
    신고횟수가 일정 수를 넘었을 때 묵시적으로 해당 회원을 블랙리스트로 처리하게끔.
    입출고에 대한 데이터 기록(INSERT)될때마다 해당 상품에대한 재고수량을 매번 수정(UPDATE)해야한다.
    
    *트리거의 종류
    -SQL문의 실행시기에 따른 분류
    -BEFORE TRIGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
    -AFTER TRIGER : 내가 지정한 테이블에 이벤트가 발생된 후에 트리거 실행
    
    -SQL문에 의해 영향을 받는 각 행에 따른 분류
    -문장트리거 : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
    -행트리거 : 해당 SQL문 실행할 때마다 매번 트리거 실행
               (FOR EACH ROW옵션 기술)
        > :OLD - BEFORE UPDARE(수정전 자료), BEFORE DELETE(삭제전 자료)
        > :NEW - AFTER INSERT(추가된 자료), AFTER UPDATE(수정후 자료)
        
    *트리거 생성 구문
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER         INSERT | UPDATE | DELETE     ON 테이블명
    [FOR EACH ROW]
    [DECLARE 변수선언]
    BEGIN
        실행할내용
    [EXCEPTION 예외처리]
    END;
    /
*/
--EMPLOYEE테이블에 새로운 행이 INSERT될 때마다 자동으로 출력되는 트리거 정의

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 안녕하세요.');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '김지원', '111111-2222222', 'D7', 'J7', SYSDATE);

-------------------------------------------------------------------------------------
DROP TABLE TB_PRODUCT;
DROP TABLE TB_PRODETAIL;

--상품 입고및 출고 관련해서 트리거를 사용해보자
--필요한 테이블, 시퀀스 생성

--1. 상품에대한 데이터를 보관할 테이블(TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, --상품번호
    PNAME VARCHAR2(30) NOT NULL, --상품명
    BRAND VARCHAR2(30) NOT NULL, --브랜드
    PRICE NUMBER,          -- 가격
    STOCK NUMBER DEFAULT 0 -- 재고
);

CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5;

INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시s25', '삼성', 1500000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰16', '애플', 1400000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤오미', 800000, 20);

COMMIT;

--2. 상품 입출고 상세 이력 테이블 생성(TB_PRODETAIL)
--어떤 상품이 어떤 날짜에 몇개가 입고 또는 출고가 되는지 데이터를 기록
CREATE TABLE TB_PRODETAIL(
    DECODE NUMBER PRIMARY KEY, --이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품번호
    PDATE DATE NOT NULL, --입출고 날짜
    AMOUNT NUMBER NOT NULL, --입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고','출고'))
);

CREATE SEQUENCE SEQ_DECODE;

--200번 상품이 오늘날짜로 10개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 10, '입고');

--200번 상품의 재고수량을 10증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

--205번 상품이 오늘날짜로 20개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 205, SYSDATE, 20, '입고');

--205번 상품의 재고수량을 20증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 205;

--TB_PRODETAIL테이블에 INSERT이벤트 발생시
--TB_PRODUCT테이블에 매번 자동으로 재고수량을 UPDATE하게 트리거 생성

/*
    --상품이 입고 -> 해당상품찾아서 재고수량 증가 UPDATE
       UPDATE TB_PRODUCT
        SET STOCK = STOCK + 입고된수량(INSERT된 자료의 AMOUNT)
        WHERE PCODE = 입고된상품번호(INSERT된 자료의 PCODE); 
        
    --상품이 출고 -> 해당상품찾아서 재고수량 감사 UPDATE
        UPDATE TB_PRODUCT
        SET STOCK = STOCK - 입고된수량(INSERT된 자료의 AMOUNT)
        WHERE PCODE = 입고된상품번호(INSERT된 자료의 PCODE); 
*/
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    IF(:NEW.STATUS = '입고')
        THEN UPDATE TB_PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    ELSE
            UPDATE TB_PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

--210번 상품이 오늘날짜로 7개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 210, SYSDATE, 7, '입고');

--205번 상품이 오늘날짜로 5개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 205, SYSDATE, 5, '출고');





















