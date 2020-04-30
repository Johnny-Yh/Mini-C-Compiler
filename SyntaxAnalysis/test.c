int gcd(int u,int v)
{
    if (v==0) return u;
    else return gcd(v,u-u/v*v);
    /*it's a comment*/
}
int main(void){
    int x;
    int y;
    x=1;  
    y=1;
    gcd(x,y);
}