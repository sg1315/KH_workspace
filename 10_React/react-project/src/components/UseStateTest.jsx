import React, {useState} from 'react'

/* 
    state : 커포넌트의 상태값
    userState : 컴포넌트의 상태를 생성하고 관리할 수 있게 해주는 react hook
    -> 컴포넌트는 state값이 변경되면 이를 확인하고 요소를 리렌더링 해준다.

    [사용법]
    const [변수명, set변수명] = useState(초기값);
*/

const UseStateTest = () => {
    return (
        <div>UseStateTest</div>
    )
}

export default UseStateTest