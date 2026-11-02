using Datafix.Tests.Infrastructure;
using Datafix.Tests.Repositories;
using Operations.DataStore;
using PaymentGenerationDomain.Integration.DataStore;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R141
{
    public class DeleteDuplicateContractAllocation : IApplyDataFix
    {
        public string Release => "R141";
        public int StoryNumber => 39110;
        public string Name => "Delete Duplicate allication 16ED-5426 of contract EDSK-4753";
        public int Order => 1;

        public void ApplyDataFix()
        {
            Guid contractId = new Guid("4FA1D42A-F675-4A48-938F-B0D47D290C60");
            string contractNumber = "EDSK-4753";
            string version = "6";
            var contractInfo = CrmReplicatedRepository.GetDuplicateConract(contractNumber, version);

            if (contractInfo.Any() && contractInfo.Count() > 1)
            {
                var contract = contractInfo.Where(x => x.Id == contractId).FirstOrDefault();
                // Delete duplicate contract of EDSK-4753 from CRM Replica DB
                CrmReplicatedRepository.DeleteDuplicateConract(contract.Id);

                // Delete duplicate contractallocation of EDSK-4753 from CRM Replica DB
                CrmReplicatedRepository.DeleteDuplicateAllocation(contract.Id);

                // Delete duplicate ConractDeliverable of EDSK-4753 from CRM Replica DB                        
                CrmReplicatedRepository.DeleteDuplicateConractDeliverable(contract.Id);

                // Delete duplicate ConractDeliverablePeriod of EDSK-4753 from CRM Replica DB                   
                CrmReplicatedRepository.DeleteDuplicateConractDeliverablePeriod(contract.Id);
            }

            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sqlFeedRead = @"Delete from [Operations].[DuplicateContract]";

                connection.Execute(sqlFeedRead);
            } 
        }
    }
}
