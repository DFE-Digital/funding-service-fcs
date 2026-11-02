namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Entity;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.DTOs;
    using Dapper;
    using Infrastructure;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SummarisedActualsRepository : ISummarisedActualsRepository, ISummarisedActualsQueryRepository
    {
        public async Task AddActual(SummarisedActual actual, ConnectionInfo connectionInfo)
        {
            const string sql = @"insert into [MonitoringDeliverables].[SummarisedActual]
                              ([CollectionType]
                              ,[CollectionReturnCode]
                              ,[OrganisationId]
                              ,[FundingStreamPeriodCode]
                              ,[UopCode]
                              ,[Period]
                              ,[DeliverableCode]
                              ,[ContractAllocationNumber]
                              ,[ActualVolume]
                              ,[ActualValue]
                              ,[DataCollectionsId])
                              values (@collectionType, @collectionReturnCode, 
                              @organisationId, @fundingStreamPeriodCode,
                              @uopCode, @period,
                              @deliverableCode, @contractAllocationNumber,
                              @actualVolume, @ActualValue,
                              @DataCollectionsId)";

            await connectionInfo.Connection.ExecuteAsync(sql, transaction: connectionInfo.Transaction, param: actual);
        }

        public async Task AddActuals(IReadOnlyCollection<SummarisedActual> actuals, ConnectionInfo connectionInfo)
        {
            using (SqlCommand command =
                new SqlCommand(cmdText: "MonitoringDeliverables.InsertSummarisedActuals",
                    connection: (SqlConnection) connectionInfo.Connection,
                    transaction: (SqlTransaction) connectionInfo.Transaction))
            {
                DataTable table = new DataTable("ActualsTable");
                table.Columns.Add("CollectionType", typeof(string));
                table.Columns.Add("CollectionReturnCode", typeof(string));
                table.Columns.Add("OrganisationId", typeof(string));
                table.Columns.Add("FundingStreamPeriodCode", typeof(string));
                table.Columns.Add("UopCode", typeof(string));
                table.Columns.Add("Period", typeof(int));
                table.Columns.Add("DeliverableCode", typeof(int));
                table.Columns.Add("ContractAllocationNumber", typeof(string));
                table.Columns.Add("ActualVolume", typeof(int));
                table.Columns.Add("ActualValue", typeof(decimal));
                table.Columns.Add("DataCollectionId", typeof(int));

                actuals.ToList().ForEach(a =>
                {
                    var row = table.NewRow();
                    row["CollectionType"] = a.CollectionType;
                    row["CollectionReturnCode"] = a.CollectionReturnCode;
                    row["OrganisationId"] = a.OrganisationId;
                    row["FundingStreamPeriodCode"] = a.FundingStreamPeriodCode;
                    row["UopCode"] = a.UopCode.GetValueOrDbNull();
                    row["Period"] = a.Period;
                    row["DeliverableCode"] = a.DeliverableCode;
                    row["ContractAllocationNumber"] = a.ContractAllocationNumber.GetValueOrDbNull();
                    row["ActualVolume"] = a.ActualVolume.GetValueOrDbNull();
                    row["ActualValue"] = a.ActualValue;
                    row["DataCollectionId"] = a.DataCollectionsId.GetValueOrDbNull();

                    table.Rows.Add(row);
                });

                SqlParameter userDefinedTableParameter = command.Parameters.AddWithValue("@actualsTable", table);
                userDefinedTableParameter.SqlDbType = SqlDbType.Structured;
                userDefinedTableParameter.TypeName = "dbo.SummarisedActualTableType";

                command.CommandType = CommandType.StoredProcedure;
                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<int> GetCountForCollectionReturn(string collectionType, string collectionReturnCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var getCount = await (from res in context.SummarisedActuals
                                      where res.CollectionType == collectionType && res.CollectionReturnCode == collectionReturnCode
                                      select res).CountAsync();
                return getCount;
            
            }
        }

        public async Task<IReadOnlyCollection<ActualOrgFspGroupKeyResult>> GetOrgFspGroups(string collectionType,
            string collectionReturnCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var groupKeys = await (from res in context.SummarisedActuals
                                      where res.CollectionType == collectionType && res.CollectionReturnCode == collectionReturnCode
                                      select new ActualOrgFspGroupKeyResult
                                      {
                                          OrganisationId = res.OrganisationId
                                      ,
                                          FundingStreamPeriodCode = res.FundingStreamPeriodCode
                                      ,
                                          UopCode = res.UopCode
                                      }).Distinct().ToListAsync();
               return groupKeys;

            }
        }

        public async Task<IReadOnlyCollection<SummarisedActual>> GetSummarisedActuals(SummarisedActualOrgFspGroupKey groupKey, ConnectionInfo connectionInfo)
        {
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                return await context.SummarisedActuals
                    .Where(sa =>
                        sa.CollectionType == groupKey.CollectionType &&
                        sa.CollectionReturnCode == groupKey.CollectionReturnCode &&
                        sa.OrganisationId == groupKey.OrganisationId &&
                        sa.FundingStreamPeriodCode == groupKey.FundingStreamPeriodCode &&
                        sa.UopCode == groupKey.UopCode)
                    .ToListAsync();
            }
        }
    }
}
