﻿

CREATE TABLE "Education_by_State" (
    "PRIMARY_KEY" VARCHAR   NOT NULL,
    "STATE" TEXT   NOT NULL,
    "YEAR" INT   NOT NULL,
    "ENROLL" INT   NOT NULL,
    "TOTAL_REVENUE" INT   NOT NULL,
    "FEDERAL_REVENUE" INT   NOT NULL,
    "STATE_REVENUE" INT   NOT NULL,
    "LOCAL_REVENUE" INT   NOT NULL,
    "TOTAL_EXPENDITURE" INT   NOT NULL,
    "INSTRUCTION_EXPENDITURE" INT   NOT NULL,
    "SUPPORT_SERVICES_EXPENDITURE" INT   NOT NULL,
    "OTHER_EXPENDITURE" INT   NOT NULL,
    "CAPITAL_OUTLAY_EXPENDITURE" INT   NOT NULL,
    "GRADES_PK_G" INT   NULL,
    "GRADES_KG_G" INT   NOT NULL,
    "GRADES_4_G" INT   NOT NULL,
    "GRADES_8_G" INT   NOT NULL,
    "GRADES_12_G" INT   NOT NULL,
    "GRADES_1_8_G" INT   NOT NULL,
    "GRADES_9_12_G" INT   NOT NULL,
    "GRADES_ALL_G" INT   NOT NULL,
    "AVG_MATH_4_SCORE" INT   NULL,
    "AVG_MATH_8_SCORE" INT   NULL,
    "AVG_READING_4_SCORE" INT   NULL,
    "AVG_READING_8_SCORE" INT   NULL
);
