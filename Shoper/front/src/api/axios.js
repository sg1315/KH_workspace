import axios from 'axios';
import { API_CONFIG } from './config';

const api = axios.create({
  baseURL: API_CONFIG.BASE_URL,
  timeout: API_CONFIG.TIMEOUT,
  headers: API_CONFIG.HEADERS,
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      //서버가 응답을 함
      const { status, data } = error.response;
      switch (status) {
        case 401:
          //인증에러
          window.location.href = '/login';
          break;
        case 403:
          console.error('접근권한이 없습니다.');
          break;
        case 404:
          console.error('요청한 리소스를 찾을 수 없습니다.');
          break;
        case 500:
          console.error('서버 에러 발생');
          break;
        default:
          console.error('API 에러 :', data);
      }
    } else if (error.request) {
      //요청은 했지만 응답을 받지 못함
      console.error('네트워크 에러 : ', error.request);
    } else {
      console.error('에러 :', error.message);
    }

    return Promise.reject(error);
  }
);

export default api;
