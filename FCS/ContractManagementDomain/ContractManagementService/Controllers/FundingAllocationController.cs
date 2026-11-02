namespace SFA.FCT.ContractManagementService.Controllers
{
    using System;
    using System.Collections.Generic;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NSB;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Authorization;

    [ApiController]
    [Route("funding-allocation")]
    [Authorize]
    public class FundingAllocationController : ControllerBase
    {
        private readonly ILogger _logger;

        public FundingAllocationController(ILogger logger)
        {
            _logger = logger;
        }

        [HttpPost]
        [Route("release-group")]
        public ActionResult ReleaseGroup(FundingAllocationReleaseGroupCommand fundingAllocationReleaseGroupCommand)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.fundingAllocationReleaseGroupCommandReceived, $"Received a POST FundingAllocationReleaseGroupCommand {fundingAllocationReleaseGroupCommand}");

            ServiceBus.Bus.Send(
                FctEndpoint.GenerateEndpointName("FundingAllocation.ReleaseGroup"),
                fundingAllocationReleaseGroupCommand);

            _logger.LogInformation(ContractManagementLoggingEvents.fundingAllocationReleaseGroupCommandProcessed, $"Sent a FundingAllocationReleaseGroupCommand {fundingAllocationReleaseGroupCommand}");

            return new AcceptedResult();
        }

        [HttpPost]
        [Route("holdevent")]
        public ActionResult HoldEvent(HoldFundingAllocationCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationHoldEventReceived,
                $"Received HoldFundingAllocationCommand: {command}");

            ServiceBus.Bus.Send("FundingAllocation.UpdateFundingAllocation", command);

            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationHoldEventProcessed,
                $"Processed HoldFundingAllocationCommand: {command}");

            return new AcceptedResult();
        }

        [HttpPost]
        [Route("un-holdevent")]
        public ActionResult UnHoldEvent(UnHoldFundingAllocationCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationUnHoldEventReceived,
                $"Received UnHoldFundingAllocationCommand: {command}");

            ServiceBus.Bus.Send("FundingAllocation.UpdateFundingAllocation", command);

            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationUnHoldEventProcessed,
                $"Processed UnHoldFundingAllocationCommand: {command}");

            return new AcceptedResult();
        }

        [HttpPost]
        [Route("withdrawalevent")]
        public ActionResult WithdrawalEvent(WithdrawFundingAllocationCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationWithdrawalEventReceived,
                $"Received WithdrawFundingAllocationCommand: {command}");

            ServiceBus.Bus.Send("FundingAllocation.UpdateFundingAllocation", command);
            
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationWithdrawalEventProcessed,
                $"Processed WithdrawFundingAllocationCommand: {command}");

            return new AcceptedResult();
        }

        [HttpPost]
        [Route("reinstate-event")]
        public ActionResult ReinstateEvent(ReinstateFundingAllocationCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationReinstateEventReceived,
                $"Received FundingAllocationReinstateEvent: {command}");

            ServiceBus.Bus.Send("FundingAllocation.UpdateFundingAllocation", command);

            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationWithdrawalEventProcessed,
                $"Processed FundingAllocationReinstateEvent: {command}");

            return new AcceptedResult();
        }

        [HttpPost]
        [Route("un-queue-event")]
        public ActionResult UnQueueEvent(UnQueueFundingAllocationsForContractCommand command)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationUnQueueEventReceived,
                $"Received FundingAllocationUnQueueEvent: {command}");
            try
            {
                var releaseQueuedFundingAllocationsForContractsCommand =
                    new ReleaseQueuedFundingAllocationsForContractsCommand(new List<ContractIdentity>
                    {
                        new ContractIdentity(command.ContractNumber, command.VersionNumber, command.SubVersionNumber)
                    });

                ServiceBus.Bus.Send("FundingAllocation.ReleaseGroup",
                    releaseQueuedFundingAllocationsForContractsCommand);

                _logger.LogInformation(ContractManagementLoggingEvents.FundingAllocationUnQueueEventProcessed,
                    $"Processed FundingAllocationUnQueueEvent: {command}");
            }
            catch (Exception e)
            {
                _logger.LogInformation(1, $"UnQueueEvent error: {e.Message}, {e.StackTrace}");
            }

            return new AcceptedResult();
        }
    }
}