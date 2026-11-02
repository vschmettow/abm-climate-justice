#Model 04: saturating sink (was base_model_v2.R, 22 Oct 2026). working model

#one agent = one country. 196 of them, one vote each. two groups: A rich, B poor, 20/80.
#agents hold wealth. no income. wealth only goes down: by restraining, by damage, by a mechanism.
#emit: free. adds alpha to D.
#restrain: costs c, same for everyone. adds nothing. everyone restraining = net zero.
#the sink pulls D down by s0*D/(1+D/Dhalf): about 2% a year today, weaker as D grows, recovers as D falls.
#D starts at today's excess, 267 units (NOAA 2025, 425.6 ppm).
#damage = dg*D^2. nothing at first, then it bites. same for everyone, so it hurts the poor more.
#at zero wealth you are out. permanently.
#each round agents copy the best paid of their four neighbours.
#random restraining is a one-round act. it only sticks if a neighbour copies it.
#mechanisms plug in at step 5 and change payoff and D only.
#one round = one year. T = 100 is 2026 to 2126.

#free choices, swept in the sensitivity analysis: c, dg, Dhalf. s0 and D0 are fitted to data (sink_report.md).

#make sure R is clear of old variables
rm(list=ls())

#use set.seed to fix random number generator
set.seed(100)

#set grid size and number of rounds
nd=14
T=900

#set starting wealth for each group, and the share of cells that are group A
rA=40
rB=10
pA=0.2

#cost of restraining. same for everyone. below it you cannot restrain
c=0.1

#set commons. each emitter adds alpha. sink = s0*D/(1+D/Dhalf). D0 = excess CO2 today
alpha=0.05
s0=0.045
Dhalf=200
D0=267

#set damage. each agent loses dg*D^2
dg=2e-6

#share emitting at t=0, and chance per round to restrain regardless
pinit=0.5
prand=0.01

#mechanism. none, flat_fee or wealth_levy. theta is the rate
mech="none"
theta=0

#draw while running. every n rounds
live=TRUE
every=5

#---------------------------------------------------------------
#set grids
#---------------------------------------------------------------

group=array(0,dim=c(nd,nd))     #0 = A, 1 = B
resource=array(0,dim=c(nd,nd))
strat=array(0,dim=c(nd,nd))     #inherited strategy. 1 = emit, 0 = restrain
grid=array(0,dim=c(nd,nd))      #what you actually do this round
payoff=array(0,dim=c(nd,nd))
alive=array(1,dim=c(nd,nd))
cumwb=array(0,dim=c(nd,nd))     #sum of wealth held, for well-being
pay=array(0,dim=c(nd,nd))
get=array(0,dim=c(nd,nd))

N=nd*nd
Dh=numeric(T); sinkh=numeric(T); actAh=numeric(T); actBh=numeric(T)
restAh=numeric(T); restBh=numeric(T)

#---------------------------------------------------------------
#initialize. groups fixed 20/80 and shuffled. wealth from group. strategy random
#---------------------------------------------------------------

nA=round(pA*N)
tmp=sample(c(rep(0,nA),rep(1,N-nA)))
k=0
for(i in 1:nd){
  for(j in 1:nd){
    k=k+1
    group[i,j]=tmp[k]
    if(group[i,j]==0) resource[i,j]=rA else resource[i,j]=rB
    if(runif(1,0,1)<pinit) strat[i,j]=1.0 else strat[i,j]=0.0
  }
}

#D where yearly damage equals the cost of restraining. reporting line only
D_crit=sqrt(c/dg)
D=D0

#---------------------------------------------------------------
#plot. grid, restraining, active, D/D_crit
#---------------------------------------------------------------

if(live) try(quartz(width=10,height=7),silent=TRUE)
draw=function(t){
  par(mfrow=c(2,2),mar=c(3,3,2,1))
  g=alive*(grid+1)   #0 out, 1 restrain, 2 emit
  image(1:nd,1:nd,t(g[nd:1,]),col=c("black","steelblue","red"),zlim=c(0,2),
        main=paste("round",t,"  D/D_crit",round(D/D_crit,2)),xlab="",ylab="",axes=FALSE)
  plot(1:t,restAh[1:t],type="l",lwd=2,col="gold",xlim=c(1,T),ylim=c(0,1),main="restraining",xlab="",ylab="")
  lines(1:t,restBh[1:t],lwd=2,col="grey40")
  plot(1:t,actAh[1:t],type="l",lwd=2,col="gold",xlim=c(1,T),ylim=c(0,1),main="active",xlab="",ylab="")
  lines(1:t,actBh[1:t],lwd=2,col="grey40")
  plot(1:t,Dh[1:t]/D_crit,type="l",lwd=2,col="red",xlim=c(1,T),ylim=c(0,max(1.2,Dh[1:t]/D_crit)),
       main="D / D_crit",xlab="",ylab="")
  abline(h=1,lty=2)
  abline(h=Dhalf/D_crit,lty=3,col="steelblue")   #sink at half strength
  legend("topleft",c("D_crit","D_half"),lty=c(2,3),col=c("black","steelblue"),bty="n")
}

#---------------------------------------------------------------
#run
#---------------------------------------------------------------

for(t in 1:T){

  #step 1: act. play your strategy. a few restrain regardless, this round only. below c you emit. the dead do nothing
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==0){ grid[i,j]=0; next }
      grid[i,j]=strat[i,j]
      if(runif(1,0,1)<prand) grid[i,j]=0
      if(resource[i,j]<c) grid[i,j]=1
    }
  }

  #step 2: commons. count emitters. sink pulls D down
  nem=0
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==1 && grid[i,j]==1) nem=nem+1
    }
  }
  sink=s0*D/(1+D/Dhalf)
  D=D+alpha*nem-sink
  if(D<0) D=0

  #step 3: pay. restrainers pay c. everyone loses dg*D^2
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==0){ payoff[i,j]=0; next }
      if(grid[i,j]==1) payoff[i,j]=-dg*D*D else payoff[i,j]=-c-dg*D*D
    }
  }

  #step 4: mechanism. who pays, then pot split across B
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

  #step 5: settle. wealth moves. at zero you are out
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==1) resource[i,j]=resource[i,j]+payoff[i,j]
      if(resource[i,j]<=0){ alive[i,j]=0; resource[i,j]=0; grid[i,j]=0 }
    }
  }
  cumwb=cumwb+resource

  #step 6: imitate. copy what the best paid of self and four neighbours DID. all at once
  #your own fallback is your inherited strategy, so a random act does not stick on its own
  newstrat=strat
  for(i in 1:nd){
    for(j in 1:nd){
      if(alive[i,j]==0) next

      # boundary conditions are periodic and wrap round
      if(i-1==0) am=nd else am=i-1
      if(i+1>nd) ap=1 else ap=i+1
      if(j-1==0) bm=nd else bm=j-1
      if(j+1>nd) bp=1 else bp=j+1

      best=payoff[i,j]; bests=strat[i,j]
      if(alive[ap,j]==1 && payoff[ap,j]>best){ best=payoff[ap,j]; bests=grid[ap,j] }
      if(alive[am,j]==1 && payoff[am,j]>best){ best=payoff[am,j]; bests=grid[am,j] }
      if(alive[i,bp]==1 && payoff[i,bp]>best){ best=payoff[i,bp]; bests=grid[i,bp] }
      if(alive[i,bm]==1 && payoff[i,bm]>best){ best=payoff[i,bm]; bests=grid[i,bm] }
      newstrat[i,j]=bests
    }
  }
  strat=newstrat

  #step 7: record
  Dh[t]=D; sinkh[t]=sink/D
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

#restraining, per group
restAh[T]
restBh[T]

#commons at end, relative to critical
D/D_crit

#sink rate per unit of D: start, lowest, end. s0 is the unsaturated rate
sinkh[1]; min(sinkh); sinkh[T]

#first round where a group is fully out. NA if never
if(any(actAh==0)) min(which(actAh==0)) else NA
if(any(actBh==0)) min(which(actBh==0)) else NA

#well-being = average wealth held per round. three criteria
wb=cumwb/T
mean(wb)                                  #utilitarian
mean(wb[group==1])                        #maximin. B mean
mean(wb[group==0])-mean(wb[group==1])     #egalitarian. gap

if(!live) draw(T)
