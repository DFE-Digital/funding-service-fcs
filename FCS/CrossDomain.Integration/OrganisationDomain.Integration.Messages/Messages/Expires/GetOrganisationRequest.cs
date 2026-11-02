namespace OrganisationDomain.Integration.Messages.Messages.Expires
{
    public class GetOrganisationRequest
    {
        public string OrganisationId { get; set; }

        public int? Ukprn { get; set; }
    }
}
