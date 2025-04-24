import React, { useState } from 'react'
import UseToggle from './UseToggle';

const ToggleBox = () => {
    const [isView, toggleIsView] = UseToggle();

    return (
        <div>
            <button onClick={toggleIsView}>
                {isView ? "숨기기" : "보이기"}
            </button>
            {isView && <div>숨겨진 영역입니다!</div>}
        </div>
    )
}

export default ToggleBox