namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs
{
    public class RoatpProvider
    {
        public RoatpProvider(string ukprn, string applicationType)
        {
            Ukprn = ukprn;
            ApplicationType = applicationType;
        }

        public string Ukprn { get; }

        public string ApplicationType { get; set; }

    }
}