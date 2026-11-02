namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    using System;

    public class PaymentInstructionAudit
    {
        public int CollectionReturnPeriod { get; set; }
        public string OrganisationId { get; set; }
        public string FundingStreamPeriodCode { get; set; }
        public int DeliverableCode { get; set; }
        public string Period { get; set; }
        public string Ukprn { get; set; }
        public string ContractNumber { get; set; }
        public int ContractVersion { get; set; }
        public int ContractSubVersion { get; set; }
        public DateTime AllocationStartDate { get; set; }
        public string CollectionReturnCode { get; set; }
        public string CollectionType { get; set; }
        public decimal PaymentValue { get; set; }
        public string ContractAllocationNumber { get; set; }

        public PaymentInstructionAudit(int collectionReturnPeriod, string organisationId, string fundingStreamPeriodCode, int deliverableCode, string period, string ukprn, string contractNumber, 
            int contractVersion, int contractSubVersion, DateTime allocationStartDate, string collectionReturnCode, string collectionType, decimal paymentValue, string contractAllocationNumber)
        {
            CollectionReturnPeriod = collectionReturnPeriod;
            OrganisationId = organisationId;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            DeliverableCode = deliverableCode;
            Period = period;
            Ukprn = ukprn;
            ContractNumber = contractNumber;
            ContractVersion = contractVersion;
            ContractSubVersion = contractSubVersion;
            AllocationStartDate = allocationStartDate;
            CollectionReturnCode = collectionReturnCode;
            CollectionType = collectionType;
            PaymentValue = paymentValue;
            ContractAllocationNumber = contractAllocationNumber;
        }
    }
}
