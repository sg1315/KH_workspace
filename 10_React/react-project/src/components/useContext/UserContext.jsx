import React, { createContext, useContext } from 'react'

const UserContext = createContext();

export function UserProvider({children}){
    const user = {
        name: "둘리",
        age: 42,
        role: "관리자",
    }

    return (
        <UserContext.Provider value={user}>
            {children}
        </UserContext.Provider>
    )
}

export function useUser(){
    return  useContext(UserContext);
}