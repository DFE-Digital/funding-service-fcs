namespace ContractCreateDomain.Endpoint.Extensions
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public static class OrganisationExtensions
    {
        public static ContractOrganisation ToContractOrganisation(
            this SFA.FCT.CrossDomain.Integration.Entities.organisation organisation)
        {
            var charityNumber = organisation.GetIdentifierValue(organisationIdentifierType.CHARITYNUMBER);
            var companyNumber = organisation.GetIdentifierValue(organisationIdentifierType.COMPANYREGISTRATIONNUMBER);
            var schemaAddress = organisation.organisationAddresses.SingleOrDefault();
            var name = organisation.organisationNames.Single().organisationName;
            var upin = organisation.GetIdentifierValue(organisationIdentifierType.UPIN);
            var ukprn = organisation.GetIdentifierValue(organisationIdentifierType.UKPROVIDERREFERENCENUMBER);
            var status = organisation.organisationStatusRelationships
                .Single(s => s.organisationStatus.organisationStatusScheme == organisationStatusSchemeType.LEGAL)
                .organisationStatus.organisationStatus;
            var type = organisation.organisationTypeRelationships
                .SingleOrDefault(r => r.organisationType.organisationTypeScheme == organisationTypeSchemeType.CORPORATE)
                ?.organisationType?.organisationType;

            return new ContractOrganisation
            {
                CharityNumber = charityNumber,
                CompanyNumber = companyNumber,
                Address = schemaAddress?.ToAddress() ?? new Address(),
                Name = name,
                OrganisationId = organisation.organisationId,
                UKPRN = ukprn,
                Status = status,
                Type = type,
                Upin = upin
            };
        }

        private static string GetIdentifierValue(this SFA.FCT.CrossDomain.Integration.Entities.organisation organisation, organisationIdentifierType type)
        {
            return organisation.organisationIdentifiers
                .SingleOrDefault(o => o.organisationIdentifierType == type)
                ?.organisationIdentifier;
        }
    }
}
