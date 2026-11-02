namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;
    using System.Collections.Generic;

    public class ContractDetail
    {
        public Guid Id { get; set; }

        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public DateTime? ContractApprovalDate { get; set; }

        public string FundingTypeCode { get; set; }

        public string FundingTypeName { get; set; }

        public string PeriodTypeCode { get; set; }

        public string PeriodTypeName { get; set; }

        public string Period { get; set; }

        public string OrganisationId { get; set; }

        public int Ukprn { get; set; }

        public string ContractType { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public string Status { get; set; }

        public string SubStatus { get; set; }

        public decimal ContractValue { get; set; }

        public string AmendmentType { get; set; }

        public DateTime? TerminationDate { get; set; }

        public string TerminationReason { get; set; }

        public IReadOnlyCollection<AllocationDetail> Allocations { get; set; }
    }

    public class AllocationDetail
    {
        public Guid Id { get; set; }

        public string AllocationNumber { get; set; }

        public string FundingStreamCode { get; set; }

        //TODO: period properties?

        public string FundingStreamName { get; set; }

        public string FundingTypeCode { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public decimal MaximumContractValue { get; set; }

        //TODO: ESF properties

        public DateTime? FundingCessationDate { get; set; }

        public string NewStartsSuspendedReason { get; set; }

        public DateTime? StopNewStartsDate { get; set; }

        public IReadOnlyCollection<DeliverableDetail> Deliverables { get; set; }
    }

    public class DeliverableDetail
    {
        public int DeliverableCode { get; set; }

        public IReadOnlyCollection<DeliverablePeriodDetail> DeliverablePeriods { get; set; }
    }

    public class DeliverablePeriodDetail
    {
        public int Period { get; set; }
    }
}
