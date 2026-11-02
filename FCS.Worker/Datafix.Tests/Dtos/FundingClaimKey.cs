namespace Datafix.Tests.Dtos
{
    public class FundingClaimKey
    {
        public string ClaimTypeName { get; set; }
        public string Period { get; set; }
        public string PeriodTypeCode { get; set; }
        public int VersionNumber { get; set; }
        public string OrganisationIdentifier { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is FundingClaimKey other)
            {
                return ClaimTypeName == other.ClaimTypeName &&
                       Period == other.Period &&
                       PeriodTypeCode == other.PeriodTypeCode &&
                       VersionNumber == other.VersionNumber &&
                       OrganisationIdentifier == other.OrganisationIdentifier;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return ClaimTypeName.GetHashCode() ^
                   Period.GetHashCode() ^
                   PeriodTypeCode.GetHashCode() ^
                   VersionNumber.GetHashCode() ^
                   OrganisationIdentifier.GetHashCode();
        }
    }
}
