namespace Datafix.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Text;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public static class AtomFeedItemRepository
    {
        public static IReadOnlyCollection<ChildContact> GetContracts()
        {
            return GetAtomFeedItems()
                .Select(ToContractFromBytes)
                .SelectMany(c => ToChildContracts(c.contract,c.atomInfo)).ToList();
        }

        public static IReadOnlyCollection<string> GetContractsAsXml(int startIndex, int endIndex)
        {
            return GetAtomFeedItems(startIndex, endIndex).
                Select(atomInfo => ToStringFromBytes(atomInfo.AtomFeedItemBytes))
                .ToList();
        }

        public static void Insert(AtomItemType itemType, string businessKey, byte[] itemBytes)
        {
            const string sql = @"Insert into[ContractManagement].[AtomFeedItem] (Identifier, ItemType, BusinessKey, AtomFeedItemBytes, DuplicateIdentifier) values
                                 (@identifier, @itemType, @businessKey, @itemBytes, @identifier)";

            var identifier = Guid.NewGuid().ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, param:new { identifier, itemType, businessKey, itemBytes });
            }
        }

        public static bool IsLatestPublishedEventAnApprovalIgnoringDraftAndWithdrawn(ContractIdentifier contractIdentifier)
        {
            List<AtomItemType> itemTypesToIgnore = new List<AtomItemType>
            {
                AtomItemType.DraftContract, AtomItemType.WithdrawnContract
            };

            const string sql = @"SELECT ItemType
                                 FROM [ContractManagement].[AtomFeedItem]
                                 where BusinessKey = @businessKey
                                 and ItemType not in @itemTypesToIgnore
                                 order by id desc";

            string businessKey =
                $"{contractIdentifier.ContractNumber}:{contractIdentifier.VersionNumber}.{contractIdentifier.SubVersionNumber}";
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var itemTypes = connection.Query<int>(sql, param: new { businessKey, itemTypesToIgnore }).ToList();

                return itemTypes.Any() && itemTypes.First() == (int) AtomItemType.ApprovedContract;
            }
        }

        public static bool IsPublished(string contractNumber, int version)
        {
            const string sql = @"SELECT count(1)
                                 FROM [ContractManagement].[AtomFeedItem]
                                 where BusinessKey like @businessKey";

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var count = connection.ExecuteScalar<int>(sql, new {businessKey = $"{contractNumber}:{version}%"});

                return count > 0;
            }
        }

        private static List<ChildContact> ToChildContracts(contract masterContract, AtomInfo atomInfo)
        {
            return masterContract.contracts.Select(c => new ChildContact(c, atomInfo.ItemType, atomInfo.CreatedDate)).ToList();
        }

        private static (contract contract, AtomInfo atomInfo) ToContractFromBytes(AtomInfo atomInfo)
        {
            string xml = ToStringFromBytes(atomInfo.AtomFeedItemBytes);

            using (var stream = new MemoryStream(new UTF8Encoding().GetBytes(xml)))
            {
                return (new System.Xml.Serialization.XmlSerializer(typeof(contract)).Deserialize(stream) as contract, atomInfo);
            }
        }

        private static string ToStringFromBytes(byte[] bytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                return bigStreamOut.ToArray().ConvertByteArrayToObject<string>();
            }
        }

        private static List<AtomInfo> GetAtomFeedItems()
        {
            const string sql = @"SELECT [AtomFeedItemBytes], [CreatedDate], [ItemType]
            FROM[ContractManagement].[AtomFeedItem]";
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<AtomInfo>(sql, commandTimeout: (int)TimeSpan.FromMinutes(30).TotalSeconds)
                    .ToList();
            }
        }

        private static List<AtomInfo> GetAtomFeedItems(int startIndex, int endIndex)
        {
            const string sql = @"SELECT [AtomFeedItemBytes], [CreatedDate], [ItemType]
            FROM[ContractManagement].[AtomFeedItem]  where id between @startIndex and @endIndex";
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<AtomInfo>(sql, commandTimeout: (int)TimeSpan.FromMinutes(30).TotalSeconds, param:new {startIndex, endIndex})
                        .ToList();
            }
        }

        private class AtomInfo
        {
            public AtomInfo(byte[] atomFeedItemBytes, DateTime createdDate, int itemType)
            {
                AtomFeedItemBytes = atomFeedItemBytes;
                CreatedDate = createdDate;
                ItemType = itemType;
            }

            public byte[] AtomFeedItemBytes { get; }

            public DateTime CreatedDate { get; }

            public int ItemType { get; }
        }
    }

    public class ChildContact
    {
        public IReadOnlyCollection<AllocationWithDeliverables> Allocations { get; }
        public int ItemType { get; }

        public DateTime CreatedDate { get; }

        public string Identity { get; }

        public string ContractNumber { get; }

        public int Version { get; }

        public int SubVersion { get; }

        public ChildContact(contractType childContract, int itemType, DateTime createdDate)
        {
            ItemType = itemType;
            CreatedDate = createdDate;
            ContractNumber = childContract.contractNumber;
            Version = childContract.contractVersionNumber;
            SubVersion = childContract.contractSubVersionNumber;
            Identity =
                $"{ContractNumber}:{Version}:{SubVersion}";
            Allocations = childContract.contractAllocations.Select(ToAllocationWithDeliverables).ToList();
        }

        public override string ToString()
        {
            return Identity;
        }

        private AllocationWithDeliverables ToAllocationWithDeliverables(
            contractAllocationsContractAllocation allocation)
        {
            return new AllocationWithDeliverables(allocation.fundingStreamPeriodCode, allocation
                .GetFlattenedDeliverables()
                .Select(d => new DeliverableInfo(d.deliverable.deliverableName, d.deliverable.deliverableCode)).ToList(), allocation.contractAllocationNumber);
        }
    }

    public class AllocationWithDeliverables
    {
        public string FspCode { get; }

        public IReadOnlyCollection<DeliverableInfo> DeliverableInfos { get; }

        public string AllocationRef { get; }

        public AllocationWithDeliverables(string fspCode, IReadOnlyCollection<DeliverableInfo> deliverableInfos, string allocationRef)
        {
            FspCode = fspCode;
            DeliverableInfos = deliverableInfos;
            AllocationRef = allocationRef;
        }
    }

    public class DeliverableInfo
    {
        public string Name { get; }

        public int Code { get; }

        public DeliverableInfo(string name, int code)
        {
            Name = name;
            Code = code;
        }
    }
}
