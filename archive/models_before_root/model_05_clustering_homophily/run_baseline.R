#E0 baseline for model 05. runs the model 10 times with different seeds, no mechanism.
#writes baseline.csv (one row per seed) and baseline.png (four panels, all seeds overlaid).
#same model as model_05.R, without the live window. keep the two in step.

rm(list=ls())

seeds=100:109
nd=14; T=100
rA=40; rB=10; pA=0.2
h=0; w=1
c=0.1
alpha=0.05; s0=0.045; Dhalf=200; D0=267
dg=2e-6
pinit=0.5; prand=0.01
N=nd*nd
D_crit=sqrt(c/dg)

#histories, one column per seed
DH=matrix(0,T,length(seeds)); AH=DH; BH=DH; RH=DH; WA=DH; WB=DH
out=data.frame(seed=seeds,B_out=NA,A_out=NA,util=NA,maximin=NA,gap=NA,Dmax=NA,Dend=NA)

for(si in 1:length(seeds)){
  set.seed(seeds[si])

  group=array(0,dim=c(nd,nd)); resource=array(0,dim=c(nd,nd))
  strat=array(0,dim=c(nd,nd)); grid=array(0,dim=c(nd,nd))
  payoff=array(0,dim=c(nd,nd)); alive=array(1,dim=c(nd,nd)); cumwb=array(0,dim=c(nd,nd))

  nA=round(pA*N)
  tmp=c(rep(0,nA),rep(1,N-nA))
  nsw=round((1-h)*N)
  if(nsw>1){ idx=sample(1:N,nsw); tmp[idx]=sample(tmp[idx]) }
  k=0
  for(i in 1:nd){ for(j in 1:nd){
    k=k+1; group[i,j]=tmp[k]
    if(group[i,j]==0) resource[i,j]=rA else resource[i,j]=rB
    if(runif(1,0,1)<pinit) strat[i,j]=1.0 else strat[i,j]=0.0
  }}
  D=D0

  for(t in 1:T){
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==0){ grid[i,j]=0; next }
      grid[i,j]=strat[i,j]
      if(runif(1,0,1)<prand) grid[i,j]=0
      if(resource[i,j]<c) grid[i,j]=1
    }}
    nem=sum(alive==1 & grid==1)
    D=D+alpha*nem-s0*D/(1+D/Dhalf); if(D<0) D=0
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==0){ payoff[i,j]=0; next }
      if(grid[i,j]==1) payoff[i,j]=-dg*D*D else payoff[i,j]=-c-dg*D*D
    }}
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==1) resource[i,j]=resource[i,j]+payoff[i,j]
      if(resource[i,j]<=0){ alive[i,j]=0; resource[i,j]=0; grid[i,j]=0 }
    }}
    cumwb=cumwb+resource
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
        if(group[x,y]==group[i,j]) eff=payoff[x,y] else eff=payoff[i,j]+w*(payoff[x,y]-payoff[i,j])
        if(eff>best){ best=eff; bests=grid[x,y] }
      }
      newstrat[i,j]=bests
    }}
    strat=newstrat

    DH[t,si]=D
    AH[t,si]=mean(alive[group==0]); BH[t,si]=mean(alive[group==1])
    RH[t,si]=if(sum(alive)>0) 1-mean(grid[alive==1]) else NA
    WA[t,si]=mean(resource[group==0]); WB[t,si]=mean(resource[group==1])
  }

  wb=cumwb/T
  out$B_out[si]=if(any(BH[,si]==0)) min(which(BH[,si]==0)) else NA
  out$A_out[si]=if(any(AH[,si]==0)) min(which(AH[,si]==0)) else NA
  out$util[si]=mean(wb); out$maximin[si]=mean(wb[group==1]); out$gap[si]=mean(wb[group==0])-mean(wb[group==1])
  out$Dmax[si]=max(DH[,si]); out$Dend[si]=D
}

write.csv(out,"baseline.csv",row.names=FALSE)
print(out)
print(colMeans(out[,-1],na.rm=TRUE))

png("baseline.png",width=1600,height=1100,res=150)
par(mfrow=c(2,2),mar=c(4,4,2,1))
matplot(DH/D_crit,type="l",lty=1,col="grey40",xlab="year",ylab="D / D_crit",main="commons")
abline(h=1,lty=2); abline(h=Dhalf/D_crit,lty=3,col="steelblue")
legend("topright",c("D_crit","D_half"),lty=c(2,3),col=c("black","steelblue"),bty="n")
matplot(AH,type="l",lty=1,col="gold",ylim=c(0,1),xlab="year",ylab="",main="share still active")
matlines(BH,lty=1,col="grey40")
legend("bottomleft",c("rich","poor"),col=c("gold","grey40"),lty=1,bty="n")
matplot(WA,type="l",lty=1,col="gold",ylim=c(0,max(WA)),xlab="year",ylab="",main="mean wealth")
matlines(WB,lty=1,col="grey40")
matplot(RH,type="l",lty=1,col="grey40",ylim=c(0,1),xlab="year",ylab="",main="share restraining")
dev.off()
