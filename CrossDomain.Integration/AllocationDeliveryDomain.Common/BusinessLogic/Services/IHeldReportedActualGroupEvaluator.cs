namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services
{
    using CrossDomain.Integration.Entities.Data;

    public interface IHeldReportedActualGroupEvaluator
    {
        bool AreAnyHeldReportedActualGroupsReadyToBeProcessed(ConnectionInfo connectionInfo);
    }
}