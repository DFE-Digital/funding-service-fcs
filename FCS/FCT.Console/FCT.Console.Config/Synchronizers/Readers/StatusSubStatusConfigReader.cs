namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using ExcelTypes;

    public class StatusSubStatusConfigReader
    {
        public const string ContractApproved = "ContractApproved";
        public const string Withdrawn = "Withdrawn";
        public const string Discarded = "Discarded";
        public const string Superseded = "Superseded";
        public const string Parked = "Parked";
        public const string NonMaterialUpdate = "NonMaterialUpdate";
        public const string AwaitingOutcome = "AwaitingOutcome";
        public const string StatusScheduling = "Scheduling";
        public const string StatusInRelease = "InRelease";
        public const string SubStatusAwaitingRelease = "AwaitingRelease";
        public const string AwaitingFundingAllocationConfig = "AwaitingFundingAllocationConfig";
        public const string AwaitingContractTypeConfig = "AwaitingContractTypeConfig";
        public const string AwaitingFundingLineConfig = "AwaitingFundingLineConfig";
        public const string AwaitingProvider = "AwaitingProvider";
        public const string StatusParkedPending = "ParkedPending";
        public const string SubStatusProviderCheck = "ProviderCheck";
        public const string SubStatusQueued = "Queued";
        public const string SubStatusNonMaterial = "NonMaterial";

        public IReadOnlyCollection<StatusSubStatusConfigType> ReadConfig()
        {
            return new List<StatusSubStatusConfigType>
            {
                new StatusSubStatusConfigType {Status = ContractApproved, SubStatus = ContractApproved},
                new StatusSubStatusConfigType {Status = Withdrawn, SubStatus = Withdrawn},
                new StatusSubStatusConfigType {Status = Discarded, SubStatus = Superseded},
                new StatusSubStatusConfigType {Status = Discarded, SubStatus = NonMaterialUpdate},
                new StatusSubStatusConfigType {Status = Discarded, SubStatus = SubStatusNonMaterial},
                new StatusSubStatusConfigType {Status = Parked, SubStatus = AwaitingOutcome},
                new StatusSubStatusConfigType {Status = StatusScheduling, SubStatus = SubStatusAwaitingRelease},
                new StatusSubStatusConfigType {Status = Parked, SubStatus = AwaitingFundingAllocationConfig},
                new StatusSubStatusConfigType {Status = Parked, SubStatus = AwaitingContractTypeConfig},
                new StatusSubStatusConfigType {Status = Parked, SubStatus = AwaitingFundingLineConfig},
                new StatusSubStatusConfigType {Status = Parked, SubStatus = AwaitingProvider},
                new StatusSubStatusConfigType {Status = StatusParkedPending, SubStatus = SubStatusProviderCheck},
                new StatusSubStatusConfigType {Status = StatusInRelease, SubStatus = SubStatusQueued}
            };
        }
    }
}
