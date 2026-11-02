namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Configuration;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using ContractManagement.DataStore;
    using ContractManagementService.Common;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Entities.Xrm;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.Xrm.Sdk;
    using NUnit.Framework;

    public class ContractManagementPageObject
    {
        private readonly IOrganizationService _organizationService;

        public ContractManagementPageObject()
        {
            _organizationService = CrmConnectionFactory.GetConnection();
        }

        public void UpdateContractSubStatus(string contractNumber, string subStatus)
        {
            Guid contractId = CrmContractRepository.GetContractIdForNumber(contractNumber);
            CrmContractRepository.SetSubStatusForContract(contractId, subStatus);
        }
        
        public void UpdateContractTaskOwner(string contractNumber, string ownerDisplayName)
        {
            var contractEntity = XrmService.Configuration.Entity("Contract");
            XrmService.Connection.GetRecord(contractEntity, contractNumber, string.Empty, false)
                .ReassignRecord(ownerDisplayName);
        }

        public void ApproveContractViaBus(string masterContractNumber, string contractNumber, int versionNumber, ApprovalRequestSource approvalRequestSource = ApprovalRequestSource.External)
        {
            InitiateContractApprovalCommand command = new InitiateContractApprovalCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber,
                ContractVersionNumber = versionNumber,
                RequestSource = approvalRequestSource
            };

            MessageSendingBus.Send("ContractManagementDomain.InitiateContractApproval", command);
        }

        public void ApproveContractViaWebAPI(string masterContractNumber, string contractNumber, int versionNumber)
        {
            CallWebAPIEndPointForContract(masterContractNumber, contractNumber, versionNumber, "/contractmanagement/contractissueandreturn/confirmreceiptofdigitalsignature");
        }

        public void ClearMonthEndHistory()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.ExecuteSqlCommand("truncate table [ContractManagement].[MonthEndHistory]");
            }
        }

        private void CallWebAPIEndPointForContract(string masterContractNumber, string contractNumber, int versionNumber, string endPointUrl)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer",
                    AzureAuthenticator.GetAuthenticationResult());

                string url = ConfigurationManager.AppSettings["ContractManagementServiceUrl"] + endPointUrl;

                ContractInformation contractInformation = new ContractInformation
                {
                    MasterContractNumber = masterContractNumber,
                    ContractNumber = contractNumber,
                    ContractVersionNumber = versionNumber
                };

                HttpResponseMessage response = client.PostAsJsonAsync(url, contractInformation).Result as HttpResponseMessage;
                Assert.AreEqual(HttpStatusCode.Accepted, response.StatusCode,
                    $"On successfully initiating {endPointUrl} the response should be 'Accepted'. The status returned is {response.StatusCode}");
            }
        }

        public IReadOnlyCollection<string> GetWorkflowHistoryActionNamesForContract(string contractNumber)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                IReadOnlyCollection<string> actionNames =
                    (from c in xrmContext.sfa_contractSet
                     join h in xrmContext.sfa_contracttransitionhistorySet on c.sfa_contractId equals h.sfa_Contract.Id
                     where c.sfa_number == contractNumber && c.sfa_LatestVersion == true
                     select h.sfa_name)
                     .ToList();

                return actionNames;
            }
        }
    }
}