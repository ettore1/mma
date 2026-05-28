###################################################
# Especialização em Métodos Matemáticos Aplicados #
#                SÉRIES TEMPORAIS                 #
#             Profa. Sheila Regina Oro            #
#                   Parte III                     #
###################################################

# Entrada dos dados a partir de uma planilha
library(ggplot2)
library(readxl)
manchas.sol<-read_excel("dados/sunspotdata.xlsx")
manchas<-ts(manchas.sol[,3], start = c(1945,7), frequency = 12)
plot(manchas)

# Ajuste do modelo ETS
library(forecast)
ets.manchas <- ets(manchas)
summary(ets.manchas)

# Diagnóstico do modelo ETS
cpgram(ets.manchas$residuals)
checkresiduals(ets.manchas)


# Ajuste do modelo VAR
library(vars)
data(Canada)
dados <- ts(Canada, start = c(1980, 1), frequency = 4)
colnames(dados) <- c("Emprego", "Produtividade", "Salario", "Desemprego")
plot(dados)
lag.var<-VARselect(dados, lag.max = 10)
lag.var
modelo_var<-VAR(dados, p = 3, type = "trend")
summary(modelo_var)

# Diagnóstico do modelo VAR
serial.test(modelo_var, lags.pt = 10, type = "PT.asymptotic")
arch.test(modelo_var)
normality.test(modelo_var)
roots(modelo_var)

# Dinâmica das relações entre as variáveis 
causality(modelo_var, cause = "Emprego")
irf_salario <- irf(modelo_var,
                   impulse = "Salário",
                   response = "Emprego",
                   n.ahead = 12,
                   boot = TRUE)
plot(irf_salario)

fevd(modelo_var, n.ahead = 12)

# Teste de estacionariedade
library(tseries)
adf.test(dados[,1])
adf.test(dados[,2])
adf.test(dados[,3])
adf.test(dados[,4])

# Diferenciação e nova modelagem
dados.dif<- diff(dados)
plot(dados.dif)
lag.var<-VARselect(dados.dif, lag.max = 5)
lag.var
modelo_var_dif<-VAR(dados.dif, p = 2)
summary(modelo_var_dif)
serial.test(modelo_var_dif, lags.pt = 10, type = "PT.asymptotic")

