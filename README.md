# Statistique des événements extrêmes et applications

Projet M2 - Analyse des hauteurs de vagues dans le Golfe du Lion

## Description

Ce projet applique la théorie des valeurs extrêmes pour modéliser le comportement des vagues dans le golfe du Lion. L'analyse est réalisée en deux volets :
- **Approche univariée** : étude de la station Lion (station de référence)
- **Approche bivariée** : étude de la dépendance entre stations

## Données

- **Période** : 1961-2012 (52 ans)
- **Fréquence** : mesures horaires
- **Stations** : 20 stations dans le golfe du Lion
- **Variable** : hauteurs significatives de vagues (en mètres)

## Objectifs

### Analyse univariée
- Comparaison de deux méthodes : maxima par blocs (GEV) et excès au-dessus d'un seuil (GPD)
- Estimation des niveaux de retour pour les périodes 100, 500 et 1000 ans

### Analyse bivariée
- Étude de la dépendance entre la station Lion et trois autres stations
- Modélisation avec des modèles max-stables (logistique et logistique asymétrique)
- Influence de la distance géographique sur la dépendance extrémale

## Structure du projet
```
├── data/
│   ├── DonneesVagues.RData
│   └── DonneesStations.RData
├── projet_vagues_extremes.Rmd
└── README.md
```

## Comment lancer le script

### Prérequis

Installer R et RStudio, puis installer les packages nécessaires :
```r
install.packages(c("evd", "ismev", "extRemes", "ggplot2", "dplyr"))
```

### Exécution

1. **Télécharger les données** depuis http://imag.umontpellier.fr/~toulemonde/filesM2/ et les placer dans le dossier `data/`

2. **Ouvrir le fichier** `projet_vagues_extremes.Rmd` dans RStudio

3. **Lancer le script** en cliquant sur le bouton "Run"

## Outils utilisés

- **Langage** : R
- **IDE** : RStudio

## Auteurs

- AIGOIN Emilie
- LABOURAIL Célia

**Année universitaire** : 2025-2026  
**Université de Montpellier** - Master 2 SSD

## Résultats principaux

- **GEV** : niveau de retour centennal = 8,57 m
- **GPD** : niveau de retour centennal = 10,15 m
- La dépendance entre stations décroît avec la distance géographique
- Dépendance quasi-totale à courte distance (< 10 km)
- Indépendance asymptotique à grande distance (> 400 km)
