library('tidyverse')
library('lubridate')
library('scales')
library('ggridges')

ufo <- read.csv('output/ufo_clean.csv', stringsAsFactors = F)


# 1995-2018 is the most complete yearly time period
ufo.dates <- ufo %>% filter(is.na(event.date) == F & 
                              event.year >= 1995 & event.year != 2019 & 
                              hoax != 1) %>%
  group_by(event.day, event.month) %>%
  summarise(n = n())

# indicator for july4
ufo.dates$july4 <- ifelse((ufo.dates$event.day == 4 & ufo.dates$event.month == 'Jul'), 1, 0
)

ufo.dates %>% group_by(july4) %>% summarise( n= sum(n)) %>% mutate(perc = n/sum(n))

head(ufo.dates)


## RIBBON PLOT

# pad with a 'year' so R will recognize as a date: https://mgimond.github.io/ES218/Week02c.html
ufo.dates$date <- ymd(paste("2016", # note it's not really 2016 this is just a placeholder
                        ufo.dates$event.month, 
                        ufo.dates$event.day, sep="-"))

write_csv(ufo.dates, 'ufo_dates.csv')

ufo.dates$date <- ymd(ufo.dates$date)

ufo.plot <- ggplot(ufo.dates, aes(x = date, y = n)) +
  scale_x_date(expand = c(0, 0), date_breaks = "month",
               date_minor_breaks = "day", 
               labels = c( 
                 'Jan',
                 'Feb',
                 'Mar',
                 'Apr',
                 'May',
                 'Jun',
                 'Jul',
                 'Aug',
                 'Sept',
                 'Oct',
                 'Nov',
                 'Dec', ''))

ufo.plot.ribbon <- ufo.plot + geom_ribbon(aes(x = date, ymax = n), ymin = 0, fill = '#6497b1',  
                                          color = '#005b96', size = 1)

ufo.plot.ribbon

ufo.plot.ribbon + labs(x = '', y = '', title = "Welcome to Earth!",
                       subtitle = "Cumulative daily reported UFO sightings, January 1995 through December 2018\n",
                       caption = "Source: National UFO Reporting Centre") + 
  scale_y_continuous(limits = c(0, 2000), 
                     expand = c(0, 0), 
                     labels = c('', "500", "1,000", "1,500", "2,000")) + 
  theme(axis.ticks = element_blank(), 
        axis.line.x = element_line(color = '#005b96'), 
        axis.text = element_text(size = 12)
  ) + theme(panel.grid.minor.x = element_blank(), 
            plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 14), 
            plot.caption = element_text(hjust = -.01, color = 'grey30', size = 10)
  )

ggsave('plot1.png', width = 8, height = 4.5)
ggsave('plot1.eps', width = 8, height = 4.5, device = 'eps')

## RIDGE PLOTS BY YEAR

ufo.dates.year <- ufo %>% filter(is.na(event.date) == F & 
                                   event.year >= 1995 & hoax != 1 & event.year != 2019) %>%
  group_by(event.day, event.month, event.year) %>%
  summarise(n = n()) %>% ungroup() %>% group_by(event.year) %>% 
  mutate(year.total = sum(n)) %>%
  mutate(prop = n/year.total)

# pad with a 'year' so R will recognize as a date: https://mgimond.github.io/ES218/Week02c.html
ufo.dates.year$date <- paste('2016', # note it's not really 2016 this is just a placeholder
                             ufo.dates.year$event.month, 
                             ufo.dates.year$event.day, sep="-")

ufo.dates.year$date <- ymd(ufo.dates.year$date)

ufo.ridge <- ggplot(ufo.dates.year, aes(x = date, 
                                        y = event.year, 
                                        height = prop * 100, 
                                        group = event.year)) + 
  geom_ridgeline(scale = 1, fill = '#25D366',  
                 color = '#128C7E') +
  scale_y_continuous(breaks = seq(1995, 2018, 1)) +
  scale_x_date(expand = c(0, 0), date_breaks = "month",
               date_minor_breaks = "day", 
               labels = c(
                 'Jan',
                 'Feb',
                 'Mar',
                 'Apr',
                 'May',
                 'Jun',
                 'Jul',
                 'Aug',
                 'Sept',
                 'Oct',
                 'Nov',
                 'Dec',
                 ''))

ufo.ridge +  
  theme(
    axis.text = element_text(size = 11)
  ) + theme(panel.grid.minor.x = element_blank(), 
            axis.line.x = element_line(color = 'black'),
            panel.background = element_blank(), 
            plot.title = element_text(size = 18, face = "bold"),
            plot.subtitle = element_text(size = 14), 
            plot.caption = element_text(hjust = -.01, color = 'grey30', size = 10)
  ) + labs ( x = '' , y = '', title = 'Missile launch, "fireball", or UFO?',
             subtitle = "Reported UFO sightings by year (%), 1995-2018")

ggsave('plot2.png', width = 10, height = 6)
ggsave('plot2.eps', width = 10, height = 6, device = 'eps')
