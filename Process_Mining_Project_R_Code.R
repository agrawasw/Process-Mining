library(tidyverse)
library(bupaR)
library(eventdataR)
library(xesreadR)
library(edeaR)
library(processmapR)
library(processmonitR)
library(ggplot2)


data("patients")
class(patients)
patients
mapping(patients)

dim(patients)
str(patients)

activity_labels(patients)

activities(patients)

patients %>% n_activities

patients %>% n_cases
patients %>% n_traces
patients %>% n_resources

##Visualizations

activity_data <- activity_frequency(patients, level = "activity") %>% arrange(relative)# least common activity

#just for reordering and keeping Registration on first and Triage on second in the plot as both have same frequency of 500
activity_data$absolute[activity_data$handling == "Registration"] <- activity_data$absolute[activity_data$handling == "Registration"] + 1 
ggplot(activity_data, aes(x = absolute, y = reorder(handling,relative),fill = relative)) + geom_bar(stat = "identity", width = 0.7) + theme_bw()
#patients %>% activity_presence %>% plot
activity_data$absolute[activity_data$handling == "Registration"] <- activity_data$absolute[activity_data$handling == "Registration"] - 1 #reverted the changes

#Dot plot
dotted_chart(patients, "relative")
#patients %>% dotted_chart("relative")

#Precedence Matrix
patients %>%
  precedence_matrix(type = "absolute") %>%
  plot

#Trace Plot
patients %>% 
  trace_explorer(coverage = 1)

?trace_explorer

#Summary Statistics of processing times
processing_time(patients, #event log 
                "activity", # level of analysis, in this situation at level of activity
                units = "mins") #time units to be used

processing_time(patients, level = "log", units = "days")

#Process Model/map
patients %>% process_map(type = frequency("relative"))

?process_map

#Resources and number of activities assigned to each
patients %>%
  resource_specialisation("resource") %>% plot()

#Activities and number of resources assigned to each
patients %>%
  resource_specialisation("activity") %>% plot()

