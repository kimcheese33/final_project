# Final Project: Probing the Relationship Between Education and Homlessness in the USA
Authors: Kim Horany, Roy Mojica, Lawrence Watson

## Separation of Duties


|  Segment  |  Kim Horany  |  Roy Mojica  |  Lawrence Watson  |
| --------- | ------------ | ------------ | ----------------- |
|  1        | Presentation & Github | Machine Learning |   Database |
|  2        | Machine Learning | Database |   Dashboard & Presentation |
|  3        | Github | Presentation | Dashboard |


## Summary

- Topic: Predicting the severity of homelessness in the United states and how it correlates with education by examining relationship between the two in each state. 

- Why topic was selected: The swift and unexpected onset of a global health crisis in 2020 led many states to issue stay-at-home orders to curtail the rate of infection.  Without homes to retreat to, our homeless population was most vulnerable during the pandemic. We may not be able to predict or control the next devastating public health crisis, but is there an aspect to homelessness that we might govern to reduce the size of those affected? That is what we hope to discover.  With the focus on education, an area in which there is plenty of data, we hope to discove a method to make accurate projections on the number of homeless in a State.

## Data Source

We are using two CSVs which we pulled from Kaggle.com. The first dataset, 2007-2016_Homelessness_USA.csv, contains counts of homeless by state, Continuum of Care (CoC), and severity of homelessness. The second dataset, state_all.csv, contains education data such as, counts of individuals by state, year, grade level, and math/reading scores. Both raw datasets are stored here: Machine Learning > Resources > Raw

## Questions to Answer

- What will the severity level of homelessness be next year?

- How does education level affect homelessness?

## Presentation

[Google Slides Presentation](https://docs.google.com/presentation/d/1qcjNdUe6113w7axp-y-amXODMnWzwdU2P95df5-UpWs/edit?usp=sharing)


[Dashboard Link](https://public.tableau.com/profile/lawrence.watson#!/vizhome/FinalProject-HomlessnessEducationintheUSA/HomelessnessEduDash?publish=yes)

## Process

### Step 1: Data Exploration & Cleaning

Before diving into describing the Machine Learning model and the database, let's go over how we got the data ready for consumption. The code to do this is stored in the Machine Learning folder: clean_data.ipynb, preprocess_data.ipynb.

Description of preliminary data preprocessing:

   - Homeless Dataset

     - Read raw data from CSV

     - Drop unneeded columns – we decided that the shelter name (CoC) was not relevant to the data

     - Create a key column that will allow us to join to the education dataset

       - Extract year from Year column

       - Concatenate year with state, ex: 2007_AK

     - Create bins for the Measures column to reduce the large number of categories to three: Sheltered, Unsheltered, or Other

     - Drop original Measures column since it is no longer needed

     - Flatten the data so that we have a count column for all three categories: Sheltered_Cnt, Unsheltered_Cnt, Other_Cnt

     - Group the data by State_Year, Year, State to aggregate the counts

   - Education dataset

     - Read raw data from CSV

     - Drop unneeded columns - by checking null counts on the columns, we discovered these columns contained too many nulls: ENROLL, OTHER_EXPENDITURE, AVG_MATH_4_SCORE, AVG_MATH_8_SCORE, AVG_READING_4_SCORE, AVG_READING_8_SCORE. In addition, we decided to drop STATE_REVENUE, LOCAL_REVENUE, INSTRUCTION_EXPENDITURE, SUPPORT_SERVICES_EXPENDITURE, CAPITAL_OUTLAY_EXPENDITURE, GRADES_PK_G, GRADES_KG_G, GRADES_4_G, and GRADES_8_G to simplify the model and focus just on high school grade counts.

     - Create a key column that will allow us to join to homeless dataset

       - Convert long state name to abbreviated state: ALASKA --> AK

       - Concatenate year with state, ex: 2007_AK

     - Replace remaining NaN values with zeros

     - Convert floats to int

Cleaned Homeless Data:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/cleaned_homeless.png"/>

Cleaned Education Data:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/cleaned_education.png"/>

### Step 2: Build Database & Integrate 

To house our data, we built a database in Postgres. We created two tables: one to house the cleaned homeless data and the other to house the cleaned education data.

ERD:
<pic>

Create Table Statement:
<pic>

After we created our two tables, we knew that we wanted to join the data before feeding it to the machine learning model. For the join, we performed an inner join on the primary key column, State_Year, which is available in both tables. We stored this data in a table: homeless_edu.

Join & Table Creation Statement (found in Database folder, querey.txt):

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/join.png"/>

To integrate the data from our Postgres database, we imported psycopg2 then used the following code, which can also be found in the Machine Learning folder at the top of the machine_learning.ipynb file:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/connect_postgres.png"/>

### Step 3: Feature Engineering & Splitting the Data

Although the data has been cleaned, flattened, and merged, we still need to do a bit more preprocessing before it can be fed to the model. Preliminary feature engineering included reducing the 20+ Measures categories to just 3 categories as described above, encoding the categorical column (State) using get_dummies, and scaling the features using Standard Scaler. We chose the features for the model to be the State, Year, TOTAL_REVENUE, TOTAL_EXPENDITURE, GRADES_9_12_G, and GRADES_ALL_G columns to be the features. We wanted to see if this combination of columns could be used to accurately predict homeless counts for subsequent years. We also split the data into training and testing sets. The code for this can be found in the Machine Learning folder in the machine_learning.ipynb file.

To turn the categorical State column into a numerical value the model can use we used pd.get_dummies:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/get_dummies.png"/>

To split the data into training and testing sets we used sklearn's train_test_split. We used the default values to split the data (75% train, 25% test):

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/train_test_split.png"/>

To scale the data we used Standard Scaler from the sklearn library:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/standard_scaler.png"/>

### Step 4: Machine Learning Model

Now that we have our data ready, it's finally time to put together the model. The model we chose to use is  Multivariate Regression Model, because we are wanting to predict homeless sheltered, unsheltered, and other counts for subsequent years. A Multivariate Regression will allow us to generate a continuous value for three dependent variables (sheltered, unsheltered, other) with more than one independent variable (state, year, total revenue, total expenditure, grades 9-12, and all grades). The benefit of using a Multivariate Regression is that we can get a more realistic picture than when just observing one dependent variable. This technique can also provide a more powerful test of significance than a typical multiple regression. A limitation of Multivariate analysis is that you need to have large datasets to overcome high standard errors. Our dataset may not be large enough to overcome this limitation.

To determine whether this model is a good fit, we got the R-squared score, which was 97.8%. This indicates a good fit. However, it may not be accurate, because our dataset might not be big enough to overcome the limitations of using a Multivariate regression model. Despite this limitation we decided to use this statistic, because R-squared shows the fraction of the variance between values predicted and the value rather than the mean of the actual.

The code containing the machine learning model is located in the Machine Learning folder in a file called machine_learning.ipynb.

Model With Results & R_Squared Output:

<img src="https://github.com/kimcheese33/final_project/blob/horany/segment_3/Images/model.png"/>

### Step 5: Build Visualizations

The last step is to visualize the data and the results. We decided to build our visualizations with Tableau Public and publish the results to Tableau Public server (linked above). The visualizations are sourced from the processed_education.csv and processed_homeless.csv files (located at Machine Learning > Resources). The two data sources are then joined via an inner join on State_Year.

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

