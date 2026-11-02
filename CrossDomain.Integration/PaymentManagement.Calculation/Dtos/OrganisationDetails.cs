namespace PaymentManagement.Calculation.Dtos
{
    public class OrganisationDetails
    {
        public OrganisationDetails(string organisationId, int ukprn)
        {
            OrganisationId = organisationId;
            Ukprn = ukprn;
        }

        public string OrganisationId { get; }

        public int Ukprn { get; }
    }
}
