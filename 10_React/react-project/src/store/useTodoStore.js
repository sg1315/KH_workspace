import React from 'react'
import { create } from 'zustand'

const useTodoStore = create((set, get) => ({
    todos: [{
        id: 1,
        text: "밥먹기",
        completed: false,
    },{
        id: 2,
        text: "잠자기",
        completed: false,
    },{
        id: 3,
        text: "숨쉬기",
        completed: false,
    }],
    
    toggleTodo: (id) => set(state => ({
        todos: state.todos.map((todo) => 
            todo.id === id ? {...todo, completed: !todo.completed} : todo
        )
    })),

    deleteTodo: (id) => set(state => ({
        todos: state.todos.filter(todo => todo.id !== id)
    })),
}))

export default useTodoStore