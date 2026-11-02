namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Services
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    public static class AllocationActualsMapper
    {
        public static ContractAllocationActualsType Map(
            AllocationDeliverablePeriodActualAudit actualAudit,
            List<ActualsSummaryType> actualsSummary)
        {
            return new ContractAllocationActualsType
            {
                ActualsSummary = actualsSummary,
                CollectionReturnCode = actualAudit.CollectionReturnCode,
                CollectionType = actualAudit.CollectionType,
                ContractAllocationNumber = actualAudit.ContractAllocationNumber,
                ContractReference = new ContractReferenceType
                {
                    ContractNumber = actualAudit.ContractNumber,
                    ContractVersionNumber = actualAudit.ContractVersion,
                    ContractSubVersionNumber = actualAudit.ContractSubVersion
                },
                ContractorReference = new OrganisationReferenceType
                {
                    OrganisationIdentifier = actualAudit.OrganisationId,
                    AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                    {
                        new organisationIdentifiersOrganisationIdentifier
                        {
                            organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                            organisationIdentifier = actualAudit.Ukprn
                        }
                    }
                },
                FundingStreamPeriodCode = actualAudit.FundingStreamPeriodCode,
                UoPCode = actualAudit.UopCode
            };
        }
    }
}