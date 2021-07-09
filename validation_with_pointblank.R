# Hello World introduction to data validation with the Pointblank package
library(pointblank) 
library(tidyverse) 
library(renv)

glimpse(small_table)

# -----
agent <- 
  create_agent(
    tbl = small_table,
    tbl_name = "small_table"
  )
agent

# -----
agent_prepped <- agent %>% 
  col_is_posix(vars(date_time)) %>%   # checking if the column "date_time" is actually of class "date_time"
  col_vals_in_set(vars(f), set = c("low", "mid", "high")) %>% # check if column "f" contains only those 3 values
  col_vals_lt(vars(a), value = 10) %>%  # check if column "a" has values all less than  10
  col_vals_regex(vars(b), regex = "^[0-9]-[a-z]{3}-[0-9]{3}$") %>%  # check if column "b" has values that all match the regular expression defined here
  col_vals_between(vars(d), left = 0, right = 5000)  # check if column "d" has values between 0 and 5000
agent_prepped

# -----
agent_done <- agent_prepped %>% interrogate()
agent_done

# -----
get_data_extracts(agent_done, i = 5)

# ----
agent <- 
  create_agent(
    tbl = small_table,
    tbl_name = "small_table",
    actions = action_levels(warn_at = 0.1, stop_at = 0.2)  # NEW! We're defining the thresholds to Warn and Stop
  ) %>%
  col_is_posix(vars(date_time)) %>%
  col_vals_in_set(vars(f), set = c("low", "mid")) %>%  # NEW! we've changed this question so it will fail more now
  col_vals_lt(vars(a), value = 7) %>%   # NEW! we've changed this question so it will fail now
  col_vals_regex(vars(b), regex = "^[0-9]-[a-w]{3}-[2-9]{3}$") %>%
  col_vals_between(vars(d), left = 0, right = 4000) %>%  # NEW! we've changed this question so it will fail now
  interrogate()
agent
