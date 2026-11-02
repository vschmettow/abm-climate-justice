#E1 for model 05. one mechanism end to end: carbon tax, emitters pay theta, revenue destroyed.
#fixes the protocol for the other 15: theta range, seed count, output columns, figure.
#writes E1_carbontax.csv (one row per theta and seed) and E1_carbontax.png.
#same model as model_05.R and run_baseline.R, without the live window. keep them in step.

rm(list=ls())

thetas=seq(0,0.30,by=0.02)
seeds=100:109
#replicate test: set thetas=0.12 and seeds=100:149, compare means at 10, 20, 50

nd=14; T=100
rA=40; rB=10; pA=0.2
h=0; w=1
c=0.1
alpha=0.05; s0=0.045; Dhalf=200; D0=267
dg=2e-6
pinit=0.5; prand=0.01
N=nd*nd
D_crit=sqrt(c/dg)

out=data.frame()

for(theta in thetas){
for(seed in seeds){
  set.seed(seed)

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
  Dmax=D; restsum=0; actAh=numeric(T); actBh=numeric(T); paid=0

  for(t in 1:T){
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==0){ grid[i,j]=0; next }
      grid[i,j]=strat[i,j]
      if(runif(1,0,1)<prand) grid[i,j]=0
      if(resource[i,j]<c) grid[i,j]=1
    }}
    nem=sum(alive==1 & grid==1)
    D=D+alpha*nem-s0*D/(1+D/Dhalf); if(D<0) D=0
    if(D>Dmax) Dmax=D

    #step 3: pay. restrainers pay c. everyone loses dg*D^2
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==0){ payoff[i,j]=0; next }
      if(grid[i,j]==1) payoff[i,j]=-dg*D*D else payoff[i,j]=-c-dg*D*D
    }}

    #step 4: mechanism. carbon tax: emitters pay theta, revenue destroyed
    for(i in 1:nd){ for(j in 1:nd){
      if(alive[i,j]==1 && grid[i,j]==1){ payoff[i,j]=payoff[i,j]-theta; paid=paid+theta }
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

    actAh[t]=mean(alive[group==0]); actBh[t]=mean(alive[group==1])
    restsum=restsum+(if(sum(alive)>0) 1-mean(grid[alive==1]) else 0)
  }

  wb=cumwb/T
  out=rbind(out,data.frame(mech="carbontax",theta=theta,seed=seed,
    B_out=if(any(actBh==0)) min(which(actBh==0)) else NA,
    A_out=if(any(actAh==0)) min(which(actAh==0)) else NA,
    util=mean(wb), maximin=mean(wb[group==1]), gap=mean(wb[group==0])-mean(wb[group==1]),
    restraint=restsum/T, Dmax=Dmax, Dend=D, transfer=paid))
  cat("theta",theta,"seed",seed,"B out",out$B_out[nrow(out)],"restraint",round(restsum/T,2),"\n")
}}

write.csv(out,"E1_carbontax.csv",row.names=FALSE)

#means per theta
agg=aggregate(out[,c("util","maximin","gap","restraint","Dmax")],by=list(theta=out$theta),FUN=mean)
print(agg)

#baseline is theta = 0
base=agg[agg$theta==0,]

png("E1_carbontax.png",width=1600,height=1100,res=150)
par(mfrow=c(2,2),mar=c(4,4,2,1))
plot(agg$theta,agg$util,type="b",pch=16,xlab="theta",ylab="",main="utilitarian: mean well-being"); abline(h=base$util,lty=2)
plot(agg$theta,agg$maximin,type="b",pch=16,xlab="theta",ylab="",main="maximin: poor group mean"); abline(h=base$maximin,lty=2)
plot(agg$theta,agg$gap,type="b",pch=16,xlab="theta",ylab="",main="egalitarian: gap rich minus poor"); abline(h=base$gap,lty=2)
plot(agg$theta,agg$restraint,type="b",pch=16,ylim=c(0,1),xlab="theta",ylab="",main="mean share restraining")
dev.off()
