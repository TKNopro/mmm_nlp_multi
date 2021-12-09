# description : calculation of the mmm result
# author : Lee
import math

def MP(x,y,r,m):
    return x*y*mod_inv(r,m)%m
    
def mod_inv(a,m):
    if math.gcd(a,m)!=1:
        return None
    u1,u2,u3 = 1,0,a
    v1,v2,v3 = 0,1,m
    while v3!=0:
        q = u3//v3
        v1,v2,v3,u1,u2,u3 = (u1-q*v1),(u2-q*v2),(u3-q*v3),v1,v2,v3
    return u1%m

def mont_check(xx,yy,r,m,k):
    if xx<2*m and yy<2*m and math.gcd(r,m)==1 and m>1 and m<2**k and r==2**(k+3):
        return True
    else:
        print('x<m y<m gcd(r,m) m>=2^(k-1) m<2^k r==2^k')
        print(xx<m,yy<m,math.gcd(r,m)==1, m>=2**(k-1), m<2**(k+3),r==2**(k+3))
        return False


def main():
    k = 256
    m=0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
    x=0xf913b410fe0d6b547a64ce68e9b7430214e56ec57e37d50dc22be4fe5e5f8d2f
    y=0x0de6501bd55b07ce9c83bbcbba280e5700e53c152304f6a1ab183a7b2e16e308

    r=2**(k+3)
    print('\n-------------------------------------------------------------')
    print('xx*yy*r^(-1) mod m:\n0x{:x}'.format(r))

    m_=(-1*(mod_inv(m,r)))%r
    print('\n-------------------------------------------------------------')
    print('-m^(-1) mod r:\n0x{:x}'.format(m_))

    r_m_=r + m_
    print('\n-------------------------------------------------------------')
    print('r-m^(-1) mod r:\n0x{:x}'.format(r_m_))

    if(m_ == r_m_):
        print('\n-------------------------------------------------------------')
        print('\033[32mthe result is equal!\033[0m')
    else:
        print('\n-------------------------------------------------------------')
        print('\033[32mthe result is not equal!\033[0m')

    mid_res=mod_inv(r,m)
    print('\n-------------------------------------------------------------')
    print('mod_inv(r,m):\n0x{:x}'.format(mid_res))

    if mont_check(x,y,r,m,k)==False:
        return print('\033[32m######\toperation conditions unmatch!\t######\033[0m') 

    res0=MP(x,y,r,m)
    print('\n-------------------------------------------------------------')
    print('xx*yy*r^(-1) mod m:\n0x{:x}'.format(res0))

    res1=x*y*mid_res%m
    print('\n-------------------------------------------------------------')
    print('xx*yy*r^(-1) mod m res1:\n0x{:x}'.format(res1))

if __name__=='__main__':
    main()