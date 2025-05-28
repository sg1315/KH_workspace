import { ThemeProvider } from 'styled-components';
import './App.css';
import theme from './styles/theme';
import GlobalStyle from './styles/GrobalStyle';
import { Routes, BrowserRouter as Router, Route } from 'react-router-dom';
import Home from './pages/Home';
import Layout from './components/Layout';

function App() {
  return (
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Home />} />
          </Routes>
        </Layout>
      </Router>
    </ThemeProvider>
  );
}

export default App;
