namespace ContractRequestDomain.Cfs.Infrastructure
{
    using ContractRequestDomain.Cfs.Common.Dtos;
    using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;

    public class CfsStubEntity : TableEntity
    {
        public int StubId { get; set; }

        public string AllocationId { get; set; }

        public int VersionNumber { get; set; }

        public int Ukprn { get; set; }

        public string SerializedAllocation { get; set; }

        public static CfsStubEntity Create(int stubId, string allocationId, int version, int ukprn, Allocation allocation)
        {
            CfsStubEntity stubEntity = new CfsStubEntity
            {
                PartitionKey = allocationId,
                RowKey = version.ToString(),
                Ukprn = ukprn,
                AllocationId = allocationId,
                VersionNumber = version,
                SerializedAllocation = JsonConvert.SerializeObject(allocation),
                StubId = stubId
            };

            return stubEntity;
        }
    }
}
