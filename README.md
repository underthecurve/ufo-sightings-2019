# UFO sightings in the United States

Dataset is from the National UFO Reporting Centre (NUFORC): http://www.nuforc.org/.

Raw data file is in the `input` folder and was processed through the R script, `01_process.R`.

Plots were made through the R script, `02_makeplots.R` using the cleaned data file  in the `output` folder.

Code and date partly based on [this repo](https://github.com/underthecurve/ufo-sightings) from 2018.

## Codebook

### `ufo_clean.csv`

| variable    | description |
| ------------| ----------- |
| event.date  | date of the sighting |
| event.time  | time the sighting occurred  |
| city  | city the sighting occurred in |
| state  | state the sighting occurred in |
| shape  | shape of the UFO sighted |
| duration  | how long the UFO was observed |
| summary  | description of the sighting |
| posted  | date the sighting was posted on NUFORC |
| id  | unique ID assigned to each sighting |
| event.year  | year the sighting occurred |
| event.month  | month the sighting occurred  |
| event.day  | day the sighting occurred  |
| posted.date  | date the sighting was posted on NUFORC (formatted as a date)  |
| posted.year  | year the sighting was posted on NUFORC |
| posted.month  | month the sighting was posted on NUFORC |
| posted.day  | day the sighting was posted on NUFORC |
| event.dow  | day of the week the sighting occurred |
| notes  | notes from the director of NUFORC on the sighting |
| hoax  | notes from the director of NUFORC on whether the sighting was thought to be a hoax (=1)|
| has  | whether the sighting has a note (=1)|







