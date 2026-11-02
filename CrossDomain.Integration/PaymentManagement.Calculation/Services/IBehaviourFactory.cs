namespace PaymentManagement.Calculation.Services
{
    using Dtos;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IBehaviourFactory
    {
        Option<Behaviour> GetBehaviour(string fsp, Period currentPeriod, ConnectionInfo connectionInfo);
    }
}