namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;

    public class CrmTransactionRequestRepository : ICrmTransactionRequestRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmTransactionRequestRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void CreateEntities<T>(IReadOnlyCollection<T> entities) where T : Entity
        {
            var requestToCreateRecords = new ExecuteTransactionRequest()
            {
                Requests = new OrganizationRequestCollection()
            };

            entities.ToList().ForEach(e =>
            {
                CreateRequest createRequest = new CreateRequest { Target = e };
                requestToCreateRecords.Requests.Add(createRequest);
            });

            _organizationService.Execute(requestToCreateRecords);
        }

        public void UpdateEntities<T>(IReadOnlyCollection<T> entities) where T : Entity
        {
            var transactionRequest = new ExecuteTransactionRequest()
            {
                Requests = new OrganizationRequestCollection()
            };

            entities.ToList().ForEach(e =>
            {
                UpdateRequest updateRequest = new UpdateRequest { Target = e };
                transactionRequest.Requests.Add(updateRequest);
            });

            _organizationService.Execute(transactionRequest);
        }
    }
}
