namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System;
    using System.Collections.Generic;
    using DataStore.Model;

    public class EnrichedReportedActual : ReportedActual
    {
        public EnrichedReportedActual()
        {
            ValidationErrors = new List<string>();
        }

        public string Ukprn { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersion { get; set; }

        public int ContractSubVersion { get; set; }

        public bool DeliverablePeriodMatch { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime AllocationEndDate { get; set; }

        public bool IsValid { get; set; }

        public IList<string> ValidationErrors { get; }

        public string EnrichedDeliverableCode { get; set; }

        public override bool Equals(object obj)
        {
            EnrichedReportedActual other = obj as EnrichedReportedActual;
            if (other != null)
            {
                return Equals(other);
            }

            return false;
        }

        private bool Equals(EnrichedReportedActual other)
        {
            return OrganisationId == other.OrganisationId
                   && FundingStreamPeriodCode == other.FundingStreamPeriodCode
                   && UoPCode == other.UoPCode
                   && DeliverableCode == other.DeliverableCode
                   && Period == other.Period
                   && GetContractAllocationNumber() == other.GetContractAllocationNumber();
        }

        public EnrichedReportedActual ShallowClone()
        {
            return (EnrichedReportedActual)MemberwiseClone();
        }

        public void UpdateFieldsFrom(AllocationDeliverablePeriod allocationDeliverablePeriod)
        {
            ContractNumber = allocationDeliverablePeriod.ContractNumber;
            ContractVersion = allocationDeliverablePeriod.ContractVersionNumber;
            ContractSubVersion = allocationDeliverablePeriod.ContractSubVersionNumber;
            ContractAllocationNumber = allocationDeliverablePeriod.ContractAllocationNumber;
            AllocationStartDate = allocationDeliverablePeriod.AllocationStartDate;
            AllocationEndDate = allocationDeliverablePeriod.AllocationEndDate.GetValueOrDefault();
            DeliverablePeriodMatch = true;
            Ukprn = allocationDeliverablePeriod.Ukprn;
            EnrichedDeliverableCode = allocationDeliverablePeriod.DeliverableCode.ToString();
            OrganisationId = allocationDeliverablePeriod.OrganisationId;
            Period = allocationDeliverablePeriod.Period;
            FundingStreamPeriodCode = allocationDeliverablePeriod.FundingStreamPeriodCode;
            DeliverableCode = allocationDeliverablePeriod.DeliverableCode.ToString();
        }

        public AllocationDeliverablePeriodActualAudit ToAllocationDeliverablePeriodActualAudit()
        {
            return new AllocationDeliverablePeriodActualAudit
            {
                CollectionReturnCode = CollectionReturnCode,
                OrganisationId = OrganisationId,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                UopCode = UoPCodeOrEmpty,
                DeliverableCode = int.Parse(DeliverableCode),
                Period = Period,
                ContractAllocationNumber = ContractAllocationNumber,
                Ukprn = Ukprn,
                ContractNumber = ContractNumber,
                ContractVersion = ContractVersion,
                ContractSubVersion = ContractSubVersion,
                AllocationStartDate = AllocationStartDate,
                AllocationEndDate = AllocationEndDate,
                PeriodTypeCode = PeriodTypeCode,
                CollectionType = CollectionType,
                ActualVolume = ActualVolume,
                ActualValue = ActualValue,
            };
        }

        private string GetContractAllocationNumber()
        {
            return ContractAllocationNumber ?? string.Empty;
        }

        public override int GetHashCode()
        {
            // Get hash code for the Org field if it is not null.
            var hashOrgId = OrganisationId == null ? 0 : OrganisationId.GetHashCode();

            // Get hash code for the FundingStreamPeriodCode field.
            var hashFspCode = FundingStreamPeriodCode == null ? 0 : FundingStreamPeriodCode.GetHashCode();

            // Get hash code for the UoPCode field.
            var hashUopCode = UoPCode == null ? 0 : UoPCode.GetHashCode();

            // Get hash code for the DeliverableCode field.
            var hashDeliverableCode = DeliverableCode == null ? 0 : DeliverableCode.GetHashCode();

            // Get hash code for the DeliverableCode field.
            var hashPeriod = Period == null ? 0 : Period.GetHashCode();

            // Calculate the hash code for the ReportedActual.
            return hashOrgId ^ hashFspCode ^ hashUopCode ^ hashDeliverableCode ^ hashPeriod;
        }

        public override string ToString()
        {
            return $"Allocation Number: {ContractAllocationNumber}, OrganisationId: {OrganisationId}, UKPRN: {Ukprn}, Funding Stream Period: {FundingStreamPeriodCode}, Period: {Period}, Deliverable Code: {DeliverableCode}, UoP Code: {UoPCode}, Actual Value: {ActualValue}, Actual Volume: {ActualVolume}.";
        }
    }
}