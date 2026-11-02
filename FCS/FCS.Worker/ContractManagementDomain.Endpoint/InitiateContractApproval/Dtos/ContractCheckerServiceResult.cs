namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Dtos
{
    public class ContractCheckerServiceResult
    {
        private ContractCheckerServiceResult(bool isLevy, bool isNew, bool isAllocationNew)
        {
            IsLevy = isLevy;
            IsNew = isNew;
            IsAllocationNew = isAllocationNew;
        }

        public static ContractCheckerServiceResult GetResult(bool isNew, bool isAllocationNew)
        {
            return new ContractCheckerServiceResult(true, isNew, isAllocationNew);
        }

        public static ContractCheckerServiceResult NotLevy()
        {
            return new ContractCheckerServiceResult(false, false, false);
        }

        public bool IsLevy { get; }

        public bool IsNew { get; }

        public bool IsAllocationNew { get; }
    }
}