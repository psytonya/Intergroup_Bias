//U= Xself-kappa*P-alpha·max((Xother-3*kappa*P)-(Xself-kappa*P),0)-theta·max((Xself-kappa*P)-(Xother-3*kappa*P),0) 
//alpha_temp+kappa_temp+theta_temp

data {//these variable names should be consistent with input data names
  int<lower=1> Ns; // define sub number(60)
  int<lower=1> Ts; // define maximum trial number(144)
  int<lower=1, upper=Ts> Tsubj[Ns]; //trial number for each sub
  int  choice[Ns, Ts];        //choice,1,2,3,4, choice is input as an integer.????Ϊ0
  real offer_propoer[Ns, Ts];   //money to the proposer(6/7/9/12)
  real offer_recipt[Ns, Ts]; //money to participants/agents(6/5/3/0)
  int  in_outgroup[Ns, Ts];  //inout:1=ingroup;2=outgroup
}

transformed data {
  vector[4] c_points=to_vector([0,2,4,6]);// points of choice:0,2,4,6
}

parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[5] mu_pr; //mean of the parameters,7 paras: punishment willingness??punishment degree and a inverse temperature.
  vector<lower=0>[5] sigma; //variance of the parameters, 7 paras

  // Subject-level raw parameters (for Matt trick)
  vector[Ns] alpha_pr11;  // ingroup_alpha:disadvantage inequality aversion
  vector[Ns] alpha_pr12;  // outgroup_alpha:disadvantage inequality aversion
  vector[Ns] theta_pr11;  // ingroup_theta:advantage inequality aversion
  vector[Ns] theta_pr12;  // outgroup_theta:advantage inequality aversion
  vector[Ns] tau_pr;    // tau: Inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  real<lower=0> alpha11[Ns];
  real<lower=0> alpha12[Ns];
  real theta11[Ns];
  real theta12[Ns];
  real<lower=0> tau[Ns];

  for (i in 1:Ns) {
    alpha11[i] = exp(mu_pr[1] + sigma[1] * alpha_pr11[i]);
    alpha12[i] = exp(mu_pr[2] + sigma[2] * alpha_pr12[i]);
    theta11[i] = mu_pr[3] + sigma[3] * theta_pr11[i];
    theta12[i] = mu_pr[4] + sigma[4] * theta_pr12[i];
    tau[i]     = exp(mu_pr[5] + sigma[5] * tau_pr[i]);
  }
}

model {
  // Hyperparameters
  mu_pr[1:2]  ~ normal(0, 1.0);
  mu_pr[3:4]  ~ normal(0, 10);
  mu_pr[5]    ~ normal(0, 10);
  sigma ~ normal(0, 0.5);

  // individual parameters
  alpha_pr11  ~ normal(0, 1.0);
  alpha_pr12  ~ normal(0, 1.0);
  theta_pr11  ~ normal(0, 1.0);
  theta_pr12  ~ normal(0, 1.0);
  tau_pr      ~ normal(0, 1.0);

  for (i in 1:Ns) {
    // Define values
    vector[4] util; // Utility for each option
    real alpha_temp;
    real theta_temp;
    for (t in 1:Tsubj[i]) { //loop over the trial number of each subject. Therefore, skipping the non-responsed trials.
      // utility
     if(in_outgroup[i,t]==1 ){
        alpha_temp = alpha11[i];
        theta_temp= theta11[i];
      } else {
        alpha_temp = alpha12[i];
        theta_temp= theta12[i];
      }  

      util[1] = offer_recipt[i,t]+6-0-alpha_temp*(fmax((offer_propoer[i,t]+6-3*0)-(offer_recipt[i,t]+6-0),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-0)-(offer_propoer[i,t]+6-3*0),0));// if chosing 0
      util[2] = offer_recipt[i,t]+6-2-alpha_temp*(fmax((offer_propoer[i,t]+6-3*2)-(offer_recipt[i,t]+6-2),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-2)-(offer_propoer[i,t]+6-3*2),0));// if chosing 2
      util[3] = offer_recipt[i,t]+6-4-alpha_temp*(fmax((offer_propoer[i,t]+6-3*4)-(offer_recipt[i,t]+6-4),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-4)-(offer_propoer[i,t]+6-3*4),0));// if chosing 4
      util[4] = offer_recipt[i,t]+6-6-alpha_temp*(fmax((offer_propoer[i,t]+6-3*6)-(offer_recipt[i,t]+6-6),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-6)-(offer_propoer[i,t]+6-3*6),0));// if chosing 6
                   
      // Sampling statement,computing the likelihood
      choice[i, t] ~ categorical_logit(util*tau[i]);

    } // end of t loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0> mu_alpha11;
  real<lower=0> mu_alpha12;
  real mu_theta11;
  real mu_theta12;
  real<lower=0> mu_tau;

  // For log likelihood calculation
  real log_lik[Ns];

  mu_alpha11  = exp(mu_pr[1]);//劣势不公厌恶
  mu_alpha12  = exp(mu_pr[2]);//劣势不公厌恶
  mu_theta11  = mu_pr[3];//优势不公厌恶
  mu_theta12  = mu_pr[4];//优势不公厌恶
  mu_tau      = exp(mu_pr[5]) ;//逆温


  { // local section, this saves time and space
    for (i in 1:Ns) {
      // Define values
      vector[4] util; // Utility for each option    
      real alpha_temp;
      real theta_temp;
      
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
         // utility
     if(in_outgroup[i,t]==1 ){
        alpha_temp=alpha11[i];
        theta_temp=theta11[i];
      } else {
        alpha_temp=alpha12[i];
        theta_temp=theta12[i];
      } 
      
        // utility
      util[1] = offer_recipt[i,t]+6-0-alpha_temp*(fmax((offer_propoer[i,t]+6-3*0)-(offer_recipt[i,t]+6-0),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-0)-(offer_propoer[i,t]+6-3*0),0));// if chosing 0
      util[2] = offer_recipt[i,t]+6-2-alpha_temp*(fmax((offer_propoer[i,t]+6-3*2)-(offer_recipt[i,t]+6-2),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-2)-(offer_propoer[i,t]+6-3*2),0));// if chosing 2
      util[3] = offer_recipt[i,t]+6-4-alpha_temp*(fmax((offer_propoer[i,t]+6-3*4)-(offer_recipt[i,t]+6-4),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-4)-(offer_propoer[i,t]+6-3*4),0));// if chosing 4
      util[4] = offer_recipt[i,t]+6-6-alpha_temp*(fmax((offer_propoer[i,t]+6-3*6)-(offer_recipt[i,t]+6-6),0))
                -theta_temp*(fmax((offer_recipt[i,t]+6-6)-(offer_propoer[i,t]+6-3*6),0));// if chosing 6
       
      // Calculate log likelihood
      log_lik[i] += categorical_logit_lpmf(choice[i,t] | util*tau[i]);
        
      // generate posterior prediction for current trial
      // y_pred[i, t]  = categorical_rng(softmax(util*tau[i])); //only for winning model

      } // end of t loop
    } // end of i loop
  } // end of local section
}


