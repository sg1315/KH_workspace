//반복문과 반복메서드 정리

//1. 기본 for문
//가장 일반적인 반복 방식
for(let i=0; i<3; i++){
    console.log("for문 i : ", i); //0~2까지
}

//2. while문
//조건이 참일 동안 반복
let j =0;
while(j < 3){
    console.log("while문 j : ", j); //0~2까지
    j++;
}

//3. do while문
//조건과 상관없이 한번은 부조건 실행된다.
j =0;
do{
    console.log("do while문 j : ", j); //0~2까지
    j++;
} while(j<3);

//4. for ... of 문
// - 배열, 문자열등을 순회
let fruits = ["사과", "배", "바나나"];
for(const fruit of fruits){
    console.log("array for ... of : ", fruit);
}

//5. for ... in 문
// - 객체의 key를 순회
fruits = {
    "사과" : 3000,
    "바나나" : 5000,
    "메론" : 6000,
}
for(const key in fruits){
    console.log(`for ... in : ${key} -> ${fruits[key]}`);
}

//6. forEach
// - 배열 순회 전용 메서드
fruits = ["사과", "배", "바나나"];
fruits.forEach((obj, index) => {
    console.log(`forEach index : ${index} -> ${obj}`);
})

const numbers = [1, 3, 5, 7, 9];
//7. map()
// - 기존 배열을 가지고 새로운 배열을 만들고 싶을 때 -> 변형한 새로운 배열을 반환
const squared = numbers.map((num) => num * num);
console.log("map의 결과 : ", squared);

//8. filter()
// - 조건에 맞는 요소만 추출하고 싶을 때 -> 조건에 맞는 값만 모아서 새로운 배열을 반환
const squared3 = numbers.filter((num) => num % 3 === 0);
console.log("filter(3의 배수)의 결과 : ", squared3);

//9. find()
// - 조건에 맞는 "첫번째 값"만 반환 -> 검색
const firstSquared3 = numbers.find((num) => num % 3 === 0);
console.log("find의 결과 : ", firstSquared3);

//10. some()
// - 하나라도 조건을 만족하면 true
const hasSquared3 = numbers.some((num) => num % 3 === 0);
console.log("some의 결과 : ", hasSquared3);
const hasSquared2 = numbers.some((num) => num % 2 === 0);
console.log("some의 결과 : ", hasSquared2);

//11. every()
// - 모든 요소가 조건을 만족해야 true
const allSquared3 = numbers.every((num) => num % 3 === 0);
console.log("every의 결과 : ", allSquared3);
const allSquared2 = numbers.every((num) => num % 2 !== 0);
console.log("every의 결과 : ", allSquared2);

//12. reduce()
// - 배열의 값을 누적하여 하나의 결과값을 도출
/*
    배열.reduce((누적값, 배열요소) => 누적값반환, 누적값의 초기값)
*/
const result = numbers.reduce((sum, obj) => {
    console.log(obj + " : " + sum);
    sum.push(obj + 1);
    return sum;
}, []);
console.log("result : ", result);

const scoreList = [
    {name: "aaa", score: 80},
    {name: "bbb", score: 50},
    {name: "ccc", score: 100},
]
console.log(scoreList);

const scoreMap = scoreList.reduce((acc, cur) => {
    acc[cur.name] = cur.score;
    return acc;
}, {})
console.log(scoreMap);