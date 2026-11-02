namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Dtos;

    public class GetFundingAllocationsPageCommand
    {
        public int ReadId { get; set; }

        public int PageNumber { get; set; }

        public AtomItem[] AtomItems { get; set; } = new AtomItem[0];

        public override string ToString() => $"ReadId: {ReadId}, PageNumber: {PageNumber}";
    }
}
