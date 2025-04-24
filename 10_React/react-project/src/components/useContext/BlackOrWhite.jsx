import React, { useState } from 'react'
import MainContent from './MainContent';
import { ThemeContext } from 'styled-components';

const BlackorWhite = () => {
    const [theme, setTheme] = useState("white");

    const toggleTheme = () => {
        setTheme(theme === "white" ? "black" : "white");
    }

    return (
        <ThemeContext.Provider value={{theme, toggleTheme}}>
            <MainContent
                theme = {theme}
                toggleTheme = {toggleTheme}
            />
        </ThemeContext.Provider>
    )
}

export default BlackorWhite