namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractCreateDomain.Endpoint.Services;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractEnrichmentService : IContractEnrichmentService
    {
        private readonly ILogger _logger;
        private readonly ISiblingApprovedContractService _siblingApprovedContractService;
        private readonly IRelatedAllocationEnricher _relatedAllocationEnricher;

        public ContractEnrichmentService(
            ILogger logger,
            ISiblingApprovedContractService siblingApprovedContractService,
            IRelatedAllocationEnricher relatedAllocationEnricher)
        {
            _logger = logger;
            _siblingApprovedContractService = siblingApprovedContractService;
            _relatedAllocationEnricher = relatedAllocationEnricher;
        }

        public async Task EnrichContractWithOrganisationData(
            Contract corporateContract,
            string masterContractNumber,
            ConnectionInfo connectionInfo,
            Func<int, organisation> getOrganisation)
        {
            await EnrichWithSharedMasterApprovedContracts(masterContractNumber, corporateContract, connectionInfo);

            EnrichContractor(corporateContract.contractor, getOrganisation(corporateContract.contractor.ukprn));
            EnrichAllocationsThatHaveDeliveryOrgs(corporateContract.contractAllocations, getOrganisation);
        }

        private async Task EnrichWithSharedMasterApprovedContracts(string masterContractNumber, Contract corporateContract, ConnectionInfo connectionInfo)
        {
            var siblingApprovedContractInfo = await _siblingApprovedContractService.GetSiblingApprovedContractsForDocumentGeneration(
                masterContractNumber: masterContractNumber,
                corporateContract.contractNumber,
                fundingTypeCode: corporateContract.fundingType.fundingTypeCode,
                fundingPeriod: corporateContract.GetFundingPeriod(),
                connectionInfo: connectionInfo);

            corporateContract.SharedMasterApprovedContracts = siblingApprovedContractInfo.ToList();
            corporateContract.SharedMasterApprovedContracts.ForEach(_relatedAllocationEnricher.EnrichWithRelatedAllocationsWhenAppropriate);
        }

        private void EnrichAllocationsThatHaveDeliveryOrgs(IReadOnlyCollection<contractAllocationsContractAllocation> contractAllocations, Func<int, organisation> getOrganisation)
        {
            var contractAllocationsWithDeliveryOrgs = contractAllocations
                .Where(a => a.DeliveryOrganisation.HasValue())
                .ToList();

            contractAllocationsWithDeliveryOrgs.ForEach(a =>
            {
                int ukprn = int.Parse(a.DeliveryOrganisation);
                organisation deliveryOrg = getOrganisation(ukprn);

                EnrichContractor(a.DeliveryOrganisationDetail, deliveryOrg);
                a.DeliveryOrganisationDetail.ukprn = ukprn;
            });
        }

        private void EnrichContractor(Contractor contractor, organisation organisation)
        {
            if (organisation != null)
            {
                var orgName =
                organisation.organisationNames.FirstOrDefault(o => o.organisationNameType == organisationNameType.LEGAL);
                if (orgName != null)
                {
                    _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractEnrichmentServiceLegalNameAdded, $"Organisation enriched with name from Org Service: {orgName.organisationName}");
                    contractor.legalName = orgName.organisationName;
                }

                var orgStatus =
                organisation.organisationStatusRelationships.FirstOrDefault(o => o.organisationStatus.organisationStatusScheme == organisationStatusSchemeType.LEGAL);
                if (orgStatus != null)
                {
                    contractor.Status = orgStatus.organisationStatus.organisationStatus;
                }

                if (organisation.organisationAddresses != null && organisation.organisationAddresses.Count > 0)
                {
                    // for the moment take the first address
                    PopulateContractorAddress(contractor, organisation.organisationAddresses[0]);
                }

                contractor.Upin = GetUpinFromOrganisation(organisation);

                contractor.organisationIdentifier = organisation.organisationId;

                contractor.registeredCompanyNumber =
                    organisation.organisationIdentifiers.FirstOrDefault(
                        oi => oi.organisationIdentifierType == organisationIdentifierType.COMPANYREGISTRATIONNUMBER)
                                ?.organisationIdentifier;

                contractor.CharityNumber =
                   organisation.organisationIdentifiers.FirstOrDefault(
                       oi => oi.organisationIdentifierType == organisationIdentifierType.CHARITYNUMBER)
                               ?.organisationIdentifier;
            }
        }

        private string GetUpinFromOrganisation(organisation organisation)
        {
            string upin = organisation.organisationIdentifiers.FirstOrDefault(
                oi => oi.organisationIdentifierType == organisationIdentifierType.UPIN)
                ?.organisationIdentifier;

            if (upin == null)
            {
                throw new ArgumentException($"The organisation object for organisationId - {organisation.organisationId} does not contain a Upin");
            }

            return upin;
        }

        private void PopulateContractorAddress(Contractor contractor, organisationAddressesOrganisationAddress address)
        {
            contractor.addressLine1 = address.addressLine1;
            contractor.addressLine2 = address.addressLine2;
            contractor.addressLine3 = address.addressLine3;
            contractor.addressLine4 = address.addressLine4;
            contractor.town = address.town;
            contractor.county = address.county;
            contractor.postcode = address.postcode;
        }
    }
}
