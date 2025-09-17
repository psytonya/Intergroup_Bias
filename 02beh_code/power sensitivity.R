install.packages("pwr")
library(pwr)

# 计算Cohen's f²
result <- pwr.f2.test(u = 1,         # 分子自由度（交互作用）
                      v = 56,        # 分母自由度（误差）
                      sig.level = 0.05,
                      power = 0.80)

# 将f²转换为偏η²
eta_p_sq <- result$f2 / (1 + result$f2)

print(paste("偏η² =", round(eta_p_sq, 3)))