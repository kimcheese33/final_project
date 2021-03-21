-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/4xrPeG
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Decade_Homelessness" (
    "State" TEXT   NOT NULL,
    "Year" INT   NOT NULL,
    "CoC_Number" VARCHAR   NOT NULL,
    "CoC_Name" VARCHAR   NOT NULL,
    "Measures" TEXT   NOT NULL,
    "Count" INT   NOT NULL
);

CREATE TABLE "Education_by_State" (
    "Primary_Key" VARCHAR   NOT NULL,
    "State" TEXT   NOT NULL,
    "Year" INT   NOT NULL,
    "Total_Revenue" INT   NOT NULL,
    "Federal_Revenue" INT   NOT NULL,
    "State_Revenue" INT   NOT NULL,
    "Total_Expenditure" INT   NOT NULL,
    CONSTRAINT "pk_Education_by_State" PRIMARY KEY (
        "Primary_Key"
     )
);

ALTER TABLE "Decade_Homelessness" ADD CONSTRAINT "fk_Decade_Homelessness_State_Year" FOREIGN KEY("State", "Year")
REFERENCES "Education_by_State" ("State", "Year");

