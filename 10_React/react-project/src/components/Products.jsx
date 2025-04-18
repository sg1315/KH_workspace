import React from 'react'
import styled from 'styled-components'

const productItems = [{
    product_name: "삼성 TV",
    price: 10000,
    color: "블랙"
},{
    product_name: "엘지 냉장고",
    price: 30000,
    color: "베이지"
},{
    product_name: "애플 노트북",
    price: 50000,
    color: "그레이"
}]

const STable = styled.table`
    border: black solid 2px;
    border-collapse: collapse;
`

const STh = styled.th`
    background-color: #808080;
    color: white;
    padding: 12px;
    border: #555555;
`

const STd = styled.td`
    padding: 12px;
    border: #c7cdff solid 2px;
`

const STr = styled.tr`
    &:hover{
        background-color: #c7cdff;
    }
`

const Products = () => {
    return (
        <div>
            <STable>
                <thead>
                <tr>
                    <STh>제품명</STh>
                    <STh>가격</STh>
                    <STh>색상</STh>
                </tr>
                </thead>
                <tbody>
                    {productItems.map((p) => 
                        <STr key={p.product_name}>
                            <STd>{p.product_name}</STd>
                            <STd>{p.price}</STd>
                            <STd>{p.color}</STd>
                        </STr>
                    )}
                </tbody>
                
            </STable>
        </div>
    )
}

export default Products