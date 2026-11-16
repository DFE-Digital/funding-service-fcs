namespace OrganisationDomain.Implementation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Azure;
    using Azure.Data.Tables;
    using Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class OrgSupplementaryDataServiceTestImpl : IOrgSupplementaryDataService
    {
        private const string PartitionKey = "UkrlpStubPartitionKey";
        private const string UkrpnPrefixForException = "9999";
        private const string UnSuffixedTableName = "UkrlpStub";

        private readonly IAzureTableStore _azureTableStore;
        private readonly string _environmentSuffixedTableName;

        public OrgSupplementaryDataServiceTestImpl(IAzureTableStore azureTableStore)
        {
            _azureTableStore = azureTableStore;
            _environmentSuffixedTableName =
                $"{UnSuffixedTableName}{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
        }

        public async Task<OrgSupplementaryDataServiceResult> GetDataForUkprn(int ukprn)
        {
            UkrlpStubEntity stubStorageOrganisation =
                _azureTableStore.GetRow<UkrlpStubEntity>(
                    _environmentSuffixedTableName,
                    PartitionKey,
                    ukprn.ToString());


            if (stubStorageOrganisation != null)
            {
                return new OrgSupplementaryDataServiceResult(
                    stubStorageOrganisation.CompanyNumber,
                    stubStorageOrganisation.CharityNumber,
                    true)
                {
                    LegalAddress = new OrgSupplementaryDataServiceResult.Address
                    {
                        Line1 = stubStorageOrganisation.AddressLine1,
                        Line2 = stubStorageOrganisation.AddressLine2,
                        Line3 = stubStorageOrganisation.AddressLine3,
                        Line4 = stubStorageOrganisation.AddressLine4,
                        Town = stubStorageOrganisation.Town,
                        County = stubStorageOrganisation.County,
                        Postcode = stubStorageOrganisation.Postcode
                    }
                };
            }

            if (WillUkprnFail(ukprn))
            {
                return new OrgSupplementaryDataServiceResult(
                    companyRegNumber: null,
                    charityNumber: null,
                    isSuccessful: false);
            }

            return new OrgSupplementaryDataServiceResult(
                companyRegNumber: null,
                charityNumber: null,
                isSuccessful: true);
        }

        public async Task<IReadOnlyCollection<OrgSupplementaryData>> GetSupplementaryDataChanges(int numberOfDaysToCheck = -7)
        {
            _azureTableStore.CreateTableIfNotExists(_environmentSuffixedTableName);

            return _azureTableStore
                .GetRows<UkrlpStubEntity>(_environmentSuffixedTableName)
                .Select(e => new OrgSupplementaryData(
                    e.Ukprn,
                    e.CompanyNumber,
                    e.CharityNumber,
                    new OrgSupplementaryAddress
                    {
                        Line1 = e.AddressLine1,
                        Line2 = e.AddressLine2,
                        Line3 = e.AddressLine3,
                        Line4 = e.AddressLine4,
                        Town = e.Town,
                        County = e.County,
                        Postcode = e.Postcode
                    }))
                .ToList();
        }

        private static bool WillUkprnFail(int ukprn)
        {
            return ukprn.ToString().StartsWith(UkrpnPrefixForException);
        }

        /// <summary>
        /// Azure Table entity (must implement ITableEntity for Azure.Data.Tables)
        /// </summary>
        private class UkrlpStubEntity : ITableEntity
        {
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }
            public ETag ETag { get; set; }

            public int Ukprn { get; set; }

            public string CompanyNumber { get; set; }

            public string CharityNumber { get; set; }

            public string AddressLine1 { get; set; }

            public string AddressLine2 { get; set; }

            public string AddressLine3 { get; set; }

            public string AddressLine4 { get; set; }

            public string Town { get; set; }

            public string County { get; set; }

            public string Postcode { get; set; }
        }
    }
}