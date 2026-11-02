namespace FctServices.Deds.Entities
{
    using Microsoft.WindowsAzure.Storage.Table;
    public class FundingClaim : TableEntity
    {
        public FundingClaim()
        {
        }

        public FundingClaim(string fundingClaimXml, string period, string claimType)
        {
            PartitionKey = CreatePartitionKey(period, claimType);
            FundingClaimXml = fundingClaimXml;
        }

        public string FundingClaimXml { get; set; }

        public static string CreatePartitionKey(string period, string claimType)
        {
            return $"{period}-{claimType}";
        }
    }
}