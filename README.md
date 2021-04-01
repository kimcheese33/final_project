# Final Project: Probing the Relationship Between Education and Homlessness in the USA
Authors: Kim Horany, Roy Mojica, Lawrence Watson

## Presentation

### Separation of Duties


|  Segment  |  Kim Horany  |  Roy Mojica  |  Lawrence Watson  |
| --------- | ------------ | ------------ | ----------------- |
|  1        | Presentation & Github | Machine Learning |   Database |
|  2        | Machine Learning | Database |   Dashboard & Presentation |


### Summary

- Topic: Predicting the severity of homelessness in the United states and how it correlates with education by examining relationship between the two in each state. 

- Why topic was selected: We think it would be interesting to see if we could predict how severe the homeless situation will be based on existing homelessness data and data about education in that state. The hope is to collect data that will allow us to make accurate projections on the number of homeless in a State based on educational trends.

### Data Source

We are using two CSVs which we pulled from Kaggle.com. The first dataset, 2007-2016_Homelessness_USA.csv, contains counts of homeless by state, Continuum of Care (CoC), and by severity of homelessness. The second dataset, state_all.csv, contains education data such as, counts of individuals by state, year, grade level, and math/reading scores.

### Questions to Answer

- What will the severity level of homelessness be next year?

- How does education level affect homelessness?

## Communication Protocols


- Slack

- Zoom Meetings

- Email

## Process

### Segment 1

### Segment 2

#### Machine Learning 

1. Description of preliminary data preprocessing:

   - Homeless Dataset

     - Read raw data from CSV

     - Drop unneeded columns – we decided that the shelter name was not relevant to the data

     - Create a key column that will allow us to join to the education dataset

       - Extract year from Year column

       - Concatenate year with state, ex: 2007_AK

     - Create bins for the Measures column to reduce the categories to either Sheltered, Unsheltered, or Other

     - Drop original Measures column

     - Group by State_Year, Year, State, Groups to aggregate the Count

     - Flatten the table so that each year/state will have one record

       - Create 3 columns: Sheltered_Cnt, Unsheltered_Cnt, Other_Cnt and store count under appropriate column

   - Education dataset

     - Read raw data from CSV

     - Drop unneeded columns - columns with too many null values

     - Create a key column that will allow us to join to homeless dataset

       - Convert long state name to abbreviated state: ALASKA --> AK

       - Concatenate year with state, ex: 2007_AK

     - Replace NaN with zeros

     - Convert floats to int

       - Merged dataset

     - Join homeless dataset and education dataset on the key: state_year

     - Drop duplicate columns

     - Reorder columns so the count columns are at the end

     - Encode State column with get_dummies

     - Use Standard Scaler on the X features

2. Description of preliminary feature engineering and preliminary feature selection, including their decision making process:

   - Preliminary feature engineering includes reducing the 20+ Measures categories to just 3 categories, scaling the features using Standard Scaler, and encoding the categorical column (State) using get_dummies. We chose the features to be the state, year, total state revenue, total state expenditure, number of students in high school, and number of students in all grades to be the features. We wanted to see if this combination of columns could be used to accurately predict homeless counts for subsequent years.

3. Description of how data was split into training and testing sets:

   - Data was split into training and testing sets using sklearn's train_test_split. We used the default split values.

4. Explanation of model choice, including limitations and benefits:

   - We chose a multivariate multiple regression model, because we had more than two independent variables, more than one dependent variable, and we wanted to predict a continuous value. The benefits of multivariate regression is that we can get a more realistic picture than when just observing one dependent variable. This technique can also provide a more powerful test of significance than typical multiple regression. A limitation of multivariate analysis  is that you need to have large datasets to overcome high standard errors. Our dataset may not be large enough to overcome this limitation.
   - To determine whether this model is a good fit, I got the R-squared score, which was 97.8%. This indicates a good fit. However, it may not be accurate, because our dataset might not be big enough to overcome the limitations of using a multivariate regression model. Despite this limitation we decided to use this statistic, because R-squared shows the fraction of the variance between values predicted and the value rather than the mean of the actual.
