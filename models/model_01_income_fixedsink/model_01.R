#Model 01: income and fixed sink (was commons_v2.R, 16 Sept 2026)

#two groups A and B on a grid. one parameter differs: resources.
#agents extract or restrain. extracting earns more. every extractor adds to D.
#everyone loses dg*D. same absolute amount, so it hurts the poor more.
#at zero resources you are out. permanently.
#each round agents copy the best paid of their four neighbours.
#mechanisms plug in at step 5 and change payoff only. nothing else.

#make sure R is clear of old variables
rm(list=ls())

#use set.seed to fix random number generator
set.seed(100)

#set grid size and number of rounds
nd=14
T=1000

#set starting resources for each group, and the share of cells that are group A
rA=20
rB=10
pA=0.5

#set income. share=b0*h2/(r+h2), so the rich earn a thinner slice. restraining earns a*share*r
b0=0.034
h2=50
a=0.4

#below this you cannot restrain
C=8

#set commons. each extractor adds alpha. nature removes alpha*sigma*N.
#restrainers above sigma*N remove beta each
alpha=0.05
beta=0.01
sigma=0.5

#set damage. each agent loses dg*D
dg=0.001

#share extracting at t=0, and chance per round to restrain regardless
pinit=0.5
prand=0.01

#mechanism. none, flat_fee or wealth_levy. theta is the rate
mech="none"
theta=0

#draw while running. every n rounds
live=TRUE
every=10

#---------------------------------------------------------------
#set grids
#---------------------------------------------------------------

group=array(0,dim=c(nd,nd))     #0 = A, 1 = B
resource=array(0,dim=c(nd,nd))
grid=array(0,dim=c(nd,nd))      #1 = extract, 0 = restrain
income=array(0,dim=c(nd,nd))
payoff=array(0,dim=c(nd,nd))
alive=array(1,dim=c(nd,nd))
cumwb=array(0,dim=c(nd,nd))     #sum of resources held, for well-being
pay=array(0,dim=c(nd,nd))
get=array(0,dim=c(nd,nd))

N=nd*nd
Dh=numeric(T); actAh=numeric(T); actBh=numeric(T)
restAh=numeric(T); restBh=numeric(T)

#---------------------------------------------------------------
#initialize. groups fixed 50/50 and shuffled. resources from group. strategy random
#---------------------------------------------------------------

nA=round(pA*N)
tmp=sample(c(rep(0,nA),rep(1,N-nA)))
k=0
for(i in 1:nd){
  for(j in 1:nd){
    k=k+1
    group[i,j]=tmp[k]
    if(group[i,j]==0) resource[i,j]=rA else resource[i,j]=rB
    if(runif(1,0,1)<pinit) grid[i,j]=1.0 else grid[i,j]=0.0
  }
}

#D where damage equals mean income. reporting line only
D_crit=mean(b0*h2/(resource+h2)*resource)/dg
D=0.0

#---------------------------------------------------------------
#plot. grid, restraint, active, D/D_crit
#---------------------------------------------------------------

if(live) try(quartz(width=10,height=7),silent=TRUE)
draw=function(t){
  par(mfrow=c(2,2),mar=c(3,3,2,1))
  g=alive*(grid+1)   #0 out, 1 restrain, 2 extract
  image(1:nd,1:nd,t(g[nd:1,]),col=c("black","steelblue","red"),zlim=c(0,2),
        main=paste("round",t,"  D/D_crit",round(D/D_crit,2)),xlab="",ylab="",axes=FALSE)
  plot(1:t,restAh[1:t],type="l",lwd=2,col="gold",xlim=c(1,T),ylim=c(0,1),main="restraint",xlab="",ylab="")
  lines(1:t,restBh[1:t],lwd=2,col="grey40")
  plot(1:t,actAh[1:t],type="l",lwd=2,col="gold",xlim=c(1,T),ylim=c(0,1),main="active",xlab="",ylab="")
  lines(1:t,actBh[1:t],lwd=2,col="grey40")
  plot(1:t,Dh[1:t]/D_crit,type="l",lwd=2,col="red",xlim=c(1,T),ylim=c(0,max(1.2,Dh[1:t]/D_crit)),
       main="D / D_crit",xlab="",ylab="")
  abline(h=1,lty=2)
}

#---------------------------------------------------------------
#run
#---------------------------------------------------------------

for(t in 1:T){

  #step 1: act. a few restrain regardless. below C you extract. the dead do nothing
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==0){ grid[i,j]=0; next }
      if(runif(1,0,1)<prand) grid[i,j]=0
      if(resource[i,j]<C) grid[i,j]=1
    }
  }

  #step 2: earn
  for(i in 1:nd){
    for(j in 1:nd){
      share=b0*h2/(resource[i,j]+h2)
      if(alive[i,j]==0) income[i,j]=0
      else if(grid[i,j]==1) income[i,j]=share*resource[i,j]
      else income[i,j]=a*share*resource[i,j]
    }
  }

  #step 3: commons. count extractors and restrainers
  next_=0; nres=0
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==1 && grid[i,j]==1) next_=next_+1
      if(alive[i,j]==1 && grid[i,j]==0) nres=nres+1
    }
  }
  D=D+alpha*(next_-sigma*N)-beta*max(0,nres-sigma*N)
  if(D<0) D=0

  #step 4: damage
  for(i in 1:nd){
    for(j in 1:nd){
      payoff[i,j]=income[i,j]-dg*D
      if(alive[i,j]==0) payoff[i,j]=0
    }
  }

  #step 5: mechanism. who pays, then pot split across B
  pay[,]=0; get[,]=0
  if(theta>0 && mech!="none"){
    for(i in 1:nd){
      for(j in 1:nd){
        if(alive[i,j]==0) next
        if(mech=="flat_fee" && grid[i,j]==1) pay[i,j]=theta
        if(mech=="wealth_levy" && group[i,j]==0) pay[i,j]=theta*resource[i,j]
      }
    }
    nB=sum(alive==1 & group==1)
    if(nB>0) get[alive==1 & group==1]=sum(pay)/nB
    payoff=payoff-pay+get
  }

  #step 6: settle. resources move. at zero you are out
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==1) resource[i,j]=resource[i,j]+payoff[i,j]
      if(resource[i,j]<=0){ alive[i,j]=0; resource[i,j]=0; grid[i,j]=0 }
    }
  }
  cumwb=cumwb+resource

  #step 7: imitate. copy the best paid of self and four neighbours. all at once
  newgrid=grid
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==0) next

      # boundary conditions are periodic and wrap round
      if(i-1==0) am=nd else am=i-1
      if(i+1>nd) ap=1 else ap=i+1
      if(j-1==0) bm=nd else bm=j-1
      if(j+1>nd) bp=1 else bp=j+1

      best=payoff[i,j]; bests=grid[i,j]
      if(alive[ap,j]==1 && payoff[ap,j]>best){ best=payoff[ap,j]; bests=grid[ap,j] }
      if(alive[am,j]==1 && payoff[am,j]>best){ best=payoff[am,j]; bests=grid[am,j] }
      if(alive[i,bp]==1 && payoff[i,bp]>best){ best=payoff[i,bp]; bests=grid[i,bp] }
      if(alive[i,bm]==1 && payoff[i,bm]>best){ best=payoff[i,bm]; bests=grid[i,bm] }
      newgrid[i,j]=bests
    }
  }
  grid=newgrid

  #step 8: record
  Dh[t]=D
  actAh[t]=mean(alive[group==0]); actBh[t]=mean(alive[group==1])
  lA=(alive==1 & group==0); lB=(alive==1 & group==1)
  restAh[t]=if(sum(lA)>0) 1-mean(grid[lA]) else NA
  restBh[t]=if(sum(lB)>0) 1-mean(grid[lB]) else NA

  if(live && (t%%every==0 || t==T)){ draw(t); Sys.sleep(0.02) }
}

#---------------------------------------------------------------
#outcomes
#---------------------------------------------------------------

grid
alive

#share still active, per group
actAh[T]
actBh[T]

#restraint, per group
restAh[T]
restBh[T]

#commons at end, relative to critical
D/D_crit

#well-being = average resources held per round. three yardsticks
wb=cumwb/T
mean(wb)                                  #utilitarian
mean(wb[group==1])                        #maximin. B mean
mean(wb[group==0])-mean(wb[group==1])     #egalitarian. gap

if(!live) draw(T)
