#该函数的主要作用是建立一个数据框，把之前的excel主要数据都填进去
#1.1. pre-processing function
prepro_func <- function(d_df, general_info) {
  # Currently class(d_df) == "data.table"
  
  # Use general_info of d_df
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs # number of trials for each sub and block
  t_max   <- general_info$t_max
  
  # Initialize (model-specific) data arrays
  #choice 是一个二维数组，用于存储多个个体（n_subj）在多个时间点（t_max）的选择结果;
  #初始时，所有元素都被设置为 -1，这可能意味着在实验或模拟开始之前，所有选择都是未知的。
  #随着实验或模拟的进行，这些 -1 值将被实际的选择结果所替代。
  #如果 n_subj 是 10（即有 10 个个体），t_max 是 5（即有 5 个时间点），
  #那么 choice 数组将是一个 10x5 的矩阵，初始时每个元素都是 -1。
  #在实验过程中，每个个体在每个时间点的选择将被记录在这个数组中。
  #设置可能是-1或0，看自己的设定
  choice       <- array(-1, c(n_subj, t_max)) # choice, -1 for missing data
  offer_propoer<- array(-1, c(n_subj, t_max)) # money to the proposer, -1 for missing data
  offer_recipt <- array(-1, c(n_subj, t_max)) # money to the recipt, -1 for missing data  
  in_outgroup  <- array(-1, c(n_subj, t_max)) # in_outgroup, -1 for missing data

  data_new <- data.frame('subid'=rep(-1,n_subj*t_max),'trial'=rep(-1,n_subj*t_max),"choice"=rep(-1,n_subj*t_max),"offer_propoer"=rep(-1,n_subj*t_max),
                         "offer_recipt"=rep(-1,n_subj*t_max),"in_outgroup"=rep(-1,n_subj*t_max))

  
  # Write from d_df to the data arrays
  for (i in 1:n_subj) {
    subj                        <- subjs[i]
    t                           <- t_subjs[i] #trial number of the current subject
    DT_subj                     <- d_df[d_df$subid == subj]
    
    choice[i, 1:t]              <- DT_subj$choice
    offer_propoer[i, 1:t]       <- DT_subj$offer_propoer
    offer_recipt[i, 1:t]       <- DT_subj$offer_recipt
    in_outgroup[i, 1:t]         <- DT_subj$in_outgroup

  }
  
  # Wrap into a list for Stan
  #要注意对应地去修改数据的列名
  data_list <- list(
    Ns             = n_subj,
    Ts             = t_max,
    Tsubj          = t_subjs,
    choice         = choice,
    offer_propoer  = offer_propoer,
    offer_recipt   = offer_recipt,    
    in_outgroup    = in_outgroup)
  
  
  # write into a data frame for PPC
  data_new$subid                 <- rep(subjs,each=t_max)
  data_new$trial                 <- rep(rep(1:t_max),times=n_subj)
  data_new$choice                <- as.vector(aperm(choice, c(2,1))) #change the order of arrary and then transfer to a vector
  data_new$offer_propoer         <- as.vector(aperm(offer_propoer, c(2,1)))
  data_new$offer_recipt          <- as.vector(aperm(offer_recipt, c(2,1)))
  data_new$in_outgroup           <- as.vector(aperm(in_outgroup, c(2,1)))

 
  
  if (general_info$gen_file==1){  #only generate the data file for the main analysis, not for simulation analysis
    write.csv(data_new,file='inout_bestmodel_simulation.csv',row.names = FALSE)
  }
  
  # Returned data_list will directly be passed to Stan
  return(data_list)
}
