namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Entities;
    using Implementation.Entities;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;

    public interface ILookupManager
    {
        string BatchId { get; set; }

        void Lookup(LookupCriteria lookupCriteria);

        Guid? GetMatchingEntity(CrmLookupType lookupType, string value);

        Guid? GetMatchingEntity(CrmLookupType lookupType, CrmCompositeKey compositeKey);
        
        int? GetOptionsetValue(string optionsetName, string label);

        void CheckForPresence(IEnumerable<PresenceCheckItem> presenceCheckItems);

        List<T> GetColumnValuesForEntity<T>(CrmLookupType lookupType, string columnName);

        IList<Guid> GetPkColumnValuesForEntity(CrmLookupType lookupType, string columnName, IEnumerable<string> columnFilterValues);

        List<T> GetColumnValuesForEntity<T>(CrmLookupType lookupType, string columnName, string filterColumnName, IEnumerable<string> columnFilterValues);
     
        Guid? GetPeriodId(string periodString, CorporateContract.periodTypeCodeType periodTypeCode);
        
        Guid? GetFundingTypeId(string fundingTypeString);

        bool CheckContractExists(string correlationId);

        IEnumerable<AllocationValueData> GetAllocationsForApprovedContract(string contractNumber);

        DateTime? GetApprovedDateForContract(string contractNumber, int version);

        DeliverablePeriodsValueData GetPaymentScheduleDeliverablePaymentsValues(string allocationNumber, int version, string deliverableCode, string period);

        IReadOnlyCollection<MatchingTenderAwardReferenceItem> GetMatchingTenderAwardRefsForAllocation(IList<string> importedTenderAwardRefs);

        bool AreMultipleOverlappingContractsAllowedForFundingType(string fundingTypeCode);

        int? GetLatestContractVersionNumberForContract(string contractNumber);

        bool IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(string contractNumber,
            string masterContractNumber,
            int ukprn,
            Guid periodId,
            Guid fundingTypeId
            );

        bool AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber(string contractNumber);

        bool IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(int ukprn, Guid fundingType);

        IReadOnlyCollection<UnitOfProcurement> GetUnitOfProcurementReferenceData();
    }
}
