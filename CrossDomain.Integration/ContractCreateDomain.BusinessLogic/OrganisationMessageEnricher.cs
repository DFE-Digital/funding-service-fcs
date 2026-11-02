namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Services;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using MoreLinq;

    public class OrganisationMessageEnricher : IOrganisationMessageEnricher
    {
        public OrganisationMessageEnricher()
        {
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public IOrganisationService OrganisationService { get; set; }

        public void Enrich(contractRequestType masterContract)
        {
            OrganisationServiceCache organisationServiceCache = new OrganisationServiceCache(OrganisationService);

            // the masterContract and contract will have the same contractor info
            organisation organisation = organisationServiceCache.GetOrganisationForUkprn(masterContract.contract.contractor.ukprn);

            Enrich(masterContract.contract.contractor, organisation);
            masterContract.contract.contracts.ForEach(c => Enrich(c.contractor, organisation));

            // the allocations can have delivery orgs so enrich where appropriate
            EnrichAllocationsThatHaveDeliveryOrgs(masterContract.contract.contracts.SelectMany(c => c.contractAllocations).ToList(), organisationServiceCache);
        }

        private void EnrichAllocationsThatHaveDeliveryOrgs(IReadOnlyCollection<contractAllocation> contractAllocations, OrganisationServiceCache organisationServiceCache)
        {
            IReadOnlyCollection<contractAllocation> contractAllocationsWithDeliveryOrgs = contractAllocations
               .Where(a => a.HasDeliveryOrganisation())
               .ToList();

            contractAllocationsWithDeliveryOrgs.ForEach(a =>
            {
                int ukprn = int.Parse(a.DeliveryOrganisation);
                organisation deliveryOrg = organisationServiceCache.GetOrganisationForUkprn(ukprn);

                Enrich(a.DeliveryOrganisationDetail, deliveryOrg);
                a.DeliveryOrganisationDetail.ukprn = ukprn;
            });
        }

        private void Enrich(contractor contractor, organisation organisation)
        {
            if (organisation != null)
            {
                var orgName =
                organisation.organisationNames.FirstOrDefault(o => o.organisationNameType == organisationNameType.LEGAL);
                if (orgName != null)
                {
                    Logger.LogInformation(ContractCreateDomainEventLoggingId.OrganisationMessageEnricher, "Organisation enriched with name from Org Service: {0}", orgName.organisationName);
                    contractor.legalName = orgName.organisationName;
                }

                var orgStatus =
                organisation.organisationStatusRelationships.FirstOrDefault(o => o.organisationStatus.organisationStatusScheme == organisationStatusSchemeType.LEGAL);
                if (orgStatus != null)
                {
                    contractor.organisationStatus = orgStatus.organisationStatus.organisationStatus;
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

        private void PopulateContractorAddress(contractor contractor, organisationAddressesOrganisationAddress address)
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
