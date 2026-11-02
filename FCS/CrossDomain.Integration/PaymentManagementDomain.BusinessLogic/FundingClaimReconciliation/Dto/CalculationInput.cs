namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto
{
    using System;

    public class CalculationInput
    {
        public DateTime CalculationDate { get; set; }

        public ContractAllocation ContractAllocation { get; set; }
    }
}
