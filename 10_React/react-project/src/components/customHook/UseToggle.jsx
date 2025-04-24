import React, { useCallback, useState } from 'react'

const UseToggle = (init = false) => {
    const [value, setValue] = useState(init);

    const toggle = useCallback(() => {
        setValue(prev => !prev);
    },[]);
    
    return [value, toggle];
}

export default UseToggle