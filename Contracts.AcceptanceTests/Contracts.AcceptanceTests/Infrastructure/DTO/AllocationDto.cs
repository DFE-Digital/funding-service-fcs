namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;

    public class AllocationDto
    {
        public string AllocationNumber { get; set; }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public string DeliveryOrgUkprn { get; set; }

        /// <summary>
        /// Gets the ukprn from the linked provider
        /// </summary>
        public string DeliveryOrgProviderUkprn { get; set; }

        public DateTime CreatedOn { get; set; }
    }
}
