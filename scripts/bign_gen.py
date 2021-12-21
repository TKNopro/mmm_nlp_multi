import random
import math
import uuid

def random_hex(length):
    result = hex(random.randint(0,16**length)).replace('0x','').upper()
    if(len(result)<length):
        result = '0'*(length-len(result))+result
    return result

def random_hex_gen(width,num):
    for i in range(num):
        res = str(uuid.uuid4())
        res = res.replace('-', '')
        print(res[:128])

def mod_inv(a,m):
    if math.gcd(a,m)!=1:
        return None
    u1,u2,u3 = 1,0,a
    v1,v2,v3 = 0,1,m
    while v3!=0:
        q = u3//v3
        v1,v2,v3,u1,u2,u3 = (u1-q*v1),(u2-q*v2),(u3-q*v3),v1,v2,v3
    return u1%m

def MP(x,y,r,m):
    return x*y*mod_inv(r,m)%m

def cal():

    k=256
    len=64
    m=0xfffffffffffffffffffffffffffffffffffffffffffffffffffeff2defffffff
    r=2**(k+3)

    mid_res=mod_inv(r,m)
    m_=(-1*(mod_inv(m,r)))%r
    r_m_=r + m_

    a=random_hex(len)
    b=random_hex(len)
    xxx=int(a,16)
    xx=hex(xxx)

    yyy=int(b,16)
    yy=hex(yyy)

    if(xxx < 2*m):
        x=xx
    else:
        x=0xaae430952304952324ffaedee341312341234123434313ff13414532431abd23
#
    if(yyy < 2*m):
        y=yy
    else:
        y=0xabbcdd2310942391749321432910faa890a8a0d098adad89a09d9aaaaaaa8d7d
#
    res=MP(xxx,yyy,r,m)

    print('\n-------------------------------------------------------------')
    print('X :\n\t',xx)
    print('\n-------------------------------------------------------------')
    print('Y :\n\t',yy)    
    print('\n-------------------------------------------------------------')
    print('Algo : xx*yy*r^(-1) mod m:\n\t0x{:x}'.format(res))
    print('\n-------------------------------------------------------------')
    print('r-m^(-1) mod r:\n\t0x{:x}'.format(r_m_))
    print('\n-------------------------------------------------------------')
    print('mod_inv(r,m):\n\t0x{:x}'.format(mid_res))

    print(hex(int(xx,16)))

    file_x_mem=open('x.mem','a')
    file_x_mem.write(xx.replace("0x","")+'\n')
    file_y_mem=open('y.mem','a')
    file_y_mem.write(yy.replace("0x","")+'\n')
    file_m_mem=open('m.mem','a')
    file_m_mem.write(hex(m).replace("0x","")+'\n')
    file_m_b_mem=open('m_b.mem','a')
    file_m_b_mem.write(hex(r_m_).replace("0x","")+'\n')
    file_mod_inv_mem=open('mod_inv.mem','a')
    file_mod_inv_mem.write(hex(mid_res).replace("0x","")+'\n')


def main():
    n=10

    for i in range(n):
        cal()

if __name__=='__main__':
    main()
