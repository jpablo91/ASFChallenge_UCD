library(janitor)
library(dataCompareR)

df1 = read.csv("Data/Period_1/herds_day_50.csv",
               stringsAsFactors = FALSE)

df2 = read.csv("Data/Period_2/herds_day_80.csv",
               stringsAsFactors = FALSE)

# Column names
all.equal(names(df1), names(df2))

# Data
all.equal(df1, df2)

compare_df_cols(df1, df2, return = "mismatch")

comp_df = rCompare(df1, df2)
summary(comp_df)

dim(df1)
dim(df2)

tail(df1)
tail(df2)


# visdat::vis_compare(df1, df2)

# ==============================================================================
# 
# The new dataset has 4 extra rows, while the rest of the data (previous rows)
# is the same: 4533 rows corresponding to individual herds.
# 
# ==============================================================================
