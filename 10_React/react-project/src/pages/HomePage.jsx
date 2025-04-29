import React from 'react'
import styled from 'styled-components'
import { Link } from 'react-router-dom'
import { Container } from '../components/styled/common'


const Ttitle = styled.h1`
    color: black;
    margin-bottom: 24px;
`

const Button = styled(Link)`
    display: inline-block;
    background: #6c6cff;
    color: white;
    padding: 12px 24px;
    border-radius: 4px;
    text-decoration: none;
    margin: 12px;

    &:hover{
        opacity: 0.9;
        color: white;
    }
`

const HomePage = () => {
    return (
        <Container>
            <Ttitle>게시판 관리</Ttitle>
            <Button to="/posts">게시글 목록</Button>
            <Button to="/posts/new">게시글 작성</Button>
        </Container>
    )
}

export default HomePage