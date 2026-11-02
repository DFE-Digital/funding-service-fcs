namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Runtime.Serialization.Formatters.Binary;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using ContractManagement.DataStore;
    using System.Data.Entity;
    using System;
    using Operations.DataStore.Model;
    using DocumentFormat.OpenXml.Spreadsheet;

    public class ContractAtomFeedQueryRepository : IContractAtomFeedQueryRepository
    {
        private static string ConnectionString => ConfigurationManager
            .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        public async Task<IReadOnlyCollection<ContractAtomFeedInfo>> GetContracts(string contractNumber)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ContractManagementDbContext())
                {
                    var rows = await context.AtomFeedItems.ToListAsync();
                    var result = rows
                        .Where(aft => aft.BusinessKey.Contains(contractNumber))
                        .OrderBy(aft => aft.Id)
                        .Select(x => new ContractAtomFeedInfo { Id = x.Id, ItemType = (int)x.ItemType, BusinessKey = x.BusinessKey, CreatedDate = x.CreatedDate });
                    return result.ToList();
                }
            }
        }

        public async Task<string> GetXmlForContract(int id)
        {
            using (var context = new ContractManagementDbContext())
            {
                var result = await (from res in context.AtomFeedItems.Where(p => p.Id == id) select res.AtomFeedItemBytes).FirstAsync();
                return ToStringFromZippedBytes(result);
            }
        }



        private static string ToStringFromZippedBytes(byte[] bytes)
        {
            using (GZipStream bigStream = new GZipStream(new MemoryStream(bytes), CompressionMode.Decompress))
            {
                MemoryStream bigStreamOut = new MemoryStream();
                bigStream.CopyTo(bigStreamOut);
                var unZippedBytes = bigStreamOut.ToArray();

                MemoryStream memorystream = new MemoryStream(unZippedBytes);
                BinaryFormatter binaryFormatter = new BinaryFormatter();

                return (string)binaryFormatter.Deserialize(memorystream);
            }
        }

        public async Task<IReadOnlyCollection<ContractCleanup>> GetContractData(List<string> fundingIds)
        {
            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    const string sql = @"select FA.FundingId,FA.CrmEntityId,FA.UKPRN,FA.AllocationFundingStream, C.ContractNumber,C.ContractVersionNumber,c.ContractSubVersionNumber ,
                                        RG.ReleaseGroupName,RG.Status as ReleaseStatus
                                        from FundingAllocation.FundingAllocation FA Left join
                                        FundingAllocation.Contract C on FA.ContractId = c.Id Left join
                                        FundingAllocation.ReleaseGroup RG on
                                        FA.ReleaseGroupId = RG.Id
                                        where FA.FundingId in @fundingIds"
                    ;

                    var result = connection.Query<ContractCleanup>(sql, new { FundingIds = fundingIds }).ToList();

                    return result;
                }
            }
            catch (Exception ex) { }
            return null;
        }

        public Task<bool> CleanupContractData(IReadOnlyCollection<ContractCleanup> contractsdata)
        {
            try
            {
                foreach (var contractData in contractsdata)
                {
                    string fundingId = contractData.FundingId;
                    using (var connection = new SqlConnection(ConnectionString))
                    {
                        const string sql = @"select ProviderFundingId From FundingAllocation.ProviderFundingAllocation where FundingId = @fundingId";
                        var providerFundingIds = connection.Query<string>(sql, new { fundingId }).ToList();

                        string sqlFeedRead = " delete from FundingAllocation.FundingAllocation where FundingId = @fundingId ";
                        connection.Execute(sqlFeedRead, new { fundingId });

                        string sqlfeedProviderFunding = "delete from FundingAllocation.ProviderFunding where ProviderFundingId in @providerFundingIds";
                        connection.Execute(sqlfeedProviderFunding, new { providerFundingIds });

                        string sqlfeedProceesedMsg = "delete from FundingAllocation.ProcessedMessage where BusinessKey = @fundingId ";
                        connection.Execute(sqlfeedProceesedMsg, new { fundingId });

                        if (contractData.ContractNumber != null)
                        {
                            try
                            {
                                int? versionnumber = contractData.ContractVersionNumber;
                                string contractnumber = contractData.ContractNumber;
                                int? subversionnumber = contractData.ContractSubVersionNumber;
                                string sqlcontractfeedProceesedMsg = "Delete from FundingAllocation.Contract where ContractNumber = @contractnumber and ContractVersionNumber = @versionnumber and ContractSubVersionNumber = @subversionnumber";
                                connection.Execute(sqlcontractfeedProceesedMsg, new { contractnumber, versionnumber , subversionnumber });
                            }
                            catch (Exception ex) { }
                        }
                    }
                }

            }
            catch (Exception ex) { return Task.FromResult(false); }
            return Task.FromResult(true);

        }

        public async Task<IReadOnlyCollection<ContractCleanup>> GetApprovedContractData(List<string> fundingIds)
        {
            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    const string sql = @"select FA.FundingId,FA.CrmEntityId,FA.UKPRN,FA.AllocationFundingStream, C.ContractNumber,C.ContractVersionNumber,c.ContractSubVersionNumber ,
                                        RG.ReleaseGroupName,RG.Status as ReleaseStatus
                                        from FundingAllocation.FundingAllocation FA Left join
                                        FundingAllocation.Contract C on FA.ContractId = c.Id Left join
                                        FundingAllocation.ReleaseGroup RG on
                                        FA.ReleaseGroupId = RG.Id
                                        where FA.FundingId in @fundingIds AND FA.Status in ('ContractApproved','Withdrawn','Discarded','InRelease')"
                    ;

                    var result = connection.Query<ContractCleanup>(sql, new { FundingIds = fundingIds }).ToList();

                    return result;
                }
            }
            catch (Exception ex) { }
            return null;
        }
    }
}