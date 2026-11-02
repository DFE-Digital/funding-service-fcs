namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services
{
    public interface ILevyMissingDeliverablePeriodCreator
    {
        void CreateMissingDeliverablePeriodsWhenNecessary(string allocationNumber);
    }
}