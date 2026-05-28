###################################################
# Especialização em Métodos Matemáticos Aplicados #
#                SÉRIES TEMPORAIS                 #
#             Profa. Sheila Regina Oro            #
#                   Parte II                      #
###################################################

# Entrada dos dados a partir de uma planilha
library(readxl)
manchas.sol<-read_excel("dados/sunspotdata.xlsx")
manchas<-ts(manchas.sol[,3], start = c(1945,7), frequency = 12)

NAR <- read_excel("dados/NAR.xlsx")
reservatorio<-ts(NAR[,2], start=c(2000,1), frequency=365)

# Para os modelos a seguir, é necessário ativar o pacote "forecast"
library(forecast)

# Modelo SES
SES.manchas<-ses(manchas) 
summary(SES.manchas)
cpgram(SES.manchas$residuals, main="Periodograma Integrado - Residuos SES.manchas")

SES.reservatorio<-ses(reservatorio) 
summary(SES.reservatorio)
cpgram(SES.reservatorio$residuals, main="Periodograma Integrado - Residuos SES.reservatorio")

# Modelo SEH
SEH.manchas<-holt(manchas) 
summary(SEH.manchas)
cpgram(SEH.manchas$residuals, main="Periodograma Integrado - Residuos SEH.manchas")

SEH.reservatorio<-holt(reservatorio) 
summary(SEH.reservatorio)
cpgram(SEH.reservatorio$residuals, main="Periodograma Integrado - Residuos SEH.reservatorio")

# Modelo Holt-Winters
HW.manchas<-hw(manchas) 
summary(HW.manchas)
cpgram(HW.manchas$residuals, main="Periodograma Integrado - Residuos HW.manchas")

# Modelo ARIMA
manchas.ARIMA <- auto.arima(manchas)
summary(manchas.ARIMA)
cpgram(manchas.ARIMA$residuals)

reservatorio.ARIMA <- auto.arima(reservatorio)
summary(reservatorio.ARIMA)
cpgram(reservatorio.ARIMA$residuals)
