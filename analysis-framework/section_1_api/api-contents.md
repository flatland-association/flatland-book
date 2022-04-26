# What does the API consist of

The API has two classes;

-   The `Level` class
-   The `AnalysisFramework` class

## 1. `Level` class:

The `Level` class contains methods that pertain to a single level. A `Level` class instance is created by providing the **submission_id**, **test_id** & **level_id**.

The level class can then return **logged raw level info** using certain methods that directly return the data contained within the json files, for the most part as a list of integers depending on the type of data. This is not of interest in context of analysis and only serves as a helper to be used by other methods in order to calculate derived metrics.

## 2. The `AnalysisFramework` class

The `AnalysisFramework` class provides two things:

1. Methods to fetch the **episode end data** and **action data** for a particular submission or submissions given the six-digit submission ID.
   This data is then cached locally and the tool can use the cached data to fetch metrics and other information out of it.
   The root folder can be specified by the user and the contents follow the given directory structure:

```
.
└── .flatland_analysis_data/
    ├── S12345/
    │   ├── actions/
    │   │   ├── Test_0/
    │   │   │   ├── Level_0.json
    │   │   │   ├── Level_1.json
    │   │   │   └── ...
    │   │   ├── ...
    │   │   ├── Test_N
    │   │   └── seed.yml
    │   └── data/
    │       ├── Test_0/
    │       │   ├── Level_0.json
    │       │   ├── Level_1.json
    │       │   └── ...
    │       ├── ...
    │       └── Test_N
    ├── S67890/
    │   ├── actions
    │   └── data
    └── ...
```

2. Methods to calculate a given list of metrics for either a **level**, an entire **test** or across the whole **submission**. The metrics returned for the test and the submission are the mean of the values returned for all levels under them.
