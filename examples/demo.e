new;
library qardl;
cls;

// Maximum value of p orders
pend = 7; 

// Maximum value of q orders
qend = 7;                   

// Quantile levels
tau = { 0.25, 0.5, 0.7 }; 

// Load data
data = loadd(__FILE_DIR $+ "qardl_data.dat");

/*
** This is for demonstration. This step needs 
** to be done to:
** 1) Make sure the data is the correct order, with
**    the dependent variable first.
** 2) Extract the subsets of independent variables
*/

// Specify dependent variable here
yyy = data[., 1];

// Specify independent variables here
xxx = data[., 2:3];  

// Data used in qardl should have
// dependent variable in first column
// independent variable in remaining k 
// cols
data_test = yyy~xxx;                         

// qardl order estimation 
{ pst, qst } = pqorder(data_test, pend, qend);   

// Parameter estimation
struct qardlOut qaOut;
qaOut = qardl(data_test, pst, qst, tau); 

// Constructing hypotheses */
ca1 = zeros(2, cols(xxx)*rows(tau));
ca1[1, 1] = 1; 
ca1[1, cols(xxx)+1] = -1;
ca1[2, cols(xxx)+1] = 1; 
ca1[2, 2*cols(xxx)+1] = -1;

sm1 = zeros(2, 1);

ca2 = zeros(2, pst*rows(tau));
ca2[1, 1] = 1; 
ca2[1, pst+1] = -1;
ca2[2, pst+1] = 1; 
ca2[2, 2*pst+1] = -1;
sm2 = sm1;

ca3 = ca1;
sm3 = sm1;

// Long-run parameter (beta) testing 
{ wtlrb1, pvlrb1 } = wtestlrb(qaOut.bigbt, qaOut.bigbt_cov, ca1, sm1, data_test);

// Short-run parameter (phi) testing 
{ wtsrp1, pvsrp1 } = wtestsrp(qaOut.phi, qaOut.phi_cov, ca2, sm2, data_test);

// Short-run parameter (gamma) testing 
{ wtsrg1, pvsrg1 } = wtestsrg(qaOut.gamma, qaOut.gamma_cov, ca3, sm3, data_test);
    
print "=========================================================";    
print "Estimated p order ";
print "=========================================================";    
print pst;
print "=========================================================";    
print "Estimated q order ";
print "=========================================================";    
print qst;
print "=========================================================";    
print "Long-run parameter estimate (Beta)";
print "=========================================================";    
print qaOut.bigbt;
print "=========================================================";    
print "Covariance matrix estimate of long-run parameter (Beta)";
print "=========================================================";    
print qaOut.bigbt_cov;
print "=========================================================";    
print "Short-run parameter estimate (Phi)";
print "=========================================================";    
print qaOut.phi;
print "=========================================================";    
print "Covariance matrix estimate of short-run parameter (Phi)";
print "=========================================================";    
print qaOut.phi_cov;
print "=========================================================";    
print "Short-run parameter estimate (Gamma)";
print "=========================================================";    
print qaOut.gamma;
print "=========================================================";    
print "Covariance matrix estimate of short-run parameter (Gamma)";
print "=========================================================";    
print qaOut.gamma_cov;
print "=========================================================";    
print " Wald test (Beta) and its p-value";
print "=========================================================";    
print wtlrb1~pvlrb1;
print "=========================================================";    
print " Wald test (Phi) and its p-value";
print "=========================================================";    
print wtsrp1~pvsrp1;
print "=========================================================";    
print " Wald test (Gamma) and its p-value";
print "=========================================================";    
print wtsrg1~pvsrg1;
print "=========================================================";    
