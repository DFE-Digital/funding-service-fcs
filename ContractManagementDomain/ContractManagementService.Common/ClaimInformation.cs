namespace SFA.FCT.ContractManagementService.Common
{
    using System;

    public class ClaimInformation
    {
        public string FCRId { get; set; }

        public string FCRName { get; set; }

        public Guid Id => Guid.Parse(FCRId);

        public override string ToString()
        {
            return FCRName;
        }
    }
}
