#### Calculate and save transformation function for ordinal variates
createQfunction <- function(nint=512, nsamples=2^24L, mean=0, sd=1, shapelo=0.5, shapehi=0.5, scale=1, file=paste0('Qfunction',nint), plot=F){
    ##
    seqnint <- (1:(nint-1))/nint
    xsamples <- rnorm(nsamples,
                      mean=rnorm(nsamples,mean=mean,sd=sd),
                      sd=sqrt(
                          extraDistr::rbetapr(nsamples, shape1=shapehi, shape2=shapelo, scale=scale)
                      )
                      )
    ##
    thismad <- mad(xsamples,constant=1)
    oquants <- c(NULL,
                 quantile(x=xsamples, probs=seqnint, na.rm=T, type=6),
                 NULL)
    rm(xsamples)
    oquants <- (oquants-rev(oquants))/2
    approxq <- approxfun(x=seqnint, y=oquants, yleft=-Inf, yright=+Inf)
    if(is.character(plot)){
        ##
        nint <- 256
        xgrid <- seq(1/nint,(nint-1)/nint,length.out=nint-1)
        pdff(plot)
        tplot(x=xgrid,y=list(approxq(xgrid),qnorm(xgrid,sd=thismad/qnorm(3/4)),qcauchy(xgrid,scale=thismad)#,qlogis(xgrid,scale=1/qlogis(3/4))
                             ),
              lwd=c(3,2,2,5),lty=c(1,2,4,3), alpha=c(0,rep(0.25,3)),
              ylim=range(approxq(xgrid)), 
              ## xticks=c(0,0.25,0.5,0.75,1),xlabels=c(0,expression(italic(m)/4),expression(italic(m)/2),expression(3*italic(m)/4),expression(italic(m))),
              xlab=expression(italic(x)), ylab=expression(italic(Q)(italic(x))),
              mar=c(NA,5,1,1))
        legend('topleft', c(expression(italic(Q)),'Gauss','Cauchy'), lwd=c(3,2,2,5), lty=c(1,2,4,3), col=c(1,2,3,4), bty='n')
        dev.off()
    }
    if(is.character(file)){
        saveRDS(approxq, paste0(file,'.rds'))
    }
    approxq
}