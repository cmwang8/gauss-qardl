proc icmean(data,ppp,qqq);
    local yy, xx, us, um, ee, nn, eei, xxi, yyi, ii, jj, X, onex, Y, bt, uu, rh, bic, ic;
    
    nn = rows(data);
    yy = data[.,1];
    xx = data[.,2:cols(data)];
    ee = xx[2:nn,.] - xx[1:(nn-1),.];
    ee = zeros(1,cols(ee))|ee;

    eei = zeros(nn-qqq,qqq*cols(ee));
    xxi = xx[qqq+1:nn,.];
    yyi = zeros(nn-ppp,ppp);

    jj = 1;
    do until jj > cols(ee);
        ii = 0;
        do until ii > qqq-1;
            eei[., ii+1+(jj-1)*qqq] = ee[(qqq+1-ii):(nn-ii),jj];
            ii = ii + 1;
        endo;
        jj = jj+1;
    endo;

    ii = 1;
    do until ii > ppp;
        yyi[.,ii] = yy[(1+ppp-ii):(nn-ii),1];
        ii = ii + 1;
    endo;

    if ppp .> qqq;
        X  = eei[(rows(eei)+1-rows(yyi)):rows(eei),.]~xxi[(rows(xxi)+1-rows(yyi)):rows(xxi),.]~yyi;
    else;
        X  = eei~xxi~yyi[(rows(yyi)+1-rows(xxi)):rows(yyi),.];
    endif;

    ONEX= ones(rows(X),1)~X;
    Y  = yy[(nn-rows(X)+1):nn,1];
    
    bt = inv(onex'*onex)*onex'*Y;
    uu = Y - onex*bt;
    rh = uu^2;

    bic = rows(Y)*ln(meanc(rh)) + cols(onex)*ln(rows(Y));

    retp(bic);
endp;

proc (2) = pqorder(data,pend,qend);

    local icb, jj1, jj2, lst, pst, qst;

    /* bic computation */
    icb = zeros(pend*qend,1);
    jj1 = 1;
    do until jj1 > pend;
        jj2 = 1;
        do until jj2 > qend;
            icb[pend*(jj1-1)+jj2,1] = icmean(data,jj1,jj2);
            jj2 = jj2 + 1;
        endo;
        jj1 = jj1 + 1;
    endo;

    /* p and q estimation */
    lst = minindc(icb);
    pst = ceil(lst/qend);
    qst = lst - (pst-1)*qend;

    retp(pst,qst);
endp;