import axios from "axios";


// axios.get("https://jsonplaceholder.typicode.com/posts/2")
//     .then(response => {
//         console.log("받은 데이터:", response.data); // 바로 data!
//     })
//     .catch(error => {
//         console.error("에러 발생:", error);
//     });

async function getPost() {
    try{
        const response = await axios.get("https://jsonplaceholder.typicode.com/posts/2");
            console.log("받은 데이터:", response.data);
    }catch(error){
            console.error("에러 발생:", error);
    }
}

// getPost();

async function addPost(){
    //axios.post(요청할url,전달할 데이터)
    const response = await axios.post("https://jsonplaceholder.typicode.com/posts", {
        title: 'foo',
        body: 'bar',
        userId: 1,
    });
    // console.log("받은 데이터:", response);
    console.log("받은 데이터:", response.data);
}

addPost();