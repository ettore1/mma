###################################################
# Especialização em Métodos Matemáticos Aplicados #
#                SÉRIES TEMPORAIS                 #
#             Profa. Sheila Regina Oro            #
#                   Parte I                       #
###################################################

# Entrada dos dados a partir de uma planilha
library(readxl)
manchas.sol<-read_excel("dados/sunspotdata.xlsx")
manchas<-ts(manchas.sol[,3], start = c(1945,7), frequency = 12)

NAR <- read_excel("dados/NAR.xlsx")
reservatorio<-ts(NAR[,2], start=c(2000,1), frequency=365)

# Gráfico da série temporal
plot(manchas, xlab="Ano", ylab="Quantidade", col="red", main="Manchas Solares")

plot(reservatorio, xlab="Ano", ylab="Nivel (msnm)", col="blue", main="Nivel de Agua do Reservatorio")

# Periodograma Integrado
cpgram(manchas, main="Periodograma Integrado - Manchas Solares")

cpgram(reservatorio, main="Periodograma Integrado - Nivel de Agua do Reservatorio")

# Decomposição da série temporal
manchas.dec<-decompose(manchas)
plot(manchas.dec)

reservatorio.dec<-decompose(reservatorio)
plot(reservatorio.dec)

# Teste de estacionariedade
library(tseries)
adf.test(manchas)

adf.test(reservatorio)
