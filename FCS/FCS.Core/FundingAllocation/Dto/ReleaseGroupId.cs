namespace FundingAllocation.Dto
{
    using System;

    public class ReleaseGroupId
    {
        public ReleaseGroupId(int paaSId, Guid crmId)
        {
            PaaSId = paaSId;
            CrmId = crmId;
        }

        public int PaaSId { get; }
        public Guid CrmId { get; }
    }
}
