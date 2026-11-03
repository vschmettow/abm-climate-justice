#model 01. model 00 plus a wealth gap. group A starts with k times the wealth of group B.
#k = 1 gives model 00 back. mean wealth stays at r0 whatever k is.

rm(list=ls())
set.seed(100)

nd=14
T=100
r0=10          #mean start wealth
k=4            #wealth ratio A to B. 1 = equal
rB=2*r0/(1+k)  #start wealth B
rA=k*rB        #start wealth A
c=0.1          #cost of restraining
alpha=0.05     #emission per emitter per year
D0=267         #excess CO2 today
dg=2e-6        #damage dg*D^2

N=nd*nd
group=array(0,dim=c(nd,nd))
resource=array(0,dim=c(nd,nd))
strat=array(1,dim=c(nd,nd))   #1 = emit, everyone starts emitting
grid=array(0,dim=c(nd,nd))
payoff=array(0,dim=c(nd,nd))
alive=array(1,dim=c(nd,nd))

#two groups, 50/50, random places. 0 = group A, 1 = group B
tmp=sample(c(rep(0,N/2),rep(1,N/2)))
n=0
for(i in 1:nd){ for(j in 1:nd){
  n=n+1; group[i,j]=tmp[n]
  if(group[i,j]==0) resource[i,j]=rA else resource[i,j]=rB
}}
D=D0

DH=numeric(T); AH=numeric(T); BH=numeric(T); RH=numeric(T); WA=numeric(T); WB=numeric(T)

for(t in 1:T){

  #1 act. 1 = emit, 0 = restrain
  for(i in 1:nd){ for(j in 1:nd){
    if(alive[i,j]==0){ grid[i,j]=0; next }
    grid[i,j]=strat[i,j]
    if(resource[i,j]<c) grid[i,j]=1
  }}

  #2 commons. emissions go in, nothing comes out
  nem=sum(alive==1 & grid==1)
  D=D+alpha*nem

  #3 pay
  for(i in 1:nd){ for(j in 1:nd){
    if(alive[i,j]==0){ payoff[i,j]=0; next }
    if(grid[i,j]==1) payoff[i,j]=-dg*D*D else payoff[i,j]=-c-dg*D*D
    resource[i,j]=resource[i,j]+payoff[i,j]
    if(resource[i,j]<=0){ alive[i,j]=0; resource[i,j]=0; grid[i,j]=0 }
  }}

  #4 copy the best of self and 4 neighbours
  newstrat=strat
  for(i in 1:nd){ for(j in 1:nd){
    if(alive[i,j]==0) next
    if(i-1==0) am=nd else am=i-1
    if(i+1>nd) ap=1 else ap=i+1
    if(j-1==0) bm=nd else bm=j-1
    if(j+1>nd) bp=1 else bp=j+1
    best=payoff[i,j]; bests=strat[i,j]
    for(nb in list(c(ap,j),c(am,j),c(i,bp),c(i,bm))){
      x=nb[1]; y=nb[2]
      if(alive[x,y]==0) next
      if(payoff[x,y]>best){ best=payoff[x,y]; bests=grid[x,y] }
    }
    newstrat[i,j]=bests
  }}
  strat=newstrat

  DH[t]=D
  AH[t]=mean(alive[group==0]); BH[t]=mean(alive[group==1])
  RH[t]=if(sum(alive)>0) 1-mean(grid[alive==1]) else NA
  WA[t]=mean(resource[group==0]); WB[t]=mean(resource[group==1])
}

par(mfrow=c(2,2))
image(group,col=c("red","blue"),axes=FALSE,main="grid. red = A, blue = B")
plot(DH,type="l",xlab="year",ylab="D",main="commons")
plot(AH,type="l",col="red",ylim=c(0,1),xlab="year",ylab="share active",main="groups")
lines(BH,col="blue")
plot(WA,type="l",col="red",ylim=c(0,max(WA)),xlab="year",ylab="mean wealth",main="wealth")
lines(WB,col="blue")

cat("A out:",if(any(AH==0)) min(which(AH==0)) else NA,"  B out:",if(any(BH==0)) min(which(BH==0)) else NA,"\n")
