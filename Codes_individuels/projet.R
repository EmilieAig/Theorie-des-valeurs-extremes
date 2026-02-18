library(ismev)
library(evd)
library(dplyr)
library(ggplot2)


data <- donneesVague
#Analyse sur la stations 1 
X <- data %>% select(c(date, station1))

#vérifiquation des doublons 
length(unique(X$date))
#garder l'ordre des date 
X <- X[order(X$date), ]

#supprimer les aparition d'une date après la première
X <- X[!duplicated(X$date),] 

# Extraire toutes les années présentes
liste_annees <- unique(year(data$date))


plot(X$station1)

#Première approche GEV

# Nombre de points par an (donnees horaires)
npp <- 8760

#p pour une période de retour de 100 ans 
p_100 <- 1 / (100 * npp)

#p pour une période de retour de 500 ans 
p_500 <- 1 / (500 * npp)

#p pour une période de retour de 1000 ans 
p_1000 <- 1 / (1000 * npp)
#maxX par mois 
maxX = rep(0, 624)
for (i in 1:624) {maxX[i] = max(X$station1[((i - 1) * 732 + 1):(i * 732)])
}

#maxX par saisons 
maxX1 = rep(0, 208)
for (i in 1:208) {maxX1[i] = max(X$station1[((i - 1) * 2196 + 1):(i * 2196)])
}


#par ans 
maxX2 = rep(0, 52)
for (i in 1:52) {maxX2[i] = max(X$station1[((i - 1) * 8760 + 1):(i * 8760)])
}


ggplot(data.frame(index = seq_along(maxX), max = maxX), aes(x = index, y = max)) +
  geom_point(color = "black", size = 0.8) +
  labs(title = "Max mensuels", x = "Index", y = "Max station1") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data.frame(index = seq_along(maxX1), max = maxX1), aes(x = index, y = max)) +
  geom_point(color = "red", size = 0.8) +
  labs(title = "Max saisonniers", x = "Index", y = "Max station1") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data.frame(index = seq_along(maxX2), max = maxX2), aes(x = index, y = max)) +
  geom_point(color = "blue", size = 0.8) +
  labs(title = "Max annuels", x = "Index", y = "Max station1") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))



#q pour une période de reotur de 100 ans (avec choix du max annuel)

q_100<- 0.01

#q pour une période de reotur de 500 ans (avec choix du max annuel)

q_500<- 0.002

#q pour une période de reotur de 1000 ans (avec choix du max annuel)

q_1000<- 0.001

#ajustement 
dataGEV <- gev.fit(maxX2)
dataGEV$mle - 1.96 * dataGEV$se
dataGEV$mle + 1.96 * dataGEV$se


ypm1 <- (-log((1 - p_100) ^ 8760))
zp_100 <- dataGEV$mle[1] - (dataGEV$mle[2] / dataGEV$mle[3]) * (1 - ypm1 ^ (-dataGEV$mle[3]))


ypm1 <- (-log((1 - p_500) ^ 8760))
zp_500 <- dataGEV$mle[1] - (dataGEV$mle[2] / dataGEV$mle[3]) * (1 - ypm1 ^ (-dataGEV$mle[3]))

ypm1 <- (-log((1 - p_1000) ^ 8760))
zp_1000 <- dataGEV$mle[1] - (dataGEV$mle[2] / dataGEV$mle[3]) * (1 - ypm1 ^ (-dataGEV$mle[3]))

#sorti graphique
gev.diag(dataGEV)

#méthode POT
mrlplot(X$station1)



VaRGPD_100<- fpot(X$station1, 4.5, npp = 8760, mper = 100)

VaRGPD_500<- fpot(X$station1, 4.5, npp = 8760, mper = 500)

VaRGPD_1000<- fpot(X$station1, 4.5, npp = 8760, mper = 1000)

par(mfrow = c(2, 2))
plot(VaRGPD_100)


VaRGPD_1000
VaRGPD_100
VaRGPD_500


# Ajustement PPFit avec max annuels et seuil
seuil_ppt <- 4.5
PPFit <- pp.fit(xdat = X$station1, udat = maxX2, threshold = seuil_ppt, npp = 8760)

# Résumé de l'ajustement
summary(PPFit)

# Quantiles de retour estimés via PPFit (100/500/1000 ans)
pp_loc <- PPFit$mle[1]
pp_scale <- PPFit$mle[2]
pp_shape <- PPFit$mle[3]

pp_100 <- qgev(1 - 1/100, loc = pp_loc, scale = pp_scale, shape = pp_shape)
pp_500 <- qgev(1 - 1/500, loc = pp_loc, scale = pp_scale, shape = pp_shape)
pp_1000 <- qgev(1 - 1/1000, loc = pp_loc, scale = pp_scale, shape = pp_shape)



# Diagnostic PPFit
pp.diag(PPFit)
