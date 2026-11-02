namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Operations.Web.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class IntegrityCheckerService : IIntegrityCheckerService
    {
        private readonly ITransportMessageSender _messageSender;
        private const string IntegrityCheckerEndpointName = "Operations.IntegrityCheckers";

        public IntegrityCheckerService(ITransportMessageSender messageSender)
        {
            _messageSender = messageSender;
        }

        public async Task StartIntegrityChecker(string integrityCheckerName)
        {
            InitiateCheckersCommand initiateCheckersCommand = new InitiateCheckersCommand
            {
                ChecksToRun = new List<string> { integrityCheckerName }
            };

            await _messageSender.Send(command: initiateCheckersCommand, destination: IntegrityCheckerEndpointName);
        }

        public async Task StartPostMonthEndIntegrityChecks()
        {
            InitiateCheckersCommand initiateCheckersCommand = InitiateCheckersCommand.CreatePostMonthEndIntegrityChecksCommand();

            await _messageSender.Send(command: initiateCheckersCommand, destination: IntegrityCheckerEndpointName);
        }
    }
}