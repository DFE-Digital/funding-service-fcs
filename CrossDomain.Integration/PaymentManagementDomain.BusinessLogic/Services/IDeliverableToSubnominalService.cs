namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    public interface IDeliverableToSubnominalService
    {
        SubnominalValue GetSubnominalValue(string fundingStreamPeriodCode,
            int deliverableCode, string contractAllocationNumber, string contractNumber);
    }
}
