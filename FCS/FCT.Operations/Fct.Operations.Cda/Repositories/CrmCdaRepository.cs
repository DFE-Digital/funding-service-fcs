namespace FCT.Operations.Cda.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dapper.FluentColumnMapping;
    using Dtos;
    using SFA.FCS.Worker.Common;

    public class CrmCdaRepository : ICrmCdaRepository
    {
        private readonly IFcsConfiguration _configuration;

        static CrmCdaRepository()
        {
            var mappings = new ColumnMappingCollection();
            mappings.RegisterType<CdaRow>()
                .MapProperty(cdaRow => cdaRow.ContractSubStatus).ToColumn("ContractSub-Status")
                .MapProperty(cdaRow => cdaRow.SubnominalProfile).ToColumn("Subnominal-Profile")
                .MapProperty(cdaRow => cdaRow.SubnominalReconciliation).ToColumn("Subnominal-Reconciliation")
                .MapProperty(cdaRow => cdaRow.SubnominalCapping).ToColumn("Subnominal-Capping")
                .MapProperty(cdaRow => cdaRow.Deliverable).ToColumn("DeliverableName");

            mappings.RegisterWithDapper();
        }

        public CrmCdaRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IReadOnlyCollection<CdaRow>> GetRows(IEnumerable<string> fsps, bool isLatestVersion)
        {
            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];
            const int timeoutInSeconds = 1200;
            DateTime now = DateTime.Now;
            string nowString = now.ToString("dd/MM/yyyy hh:mm");
            using (var connection = new SqlConnection(connectionString))
            {
               string spName = "[dbo].[sp_CDAExtract]";
               string csvFsps = string.Join(",", fsps);
               int isLatest = isLatestVersion ? 1 : 0;
               var rows = await connection.QueryAsync<CdaRow>(spName, new { FundingStreamPeriod =  csvFsps, IsLatestVersion  = isLatest}, commandTimeout: timeoutInSeconds, commandType: CommandType.StoredProcedure);
               var listRows = rows.ToList();
               listRows.ForEach(r=> r.ExecutionTime = nowString);

               return listRows;
            }
        }
    }
}
