namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System;
    using System.Threading.Tasks;
    using System.Xml.Schema;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class FcrPublisher : IFcrPublisher
    {
        private const string AssemblyName = "CrossDomain.Integration.Entities.dll";
        private const string EmbeddedResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0.FundingClaimReconciliation.xsd";
        private const string SchemaNamespace = "urn:sfa:schemas:FCReconciliation";

        private readonly IAtomFeedItemRepository _atomFeedItemRepository;
        private readonly IDateProvider _dateProvider;

        public FcrPublisher(
            IAtomFeedItemRepository atomFeedItemRepository,
            IDateProvider dateProvider)
        {
            _atomFeedItemRepository = atomFeedItemRepository;
            _dateProvider = dateProvider;
        }

        public async Task<FcrPublishResult> PublishToFeed(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation)
        {
            DateTime statusLastUpdated = _dateProvider.GetDate(connectionInfo);

            fundingClaimReconciliation.Status = ReconciliationStatus.Published;
            fundingClaimReconciliation.StatusLastUpdatedDate = statusLastUpdated;

            FCReconciliation fundingClaimCorpSchema = FundingClaimReconciliationTransformer.ToCorpSchema(fundingClaimReconciliation);

            string fundingClaimXml = fundingClaimCorpSchema.SerializeToXml();

            bool isXmlValid = SchemaValidator.IsValid(
                assemblyName: AssemblyName,
                schemaResource: EmbeddedResourceName,
                schemaNameSpace: SchemaNamespace,
                xmlToValidate: fundingClaimXml);

            if (!isXmlValid)
            {
                throw new XmlSchemaValidationException("Funding Claim Reconciliation Xml Validation has failed");
            }

            bool isDuplicate = false;
            try
            {
                AtomFeedItem atomFeedItem = new AtomFeedItem(
                    atomItemType: AtomItemType.Published,
                    ukPrn: fundingClaimReconciliation.Contractor.UKPRN,
                    claimTypeName: fundingClaimReconciliation.ClaimType.ClaimTypeName,
                    allocationGroupName: fundingClaimReconciliation.AllocationGroup.AllocationGroupName,
                    period: fundingClaimReconciliation.Period.PeriodYear,
                    atomFeedItemXml: fundingClaimXml,
                    createdDate: statusLastUpdated);

                await _atomFeedItemRepository.Add(connectionInfo, atomFeedItem)
                    .ConfigureAwait(false);
            }
            catch (DuplicateKeyStorageException)
            {
                AtomFeedItem duplicateAtomItem = await _atomFeedItemRepository.GetByUkprnClaimTypeAllocationGroupAndPeriod(
                    connectionInfo: connectionInfo,
                    ukprn: fundingClaimReconciliation.Contractor.UKPRN,
                    claimTypeName: fundingClaimReconciliation.ClaimType.ClaimTypeName,
                    allocationGroup: fundingClaimReconciliation.AllocationGroup.AllocationGroupName,
                    period: fundingClaimReconciliation.Period.PeriodYear)
                    .ConfigureAwait(false);

                isDuplicate = true;
                statusLastUpdated = duplicateAtomItem.CreatedDate;
            }

            return new FcrPublishResult(
                isAtomFeedDuplicate: isDuplicate,
                publishedDate: statusLastUpdated,
                contractInfo: fundingClaimReconciliation.ToContractInfo());
        }

        public FcrPublishResult PublishManually(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation)
        {
            DateTime statusLastUpdated = _dateProvider.GetDate(connectionInfo);

            fundingClaimReconciliation.Status = ReconciliationStatus.Published;
            fundingClaimReconciliation.StatusLastUpdatedDate = statusLastUpdated;

            return new FcrPublishResult(
                isAtomFeedDuplicate: false,
                publishedDate: statusLastUpdated,
                contractInfo: fundingClaimReconciliation.ToContractInfo());
        }
    }
}
