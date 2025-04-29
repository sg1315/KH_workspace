const serverData = [{
    id:1,
    name: "aa"
},{
    id:2,
    name: "bb"
},
{
    id:3,
    name: "cc"
}]

//기존콜백방식
function getUser(data, successCallback, errorCallback){
    //일반함수내에서 비동기작업 실행
    setTimeout(() => {
        //완료후 callback을 통한 데이터 전달
        const user = serverData.filter(u => u.id === data.id);
        if(user.length > 0) successCallback(user);
        else errorCallback("user를 찾을 수 없습니다.");

    }, 3000)
}

getUser({id: 1}, () =>{
    console.log(user);
}, (erroMsg) => {
    console.log(erroMsg);
})
