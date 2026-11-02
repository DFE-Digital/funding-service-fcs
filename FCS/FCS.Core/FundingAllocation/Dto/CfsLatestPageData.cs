namespace FundingAllocation.Dto
{
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class CfsLatestPageData
    {
        public CfsLatestPageData(AtomItem[] atomItems, int pageNumber)
        {
            AtomItems = atomItems;
            PageNumber = pageNumber;
        }

        public AtomItem[] AtomItems { get; }
        public int PageNumber { get; }
    }
}
