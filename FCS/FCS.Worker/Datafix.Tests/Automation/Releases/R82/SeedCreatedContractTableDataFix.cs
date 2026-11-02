namespace Datafix.Tests.Automation.Releases.R82
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Dtos;
    using Infrastructure;

    public class SeedCreatedContractTableDataFix : IApplyDataFix
    {
        private readonly ICrmContractInformationRepository _crmContractInformationRepository;

        public SeedCreatedContractTableDataFix()
        {
            _crmContractInformationRepository = new CrmContractInformationRepository();
        }

        public SeedCreatedContractTableDataFix(ICrmContractInformationRepository crmContractInformationRepository)
        {
            _crmContractInformationRepository = crmContractInformationRepository;
        }

        public string Release => "R82";
        public int StoryNumber => 28484;
        public string Name => "Seed the Created Contract table with the approved contracts and their createdOn dates from CRM";
        public int Order => 1;
        public void ApplyDataFix()
        {
            IReadOnlyCollection<ContractInfo> lastApprovedContracts = _crmContractInformationRepository.GetLastApprovedContracts();

            lastApprovedContracts.ToList().ForEach(InsertCreatedContract);
        }

        private static void InsertCreatedContract(ContractInfo contract)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = @"insert into ContractManagement.CreatedContract values (@contractNumber, @version, @subVersion, @createdDate)";

                connection.Execute(sql, param:new{contract.ContractNumber, contract.Version, contract.SubVersion, createdDate = contract.CreatedDate});
            }
        }
    }
}
