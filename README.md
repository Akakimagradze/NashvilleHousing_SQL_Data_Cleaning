# Nashville Housing Data Cleaning
    This repository contains an SQL script for cleaning and processing
    the Nashville Housing dataset. The script performs various data cleaning tasks
    such as populating missing addresses, breaking out address components,
    standardizing date formats, and removing duplicates.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Overview
    The SQL script performs the following tasks:

    1. Populate Property Address Data:
       * Fills missing PropertyAddress values using ParcelID.

    2. Break Out Address Into Individual Columns:
       * Extracts and splits PropertyAddress into PropertySplitAddress and PropertySplitCity.
       * Uses PARSENAME to parse OwnerAddress into ParsedAddress, ParsedCity, and ParsedState.
       
    3. Standardize Column Values:
       * Converts 'Y' and 'N' in SoldAsVacant to 'Yes' and 'No'.

    4. Remove Duplicates:
       * Identifies and removes duplicate records based on specific columns.

    5. Standardize Date Format:
       * Converts SaleDate to a standardized date format (SaleDateConverted).
       
    6. Drop Unused Columns:
       * Removes unnecessary columns to streamline the dataset.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Usage
    To use the script, run it in your SQL environment. Ensure that the NashvilleHousing table
    is properly set up and contains the necessary columns.
    The script will perform the data cleaning operations as described.
