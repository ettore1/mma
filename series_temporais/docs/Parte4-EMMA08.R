###################################################
# Especialização em Métodos Matemáticos Aplicados #
#                SÉRIES TEMPORAIS                 #
#             Profa. Sheila Regina Oro            #
#                   Parte IV                      #
###################################################

## Comparação de modelos e previsão das Manchas solares
library(readxl)
library(tseries)
library(forecast)

# Carregar os dados a partir da planilha
manchas.sol<-read_excel("dados/sunspotdata.xlsx")
manchas<-ts(manchas.sol[,3], start = c(1945,7), frequency = 12)

# Gráfico da série temporal
plot(manchas, xlab="Ano", ylab="Quantidade", main="Manchas Solares")

# Periodograma Integrado
cpgram(manchas, main="Periodograma Integrado - Manchas Solares")

# Teste de estacionariedade
adf.test(manchas)

## Modelagem
# Separar uma parte dos dados para treinar os modelos
manchas.treino<- ts(manchas[1:846], start = c(1945,7), frequency = 12)

# Modelo SES
SES.manchas<-ses(manchas.treino, h=12) 
summary(SES.manchas)
cpgram(SES.manchas$residuals, main="Periodograma Integrado - Residuos SES.manchas")
plot(SES.manchas)
lines(manchas)
accuracy(SES.manchas,manchas[847:858])

# Modelo SEH
SEH.manchas<-holt(manchas.treino, h=12) 
summary(SEH.manchas)
cpgram(SEH.manchas$residuals, main="Periodograma Integrado - Residuos SEH.manchas")
plot(SEH.manchas)
lines(manchas)
accuracy(SEH.manchas,manchas[847:858])

# Modelo Holt-Winters
HW.manchas<-hw(manchas.treino, h=12) 
summary(HW.manchas)
cpgram(HW.manchas$residuals, main="Periodograma Integrado - Residuos HW.manchas")
plot(HW.manchas)
lines(manchas)
accuracy(HW.manchas,manchas[847:858])

# Modelo ARIMA
manchas.ARIMA <- auto.arima(manchas.treino)
summary(manchas.ARIMA)
cpgram(manchas.ARIMA$residuals)
plot(forecast(manchas.ARIMA,h=12))
lines(manchas)
accuracy(forecast(manchas.ARIMA,h=12),manchas[847:858])

# Modelo ETS
ets.manchas <- ets(manchas.treino)
summary(ets.manchas)
cpgram(ets.manchas$residuals)
plot(forecast(ets.manchas,h=12))
lines(manchas)
accuracy(forecast(ets.manchas,h=12),manchas[847:858])
