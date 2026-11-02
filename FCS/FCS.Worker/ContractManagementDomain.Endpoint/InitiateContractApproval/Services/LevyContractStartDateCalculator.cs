namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Services
{
    using System;

    public static class LevyContractStartDateCalculator
    {
        private const int PostApril2020StartingContractNumber = 5000;
        private static readonly DateTime FirstDayAfterOriginalContractNoticePeriod = new DateTime(2020, 04, 07, 0, 0, 0, DateTimeKind.Utc);
        private static readonly DateTime LastDayOfMarch = new DateTime(2020, 03, 31, 0, 0, 0, DateTimeKind.Utc);

        public static DateTime GetStartDate(string contractNumber, DateTime currentUtcDate)
        {
            if (IsPostMarch2020Contract(contractNumber) && IsBeforeEndOfOriginalContractTerminationNoticePeriod(currentUtcDate))
            {
                return LastDayOfMarch;
            }

            return currentUtcDate;
        }

        private static bool IsPostMarch2020Contract(string contractNumber)
        {
            int contractNumberInteger = int.Parse(contractNumber.Split('-')[1]);

            return contractNumberInteger >= PostApril2020StartingContractNumber;
        }

        private static bool IsBeforeEndOfOriginalContractTerminationNoticePeriod(DateTime currentUtcDate)
        {
            return currentUtcDate < FirstDayAfterOriginalContractNoticePeriod;
        }
    }
}
