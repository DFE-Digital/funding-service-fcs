namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingStreamPeriodSheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }

        public string Name { get; set; }

        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public string FundingStreamCode { get; set; }

        public string AllocationReferencePrefix { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public string DummyAccountCode { get; set; }

        public int ControlAccountCode { get; set; }

        public string Element1DefaultValue { get; set; }

        public bool ShouldCreatePaymentFileFlag => GeneratePayments;

        public DateTime CreatedDate { get; set; }

        public string PaymentCappingLevel { get; set; }

        public string PaymentCappingPeriod { get; set; }

        public string PaymentMethod { get; set; }

        public bool ShouldCapPayments { get; set; }

        public string Procurement { get; set; }

        public bool ProcessFutureActuals { get; set; }

        public bool PersistCurrentActualsState { get; set; }

        /// <summary>
        /// This is helpful as some of the models have Code as their FundingStreamPeriodCode
        /// </summary>
        public string Code => FundingStreamPeriodCode;

        /// <summary>
        /// This is the Funding Period Key
        /// </summary>
        public string FundingPeriod => PeriodTypeCode + Period;

        public bool ZeroiseMissingActuals { get; set; }

        public DateTime? ActivityCloseDate { get; set; }

        public string SummaryOfFundingDisplayName { get; set; }

        public int ContractDocumentDisplayOrder { get; set; }

        public bool GeneratePayments { get; set; }

        public bool ShouldGeneratePayments => GeneratePayments;

        public bool ShouldGenerateFundingAgreement { get; set; }

        public bool ShouldUseContractAllocationDescription { get; set; }

        public string Template { get; set; }

        public string ExtraPagesTemplate { get; set; }

        public bool MultiCollectionReturns { get; set; }

        public string FSPGroup { get; set; }

        public string FundingAgreementDisplayName { get; set; }

        public string AgencyPayment { get; set; }

        public string FspReportingName { get; set; }
    }
}
