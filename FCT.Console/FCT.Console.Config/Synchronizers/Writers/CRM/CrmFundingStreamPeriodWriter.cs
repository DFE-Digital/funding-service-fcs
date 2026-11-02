namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmFundingStreamPeriodWriter : CrmConfigWriter<FundingStreamPeriodSheetType, sfa_fundingstreamperiod>
    {
        private readonly CrmHelper _crmHelper = new CrmHelper();

        protected override void UpdateMatchingEntity(FundingStreamPeriodSheetType row, sfa_fundingstreamperiod matchingPeriod)
        {
            matchingPeriod.sfa_PaymentType = CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString(row.PaymentMethod);
            matchingPeriod.sfa_PaymentCappingLevel = CrmOptionSetFactory.CreatePaymentCappingLevelFromString(row.PaymentCappingLevel);
            matchingPeriod.sfa_AllocationReferencePrefix = row.AllocationReferencePrefix;
            matchingPeriod.sfa_FundingStreamCodeId = GetFundingStreamEntityReference(row.FundingStreamCode);
            matchingPeriod.sfa_procurement = row.Procurement;
            matchingPeriod.sfa_PeriodId = GetFundingPeriodEntityReference(row.FundingPeriod);
            matchingPeriod.sfa_fundingstreamperiodname = row.Name; 
        }

        protected override sfa_fundingstreamperiod CreateEntity(FundingStreamPeriodSheetType row)
        {
            EntityReference fundingStreamEntityReference = GetFundingStreamEntityReference(row.FundingStreamCode);

            EntityReference fundingPeriodEntityReference = GetFundingPeriodEntityReference(row.FundingPeriod);

            sfa_fundingstreamperiod fundingStreamPeriod = new sfa_fundingstreamperiod
            {
                sfa_FundingStreamCodeId = fundingStreamEntityReference,
                sfa_PeriodId = fundingPeriodEntityReference,
                sfa_AllocationReferencePrefix = row.AllocationReferencePrefix,

                // there is domain language inconsistency here - we say payment method CRM says FundingStreamPaymentType
                sfa_PaymentType = CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString(row.PaymentMethod),
                sfa_PaymentCappingLevel = CrmOptionSetFactory.CreatePaymentCappingLevelFromString(row.PaymentCappingLevel),

                sfa_fundingstreamperiodcode = row.FundingStreamPeriodCode,
                sfa_procurement = row.Procurement,
                sfa_fundingstreamperiodname = row.Name
            };

            return fundingStreamPeriod;
        }

        protected override IEnumerable<sfa_fundingstreamperiod> GetMatchingEntities(XrmServiceContext crmContext, FundingStreamPeriodSheetType row)
        {
            return from fsp in crmContext.sfa_fundingstreamperiodSet
                   where fsp.sfa_fundingstreamperiodcode == row.FundingStreamPeriodCode
                   select fsp;
        }

        private EntityReference GetFundingStreamEntityReference(string fundingStreamCode)
        {
            return new EntityReference(CrmEntityName.FundingStream,
               _crmHelper.GetLookupPrimaryKey(CrmLookupType.FundingStreamCode, "sfa_fundingstreamid", new string[] { fundingStreamCode }));
        }

        private EntityReference GetFundingPeriodEntityReference(string fundingPeriod)
        {
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var entityQuery = from fp in crmContext.sfa_periodSet
                    where fp.sfa_periodname == fundingPeriod
                    select fp;
                return entityQuery.Single().ToEntityReference();
            }
        }
    }
}
