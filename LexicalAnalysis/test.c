int gcd(int u,int v)
{
    if (v==0) return u;
    else return gcd(v,u-u/v*v);
    /*it's a comment*/
}
void main(){
    int aaaaaa;
    aaaaaa=15;
    int x,int y;
    x=input();
    y=input();
    output(gcd(x,y));
}