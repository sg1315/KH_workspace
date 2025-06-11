import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';
import { SITE_CONFIG } from '../config/site';
import { media } from '../styles/MediaQueries';
import { GiHamburgerMenu } from 'react-icons/gi';
import useUserStore from '../store/userStore';

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const { user, isAuthenticated } = useUserStore();

  return (
    <HeaderContainer>
      <HeaderWrapper>
        <Logo to="/">{SITE_CONFIG.name}</Logo>

        {/* 모바일환경에서의 nav */}
        <MenuButton onClick={() => setIsMenuOpen(!isMenuOpen)} />

        <MobileMenu $isOpen={isMenuOpen}>
          {isAuthenticated && (
            <UserProfile>
              <UserName>{user?.username}님</UserName>
            </UserProfile>
          )}
          <Nav>
            <NavItem to="/">홈</NavItem>
            <NavItem to="/products">상품</NavItem>
            <NavItem to="/question">Q&A 게시판</NavItem>
          </Nav>

          {isAuthenticated ? (
            <UserMenu>
              <NavItem to="/cart">장바구니</NavItem>
              <NavItem to="/orders">주문내역</NavItem>
              <NavItem to="/profile">회원정보</NavItem>
            </UserMenu>
          ) : (
            <UserMenu>
              <NavItem to="/login">로그인</NavItem>
              <NavItem to="/signup">회원가입</NavItem>
            </UserMenu>
          )}
        </MobileMenu>

        {/* pc환경에서의 nav */}
        <DesktopNav>
          <NavItem to="/">홈</NavItem>
          <NavItem to="/products">상품</NavItem>
          <NavItem to="/question">Q&A 게시판</NavItem>
        </DesktopNav>

        <DesktopUserMenu>
          {isAuthenticated ? (
            <>
              <NavItem to="/cart">장바구니</NavItem>
              <NavItem to="/orders">주문내역</NavItem>
              <NavItem to="/profile">{user?.username}님</NavItem>
            </>
          ) : (
            <>
              <NavItem to="/login">로그인</NavItem>
              <NavItem to="/signup">회원가입</NavItem>
            </>
          )}
        </DesktopUserMenu>
      </HeaderWrapper>
    </HeaderContainer>
  );
};

const UserProfile = styled.div`
  display: flex;
  align-items: center;
  padding: ${({ theme }) => theme.spacing[4]};
`;

const UserName = styled.span`
  font-weight: ${({ theme }) => theme.fontWeights.bold};
  color: ${({ theme }) => theme.colors.gray[800]};
`;

const HeaderContainer = styled.header`
  background: ${({ theme }) => theme.colors.white};
  box-shadow: ${({ theme }) => theme.shadows.sm};
  position: sticky;
  top: 0;
  z-index: ${({ theme }) => theme.zIndices.sticky};
`;

const HeaderWrapper = styled.div`
  padding: ${({ theme }) => theme.spacing[4]};
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const Logo = styled(Link)`
  font-size: ${({ theme }) => theme.fontSizes.xl};
  font-weight: ${({ theme }) => theme.fontWeights.bold};
  color: ${({ theme }) => theme.colors.primary};

  ${media.md`
   font-size: ${({ theme }) => theme.fontSizes['2xl']}; 
  `}
`;

const DesktopNav = styled.nav`
  display: none;
  gap: ${({ theme }) => theme.spacing[8]};

  ${media.md`
        display: flex;
    `}
`;

const DesktopUserMenu = styled.nav`
  display: none;
  gap: ${({ theme }) => theme.spacing[8]};

  ${media.md`
        display: flex;
    `}
`;

const NavItem = styled(Link)`
  font-size: ${({ theme }) => theme.fontSizes.base};
  font-weight: ${({ theme }) => theme.fontWeights.medium};
  color: ${({ theme }) => theme.colors.gray[700]};

  &:hover {
    color: ${({ theme }) => theme.colors.primary};
  }
`;

const MenuButton = styled(GiHamburgerMenu)`
  width: 30px;
  height: 30px;
  cursor: pointer;
  z-index: 10;

  ${media.md`
        display: none;
    `}
`;

const MobileMenu = styled.div`
  display: flex;
  flex-direction: column;
  gap: ${({ theme }) => theme.spacing[4]};
  position: fixed;
  top: 0;
  right: 0;
  width: 100%;
  max-width: 400px;
  height: 100vh;
  background: ${({ theme }) => theme.colors.white};
  transform: translateX(${({ $isOpen }) => ($isOpen ? '0' : '100%')});
  transition: transform 0.3s ease;
  padding: ${({ theme }) => theme.spacing[4]};
  padding-top: ${({ theme }) => theme.spacing[16]};
  z-index: 5;
  overflow-y: auto;

  ${media.md`
        display: none;
    `}
`;

const Nav = styled.nav`
  display: flex;
  flex-direction: column;
  gap: ${({ theme }) => theme.spacing[4]};
`;

const UserMenu = styled.div`
  display: flex;
  flex-direction: column;
  gap: ${({ theme }) => theme.spacing[4]};
  border-top: 1px solid ${({ theme }) => theme.colors.gray[200]};
  padding-top: ${({ theme }) => theme.spacing[8]};
`;

export default Header;
