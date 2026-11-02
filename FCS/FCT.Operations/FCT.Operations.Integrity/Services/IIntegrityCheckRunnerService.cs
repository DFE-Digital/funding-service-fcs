namespace SFA.FCT.Operations.Integrity.Services
{
    using CrossDomain.Integration.Messages.Commands;

    public interface IIntegrityCheckRunnerService
    {
        void RunChecks(InitiateCheckersCommand initiateCheckersCommand);
    }
}
