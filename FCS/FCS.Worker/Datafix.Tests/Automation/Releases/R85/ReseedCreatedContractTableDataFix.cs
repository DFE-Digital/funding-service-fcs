namespace Datafix.Tests.Automation.Releases.R85
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Dtos;
    using Infrastructure;

    public class ReseedCreatedContractTableDataFix : IApplyDataFix
    {
        public string Release => "R85";

        public int StoryNumber => 30010;

        public string Name => "Variation amendment for EDSK 20/21 contract incorrectly included all Ts&Cs";

        public int Order => 2;

        public void ApplyDataFix()
        {
            ClearCreatedContractTable();

            ISet<ContractInfo> contracts = GetLastApprovedAndLatestVersionContractsWithoutDuplicates();

            contracts.ToList().ForEach(InsertCreatedContract);
        }

        private static void ClearCreatedContractTable()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                connection.Execute(@"TRUNCATE TABLE ContractManagement.CreatedContract");
            }
        }

        private static ISet<ContractInfo> GetLastApprovedAndLatestVersionContractsWithoutDuplicates()
        {
            var crmContractInformationRepository = new CrmContractInformationRepository();

            return crmContractInformationRepository.GetLastApprovedAndLatestVersionContractsWithoutDuplicates();
        }

        private static void InsertCreatedContract(ContractInfo contract)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"INSERT INTO ContractManagement.CreatedContract VALUES (@contractNumber, @version, @subVersion, @createdDate)";

                connection.Execute(sql, param:new {contract.ContractNumber, contract.Version, contract.SubVersion, createdDate = contract.CreatedDate});
            }
        }
    }
}
