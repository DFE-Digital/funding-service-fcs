namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner;
    using Framework.Logging.NullObjects;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentConfiguration;
    using SFA.FCT.DocumentsDomain.Integration;

    class DocumentPartCreatorTestChild : DocumentPartCreator
    {
        public DocumentPartCreatorTestChild(ITemplateRepository templateRepository, IDocumentConfigurationSource documentConfigurationSource) 
            : base (templateRepository, documentConfigurationSource)
        {
            Logger = new LoggerNullObject();
        }

        public override bool IsHeaderDocumentRequired
        {
            get { throw new NotImplementedException(); }
        }

        public override string RequiredHeaderDocumentName
        {
            get { throw new NotImplementedException(); }
        }

        public string TestGetNameOfTemplateActiveOnDate(string containerName, string startsWith, DateTime contractStartDate)
        {
            return GetNameOfTemplateActiveOnDate(containerName, startsWith, contractStartDate);
        }

        //public decimal TestGetPeriodValuesTotal(Dictionary<int, Dictionary<string, decimal>> periodValuesDictionary, contractAllocationsContractAllocation contractAllocation, int key)
        //{
        //    return base.GetTotalForDeliverable(periodValuesDictionary, contractAllocation, key);
        //}

        public string[] TestGetMonthsInPeriod(contractAllocationsContractAllocation periodToTest)
        {
            return GetMonthsInPeriod(periodToTest);
        }

        //public string TestCalculatePeriodValue(
        //    Dictionary<int, Dictionary<string, decimal>> periodValuesDictionary, 
        //    contractAllocationsContractAllocation contractAllocation, 
        //    int deliverableCode, 
        //    string periodToCalculate)
        //{
        //    return CalculatePeriodValue(
        //        periodValuesDictionary,
        //        contractAllocation,
        //        deliverableCode,
        //        periodToCalculate);
        //}

        public List<MergeFieldType> TestGetDocumentHeaderFields(string masterContractNumber, contractType contract, contractAllocationsContractAllocation allocation)
        {
            return GetDocumentHeaderFields(masterContractNumber, contract, allocation);
        }

        //public List<MergeFieldType> TestGetRowMergeFields(contractAllocationsContractAllocation contractAllocation, string mergeFieldNameFormat, Dictionary<int, Dictionary<string, decimal>> periodValuesDictionary, int deliverableCode, string[] monthsInPeriod)
        //{
        //    return GetRowMergeFields(contractAllocation, mergeFieldNameFormat, periodValuesDictionary, deliverableCode, monthsInPeriod);
        //}

        public override bool IsDocumentPartRequired(contractType contract)
        {
            throw new NotImplementedException();
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer)
        {
            throw new NotImplementedException();
        }
    }
}
