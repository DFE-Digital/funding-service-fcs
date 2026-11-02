namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{ 
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Xrm;
    using Implementation.Entities;
    using contractAllocationsContractAllocation = CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation;
    using contractor = CrossDomain.Integration.Entities.CorporateContract.contractor;
    using contractStatusType = CrossDomain.Integration.Entities.CorporateContract.contractStatusType;
    using fundingStream = CrossDomain.Integration.Entities.CorporateContract.fundingStream;
    using fundingType = CrossDomain.Integration.Entities.CorporateContract.fundingType;
    using period = CrossDomain.Integration.Entities.CorporateContract.period;
    using periodTypeType = CrossDomain.Integration.Entities.CorporateContract.periodTypeType;

    /// <summary>
    /// This class is responsible for returning the CRM mapping attribute for a given class and property
    /// </summary>
    public static class CrmFieldMapper
    {
        public const string SfaPeriodAlias = "p";
        public const string SfaFundingstreamAlias = "fs";
        public const string SfaPeriodTypeAlias = "pt";
        public const string CorrelationIdPropertyName = "correlationId";
        public const string AmendmentTypePropertyName = "amendmentType";
        public const string VariationPropertyName = "ValueVariation";
        public const string OwnerPropertyName = "Owner";
        public const string ContractAdvisorPropertyName = "ContractAdvisorId";
        public const string PreviousVersionPropertyName = "PreviousVersionId";
        public const string ParentContractPropertyName = "ParentContractId";

        // this hold the class names and the Dictionary of properties that belong to each class 
        private static readonly IDictionary<string, IDictionary<string, IEnumerable<CrmMappingAttribute>>> ClassFieldMap =
            new Dictionary<string, IDictionary<string, IEnumerable<CrmMappingAttribute>>>();

        static CrmFieldMapper()
        {
            // Contract Type Mapping (Corporate schema)
            foreach (var contractTypeName in new[] { "contract", "contractType", "ExtendedContractType", "ExtendedContract" })
            {
                var contractFieldMap = new Dictionary<string, IEnumerable<CrmMappingAttribute>>();

                contractFieldMap.Add("endDate", new[] { new CrmMappingAttribute(CrmContractFieldName.EndDate) });
                contractFieldMap.Add("SkipCaseloadAssignment", new [] {new CrmMappingAttribute(CrmContractFieldName.SkipCaseloadAssignment)});
                contractFieldMap.Add("SkipReviewAndInternalApproval", new[] { new CrmMappingAttribute(CrmContractFieldName.SkipReviewAndInternalApproval) });
                contractFieldMap.Add("startDate", new[] { new CrmMappingAttribute(CrmContractFieldName.StartDate) });
                contractFieldMap.Add("contractType1", new[] { new CrmMappingAttribute(CrmContractFieldName.ContractType, CrmLookupType.ContractType) });

                contractFieldMap.Add("fundingType", new[] { new CrmMappingAttribute(CrmContractFieldName.FundingType, CrmLookupType.FundingType) });
                contractFieldMap.Add("period", new[] { new CrmMappingAttribute(CrmContractFieldName.PeriodId, CrmLookupType.Period) });
                contractFieldMap.Add("contractNumber", new[] { new CrmMappingAttribute(CrmContractFieldName.Number) });
                contractFieldMap.Add("contractVersionNumber", new[] { new CrmMappingAttribute(CrmContractFieldName.Version) });
                contractFieldMap.Add("contractSubVersionNumber", new[] { new CrmMappingAttribute(CrmContractFieldName.SubVersion) });
                contractFieldMap.Add("description", new[] { new CrmMappingAttribute(CrmContractFieldName.Description) });
                contractFieldMap.Add(
                    "contractor",
                    new[]
                    {
                        new CrmMappingAttribute(CrmContractFieldName.Ukprn),
                        new CrmMappingAttribute(CrmContractFieldName.ProviderName, CrmLookupType.Organisation)
                    });
                contractFieldMap.Add("hierarchyType", new[] { new CrmMappingAttribute(CrmContractFieldName.HierarchyType, CrmOptionSetType.HierarchyType) });
                contractFieldMap.Add("contractValue", new[] { new CrmMappingAttribute(CrmContractFieldName.ContractValue, CrmColumnType.Currency) });
                contractFieldMap.Add("status", new[] { new CrmMappingAttribute(CrmContractFieldName.ContractStatus, CrmOptionSetType.Status) });
                contractFieldMap.Add("latestVersion", new[] { new CrmMappingAttribute(CrmContractFieldName.LatestVersion) });
                contractFieldMap.Add(CorrelationIdPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.CorrelationId) });
                contractFieldMap.Add(AmendmentTypePropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.AmendmentType, CrmOptionSetType.AmendmentType) });
                contractFieldMap.Add(VariationPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.Variation, CrmColumnType.Decimal) });
                
                contractFieldMap.Add(OwnerPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.Owner, CrmLookupType.Owner) });

                contractFieldMap.Add(ContractAdvisorPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.ContractAdvisor, CrmColumnType.EntityReference, CrmLookupType.User) });
                contractFieldMap.Add(PreviousVersionPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.PreviousVersion, CrmColumnType.EntityReference, CrmLookupType.Contract) });
                contractFieldMap.Add(ParentContractPropertyName, new[] { new CrmMappingAttribute(CrmContractFieldName.ParentContract, CrmColumnType.EntityReference, CrmLookupType.Contract) });
                contractFieldMap.Add("SkipDocumentMerge", new[] { new CrmMappingAttribute(CrmContractFieldName.SkipDocumentMerge) });
                contractFieldMap.Add("DocumentationRequired", new[] { new CrmMappingAttribute(CrmContractFieldName.DocumentRequired) });
                contractFieldMap.Add("IsNonFinancialAmendment", new[] { new CrmMappingAttribute(CrmContractFieldName.IsNonFinancialAmendment) });

                contractFieldMap.Add("TerminationDate", new[] { new CrmMappingAttribute(CrmContractFieldName.TerminationDate) });
                contractFieldMap.Add("TerminationReason", new[] { new CrmMappingAttribute(CrmContractFieldName.TerminationReason, CrmOptionSetType.TerminationReason) });

                contractFieldMap.Add("StopNewStartsDate", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_defaultstopnewstartsdate) });
                contractFieldMap.Add("InflightStopNewStartsDate", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_inflightstopnewstartsdate) });
                contractFieldMap.Add("NewStartsSuspendedReason", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_defaultnewstartssuspendedreason, CrmOptionSetType.NewStartSuspendedReason) });
                contractFieldMap.Add("InflightNewStartsSuspendedReason", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_inflightnewstartssuspendedreason, CrmOptionSetType.NewStartSuspendedReason) });
                contractFieldMap.Add("InflightTerminationDate", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_inflightterminationdate) });
                contractFieldMap.Add("InflightTerminationReason", new[] { new CrmMappingAttribute(sfa_contract.Fields.sfa_inflightterminationreason, CrmOptionSetType.TerminationReason ) });

                ClassFieldMap.Add(contractTypeName, contractFieldMap);
            }

            // ContractAllocations Mapping
            var contractAllocationMap = new Dictionary<string, IEnumerable<CrmMappingAttribute>>();
            contractAllocationMap.Add("period", new[] { new CrmMappingAttribute(CrmAllocationFieldName.PeriodId, CrmLookupType.Period) });
            contractAllocationMap.Add("fundingStream", new[] { new CrmMappingAttribute(CrmAllocationFieldName.FundingStreamId, CrmLookupType.FundingStreamCode), new CrmMappingAttribute(CrmAllocationFieldName.FundingStreamPeriodId, CrmLookupType.FundingStreamPeriodCode) });
            contractAllocationMap.Add("contractAllocationNumber", new[] { new CrmMappingAttribute(CrmAllocationFieldName.ContractAllocationNumber) });
            contractAllocationMap.Add("description", new[] { new CrmMappingAttribute(CrmAllocationFieldName.Description) });
            contractAllocationMap.Add("hierarchyType", new[] { new CrmMappingAttribute(CrmAllocationFieldName.HierarchyType, CrmOptionSetType.HierarchyType) });
            contractAllocationMap.Add("startDate", new[] { new CrmMappingAttribute(CrmAllocationFieldName.StartDate) });
            contractAllocationMap.Add("endDate", new[] { new CrmMappingAttribute(CrmAllocationFieldName.EndDate) });
            contractAllocationMap.Add("maximumContractValue", new[] { new CrmMappingAttribute(CrmAllocationFieldName.MaxContractValue) });
            contractAllocationMap.Add("reasonForAmendment", new[] { new CrmMappingAttribute(CrmAllocationFieldName.AmendmentReason) });
            contractAllocationMap.Add("tenderSpecificationReference", new[] { new CrmMappingAttribute(CrmAllocationFieldName.TenderSpecificationReference) });
            contractAllocationMap.Add("tenderAwardReference", new[] { new CrmMappingAttribute(CrmAllocationFieldName.TenderAwardReference) });
            contractAllocationMap.Add("ActivityDescription", new[] { new CrmMappingAttribute(CrmAllocationFieldName.ActivityDescription) });
            contractAllocationMap.Add("AgreementNumber", new[] { new CrmMappingAttribute(CrmAllocationFieldName.AgreementNumber) });
            contractAllocationMap.Add("SpecificationTitle", new[] { new CrmMappingAttribute(CrmAllocationFieldName.SpecificationTitle) });
            contractAllocationMap.Add("RegionType", new[] { new CrmMappingAttribute(CrmAllocationFieldName.RegionType) });
            contractAllocationMap.Add("LearningRatePremium", new[] { new CrmMappingAttribute(CrmAllocationFieldName.LearningRatePremium) });
            contractAllocationMap.Add("InvestmentPriority", new[] { new CrmMappingAttribute(CrmAllocationFieldName.InvestmentPriority) });
            contractAllocationMap.Add(VariationPropertyName, new[] { new CrmMappingAttribute(CrmAllocationFieldName.Variation, CrmColumnType.Decimal) });
            contractAllocationMap.Add("InflightNewStartsSuspendedReason", 
                new[] { new CrmMappingAttribute(sfa_contractallocation.Fields.sfa_inflightnewstartssuspendedreason, CrmOptionSetType.NewStartSuspendedReason) });
            contractAllocationMap.Add("NewStartsSuspendedReason",
                new[] { new CrmMappingAttribute(sfa_contractallocation.Fields.sfa_newstartssuspendedreason, CrmOptionSetType.NewStartSuspendedReason) });
            contractAllocationMap.Add("InflightStopNewStartsDate", new[] { new CrmMappingAttribute(sfa_contractallocation.Fields.sfa_inflightstopnewstartsdate) });

            contractAllocationMap.Add(
                "uopCode",
                new[]
                {
                    new CrmMappingAttribute(CrmAllocationFieldName.UnitOfProcurement, CrmLookupType.UnitOfProcurement),
                    new CrmMappingAttribute(CrmAllocationFieldName.UnitOfProcurementCode)
                });
            //contractAllocationMap.Add(
            //    "LEPCode",
            //    new[]
            //    {
            //        new CrmMappingAttribute(CrmAllocationFieldName.LepCode, CrmLookupType.LocalEnterprisePartnership)

            //    });

            contractAllocationMap.Add("LEPCode", new[] { new CrmMappingAttribute(CrmAllocationFieldName.LepCode) });
            contractAllocationMap.Add("LEPName", new[] { new CrmMappingAttribute(CrmAllocationFieldName.LepName) });
            contractAllocationMap.Add("lotReference", new[] { new CrmMappingAttribute(CrmAllocationFieldName.LotReference) });
            contractAllocationMap.Add("DeliveryOrganisation", new[]
            {
                new CrmMappingAttribute(CrmAllocationFieldName.DeliveryOrganisationUkprn),
                new CrmMappingAttribute(CrmAllocationFieldName.DeliveryOrganisationProvider, CrmLookupType.Organisation)
            });
            contractAllocationMap.Add("TerminationDate", new[] { new CrmMappingAttribute(CrmAllocationFieldName.TerminationDate) });
            contractAllocationMap.Add("FundingCessationDate", new[] { new CrmMappingAttribute(CrmAllocationFieldName.TerminationDate) });
            contractAllocationMap.Add("StopNewStartsDate", new[] { new CrmMappingAttribute(CrmAllocationFieldName.StopNewStartsDate) });
            contractAllocationMap.Add("InflightTerminationDate", new[] { new CrmMappingAttribute(sfa_contractallocation.Fields.sfa_inflightterminationdate) });

            ClassFieldMap.Add("contractAllocationsContractAllocation", contractAllocationMap);
            ClassFieldMap.Add("ExtendedContractAllocation", contractAllocationMap);

            // ContractDeliverables Mapping
            var contractDeliverableMap = new Dictionary<string, IEnumerable<CrmMappingAttribute>>();

            // contractDeliverableMap.Add("fundingStream", new[] { new CrmMappingAttribute("sfa_fundingstreamid", CrmLookupType.FundingStreamCode), new CrmMappingAttribute("sfa_fundingstreamperiodid", CrmLookupType.FundingStreamPeriodCode) });
            contractDeliverableMap.Add(
                "deliverableCode",
                new[]
                {
                    new CrmMappingAttribute(CrmDeliverableFieldName.DeliverableCode, CrmColumnType.Text)
                });
            contractDeliverableMap.Add("deliverableName", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.DeliverableName) });
            
            ClassFieldMap.Add("deliverableType", contractDeliverableMap);

            // contractDeliverablesTypeContractDeliverable Mapping
            var contractDeliverablesTypeContractDeliverableMap = new Dictionary<string, IEnumerable<CrmMappingAttribute>>();

            contractDeliverablesTypeContractDeliverableMap.Add("deliverableDescription", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.DeliverableDescription) });
            contractDeliverablesTypeContractDeliverableMap.Add("plannedValue", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.PlannedValue) });
            contractDeliverablesTypeContractDeliverableMap.Add("plannedVolume", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.PlannedVolume) });

            contractDeliverablesTypeContractDeliverableMap.Add("unitCost", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.UnitCost) });
            contractDeliverablesTypeContractDeliverableMap.Add("DisplayOrder", new[] { new CrmMappingAttribute(CrmDeliverableFieldName.DisplayOrder) });

            ClassFieldMap.Add("contractDeliverablesTypeContractDeliverable", contractDeliverablesTypeContractDeliverableMap);

            // ContractDeliverablePeriods Mapping
            var contractDeliverablePeriodMap = new Dictionary<string, IEnumerable<CrmMappingAttribute>>();
            contractDeliverablePeriodMap.Add("year", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.Year) });
            contractDeliverablePeriodMap.Add("period", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.Period) });
            contractDeliverablePeriodMap.Add("plannedValue", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.PlannedValue) });
            contractDeliverablePeriodMap.Add("periodType", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.PeriodTypeId, CrmLookupType.PeriodType) });
            contractDeliverablePeriodMap.Add("aggregate", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.Aggregate) });
            contractDeliverablePeriodMap.Add("periodName", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.PeriodName), new CrmMappingAttribute(CrmDeliverablePeriodFieldName.Name) });
            contractDeliverablePeriodMap.Add("displayOrder", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.DisplayOrder) });
            contractDeliverablePeriodMap.Add("plannedVolume", new[] { new CrmMappingAttribute(CrmDeliverablePeriodFieldName.PlannedVolume) });

            ClassFieldMap.Add("contractDeliverablePeriodsTypeContractDeliverablePeriod", contractDeliverablePeriodMap);
        }

        /// <summary>
        /// Returns a mapping attribue if the field is mapped otherwise null
        /// </summary>
        /// <param name="className">The name of the class to which the property belongs to</param>
        /// <param name="propertyName">The property of the property prefixed with the class it belongs to</param>
        /// <returns>a mapping attribue is the field is mapped</returns>
        public static IEnumerable<CrmMappingAttribute> GetMappings(string className, string propertyName)
         {
            IEnumerable<CrmMappingAttribute> attributes;

            if (ClassFieldMap.ContainsKey(className) && ClassFieldMap[className].ContainsKey(propertyName))
            {
                attributes = ClassFieldMap[className][propertyName];
            }
            else
            {
                attributes = new List<CrmMappingAttribute>();
            }

            return attributes;
        }

        public static string GetPrimaryKeyFieldValue(object obj)
        {
            string primaryKeyStr = null;
            
            if (obj is period)
            {
                period period = (period)obj;
                primaryKeyStr = period.periodType.periodTypeCode + period.period1;
            }
            else if (obj is contractor)
            {
                contractor contractor = (contractor)obj;
                primaryKeyStr = contractor.ukprn.ToString();
            }
            else if (obj is fundingType)
            {
                fundingType fundingType = (fundingType)obj;
                primaryKeyStr = fundingType.fundingTypeCode;
            }
            else if (obj is fundingStream)
            {
                fundingStream fundingStream = (fundingStream)obj;
                primaryKeyStr = fundingStream.fundingStreamCode;
            }
            else if (obj is contractStatusType)
            {
                contractStatusType contractStatusType = (contractStatusType)obj;
                primaryKeyStr = contractStatusType.status;
            }
            else if (obj != null && obj.GetType().IsEnum)
            {
                primaryKeyStr = obj.ToString();
            }
            else  if (obj is periodTypeType)
            {
                periodTypeType periodTypeType = (periodTypeType)obj;
                primaryKeyStr = periodTypeType.periodTypeCode.ToString();
            }

            return primaryKeyStr;
        }

        public static CrmCompositeKey GetPeriodPk(period period)
        {
            // this is a special case where the pk comes from the period and the funding stream
            var compositeKey = new CrmCompositeKey();
            if (period != null)
            {
                compositeKey.KeyFields.Add(new ColumnValue() { Column = "sfa_period", Value = period.period1, Table = "sfa_period" });
                compositeKey.KeyFields.Add(new ColumnValue() { Column = "sfa_periodtypecode", Value = period.periodType.periodTypeCode, Table = "sfa_periodtype", Alias = "pt" });    
            }

            return compositeKey;
        }

        public static CrmCompositeKey GetFundingStreamPeriodPk(contractAllocationsContractAllocation contractAllocation)
        {
            // this is a special case where the pk comes from the period and the funding stream
            var compositeKey = new CrmCompositeKey();
            compositeKey.KeyFields.Add(new ColumnValue() { Column = "sfa_period", Value = contractAllocation.period.period1, Table = "sfa_period", Alias = SfaPeriodAlias });
            compositeKey.KeyFields.Add(new ColumnValue() { Column = "sfa_fundingstreamcode", Value = contractAllocation.fundingStream.fundingStreamCode, Table = "sfa_fundingstream", Alias = SfaFundingstreamAlias });
            compositeKey.KeyFields.Add(new ColumnValue() { Column = "sfa_periodtypecode", Value = contractAllocation.period.periodType.periodTypeCode, Table = "sfa_periodtype", Alias = SfaPeriodTypeAlias });
            return compositeKey;
        }
    }
}
