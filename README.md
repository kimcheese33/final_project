# Final Project: Probing the Relationship Between Education and Homlessness in the USA
Authors: Kim Horany, Roy Mojica, Lawrence Watson

## Separation of Duties


|  Segment  |  Kim Horany  |  Roy Mojica  |  Lawrence Watson  |
| --------- | ------------ | ------------ | ----------------- |
|  1        | Presentation & Github | Machine Learning |   Database |
|  2        | Machine Learning | Database |   Dashboard & Presentation |


## Summary

- Topic: Predicting the severity of homelessness in the United states and how it correlates with education by examining relationship between the two in each state. 

- Why topic was selected: The swift and unexpected onset of a global health crisis in 2020 led many states to issue stay-at-home orders to curtail the rate of infection.  Without homes to retreat to, our homeless population was most vulnerable during the pandemic. We may not be able to predict or control the next devastating public health crisis, but is there an aspect to homelessness that we might govern to reduce the size of those affected? That is what we hope to discover.  With the focus on education, an area in which there is plenty of data, we hope to discove a method to make accurate projections on the number of homeless in a State.

## Data Source

We are using two CSVs which we pulled from Kaggle.com. The first dataset, 2007-2016_Homelessness_USA.csv, contains counts of homeless by state, Continuum of Care (CoC), and by severity of homelessness. The second dataset, state_all.csv, contains education data such as, counts of individuals by state, year, grade level, and math/reading scores.

## Questions to Answer

- What will the severity level of homelessness be next year?

- How does education level affect homelessness?

## Presentation

[Google Slides Presentation](https://docs.google.com/presentation/d/1qcjNdUe6113w7axp-y-amXODMnWzwdU2P95df5-UpWs/edit?usp=sharing)


[Dashboard Link](https://public.tableau.com/profile/lawrence.watson#!/vizhome/EducationandHomlessnessintheUSA/Dashboard1?publish=yes)

## Communication Protocols

- Slack

- Zoom Meetings

- Email

## Process

### Segment 1

#### Machine Learning Model

1. Takes in data from the provisional database using the "ML_Model_Draft" file. Tested connection using "psycopg2 successfully with test postgres server created by Lawrence.

2. Outputs counts we will use for "y" or label values for machine learning model.

#### Database Integration

1. Produce sample data that mimics the expected final database structure or schema:

   - ERD for sample database was completed with the integration of our two primary datasets in mind (DB_structure.png).
   - Created tables to house the DBs with querries in postgreSQL11 and exported the tables (Decade_Homelessness.sql & Education_by_state.sql).
   - Drafted a list of suggested edits to our datasets for the preprocessing phase (DB_prospective_edits).
 
2. Confirm draft machine learning model is connected to the provisional database:

   - Successfully connected provisional DB to the drafted model (ML_Model_Draft.ipynb) and took a picture of returned connection (database_connection.png).


### Segment 2

#### Machine Learning Model

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

#### Database Intergration

1. Database stores static data though the "db_creator.py" file by taking the CSV that were created from the data cleaning/processing file.

2. Database interfaces with the project by connecting to the machine learning file using "psycopg2"
   - Includes the tables for "homeless_processed" and "education_processed" CSVs.
   - Created an INNER JOIN through Postgres and included the querey code in "querey.txt" file.
   - Includes the SQLAlchemy connection string "db_creator.py"
 
 3. ERD is saved in the "homeless_erd.PNG" file.

#### Dashboard

1. Dashboard created using Tableau Public.
   - proccessed & joined data is exported to .csv format for connection to Tableau.
      - Further manipulation of data required (calculated field may suffice) to collate state data into single column.

2. Blueprint for vizualizations 
   - Bubble Chart
      - Values: Y - Total Expenditure (10 year period), X - Grades All (10 year period), Bubble - Total Homeless per State
      - Description: Total homeless value as a percentage of State population is represented w/ dimensions of bubble labeled by State. Bubbles are plotted on a graph that shows how much money was spent on education and the aggregate k-12 grades. Will help identify which states are spending the most on education and whether or not it has an impact on the homeless population.
    - Heat Maps
         - Values: X -Years, Y - States, Heat Value - Total Homeless
         - Description: A heat map to display the homeless population in each state for every year 2007-2016. If a state's homeless population is trending downward over time, it will be represented.
    - Interactive Element
         - Description: Map of the United States displaying where each state is colored with a heat value to represent either Homelessness, Educational Spending, or k-12 grade performance. A button will be used to select between the three values. A slider at the map's edge will be used to select the year 2006-2017.

3. Tableau Story, minus vizualizations, integrated into Google Slides presentation.

