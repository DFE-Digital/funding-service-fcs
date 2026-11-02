namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    public class Contractor
    {
        public string OrganisationIdentifier { get; set; }

        public int Ukprn { get; set; }

        public override string ToString()
        {
            return $"Ukprn: {Ukprn}";
        }
    }
}