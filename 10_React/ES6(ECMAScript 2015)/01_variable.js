//var -> 더이상 사용하지 않는다.

console.log(tmp); //호이스팅 : 문서내의 모든 변수를 위로 끌어올려 선언하는 것
var tmp = "여기서 시작";

//let vs const : 변수와 상수
//호이스팅의 문데를 TDZ를 통해서 해결
//Temporal Dad Zone -> 일시적 사각지대
//let과 const는 호이스팅이 되지만 선언되는 코드 실행 전까지는 TDZ에 등록해서 사용할 수 없게 관리

//변수명 규칙
//1. 변수명에는 $, _외의 특수문자는 안됨
//2. 숫자로 시작할 수 없음
//3. 예약어 사용 안됨
//ex) let const = 1;

//올바른 변수명 예
let $price = 10000;
let userName = "gg"; //일반적으로 카멜케이스 사용
let _status = true;

//let : 변수(값 재할당 가능)
let name = "aa";
console.log("처음 name : ", name);

name = "bb"
console.log("변경된 name : ", name);

//const : 상수(값 재할당 불가능)
const nickName = "cc";
console.log("const nickName : ", nickName);

try{
    nickName = "dd";
} catch(error){
    console.log("오류 발생 : ", error.message);
}

//const는 왜 사용할까?
// - 변경되면 안되는 값을 실수로 변경하는 것을 막기 위해서
// - 변하지 않아야 하는 값을 명확하게 표현하기 위해서