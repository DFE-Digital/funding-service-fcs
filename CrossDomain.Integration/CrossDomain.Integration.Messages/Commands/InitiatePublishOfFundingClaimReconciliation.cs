namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using System;

    public class InitiatePublishOfFundingClaimReconciliationCommand
    {
        public InitiatePublishOfFundingClaimReconciliationCommand()
        {
        }

        public InitiatePublishOfFundingClaimReconciliationCommand(Guid fundingClaimReconciliationId, string name)
        {
            FundingClaimReconciliationId = fundingClaimReconciliationId;
            Name = name;
        }

        public Guid FundingClaimReconciliationId { get; set; }

        public string Name { get; set; }

        public override string ToString()
        {
            return Name;
        }
    }
}
