namespace SFA.FCT.PerformanceManagementDomain.Common.Commands
{
    public class PullPageForPeriodClaimTypeCommand
    {
        public string PeriodClaimType { get; set; }

        public int PageNumber { get; set; }

        public static PullPageForPeriodClaimTypeCommand Create(string periodClaimType, int pageNumber)
        {
            return new PullPageForPeriodClaimTypeCommand
            {
                PeriodClaimType = periodClaimType,
                PageNumber = pageNumber
            };
        }

        public override string ToString()
        {
            return $"PeriodClaimType: {PeriodClaimType}, PageNumber: {PageNumber}";
        }
    }
}
