namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using Newtonsoft.Json;

    public static class CfsAllocationTransfomer
    {
        public static Allocation TransformToAllocation(string jsonStringAllocation)
        {
            dynamic jsonAllocation = JsonConvert.DeserializeObject(jsonStringAllocation);
           
            return new Allocation
            {
                Ukprn = jsonAllocation.provider.ukPrn,
                MajorVersion = jsonAllocation.allocationMajorVersion,
                MinorVersion = jsonAllocation.allocationMinorVersion,
                AllocationPeriods = ToAllocationPeriods(jsonAllocation.profilePeriods)
            };
        }

        private static List<AllocationPeriod> ToAllocationPeriods(dynamic jsonProfilePeriods)
        {
            List<AllocationPeriod> allocationPeriods = new List<AllocationPeriod>();

            foreach (dynamic jsonProfilePeriod in jsonProfilePeriods)
            {
                AllocationPeriod allocationPeriod = new AllocationPeriod
                {
                    Month = GetMonthNumberFromShortMonthString(jsonProfilePeriod.period.ToString()),
                    Period = GetPeriodFromProfilePeriod(jsonProfilePeriod.period.ToString(), jsonProfilePeriod.periodYear.ToString()),
                    Year = jsonProfilePeriod.periodYear,
                    ProfileValue = jsonProfilePeriod.profileValue
                };

                allocationPeriods.Add(allocationPeriod);
            }

            return allocationPeriods;
        }

        private static string GetPeriodFromProfilePeriod(string shortMonthString, string year)
        {
            return $"{shortMonthString}-{year.Substring(2, 2)}";
        }

        private static int GetMonthNumberFromShortMonthString(string shortMonthString)
        {
            return DateTime.ParseExact(shortMonthString, "MMM", CultureInfo.CurrentCulture).Month;
        } 
    }
}
