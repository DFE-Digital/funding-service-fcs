namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Extensions;

    public class SetBatchToDiscardedCommand
    {
        public SetBatchToDiscardedCommand(IReadOnlyCollection<string> fundingNamesForDiscarding, int readIdToIgnore)
        {
            FundingNamesForDiscarding = fundingNamesForDiscarding;
            ReadIdToIgnore = readIdToIgnore;
        }

        public IReadOnlyCollection<string> FundingNamesForDiscarding { get; }

        public int ReadIdToIgnore { get; }

        public override string ToString() =>
            $"ReadIdToIgnore: {ReadIdToIgnore}, FundingNamesForDiscarding or count: {FundingNamesForDiscarding.ToCsv()}";

    }
}
